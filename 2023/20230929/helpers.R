
tss <- \(x, eps = 0.1) (x + eps) / colSums(x + eps)

filter_abund <- function(x, thresh = 0.001) {
  col_total <- colSums(x[, -1])
  x[, c(TRUE, col_total / sum(col_total) > thresh)]
}

create_summarized_experiments <- function(multiomics, omics_names) {
  experiments <- map(omics_names, ~ {
    metadata <- multiomics$metadata
    if (. == "metabolomics") {
      metadata <- filter(metadata, Age == 12)
    }

    x <- multiomics[[.]] |>
      column_to_rownames("SampleID") |>
      select(-ends_with("ID", ignore.case = FALSE)) |>
      as.matrix()
    col_data <- multiomics[[.]] |>
      select(ends_with("ID", ignore.case = FALSE)) |>
      left_join(metadata)
    row_data <- tibble(feature = colnames(x))

    SummarizedExperiment(
      assay = list(counts = t(x)),
      colData = col_data,
      rowData = row_data
    )
  })
  names(experiments) <- omics_names
  experiments
}

subset_histogram <- function(x, ix, transform = identity) {
  x |>
    select(c(ends_with("id"), ix)) |>
    pivot_longer(-ends_with("id")) |>
    ggplot() +
    geom_histogram(aes(transform(value))) +
    facet_wrap(~ name, scales = "free_x")
}

reorder_cols <- function(x) {
  if (all(sapply(x[, -1], is.numeric))) {
    x <- x[, c(1, 1 + order(colSums(x[, -1]), decreasing = TRUE))]
  }

  x
}

create_design <- function(omics_names, rho = 0.1) {
  n_omics <- length(omics_names)
  design <- matrix(
    rho,
    ncol = n_omics,
    nrow = n_omics,
    dimnames = list(omics_names, omics_names)
  )
  diag(design) <- 0
  design
}

spls_workflow <- function(samples, y_var = "Genotype", ncomp = 4,
                          test.keepX = NULL, tss_transform = FALSE, ...) {
  X <- t(assay(samples))
  y <- colData(samples)[[y_var]]

  if (tss_transform) {
    X <- tss(X)
  }

  if (is.null(test.keepX)) {
    test.keepX <- floor(seq(5, ncol(X) / 4, length.out = 10))
  }

  tuning <- tune.splsda(
    X, y,
    test.keepX = test.keepX,
    ncomp = ncomp,
    nrepeat = 4,
    folds = 2,
    dist = "centroids.dist",
    progressBar = FALSE,
    ...
  )

  fit <- splsda(X, y, keepX = tuning$choice.keepX, ncomp = ncomp, ...)
  selected <- map_dfr(
    seq_len(fit$ncomp),
    ~ selectVar(fit, comp = .) |>
      bind_cols() |>
      as_tibble(),
    .id = "comp"
  )
  list(tuning = tuning, fit = fit, selected = selected)
}

study_design <- function(n_mouse, min = 4, max = 12, by = 4) {
  grid <- expand.grid(
    Genotype = factor(c("WT", "HD")),
    Age = seq(min, max, by = by),
    mouse = seq_len(n_mouse)
  ) |>
    select(-mouse) |>
    mutate(newdata_index = row_number())
}

variable_importances <- function(estimates) {
  estimates |>
  map_dfr(~ {
    varimp(.@estimate$fit[[1]]$mu) |>
      as_tibble() |>
      select(variable, reduction) |>
      filter(variable != "(Intercept)") |>
      mutate(
        variable = as.character(variable),
        spline_main = str_detect(variable, "[0-9], ns\\("),
        spline_inter = str_detect(variable, "GenotypeWT, ns\\(")
      ) |>
      group_by(spline_main, spline_inter) |>
      summarise(
         reduction = mean(reduction),
         variable = dplyr::first(variable),
         .groups = "drop_last"
      ) |>
      mutate(variable_type = case_when(
        spline_inter ~ "Interaction",
        spline_main ~ "Age",
        !(spline_inter | spline_main) ~ "GenotypeWT")
      ) |>
      ungroup()
    },
    .id = "feature"
    ) |>
    select(feature, variable_type, reduction) |>
    pivot_wider(names_from = variable_type, values_from = reduction)
}

plot_corr <- function(exp1, exp2, features = NULL) {
  if (is.null(features)) {
    features <- rownames(exp1)
  }
  x <- cor(t(assay(exp1[features, ])))
  y <- cor(t(assay(exp2[features, ])))
  diag(x) <- 0
  diag(y) <- 0
  tibble(
    x = as.numeric(x),
    y = as.numeric(y)
  ) |>
  ggplot(aes(x, y)) +
  geom_hline(yintercept = 0, col = "#d3d3d3") +
  geom_vline(xintercept = 0, col = "#d3d3d3") +
  geom_abline(slope = 1, col = "darkred") +
  geom_point(alpha = 0.05, size = 0.6) +
  labs(x = "True Pairwise Correlations", y = "Simulated Pairwise Correlations")
}

spls_metrics <- function(selected, true_effects) {
  selected |>
    mutate(effect = ifelse(name %in% true_effects, "nonnull", "null")) |>
    group_by(comp) |>
    arrange(comp, -abs(value.var)) |>
    mutate(
      FDR = cumsum(effect == "null") / row_number(),
      power = cumsum(effect == "nonnull") / length(true_effects)
    )
}

plot_altered <- function(simulator, nulls, formula) {
  simulator@margins <- simulator@margins |>
    mutate(any_of(nulls), link = formula)
  
  simulator <- estimate(simulator)
  samples <- sample(simulator)
  p <- plot(simulator, "Age", samples, color = "Genotype", transform = identity, feature = nulls) +
    labs(x = "Mouse Age (Weeks)", y = "Gene Expression (Scaled)")
  list(plot = p, samples = samples)
}
