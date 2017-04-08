
## ---- rebuild-figures ----
f <- list.files("/scratch/users/kriss1/data/metagenomeAnalysis/", full.names = TRUE)
f <- unique(sapply(f, tools::file_path_sans_ext))[-1]
for (i in seq_along(f)) {
  lazyLoad(f[i])
}

## ---- libraries ----
library("FactoMineR")
library("data.table")
library("plyr")
library("dplyr")
library("caret")
library("metagenomeAnalysis")
library("phyloseq")
library("reshape2")
library("ggplot2")
##library("metagenomedata")
library("zoo")
library("grid")
theme_set(theme_bw())

## ---- utils ----
# @title Wrapper for caret::train
# @description This gives a simpler default grid of tuning parameters
# to train across.
run_lda <- function(X, y, num_vars = c(10, 15),
                    lambda = c(0, 0.1, 1, 10, 100)) {
  lda_grid <- expand.grid(NumVars = num_vars, lambda = lambda)
  train(x = X, y = y, method = "sparseLDA", tuneGrid = lda_grid,
        trControl = trainControl(verbose = FALSE, number = 10))
}

# @title Run multiple sparse LDAs
# @description Computes one lda for each of the x's in x_list, and returns the
# models and errors associated with each.
multiple_ldas <- function(x_list, master, ...) {
  y <- master$perturbed
  baseline <- max(table(y) / length(y))

  # Run a model for each of the input vars
  models <- lapply(x_list, function(x) {
    run_lda(x, y, ...)
  })

  # store errors for each of the models
  errors <- lapply(models, function(m) {
    xtabs(~ ., cbind(pred = predict(m), truth = y, master$SubjectID))
  })

  names(models) <- names(x_list)
  names(errors) <- names(x_list)
  return (list(baseline = baseline, models = models, errors = errors))
}

# @title Identify the selected features in each model
# @param models The output of a call to multiple_ldas
subset_vars <- function(x_list, models) {
  x_subset <- list()
  for(i in seq_along(models)) {
    x_subset[[i]] <- x_list[[i]][, models$models[[i]]$finalModel$varIndex]
  }
  return (x_subset)
}

# Run a multiple factor analysis for each group, with colors by perturbation
mfa_subset <- function(x_subset, master) {
  group_lens <- sapply(x_subset, ncol)
  x <- do.call(cbind, x_subset)
  supp <- colwise(as.factor)(master[, c("perturbed", "SubjectID")])
  MFA(data.frame(supp, x), group = c(2, group_lens),
      type = c("n", rep("s", length(group_lens))),
      num.group.sup = 1, graph = F)
}

plot_mfa <- function(mfa_res, master) {
  scores_df <- data.frame(mfa_res$ind$coord, Subject = master$SubjectID,
                          perturbed = master$perturbed)
  eigs <- round(mfa_res$eig[1:2, 2], 2)

  scores <- ggplot(scores_df) +
    geom_point(aes(x = Dim.1, y = Dim.2, col = perturbed, shape = Subject)) +
    scale_color_brewer(palette = "Set1") +
    xlab(sprintf("Dimension 1 [%g%%]", eigs[1])) +
    ylab(sprintf("Dimension 2 [%s%%]", eigs[2])) +
    ggtitle("MFA: Projected Samples")

  # Plot the scores
  groups <- inverse_rle(mfa_res$call$group[-1], c("NMR", "OTU", "Metagenome"))
  loadings_df <- data.frame(mfa_res$quanti.var$coord, group = groups,
                            label = rownames(mfa_res$quanti.var$coord))

  # Make a cor circle
  cor_circle <- ggplot(loadings_df) +
    geom_text(aes(x = Dim.1, y = Dim.2, col = group, label = label), size = 5, alpha = 0.8) +
    geom_segment(aes(x = 0, y = 0, xend = 0.9 * Dim.1, yend = 0.9 * Dim.2, col = group),
                 arrow = arrow(length = unit(0.1,"cm")), size = 0.5, alpha = 0.7) +
    geom_path(data = circleFun(), aes(x = x, y = y), alpha = 0.7) +
    scale_color_brewer(palette = "Set2") +
    xlab(sprintf("Dimension 1 [%s%%]", eigs[1])) +
    ylab(sprintf("Dimension 2 [%s%%]", eigs[2])) +
    xlim(c(-1, 1)) + ylim(c(-1, 1)) + coord_fixed() +
    ggtitle("MFA: Correlation Circle")
  return(list(scores, cor_circle))
}

