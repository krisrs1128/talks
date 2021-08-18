#! /usr/bin/env Rscript

# File description -------------------------------------------------------------
# This includes the code for generating figures that appear in my proposal
# slides

## ---- setup ----

# Setup packages ---------------------------------------------------------------
# List of packages for session
library("data.table")
library("plyr")
library("dplyr")
library("reshape2")
library("ggplot2")

# Load packages into session
set.seed(05122016)
rm(list = ls()) # Delete all existing variables
graphics.off() # Close all open plots

# minimal theme for ggplots
theme_set(theme_bw())
min_theme <- theme_update(
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.ticks = element_blank(),
  legend.title = element_text(size = 12),
  legend.text = element_text(size = 8),
  axis.text = element_text(size = 8),
  axis.title = element_text(size = 12),
  strip.background = element_blank(),
  strip.text = element_text(size = 12),
  legend.key = element_blank()
)

load("~/Documents/writing/research/microbiome_multitable/sims/gflasso_sim.RData")
load("~/Documents/programming/F1000_workflow/pca_rank.rda")

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

## ---- pca_rank_pca_plot ----
ggplot() +
  geom_point(data = col_scores, aes(x = 25 * co.Comp1, y = 25 * co.Comp2, col = Order),
             size = .3, alpha = 0.6) +
  geom_point(data = row_scores, aes(x = li.Axis1, y = li.Axis2),
             alpha = 0.2, shape = 2, size = .5) +
  scale_color_brewer(palette = "Set2") +
  facet_grid(age_binned ~ .) +
  guides(col = guide_legend(override.aes = list(size = 1.5, alpha = 1))) +
  labs(x = sprintf("Axis1 [%s%% variance]", round(evals_prop[1], 2)),
       y = sprintf("Axis2 [%s%% variance]", round(evals_prop[2], 2))) +
  coord_fixed(sqrt(ranks_pca$eig[2] / ranks_pca$eig[1])) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 6),
    axis.text = element_text(size = 6),
    axis.title = element_text(size = 8),
    strip.text = element_text(size = 6),
    panel.spacing = unit(.5, "line")
  )

## ---- sparse_cca_workflow ----
sample_info <- feather::read_feather("~/Documents/programming/F1000_workflow/sample_info.feather")
feature_info <- feather::read_feather("~/Documents/programming/F1000_workflow/feature_info.feather")
eigs <- feather::read_feather("~/Documents/programming/F1000_workflow/eigs.feather")$eig

ggplot() + geom_point(data = sample_info,
                      aes(x = Axis1, y = Axis2, col = sample_type), size = 3) +
  geom_hline(yintercept = 0, size = .2, alpha = 0.5) +
  geom_vline(xintercept = 0, size = .2, alpha = 0.5) +
  geom_label_repel(data = feature_info,
                   aes(x = 5.5 * CS1, y = 5.5 * CS2, label = feature, fill = feature_type),
                   size = 2, segment.size = 0.3,
                   label.padding = unit(0.1, "lines"), label.size = 0) +
  geom_point(data = feature_info,
             aes(x = 5.5 * CS1, y = 5.5 * CS2, fill = feature_type),
             size = 1, shape = 23, col = "#383838") +
  scale_color_brewer(palette = "Set2") +
  scale_fill_manual(values = c("#a6d854", "#e78ac3")) +
  guides(fill = guide_legend(override.aes = list(shape = 32, size = 0))) +
  coord_fixed(sqrt(eigs[2] / eigs[2])) +
  labs(x = sprintf("Axis1 [%s%% Variance]",
                   100 * round(eigs[1] / sum(eigs), 2)),
       y = sprintf("Axis2 [%s%% Variance]",
                   100 * round(eigs[2] / sum(eigs), 2)),
       fill = "Feature Type", col = "Sample Type")

