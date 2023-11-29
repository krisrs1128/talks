library(GGally)
library(SummarizedExperiment)
library(ggraph)
library(gamboostLSS)
library(glue)
library(qgraph)
library(patchwork)
library(progress)
library(ggdist)
library(scDesigner)
library(splines)
library(tidygraph)
library(tidyverse)
#********#
library(SpiecEasi)
library(corrplot)
#********#

block_matrix <- function(cors, lengths) {
  blocks <- map2(cors, lengths, ~ matrix(rep(.x, .y ^ 2), .y))
  rho <- as.matrix(Matrix::bdiag(blocks))
  diag(rho) <- 1
  rho
}

combine_sources <- function(taxa, sample_info) {
  sample_info <- rownames_to_column(sample_info, "sample_id")
  sample_names <- colnames(sample_info)
  taxa_order <- tibble(
    taxon = colnames(taxa),
    rank = order(colSums(taxa), decreasing = TRUE)
  )

  bind_cols(sample_info, taxa) |>
    pivot_longer(-any_of(sample_names), names_to = "taxon") |>
    mutate(
      taxon = factor(taxon, levels = taxa_order$taxon),
      day = as.numeric(str_extract(Day, "[0-9]"))
    ) |>
    left_join(taxa_order)
}

contrast_series <- function(simulator, samples, features, new_data,
                            title = "") {
  p <- plot(
    simulator, "day", samples,
    col = "Diet",
    feature = features, new_data = new_data
  )

  ggplot(p$data) +
    geom_line(
      aes(
        day, log(1 + value),
        group = interaction(replicate, MouseID),
        col = Diet
      ),
      linewidth = 0.5, alpha = 0.6
    ) +
    facet_grid(source ~ feature) +
    labs(x = "Day", y = expression(log(1 + "Abundance")), title = title) +
    guides(col = guide_legend(override.aes = list(alpha = 1, linewidth = 2)))
}


plot_series <- function(x, max_rank = 10, transform = identity) {
  x |>
    filter(rank < max_rank) |>
    ggplot() +
    geom_line(
      aes(day, transform(value), col = Diet, group = MouseID)
    ) +
    facet_wrap(~ reorder(taxon, rank), scales = "free")
}

plot_histogram <- function(x, max_rank = 10, transform = identity) {
  x |>
    filter(rank < max_rank) |>
    ggplot() +
    geom_histogram(
      aes(transform(value), fill = Diet),
      position = "identity", alpha = 0.8
    ) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    facet_wrap(~ reorder(taxon, rank), scales = "free")
}

widen_data <- function(x, max_rank = NULL, transform = identity) {
  if (is.null(max_rank)) {
    max_rank <- max(x$rank)
  }

  taxa <- distinct(x, taxon) |>
    pull(taxon)

  x |>
    filter(rank <= max_rank) |>
    mutate(value = transform(value)) |>
    select(taxon, value, day, MouseID, Diet) |>
    pivot_wider(names_from = taxon, values_from = value, values_fn = list) |>
    unnest(any_of(taxa))
}

groupwise_average <- function(exper, vars, within) {
  colData(exper) <- colData(exper) |>
    data.frame() |>
    rownames_to_column("row") |>
    group_by(!!enquo(within)) |>
    mutate(across(any_of(vars), mean)) |>
    column_to_rownames("row") |>
    DataFrame()

  exper
}

sample_mds <- function(exper, n) {
  SummarizedExperiment::colData(exper) |>
    data.frame() |>
    dplyr::select(Diet, dplyr::starts_with("MDS")) |>
    unique() |>
    dplyr::group_by(Diet) |>
    dplyr::sample_n(n / 2, replace = TRUE) |>
    dplyr::ungroup() |>
    dplyr::arrange(Diet) |>
    dplyr::mutate(MouseID = seq_len(n))
}

pairs_plot <- function(
    x, columns, points_opts = list(alpha = 0.7, size = 0.9),
    ...) {
  x |>
    filter(taxon %in% columns) |>
    widen_data(...) |>
    select(-day:-MouseID) |>
    ggpairs(
      aes(col = Diet),
      columns = columns,
      lower = list(continuous = do.call(wrap, c("points", points_opts))),
      progress = FALSE
    )
}

