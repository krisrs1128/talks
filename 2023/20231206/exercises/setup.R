knitr::opts_chunk$set(
  fig.align = "center",
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE, 
  eval = TRUE,
  cache = FALSE,
  dev.args = list(bg = "transparent")
)

library(tidyverse)
options(
  ggplot2.discrete.colour = c("#9491D9", "#3F8C61", "#F24405", "#8C2E62", "#F2B705", "#11A0D9"),
  ggplot2.discrete.fill = c("#9491D9", "#3F8C61", "#F24405", "#8C2E62", "#F2B705", "#11A0D9"),
  ggplot2.continuous.colour = function(...) scale_color_distiller(palette = "Spectral", ...),
  ggplot2.continuous.fill = function(...) scale_fill_distiller(palette = "Spectral", ...)
)

th <- theme_classic() +
  theme(
    panel.background = element_rect(fill="transparent"),
    strip.background = element_rect(fill="transparent"),
    plot.background = element_rect(fill="transparent", color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(fill="transparent"),
    legend.box.background = element_rect(fill="transparent"),
    legend.position = "bottom"
  )

theme_set(th)

heatmap <- function(...) {
  stats::heatmap(..., col=hcl.colors(15, "Zissou"))
}

copula_parameters <- function(x) {
  p2P(sim@dependence@fit[[1]]@parameters)
}