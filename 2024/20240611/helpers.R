
# Plot histogram for toy data
exper_histogram <- function(exper) {
  pivot_experiment(exper) |>
    ggplot() +
      geom_histogram(
        aes(value, fill = group), 
        position = "identity", alpha = 0.8
      ) +
      facet_wrap(~ feature)
}

# Plot time series for toy data
exper_lineplot <- function(exper) {
  pivot_experiment(exper) |>
    ggplot() +
      geom_point(aes(time, value, color = group)) +
      facet_wrap(~ feature) +
      ylim(-2, 3)
}