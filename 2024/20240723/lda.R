#! /usr/bin/env Rscript

# File description -------------------------------------------------------------
# RStan code to run LDA on antibiotics dataset.
# Based on
# https://github.com/stan-dev/stan/releases/download/v2.12.0/stan-reference-2.12.0.pdf
# page 157

library("argparser")
parser <- arg_parser("Perform LDA on the antibiotics dataset")
parser <- add_argument(parser, "--subject", help = "Subject on which to perform analysis", default = "F")
argv <- parse_args(parser)
# setwd("src/antibiotics-study")
## ---- setup ----
library("rstan")
library("reshape2")
library("tidyverse")
library("stringr")
library("phyloseq")
library("ggscaffold")
library("feather")
theme_set(min_theme(list(text_size = 7, subtitle_size = 9)))
source("./posterior_check_funs.R")
dir.create("../../data/fits/", recursive = TRUE)
dir.create("../../data/figure-input/", recursive = TRUE)
dir.create("../../doc/figure/", recursive = TRUE)
set.seed(11242016)

## ---- get-data ----
abt <- get(load("../../data/antibiotics-study/abt.rda"))
abt <- abt %>%
  subset_samples(ind == argv$subject)

releveled_sample_data <- abt %>%
  sample_data() %>%
  data.frame() %>%
  mutate(
    condition = recode(
      condition,
      "Pre Cp" = "Pre",
      "1st Cp" = "1st Course",
      "1st WPC" = "1st Course",
      "2nd Cp" = "2nd Course",
      "2nd WPC" = "2nd Course",
      "Post Cp" = "Post"
    )
  )
rownames(releveled_sample_data) <- abt %>%
  sample_data %>%
  rownames
sample_data(abt) <- releveled_sample_data

## ---- histograms ---
transformed_counts <- tibble(
  count = c(get_taxa(abt), asinh(get_taxa(abt))),
  transformation = c(
    rep("original", ntaxa(abt) * nsamples(abt)),
    rep("asinh", ntaxa(abt) * nsamples(abt))
  )
)

p <- ggplot(transformed_counts) +
  geom_histogram(aes(x = count)) +
  facet_grid(. ~ transformation, scale = "free_x") +
  min_theme(list(text_size = 8, subtitle_size = 12))
ggsave("../../doc/figure/histograms-1.png", p)

## ---- heatmaps ----
x_order <- names(sort(taxa_sums(abt)))
y_order <- names(sort(sample_sums(abt)))
ordered_map <- function(x) {
  ggheatmap(
    x %>%
    as.data.frame() %>%
    rownames_to_column("x") %>%
    gather(y, fill, -x),
    list("x_order" = x_order, "y_order" = y_order)
  ) +
    min_theme(list(text_size = 0)) +
    labs(x = "Sample", y = "Microbe")
}

p <- ordered_map(get_taxa(abt)) + ggtitle("Raw")
ggsave("../../doc/figure/heatmaps-1.png", p)

p <- ordered_map(asinh(get_taxa(abt))) + ggtitle("asinh")
ggsave("../../doc/figure/heatmaps-2.png", p)

## ---- lda ----
x <- t(get_taxa(abt))
dimnames(x) <- NULL
stan_data <- list(
  K = 4,
  V = ncol(x),
  D = nrow(x),
  n = x,
  alpha = rep(1, 4),
  gamma = rep(0.5, ncol(x))
)

start_fit <- Sys.time()
f <- stan_model(file = "../stan/lda_counts.stan")
stan_fit <- vb(
  f,
  data = stan_data,
  output_samples = 1000,
  eta = 1,
  adapt_engaged = FALSE
)
cat(sprintf(
  "Finished in %f minutes\n",
  Sys.time() - start_fit, 4)
)

save(
  stan_fit,
  file = sprintf("../../data/fits/lda-%s-%s.rda", argv$subject, gsub("[:|| ||-]", "", Sys.time()))
)
samples <- rstan::extract(stan_fit)
rm(stan_fit)

## ---- extract_beta ----
# underlying RSV distributions
beta_logit <- samples$beta

for (i in seq_len(nrow(beta_logit))) {
  for (k in seq_len(stan_data$K)) {
    beta_logit[i, k, ] <- log(beta_logit[i, k, ])
    beta_logit[i, k, ] <- beta_logit[i, k, ] - mean(beta_logit[i, k, ])
  }
}

beta_hat <- beta_logit %>%
  melt(
    varnames = c("iterations", "topic", "rsv_ix"),
    value.name = "beta_logit"
  ) %>%
  as_data_frame()

