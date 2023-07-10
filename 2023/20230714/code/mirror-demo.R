
nb_matrix <- function(mu, N = 100, size = 1) {
  x <- matrix(0, N, length(mu))
  for (j in seq_along(mu)) {
    x[, j] <- rnbinom(N, size, mu = mu[j])
  }

  x
}

matnorm <- function(mu) {
  N <- nrow(mu)
  M <- ncol(mu)

  x <- matrix(nrow = N, ncol = M)
  for (i in seq_len(N)) {
    x[i, ] <- rnorm(M, mu[i, ])
  }
  
  x
}

simulate_pvalues <- function(N, M, signal = 0.25, nonnull_frac = 0.2) {
  mu <- matrix(0, N, M)
  disease_ix <- seq_len(N / 2)
  nonnull_ix <- seq_len(nonnull_frac * M)
  mu[disease_ix, nonnull_ix] <- signal
  x <- matnorm(mu)
  
  p_values <- list()
  for (j in seq_len(M)) {
    p_values[[j]] <- tibble(
      hypothesis = j,
      p_value = t.test(x[disease_ix, j], x[-disease_ix, j])$p.value
    )
  }
  
  p_values |>
    bind_rows() |>
    mutate(
      nonnull = ifelse(hypothesis %in% nonnull_ix, "nonnull", "null"),
      nonnull = factor(nonnull, levels = c("nonnull", "null"))
    )
}


plot_pval <- function(p_values, facet = FALSE) {
  p <- list()

  p[[1]] <- ggplot(p_values) +
    geom_histogram(aes(p_value), binwidth = 0.03) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0, 0.1, 0)) +
    labs(x = "p-value") +
    theme(
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      panel.border = element_blank()
    )
  
  p[[2]] <- ggplot(p_values) +
    geom_histogram(
      aes(p_value, fill = nonnull), 
      position = "identity",
      alpha = 0.7,
      binwidth = 0.03
    ) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0, 0.1, 0)) +
    labs(x = "p-value") +
    scale_fill_manual(values = cols, guide = "none") +
    theme(
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      panel.border = element_blank()
    )
  
  if (facet) {
    p[[2]] <- p[[2]] + 
      facet_grid(nonnull ~ ., scales = "free_y")
  }

  p
}

metrics <- function(selection_ix, nonnull) {
  power <- length(intersect(selection_ix, seq_len(nonnull))) / nonnull
  fdr <- length(setdiff(selection_ix, seq_len(nonnull))) / length(selection_ix)
  list(fdr = fdr, power = power)
}