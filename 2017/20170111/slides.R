#! /usr/bin/env Rscript

## File description -------------------------------------------------------------
## This includes the code for generating figures that appear in the slides for
## lab meeting on January 11, 2017.

## ---- setup ----
## Setup packages ---------------------------------------------------------------
## List of packages for session
library("data.table")
library("plyr")
library("dplyr")
library("reshape2")
library("ggplot2")
library("ggscaffold")
library("feather")

## Load packages into session
set.seed(05122016)
rm(list = ls()) ## Delete all existing variables

## Multiple plot function
##
## ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
## - cols:   Number of columns in layout
## - layout: A matrix specifying the layout. If present, 'cols' is ignored.
##
## If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
## then plot 1 will go in the upper left, 2 will go in the upper right, and
## 3 will go all the way across the bottom.
##
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  ## Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  ## If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    ## Make the panel
    ## ncol: Number of columns of plots
    ## nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }

  if (numPlots==1) {
    print(plots[[1]])

  } else {
    ## Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    ## Make each plot, in the correct location
    for (i in 1:numPlots) {
      ## Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

## ---- lda_data ----
beta_hat <- read_feather("/scratch/users/kriss1/programming/readings/lda/results/beta.feather")
theta_hat <- read_feather("/scratch/users/kriss1/programming/readings/lda/results/theta.feather")

## ---- lda_figures ----
theta_hat$cluster <- gsub("Cluster ", "", theta_hat$cluster)
theta_hat$cluster <- factor(theta_hat$cluster, levels = c("4", "3", "2", "1"))

plot_opts <- list(
  "x" = "time",
  "y" = "cluster",
  "fill" = "theta"
)
p1 <- ggheatmap(theta_hat, plot_opts)

plot_opts <- list(
  "x" = "as.factor(time)",
  "y" = "theta",
  "facet_terms" = c("cluster", "time")
)
p1 <- ggboxplot(data.frame(theta_hat), plot_opts)

plot_opts <- list(
  "x" = "rsv",
  "y" =  "beta",
  "fill" = "Taxon_5",
  "col" = "Taxon_5",
  "facet_terms" = c("cluster", "Taxon_5"),
  "facet_scales" = "free_x",
  "facet_space" = "free_x",
  "theme_opts" = list(border_size = 0)
)
p2 <- ggboxplot(
  beta_hat %>% data.frame() %>% filter(Taxon_5 %in% levels(beta_hat$Taxon_5)[1:8]),
  plot_opts
) +
  labs(y = "beta", fill = "Family") +
  theme(
    axis.text.x = element_blank(),
    strip.text.x = element_blank()
  )
multiplot(p1, p2, ncol = 1)

 ## ---- unigram_data ----
beta_hat <- read_feather("/scratch/users/kriss1/programming/readings/dtm/beta_unigram.feather")

## ---- unigram_series ----
plot_opts <- list(
  "x" = "time",
  "y" = "mean_prob",
  "col" = "Taxon_5",
  "alpha" = 0.4,
  "group" = "rsv",
  "facet_terms" = c("Taxon_5", ".")
)
gglines(
  beta_hat %>%
  filter(Taxon_5 %in% levels(beta_hat$Taxon_5)[1:8]) %>%
  group_by(rsv, time) %>%
  summarise(mean_prob = mean(prob), Taxon_5 = Taxon_5[1]) %>%
  as.data.frame(),
  plot_opts
) +
  theme(
    strip.text.y = element_blank(),
    legend.position = "bottom"
  )

## ---- unigram-beta-box ----
plot_opts <- list(
  "x" = "rsv",
  "y" = "prob",
  "fill" = "Taxon_5",
  "col" = "Taxon_5",
  "outlier.size" = 0.01,
  "alpha" = 0.4,
  "facet_terms" = c("time", "Taxon_5"),
  "facet_scales" = "free_x",
  "facet_space" = "free_x"
)
ggboxplot(
  beta_hat %>%
  filter(Taxon_5 %in% levels(beta_hat$Taxon_5)[1:8]) %>%
  as.data.frame(),
  plot_opts
) +
  theme(
    strip.text.x = element_blank(),
    axis.text.x = element_blank(),
    legend.position = "bottom"
  )

## ---- dtm_data ----
theta_hat <- read_feather("/scratch/users/kriss1/programming/readings/dtm/dtm_theta_hat.feather")
mbeta_hat <- read_feather("/scratch/users/kriss1/programming/readings/dtm/dtm_mbeta_hat.feather")

## ---- dtm_figures ----
plot_opts <- list(
  "x" = "time",
  "y" = "cluster",
  "fill" = "value",
  "coord_ratio" = 2
)
ggheatmap(theta_hat, plot_opts)

cast_theta <- theta_hat %>%
  dcast(sample + ind + condition + time ~ cluster) %>%
  setnames(c("sample", "ind", "condition", "time", "cluster_1", "cluster_2"))
plot_opts <- list(
  "x" = "as.factor(time)",
  "y" = "cluster_1"
)

ggboxplot(cast_theta, plot_opts)

ggcontours(cast_theta, plot_opts)

ggplot(theta_hat %>%
       dcast(sample + ind + condition + time ~ cluster)
       ) +
  geom_point()

p1 <- ggplot(theta_hat) +
  geom_tile(aes(x = time, y = cluster, fill = value)) +
  scale_fill_gradient(low = "#FFFFFF", high = "#5BBABA", limits = c(.3, .7)) +
  guides(fill = guide_legend(keywidth = .2, keyheight = .4)) +
  facet_grid(~condition, scale = "free_x", space = "free_x") +
  labs(x = "time") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  coord_fixed(2) +
  theme(
    panel.border = element_rect(fill = "transparent", size = .4, color = "#C9C9C9"),
    panel.spacing = unit(0, "line"),
    ##legend.text = element_text(size = 6),
    legend.title = element_blank()
  )

p2 <- ggplot(mbeta_hat %>%
        filter(Taxon_5 %in% levels(mbeta_hat$Taxon_5)[1:8])
      ) +
  geom_bar(aes(x = rsv, y = value, fill = Taxon_5), stat = "identity") +
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(breaks = c(0, .02), limits = c(0, .05), oob = scales::rescale_none) +
  facet_grid(time ~ cluster) +
  guides(fill = guide_legend(keywidth = .2, keyheight = .4)) +
  theme(
    panel.border = element_rect(fill = "transparent", size = 0.3),
    panel.spacing = unit(0, "line"),
    axis.text.x = element_blank(),
    ##legend.text = element_text(size = 6),
    legend.title = element_blank()
  )

multiplot(p1, p2, layout = matrix(c(1, 2, 2, 2), ncol = 1))

## ---- read-bootstrap-sim ----
theta <- list()
beta <- list()
theta[[1]] <- read_feather("/scratch/users/kriss1/programming/research/bootstrap_lda/figure/d100_n20/theta_merged.feather")
theta[[2]] <- read_feather("/scratch/users/kriss1/programming/research/bootstrap_lda/figure/d100_n100/theta_merged.feather")
beta[[1]] <- read_feather("/scratch/users/kriss1/programming/research/bootstrap_lda/figure/d100_n20/beta_merged.feather")
beta[[2]] <- read_feather("/scratch/users/kriss1/programming/research/bootstrap_lda/figure/d100_n100/beta_merged.feather")

theta <- do.call(rbind, theta)
beta <- do.call(rbind, beta)

## Reshape
theta_supp <- theta %>%
  filter(method %in% c("truth")) %>%
  mutate(type = method) %>%
  select(-method)
theta <- theta %>%
  filter(!(method %in% c("truth", "vb_fit")))

beta_supp <- beta %>%
  filter(method %in% c("truth")) %>%
  mutate(type = method) %>%
  select(-method)
beta <- beta %>%
  filter(!(method %in% c("truth", "vb_fit", "vb_mean")))

beta_cast <- beta %>%
  data.table::setDT() %>%
  data.table::dcast(rep + v + method + N ~ k, value.vars = "value")
colnames(beta_cast) <- make.names(colnames(beta_cast))

beta_supp_cast <- beta_supp %>%
  dcast(rep + v + N ~ k, value.vars = "value")
colnames(beta_supp_cast) <- make.names(colnames(beta_supp_cast))

theta_cast <- theta %>%
  dcast(rep + n + method + N ~ k, value.var = "theta")
colnames(theta_cast) <- make.names(colnames(theta_cast))

theta_supp_cast <- theta_supp %>%
  dcast(rep + n + N ~ k, value.var = "theta")
colnames(theta_supp_cast) <- make.names(colnames(theta_supp_cast))

## ---- compare-beta-plot ----
ggplot() +
  stat_density2d(
    data = beta_cast,
    aes(x = X1, y = X2, group = as.factor(v), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.01, bins = 40
  ) +
  geom_text(
    data = beta_supp_cast,
    aes(x = X1, y = X2, label = v),
    size = 1.3
  ) +
  coord_fixed() +
  facet_grid(N ~ method) +
  scale_fill_gradientn(colors = viridis(256, option = "D"), breaks = -3:0)

## ---- compare-theta-plot ----
ggplot() +
  geom_vline(
    data = theta_supp_cast %>% filter(as.numeric(n) < 10),
    aes(xintercept = X1),
    size = .4, alpha = 0.6
  ) +
  stat_density(
    data = theta_cast %>% filter(as.numeric(n) < 10),
    aes(x = X1, fill = method),
    alpha = 0.7
  ) +
  facet_grid(n ~ N)

## ---- nmf-setup ----
stan_data <- list(
  K = 2,
  N = 100,
  P = 75,
  a = 1,
  b = 1,
  c = 1,
  d = 1
)
attach(stan_data)

## scores
theta <- matrix(
  rgamma(N * K, rate = a, shape = b),
  N, K
)

## factors
beta <- matrix(
  rgamma(P * K, rate = a, shape = b),
  P, K
)

## observations
y <- matrix(
  rpois(N * P, theta %*% t(beta)),
  N, P
)

## ---- nmf-heatmap ----
y_df <- melt(y)
y_df$Var1 <- factor(y_df$Var1, levels = order(theta[, 1]))
y_df$Var2 <- factor(y_df$Var2, levels = order(beta[, 1]))
ggplot(y_df) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  scale_fill_gradient(low = "white", high = "#C36395") +
  coord_fixed() +
    guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  labs(x = "variable", y = "sample")

## ---- nmf-pca----
compare_data <- data.frame(
  theta,
  princomp(scale(y))$scores
)

ggplot(compare_data) +
  geom_point(aes(x = Comp.1, Comp.2, size = X1, col = X2)) +
  coord_fixed() +
  theme(legend.position = "none")

## ---- nmf-overdispersion ----
yy <- sort(rpois(N * P, mean(y)))
qq_df <- data.frame(
  y = c(sort(y), yy),
  label = c(rep("gamma-poisson", N * P), rep("poisson", N * P))
)

ggplot(qq_df) +
  geom_histogram(aes(x = y), binwidth = .5) +
  facet_grid(label ~ .)

## ---- theta-gibbs ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf.rda"))
theta_fit <- melt(
   fit$theta,
   varnames = c("iteration", "i", "k")
) %>%
  left_join(
    melt(
      theta,
      varnames = c("i", "k"),
      value.name = "truth"
    )
  )

theta_fit$i <- factor(
  theta_fit$i,
  levels = order(theta[, 1])
)

theta_fit_cast <- theta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(i + iteration ~ k, value.var = c("value", "truth"))

p <- ggplot() +
  stat_density2d(
    data = theta_fit_cast,
    aes(x = value_1, y = value_2, group = as.factor(i), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
  ) +
  geom_text(
    data = theta_fit_cast %>%
      group_by(i) %>%
      summarise(mean_1 = mean(value_1), mean_2 = mean(value_2)),
    aes(x = mean_1, y = mean_2, label = i),
    col = "#e34a33",
    size = 1.3
  ) +
  geom_text(
    data = theta_fit_cast %>% filter(iteration == 1),
    aes(x = truth_1, y = truth_2, label = i),
    size = 1.3
  ) +
  xlim(0, 6) +
  ylim(0, 8) +
  guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  theme(
    axis.text = element_blank(),
    panel.spacing = unit(0, "line")
  ) +
  coord_fixed() +
  scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- theta-vb ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf_vb.rda"))

theta_fit <- melt(
   fit$theta,
   varnames = c("iteration", "i", "k")
) %>%
  left_join(
    melt(
      theta,
      varnames = c("i", "k"),
      value.name = "truth"
    )
  )

theta_fit$i <- factor(
  theta_fit$i,
  levels = order(theta[, 1])
)

theta_fit_cast <- theta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(i + iteration ~ k, value.var = c("value", "truth"))

 p <- ggplot() +
   stat_density2d(
     data = theta_fit_cast,
     aes(x = value_1, y = value_2, group = as.factor(i), fill = log(..level..)),
     geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
   ) +
   geom_text(
     data = theta_fit_cast %>%
       group_by(i) %>%
       summarise(mean_1 = mean(value_1), mean_2 = mean(value_2)),
     aes(x = mean_1, y = mean_2, label = i),
     col = "#e34a33",
     size = 1.3
   ) +
   geom_text(
     data = theta_fit_cast %>% filter(iteration == 1),
     aes(x = truth_1, y = truth_2, label = i),
     size = 1.3
   ) +
   xlim(0, 6) +
   ylim(0, 8) +
   guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
   theme(
     axis.text = element_blank(),
     panel.spacing = unit(0, "line")
   ) +
   coord_fixed() +
   scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- beta-gibbs ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf.rda"))
beta_fit <- melt(
  fit$beta,
  varnames = c("iteration", "v", "k")
) %>%
  left_join(
    melt(
      beta,
      varnames = c("v", "k"),
      value.name = "truth"
    )
  )

beta_fit$i <- factor(
  beta_fit$i,
  levels = order(beta[, 1])
)

beta_fit_cast <- beta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(v + iteration ~ k, value.var = c("value", "truth"))

p <- ggplot() +
  stat_density2d(
    data = beta_fit_cast,
    aes(x = value_1, y = value_2, group = as.factor(v), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
  ) +
  geom_text(
    data = beta_fit_cast %>%
      group_by(v) %>%
      summarise(mean_1 = mean(value_1), mean_2 = mean(value_2)),
    aes(x = mean_1, y = mean_2, label = v),
    col = "#e34a33",
    size = 1.3
  ) +
  xlim(0, 6.5) +
  ylim(0, 7) +
  geom_text(
    data = beta_fit_cast %>% filter(iteration == 1),
    aes(x = truth_1, y = truth_2, label = v),
    size = 1.3
  ) +
  guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  theme(
    axis.text = element_blank(),
    panel.spacing = unit(0, "line")
  ) +
  coord_fixed() +
  scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- beta-vb ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf_vb.rda"))
beta_fit <- melt(
  fit$beta,
  varnames = c("iteration", "v", "k")
) %>%
  left_join(
    melt(
      beta,
      varnames = c("v", "k"),
      value.name = "truth"
    )
  )

beta_fit$i <- factor(
  beta_fit$i,
  levels = order(beta[, 1])
)

beta_fit_cast <- beta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(v + iteration ~ k, value.var = c("value", "truth"))

p <- ggplot() +
  stat_density2d(
    data = beta_fit_cast,
    aes(x = value_1, y = value_2, group = as.factor(v), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
  ) +
  geom_text(
    data = beta_fit_cast %>%
      group_by(v) %>%
      summarise(mean_1 = mean(value_1), mean_2 = mean(value_2)),
    aes(x = mean_1, y = mean_2, label = v),
    col = "#e34a33",
    size = 1.3
  ) +
  geom_text(
    data = beta_fit_cast %>% filter(iteration == 1),
    aes(x = truth_1, y = truth_2, label = v),
    size = 1.3
  ) +
  guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  xlim(0, 6.5) +
  ylim(0, 7) +
  theme(
    axis.text = element_blank(),
    panel.spacing = unit(0, "line")
  ) +
  coord_fixed() +
  scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- nmf-zero-setup ----
set.seed(01082017)
stan_data <- list(
  K = 2,
  N = 100,
  P = 75,
  a = 1,
  b = 1,
  c = 1,
  d = 1,
  zero_inf_prob = 0.8
)
attach(stan_data)

## scores
theta <- matrix(
  rgamma(N * K, rate = a, shape = b),
  N, K
)

## factors
beta <- matrix(
  rgamma(P * K, rate = a, shape = b),
  P, K
)

## observations
y <- matrix(
  rpois(N * P, theta %*% t(beta)),
  N, P
)

## set some proportion to zero
mask <- matrix(
  sample(
    c(0, 1),
    N * P,
    replace = T,
    prob = c(stan_data$zero_inf_prob, 1 - stan_data$zero_inf_prob)),
  N, P
)
y[mask == 1] <- 0

## ---- nmf-zeros-heatmap ----
y_df <- melt(y)
y_df$Var1 <- factor(y_df$Var1, levels = order(theta[, 1]))
y_df$Var2 <- factor(y_df$Var2, levels = order(beta[, 1]))
ggplot(y_df) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  scale_fill_gradient(low = "white", high = "#C36395") +
  coord_fixed() +
    guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  labs(x = "variable", y = "sample")


## ---- nmf-zeros-pca ----
compare_data <- data.frame(
  theta,
  princomp(scale(y))$scores
)

ggplot(compare_data) +
  geom_point(aes(x = Comp.1, Comp.2, size = X1, col = X2)) +
  coord_fixed() +
  theme(legend.position = "none")

## ---- zeros-overdispersion ----
yy <- sort(rpois(N * P, mean(y)))
qq_df <- data.frame(
  y = c(sort(y), yy),
  label = c(rep("gamma-poisson-zinf", N * P), rep("poisson", N * P))
)

ggplot(qq_df) +
  geom_histogram(aes(x = y), binwidth = .5) +
  facet_grid(label ~ .)

## ---- zero-theta-gibbs ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf_zero.rda"))
theta_fit <- melt(
   fit$theta,
   varnames = c("iteration", "i", "k")
) %>%
  left_join(
    melt(
      theta,
      varnames = c("i", "k"),
      value.name = "truth"
    )
  )

theta_fit$i <- factor(
  theta_fit$i,
  levels = order(theta[, 1])
)

theta_fit_cast <- theta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(i + iteration ~ k, value.var = c("value", "truth"))

p <- ggplot() +
  stat_density2d(
    data = theta_fit_cast,
    aes(x = value_1, y = value_2, group = as.factor(i), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
  ) +
  geom_text(
    data = theta_fit_cast %>%
      group_by(i) %>%
      summarise(mean_1 = mean(value_1), mean_2 = mean(value_2)),
    aes(x = mean_1, y = mean_2, label = i),
    col = "#e34a33",
    size = 1.3
  ) +
  geom_text(
    data = theta_fit_cast %>% filter(iteration == 1),
    aes(x = truth_1, y = truth_2, label = i),
    size = 1.3
  ) +
  xlim(0, 6) +
  ylim(0, 8) +
  guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  theme(
    axis.text = element_blank(),
    panel.spacing = unit(0, "line")
  ) +
  coord_fixed() +
  scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- zero-theta-vb ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf_zero_vb.rda"))
theta_fit <- melt(
   fit$theta,
   varnames = c("iteration", "i", "k")
) %>%
  left_join(
    melt(
      theta,
      varnames = c("i", "k"),
      value.name = "truth"
    )
  )

theta_fit$i <- factor(
  theta_fit$i,
  levels = order(theta[, 1])
)

theta_fit_cast <- theta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(i + iteration ~ k, value.var = c("value", "truth"))

 p <- ggplot() +
   stat_density2d(
     data = theta_fit_cast,
     aes(x = value_2, y = value_1, group = as.factor(i), fill = log(..level..)),
     geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
   ) +
   geom_text(
     data = theta_fit_cast %>%
       group_by(i) %>%
       summarise(mean_1 = mean(value_2), mean_2 = mean(value_1)),
     aes(x = mean_1, y = mean_2, label = i),
     col = "#e34a33",
     size = 1.3
   ) +
   geom_text(
     data = theta_fit_cast %>% filter(iteration == 1),
     aes(x = truth_1, y = truth_2, label = i),
     size = 1.3
   ) +
   xlim(0, 6) +
   ylim(0, 8) +
   guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
   theme(
     axis.text = element_blank(),
     panel.spacing = unit(0, "line")
   ) +
   coord_fixed() +
   scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- zero-beta-gibbs ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf_zero.rda"))
beta_fit <- melt(
  fit$beta,
  varnames = c("iteration", "v", "k")
) %>%
  left_join(
    melt(
      beta,
      varnames = c("v", "k"),
      value.name = "truth"
    )
  )

beta_fit$i <- factor(
  beta_fit$i,
  levels = order(beta[, 1])
)

beta_fit_cast <- beta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(v + iteration ~ k, value.var = c("value", "truth"))

p <- ggplot() +
  stat_density2d(
    data = beta_fit_cast,
    aes(x = value_1, y = value_2, group = as.factor(v), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
  ) +
  geom_text(
    data = beta_fit_cast %>%
      group_by(v) %>%
      summarise(mean_1 = mean(value_1), mean_2 = mean(value_2)),
    aes(x = mean_1, y = mean_2, label = v),
    col = "#e34a33",
    size = 1.3
  ) +
  xlim(0, 6.5) +
  ylim(0, 7) +
  geom_text(
    data = beta_fit_cast %>% filter(iteration == 1),
    aes(x = truth_1, y = truth_2, label = v),
    size = 1.3
  ) +
  guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  theme(
    axis.text = element_blank(),
    panel.spacing = unit(0, "line")
  ) +
  coord_fixed() +
  scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p

## ---- zero-beta-vb ----
fit <- get(load("/scratch/users/kriss1/classes/stan_exercises/nmf_zero_vb.rda"))
beta_fit <- melt(
  fit$beta,
  varnames = c("iteration", "v", "k")
) %>%
  left_join(
    melt(
      beta,
      varnames = c("v", "k"),
      value.name = "truth"
    )
  )

beta_fit$i <- factor(
  beta_fit$i,
  levels = order(beta[, 1])
)

beta_fit_cast <- beta_fit %>%
  data.table::setDT() %>%
  data.table::dcast(v + iteration ~ k, value.var = c("value", "truth"))

p <- ggplot() +
  stat_density2d(
    data = beta_fit_cast,
    aes(x = value_2, y = value_1, group = as.factor(v), fill = log(..level..)),
    geom = "polygon", alpha = 0.05, h = 0.4, bins = 40
  ) +
  geom_text(
    data = beta_fit_cast %>%
      group_by(v) %>%
      summarise(mean_1 = mean(value_2), mean_2 = mean(value_1)),
    aes(x = mean_1, y = mean_2, label = v),
    col = "#e34a33",
    size = 1.3
  ) +
  geom_text(
    data = beta_fit_cast %>% filter(iteration == 1),
    aes(x = truth_1, y = truth_2, label = v),
    size = 1.3
  ) +
  xlim(0, 6.5) +
  ylim(0, 7) +
  guides(fill = guide_legend(keywidth = 0.4, keyheight = 0.8, override.aes = list(alpha = 1))) +
  theme(
    axis.text = element_blank(),
    panel.spacing = unit(0, "line")
  ) +
  coord_fixed() +
  scale_fill_gradientn(colours = viridis(256, option = "D"), breaks = -3:0)
p