beta_hat$rsv <- rownames(tax_table(abt))[beta_hat$rsv_ix]
taxa <- as_data_frame(tax_table(abt)@.Data)
taxa$rsv <- rownames(tax_table(abt))
taxa$Taxon_5[which(taxa$Taxon_5 == "")] <- taxa$Taxon_4[which(taxa$Taxon_5 == "")]

beta_hat <- beta_hat %>%
  left_join(taxa) %>%
  mutate(
    topic = paste("Topic", topic),
    Taxon_5 = str_extract(Taxon_5, "[^_]+")
  )

sorted_taxa <- names(sort(table(beta_hat$Taxon_5), decreasing = TRUE))
beta_hat$Taxon_5 <- factor(beta_hat$Taxon_5, levels = sorted_taxa)
beta_hat$rsv <- factor(beta_hat$rsv, levels = taxa$rsv)

## ---- extract_theta ----
theta_logit <- samples$theta
for (i in seq_len(nrow(theta_logit))) {
  for (d in seq_len(stan_data$D)) {
    theta_logit[i, d, ] <- log(theta_logit[i, d, ])
    theta_logit[i, d, ] <- theta_logit[i, d, ] - mean(theta_logit[i, d, ])
  }
}

theta_hat <- theta_logit %>%
  melt(
    varnames = c("iteration", "sample", "topic"),
    value.name = "theta_logit"
  )

theta_hat$sample <- sample_names(abt)[theta_hat$sample]
sample_info <- sample_data(abt)
sample_info$sample <- rownames(sample_info)
theta_hat$topic <- paste("Topic", theta_hat$topic)

theta_hat <- theta_hat %>%
  left_join(sample_info, by = "sample")

## ---- visualize_lda_theta_heatmap ----
plot_opts <- list(
  "x" = "time",
  "y" = "topic",
  "fill" = "mean_theta",
  "y_order" = paste("Topic", stan_data$K:1)
)

p <- ggheatmap(
  theta_hat %>%
  group_by(topic, time) %>%
  summarise(mean_theta = mean(theta_logit, na.rm = TRUE)) %>%
  as.data.frame(),
  plot_opts
) +
  labs(fill = "g(theta)")
ggsave(
  sprintf("../../doc/figure/visualize_lda_theta_heatmap-%s.png", argv$subject),
  p, width = 7, height = 0.9
)

## ---- visualize_lda_theta_boxplot ----
p <- ggplot(theta_hat) +
  geom_boxplot(
    aes(x = as.factor(time), y = theta_logit),
    fill = "#C9C9C9",
    outlier.size = 0.05,
    size = 0.1,
    notchwidth = 0.1,
    position = position_dodge(width = 0)
  ) +
  scale_y_continuous(breaks = scales::pretty_breaks(3)) +
  min_theme(list(border_size = 0.7, text_size = 10, subtitle_size = 11)) +
  facet_grid(topic ~ condition, scales = "free_x", space = "free_x") +
  geom_hline(yintercept = 0, alpha = 0.4, size = 0.5, col = "#999999") +
  labs(x = "Time", y = expression(paste("g(", theta[k], ")"))) +
  theme(legend.position = "none") +
  scale_x_discrete(breaks = seq(1, 60, by = 10) - 1)
ggsave(
  sprintf("../../doc/figure/visualize_lda_theta_boxplot-%s.png", argv$subject),
  p, width = 6, height = 3.3
)

## ---- visualize_theta_stacked ---
theta <- apply(samples$theta, c(2, 3), mean)
theta <- data.frame(theta) |>
  mutate(sample = paste0("F", row_number())) |>
  left_join(sample_info) |>
  pivot_longer(starts_with("X"), names_to = "topic") |>
  mutate(topic = str_remove(topic, "X"))

library(scico)
theme_set(theme_classic())
ggplot(theta, aes(time, value, fill = topic, col = topic)) +
  geom_col(position = position_stack()) +
  facet_grid(. ~ condition, scales = "free", space = "free") +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  #scale_color_brewer(palette = "Set2", guide = "none") +
  #scale_fill_brewer(palette = "Set2") +
  scale_fill_scico_d() +
  scale_color_scico_d() +
  labs(y = "Topic Membership", x = "Time", fill = "Topic", color = "Topic") +
  theme(
    panel.spacing = unit(0.5, "lines"),
    strip.switch.pad.grid = unit(0, "cm"),
    strip.text.x = element_text(size = 8, angle = 90),
    axis.ticks.x = element_blank(),
    panel.background = element_rect(fill = "transparent", color = NA),
    legend.background = element_rect(fill = "transparent", color = NA),
    strip.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA)
  )
ggsave("../../doc/figure/antibiotic_memberships.png", bg = "transparent", width=8, height=3.5, dpi= 700)