## ---- supervised_proximities ----
rf_prox <- feather::read_feather("~/Documents/programming/F1000_workflow/rf_prox.feather")
ggplot(rf_prox) +
  geom_point(aes(x = X1, y = X2, col = age_binned),
             size = 1.5, alpha = 0.6) +
  scale_color_manual(values = c("#A66EB8", "#238DB5", "#748B4F")) +
  guides(col = guide_legend(override.aes = list(size = 3, alpha = 1))) +
  labs(col = "Binned Age", x = "Axis1", y = "Axis2")

## ---- supervised_lachno ----
maxImpDF <- feather::read_feather("~/Documents/programming/F1000_workflow/maxImpDF.feather")
ggplot(maxImpDF) +   geom_histogram(aes(x = abund)) +
  facet_grid(age2 ~ .) +
  labs(x = "Abundance of Lachnospiraceae", y = "Number of samples")

## ---- graph_lasso_B ----
X <- feather::read_feather("~/Documents/programming/gflasso/sims/X.feather")
Y <- feather::read_feather("~/Documents/programming/gflasso/sims/20161128190934_Y.feather")
B <- feather::read_feather("~/Documents/programming/gflasso/sims/20161128190934_truth.feather")
b_lasso <- feather::read_feather("~/Documents/programming/gflasso/sims/20161128190934_lasso.feather")
b_gflasso <- feather::read_feather("~/Documents/programming/gflasso/sims/20161128190934_gflasso.feather")

B <- B %>%
  select(starts_with("X"))
b_lasso <- b_lasso %>%
  select(starts_with("X"))
b_gflasso <- b_gflasso %>%
  select(starts_with("X"))
Y <- Y %>%
  select(starts_with("X"))

b_combined <- rbind(
  data.table(
    "type" = "truth",
    "feature" = 1:nrow(B),
    B
  ),
  data.table(
    "type" = "lasso",
    "feature" = 1:nrow(B),
    b_lasso
  ),
  data.table(
    "type" = "gflasso",
    "feature" = 1:nrow(B),
    b_gflasso
  )
) %>%
  melt(id.vars = c("type", "feature"), variable.name = "task")

b_combined$task <- gsub("X", "", b_combined$task) %>%
  as.integer()
b_combined$type <- factor(b_combined$type, c("truth", "lasso", "gflasso"))

ggplot(b_combined) +
  geom_tile(aes(x = task, y = feature, fill = value)) +
  scale_fill_gradient2(midpoint = 0, high = "#90ee90", low = "#000080") +
  facet_wrap(~ type) +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
    theme(panel.border = element_rect(fill = "transparent"),
          axis.title = element_text(size = 15),
          strip.text = element_text(size = 15))

## ---- reg_data ----
m_y <- melt(as.matrix(Y), varnames = c("sample", "task"), value.name = "y")
m_x <- melt(as.matrix(X), varnames = c("sample", "feature"), value.name = "x")
reg_data <- m_y %>%
  left_join(m_x) %>%
  mutate(
    feature = as.integer(gsub("V|X", "", feature)),
    task = as.integer(gsub("V|X", "", task))
  )

reg_data <- b_combined %>%
  dcast(feature + task ~ type) %>%
  mutate(zero = truth == 0) %>%
  left_join(reg_data) %>%
  melt(measure.vars = c("truth", "lasso", "gflasso"),
       variable.name = "type")

cur_data <- reg_data %>%
  filter(task %in% 98:102,
         feature %in% 11:15)

ggplot(cur_data) +
  geom_point(aes(x = x, y = y, col = zero),
             size = .5, alpha = 0.3) +
  geom_abline(aes(slope = value, intercept = 0,
                  linetype = type, col = zero), size = .7) +
  facet_grid(feature ~ task) +
  scale_color_manual(values = c("#8068ab", "#d9bad8")) +
  coord_fixed(.25)

## ---- lda_data ----
beta_hat <- read_feather("~/Documents/programming/readings/lda/results/beta.feather")
theta_hat <- read_feather("~/Documents/programming/readings/lda/results/theta.feather")