plot_mvis <- function(mvis_df, tax_level = "Species") {
  p <- list()
  colnames(mvis_df)[colnames(mvis_df) == "SubjectID"] <- "Subject"

  p[[1]] <- ggplot(filter(mvis_df, group == "NMR")) +
    geom_point(aes(x = days, y = value, col = perturbed, shape = Subject), size = 1) +
    geom_line(aes(x = days, y = value, col = perturbed, group = Subject), alpha = 0.2) +
    facet_grid(variable ~ ., scale = "free_y") +
    xlim(c(-50, 50)) +
    ggtitle("NMR Features")

  grid_fmla <- formula(paste0("variable + ", tax_level , " ~ ."))
  p[[2]] <- ggplot(filter(mvis_df, group == "OTU")) +
    geom_point(aes(x = days, y = value, col = perturbed, shape = Subject), size = 1) +
    geom_line(aes(x = days, y = value, col = perturbed, group = Subject), alpha = 0.2) +
    facet_grid(grid_fmla, scale = "free_y") +
    xlim(c(-50, 50)) +
    theme(strip.text = element_text(size = 6)) +
    ggtitle("OTU Features")

  p[[3]] <- ggplot(filter(mvis_df, group == "Metagenome")) +
    geom_point(aes(x = days, y = value, col = perturbed, shape = Subject), size = 1) +
    geom_line(aes(x = days, y = value, col = perturbed, group = Subject), alpha = 0.2) +
    facet_grid(variable + GO.term ~ ., scale = "free_y") +
    xlim(c(-50, 50)) +
    theme(strip.text = element_text(size = 4)) +
    ggtitle("Metagenome Features, by GO")

  p[[4]] <- ggplot(filter(mvis_df, group == "Metagenome")) +
    geom_point(aes(x = days, y = value, col = perturbed, shape = Subject), size = 1) +
    geom_line(aes(x = days, y = value, col = perturbed, group = Subject), alpha = 0.2) +
    facet_grid(variable + X8 ~ ., scale = "free_y") +
    xlim(c(-50, 50)) +
    theme(strip.text = element_text(size = 4)) +
    ggtitle("Metagenome Features (by taxa)")
  return (p)
}

## ---- annotate-selected ----
result_annotation <- function(mvis_df, mfa_groups, otu_tax, gene_go, lineage,
                              otu_abund) {
  # label with the group the feature came from
  groups_map <- setNames(inverse_rle(mfa_groups, c("NMR", "OTU", "Metagenome")),
                         colnames(do.call(cbind, x_subset)))
  names(groups_map)[groups_map != "Metagenome"] <- paste0("X", names(groups_map)[groups_map != "Metagenome"])
  mvis_df$group <- groups_map[as.character(mvis_df$variable)]

  # push lineage info as far back as we know it, so we can plot the most detailed
  # available classification
  lineage <- filter(lineage, id %in% mvis_df$variable)
  lineage[lineage == ""] <- NA
  lineage[lineage == "environmental"] <- NA
  lineage <- data.table(t(apply(lineage, 1, na.locf)))

  otu_tax <- filter(otu_tax, variable %in% mvis_df$variable)
  otu_tax[otu_tax == ""] <- NA
  otu_tax <- data.table(t(apply(otu_tax, 1, na.locf)))

  # merge in metagenome annotation
  setnames(lineage, c("variable", colnames(lineage)[-1]))
  setnames(gene_go, c("variable", "GO.term"))

  mvis_df <- merge(mvis_df, lineage, by = "variable", all.x = TRUE)
  mvis_df <- merge(mvis_df, gene_go, by = "variable", all.x = TRUE)

  # merge in OTU annotation
  mvis_df <- merge(mvis_df, otu_tax, by = "variable", all.x = TRUE)
  otu_abund <- colSums(otu_table(bsub))
  names(otu_abund) <- paste0("X", names(otu_abund))
  mvis_df$abund <- otu_abund[as.character(mvis_df$variable)]

  # annotate unique features
  features <- mvis_df
  features$SubjectID <- NULL
  features$value <- NULL
  features$days <- NULL
  features$perturbed <- NULL
  features <- unique(features)
  features <- dlply(features, .(group), function(x) x[, !apply(is.na(x), 2, all)])

  return (list(features = features, mvis_df = mvis_df))
}


## ---- vis-results ----
master <- master %>%
  filter(SubjectID == "AAI")
x_subset <- subset_vars(x_list, models)
mfa_res <- mfa_subset(x_subset, master)
mfa_res$group$RV # groups 2-4 are NMR, OTU, and Metagenome, respectively
p <- plot_mfa(mfa_res, master)
p[[1]] <- p[[1]] +
  theme(
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    panel.background = element_blank(),
    legend.position = "bottom"
  )

p[[2]] <- p[[2]] +
  theme(
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    panel.background = element_blank(),
    legend.position = "bottom"
  )

ggsave("figure/mfa_scores.png", p[[1]], height = 4, width = 4, dpi = 450)
ggsave("figure/mfa_factors.png", p[[2]], height = 5, width = 5, dpi = 450)