## ---- visualize_lda_beta ----
beta_summary <- beta_hat %>%
  group_by(rsv_ix, topic) %>%
  summarise(
    rsv = rsv[1],
    beta_median = median(beta_logit),
    Taxon_5 = Taxon_5[1],
    beta_upper = quantile(beta_logit, 0.975),
    beta_lower = quantile(beta_logit, 0.025)
  )

levels(beta_summary$Taxon_5) <- append(levels(beta_summary$Taxon_5), "other")
beta_summary$Taxon_5[!(beta_summary$Taxon_5 %in% levels(beta_summary$Taxon_5)[1:7])] <- "other"

beta_subset <- beta_summary %>%
  filter(rsv %in% rev(x_order)[1:750])
beta_subset$rsv_ix <- rep(seq_len(nrow(beta_subset) / 4), each = 4)

p <- ggplot(beta_subset) +
  geom_hline(yintercept = 0, alpha = 0.4, size = 0.5, col = "#999999") +
  geom_point(aes(x = rsv_ix, y = beta_median, col = Taxon_5), size = 0.1) +
  geom_errorbar(
    aes(x = rsv_ix, alpha = beta_upper, ymax = beta_upper, ymin = beta_lower, col = Taxon_5),
    size = 0.4
  ) +
  scale_color_brewer(palette = "Set2") +
  scale_alpha(range = c(0.01, 1), breaks = c(1, 2, 3), guide = FALSE) + ## larger values have darker CIs
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(breaks = scales::pretty_breaks(3), limits = c(-5, 12)) +
  facet_grid(topic ~ .) +
  guides(color = guide_legend(override.aes = list(alpha = 1, size = 2))) +
  labs(x = "Species", y = expression(paste("g(", beta[k], ")")), col = "Family") +
  theme(
    panel.border = element_rect(fill = "transparent", size = 0.75),
    axis.text.x = element_blank(),
    strip.text.x = element_blank(),
    legend.position = "bottom"
  )
ggsave(
  sprintf("../../doc/figure/visualize_lda_beta-%s.png", argv$subject),
  p, width = 6, height = 3.5
)

## ---- beta-commentary ----
inv_logit <- function(x) {
  exp(x) / sum(exp(x))
}

## extract contrasts indicating whether most membership
## comes from one topic
beta_probs <- beta_summary %>%
  group_by(topic) %>%
  mutate(prob = inv_logit(beta_median)) %>%
  select(rsv_ix, rsv, Taxon_5, prob) %>%
  spread(topic, prob)

p_topic <- beta_probs %>%
  select(starts_with("Topic")) %>%
  as.matrix()
rownames(p_topic) <- beta_probs$rsv

for (k in seq_len(stan_data$K)) {
  contrast <- rep(-1, stan_data$K)
  contrast[k] <- 1
  beta_probs[, sprintf("topic_%s_diff", k)] <- p_topic %*% contrast %>%
    as.numeric()
}

## join taxa, sample, and count data, for some plots
sam_data <- abt %>%
  sample_data() %>%
  data.frame() %>%
  rownames_to_column("sample") %>%
  as_data_frame()

mabt <- get_taxa(abt) %>%
  melt(varnames = c("rsv", "sample")) %>%
  as_data_frame() %>%
  left_join(sam_data) %>%
  left_join(beta_summary %>% select(rsv, Taxon_5)) %>%
  mutate(prototypical = NA)

## plot individual species that are representative
## ("prototypical") of given topics
prototypes <- list()
for (k in seq_len(stan_data$K)) {
  prototypes[[k]] <- beta_probs %>%
    arrange_(sprintf("desc(topic_%s_diff)", k)) %>%
    .[["rsv"]]
  mabt[mabt$rsv %in% prototypes[[k]][1:50], "prototypical"] <- paste0("Topic ", k)
}

p <- ggplot(mabt %>% filter(!is.na(prototypical))) +
  geom_line(
    aes(x = time, y = value, group = rsv, col = prototypical),
    alpha = 0.6
  ) +
  scale_y_sqrt(
    "abundance (sqrt scale)",
    breaks = scales::pretty_breaks(3)
  ) +
  facet_grid(Taxon_5 ~ prototypical, scale = "free_y") +
  scale_color_scico_d("") +
  theme(
    strip.text.y = element_text(angle = 0),
    panel.border = element_rect(fill = "transparent", size = 0.75),
    panel.background = element_rect(fill = "transparent", color = NA),
    legend.position = "none",
    legend.background = element_rect(fill = "transparent", color = NA),
    strip.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA)
  )