## ---- lda_figures ----
theta_hat$cluster <- gsub("Cluster ", "", theta_hat$cluster)
theta_hat$cluster <- factor(theta_hat$cluster, levels = c("4", "3", "2", "1"))

p1 <- ggplot(theta_hat) +
  geom_tile(aes(x = time, y = cluster, fill = theta)) +
  scale_fill_gradient(low = "#FFFFFF", high = "#5BBABA", limits = c(0, 1)) +
  facet_grid(~condition, scale = "free_x", space = "free_x") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  labs(x = "Day", y = "Theta") +
  theme(
    panel.border = element_rect(fill = "transparent", size = .4, color = "#C9C9C9"),
    panel.spacing = unit(0, "line")
  )

# might want to set prior for more extreme decay
p2 <- ggplot(beta_hat %>%
         filter(Taxon_5 %in% levels(beta_hat$Taxon_5)[1:8])) +
  geom_bar(aes(x = rsv, y = value, fill = Taxon_5),
           stat = "identity") +
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(breaks = c(0, 0.02)) +
  facet_grid(cluster~Taxon_5, scale = "free_x", space = "free_x") +
  labs(y = "Beta", fill = "family") +
  theme(
    axis.text.x = element_blank(),
    strip.text.x = element_blank()
  )
multiplot(p1, p2, ncol = 1)

## ---- unigram_data ----
p_hat <- feather::read_feather("~/Documents/programming/readings/dtm/p_hat.feather")

## ---- unigram_series ----
ggplot(p_hat %>%
         filter(group %in% names(group_order)[1:8])) +
  geom_line(aes(x = time, y = prob, col = group, group = rsv), alpha = 0.4) +
  scale_color_brewer(palette = "Set2") +
  facet_wrap(~group) +
  theme(legend.position = "none")

## ---- unigram_histograms ----
ggplot(p_hat %>%
         filter(group %in% names(group_order)[1:8])) +
  geom_bar(aes(x = rsv, y = prob, fill = group), stat = "identity") +
  facet_grid(time ~ group, space = "free_x", scales = "free_x") +
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(breaks = c(0, .02)) +
  labs(x = "Microbe", y = "beta") +
  theme(
    strip.text.x = element_blank(),
    axis.text.x = element_blank(),
    panel.spacing = unit(0, "line")
  )

## ---- dtm_data ----
theta_hat <- feather::read_feather("~/Documents/programming/readings/dtm/dtm_theta_hat.feather")
mbeta_hat <- feather::read_feather("~/Documents/programming/readings/dtm/dtm_mbeta_hat.feather")

## ---- dtm_figures ----
p1 <- ggplot(theta_hat) +
  geom_tile(aes(x = time, y = cluster, fill = value)) +
  scale_fill_gradient(low = "#FFFFFF", high = "#5BBABA", limits = c(.3, .7)) +
  guides(fill = guide_legend(keywidth = .5, keyheight = .5)) +
  facet_grid(~condition, scale = "free_x", space = "free_x") +
  labs(x = "time") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  coord_fixed(2) +
  theme(
    panel.border = element_rect(fill = "transparent", size = .4, color = "#C9C9C9"),
    panel.spacing = unit(0, "line"),
    legend.text = element_text(size = 6),
    legend.title = element_blank()
  )

p2 <- ggplot(mbeta_hat %>%
         filter(Taxon_5 %in% levels(mbeta_hat$Taxon_5)[1:8])
       ) +
  geom_bar(aes(x = rsv, y = value, fill = Taxon_5), stat = "identity") +
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(breaks = c(0, .02), limits = c(0, .05), oob = scales::rescale_none) +
  facet_grid(time ~ cluster) +
  guides(fill = guide_legend(keywidth = .5, keyheight = .5)) +
  theme(
    panel.border = element_rect(fill = "transparent", size = 0.3),
    panel.spacing = unit(0, "line"),
    axis.text.x = element_blank(),
    legend.text = element_text(size = 6),
    legend.title = element_blank()
  )

multiplot(p1, p2, layout = matrix(c(1, 2, 2, 2), ncol = 1))