pairwise_hist <- function(x, ...) {
  widen_data(x, ...) |>
    select(-day:-MouseID) %>%
    split(.$Diet) |>
    map_dfr(~ {
      as.data.frame(.) |>
        select(-Diet) |>
        cor() |>
        as_tibble() |>
        pivot_longer(everything(), names_to = "taxon")
    }, .id = "Diet") |>
    ggplot() +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(expand = c(0, 0)) +
    geom_histogram(
      aes(value, fill = Diet),
      position = "identity", alpha = 0.7, bins = 40
    )
}

mean_variance <- function(x, ...) {
  x |>
    group_by(taxon, Diet) |>
    mutate(value = log(1 + value)) |>
    summarise(mvalue = mean(value), sigma_value = sd(value)) |>
    ggplot() +
    geom_point(aes(mvalue, sigma_value, col = Diet))
}

save_results <- function(sim_df, omega, new_data, out_suffix = "") {
  save(new_data, file = glue("data/SampleData{out_suffix}.rds"))
  counts <- xtabs(value ~ MouseID + taxon + day, sim_df)
  save(counts, file = glue("data/CountData{out_suffix}.rds"))
  lib_sizes <- apply(counts, c(1, 3), sum)
  save(lib_sizes, file = glue("data/LibSize{out_suffix}.rds"))

  binarized <- map(omega, ~ 1 * (. != 0))
  para <- c(omega, binarized)
  names(para) <- c(
    "omega.graph1_h",
    "omega.graph1_n",
    "binary.graph1_h",
    "binary.graph1_n"
  )
  save(para, file = glue("data/para{out_suffix}.rds"))
}

#********#
filter_otu_ids <- function(data.raw, sample.info, min_ra = 0.5) {
  filtered_bio_OTU<-data.raw|>  data.frame()%>%
    filter(sample.info$Rep=="Biological" & rownames(.)!="83M" &sample.info$Day!="A")
  
  df_libsize<-data.frame(sample_name = rownames(filtered_bio_OTU), lib.size=rowSums(filtered_bio_OTU))
  
  #### filtering data by minimum reads ans minimum occurance(i.e., % of zeros) ####
  sample.info<- sample.info|>rownames_to_column('sample_name')
  t(apply(filtered_bio_OTU,1, function(x) x/sum(x))) |>
    data.frame() |>
    rownames_to_column('sample_name')|>
    pivot_longer(cols = -sample_name,
                 names_to = 'sOTUs',
                 values_to = 'RelativeAbundance') |> 
    mutate(RelativeAbundance = 100*RelativeAbundance) |>
    left_join(sample.info, by = 'sample_name')  |> 
    group_by(sOTUs, Diet, Day) |>
    summarise(MeanRA = mean(RelativeAbundance)) |>
    filter(MeanRA >= min_ra) |>
    pivot_wider(names_from = sOTUs, 
                values_from = MeanRA)|>
    select_if(~ !any(is.na(.)))|>
    colnames()|>
    select_v(starts_with("OTU"))
}

select_v <- function(x, ...) {
  x_df <- as.data.frame(matrix(ncol = length(x)))
  names(x_df) <- x
  names(dplyr::select(x_df, ...))
}
#********#

max_cor <- \(rho, samples) {
  diag(rho) <- 0
  max_ix <- which(rho == max(rho), arr.ind = TRUE)
  rownames(samples)[max_ix]
}

plot_samples <- function(se, reorder = TRUE, otu_order = NULL) {
  result <- scDesigner:::pivot_experiment(se) |>
    mutate(
      Diet = ifelse(Diet == "HFHS", "High Fat", "Normal"),
      feature = factor(feature, levels = otu_order)
    ) |>
    filter(feature %in% otu_order[1:7])
  
  if (reorder) {
    result <- result |>
      mutate(
        MouseID = factor(MouseID, levels = vctrs::vec_interleave(1:23, 24:46))
      )
  }
  
  ggplot(result) +
    geom_line(aes(day, log(1 + value), group = MouseID, col = Diet), alpha = 0.9, size = 0.5) +
    facet_wrap(~ feature, ncol = 7) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(breaks = c(3, 6, 9)) +
    scale_color_manual(values = c("#575FF2", "#3BD97F")) +
    guides(color = guide_legend(override.aes = list(linewidth = 5))) +
    labs(x = "Day", y = expression(log(1 + value))) +
    theme(
      legend.position = "bottom",,
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12),
      strip.text = element_text(size = 10),
      legend.text = element_text(size = 12),
      legend.title = element_text(size = 14)
    )
}