ggsave(
  "../../doc/figure/antibiotic_prototypes.png",
  p, width = 8, height = 3.7, dpi = 800,
  bg = "transparent"
)
stop()
for (k in seq_len(stan_data$K)) {
  cur_prototypes <- mabt %>%
    filter(rsv %in% prototypes[[k]][1:15])
  cur_prototypes$rsv <- factor(cur_prototypes$rsv, levels = prototypes[[k]][1:15])
  p <- ggplot(cur_prototypes) +
    geom_line(aes(x = time, y = value, col = Taxon_5)) +
    scale_y_sqrt(breaks = scales::pretty_breaks(3)) +
    scale_color_manual(
      "Family",
      values = c("Lachnospiraceae" = "#66C2A5", "Ruminococcaceae" = "#FC8D62",
                 "Bacteroidaceae" = "#8DA0CB", "uncultured" = "#E78AC3",
                 "other" = "grey"),
      guide = guide_legend(override.aes = list(alpha = 1, size = 3)),
      na.value = "black"
    ) +
    facet_wrap(~rsv, scale = "free_y", nrow = 3) +
    theme(
      panel.border = element_rect(fill = "transparent", size = 0.75),
      legend.position = "bottom"
    )
  ggsave(
    sprintf("../../doc/figure/species_prototypes_%s.png", k),
    p, width = 6.5, height = 3.5
  )
}

## make comparisons at the family level, by studying
## the average probability assigned to each topic,
## across all species within that family.
taxa_df <- tax_table(abt) %>%
  data.frame() %>%
  rownames_to_column("rsv")
ave_probs <- beta_summary %>%
  group_by(topic) %>%
  mutate(prob = inv_logit(beta_median)) %>%
  select(-Taxon_5) %>%
  left_join(taxa_df) %>%
  filter(Taxon_5 != "") %>%
  group_by(topic, Taxon_5) %>%
  summarise(n_prob = n(), ave_prob = mean(prob)) %>%
  arrange(topic, desc(ave_prob))

uneven_probs <- ave_probs %>%
  filter(ave_prob > 0.0001)
mbt_uneven_taxa <- mabt %>%
  select(-Taxon_5) %>%
  left_join(taxa_df) %>%
  filter(Taxon_5 %in% uneven_probs$Taxon_5)

Taxon_5_order <- uneven_probs %>%
  group_by(Taxon_5) %>%
  summarise(max_ave = max(ave_prob)) %>%
  arrange(desc(max_ave)) %>%
  .[["Taxon_5"]]
uneven_probs$Taxon_5 <- factor(
  uneven_probs$Taxon_5,
  levels = Taxon_5_order
)

## visualize the unevenness in topic assignments across taxa
p <- ggplot(uneven_probs) +
  geom_point(
    aes(
      x = Taxon_5,
      y = ave_prob,
      col = topic,
      size = n_prob
    ),
    alpha = 0.6
  ) +
  labs(x = "Family", y = "Average Topic Probability", size = "n[taxa]") +
  theme(
    axis.text.x = element_text(angle = -90, hjust = 0),
    panel.border = element_rect(size = 1, fill = "transparent")
  )
ggsave(
  "../../doc/figure/uneven_taxa_ordered.png",
  p, width = 5, height = 5
)

mbt_uneven_taxa$Taxon_5 <- factor(mbt_uneven_taxa$Taxon_5, levels = Taxon_5_order)
p <- ggplot(mbt_uneven_taxa) +
  geom_line(
    aes(x = time, y = value, group = rsv, col = prototypical),
    alpha = 0.6
  ) +
  scale_y_sqrt(breaks = scales::pretty_breaks(3)) +
  scale_color_hue("Prototype", guide = guide_legend(override.aes = list(alpha = 1, size = 2))) +
  facet_wrap(~ Taxon_5, scale = "free_y") +
  labs(y = "abundance (sqrt scale)") +
  theme(
    strip.text = element_text(size = 6.5),
    axis.text = element_text(size = 6),
    legend.position = "bottom",
    panel.border = element_rect(fill = "transparent", size = 0.75)
  )
ggsave(
  "../../doc/figure/uneven_taxa_facet.png",
  p, width = 6, height = 3.5
)

## ---- posterior-checks ----
checks_data <- posterior_checks_input(
  x,
  samples$x_sim,
  sprintf("../../data/figure-input/lda-%s", argv$subject)
)

## ---- js-input ----
colnames(beta_summary) <- c("ix", "topic", "label", "median", "fill", "upper", "lower")
cat(
  sprintf("var beta = %s", jsonlite::toJSON(beta_summary, auto_unbox = TRUE)),
  file = sprintf("vis/lda_beta-%s.js", argv$subject)
)
