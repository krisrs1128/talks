
matnorm <- function(N, D, mu = 0, sigma = 1) {
  rnorm(N * D, mu, sigma) |>
    matrix(N, D)
}

matbern <- function(J, prob) {
  rbinom(prod(J), 1, prob) |>
    matrix(J[1], J[2])
}

reshape_mat <- function(mat, thresholds) {
  as_tibble(mat) |>
    mutate(ix1 = row_number()) |>
    pivot_longer(-ix1, names_to = "ix2") |>
    mutate(
      ix2 = as.integer(str_extract(ix2, "[0-9]+")),
      t1 = thresholds[ix1],
      t2 = thresholds[ix2],
    )
}

estimate_fdr <- function(p_values, thresholds) {
  m <- map_dbl(p_values, length)
  R_sum <- count_rejections(p_values, thresholds)
  sum(m * thresholds) / R_sum
}

count_rejections <- function(p_values, thresholds) {
  sum(map2_dbl(p_values, thresholds, ~ sum(.x < .y)))
}

estimate_fdr_vec <- function(p_values, thresholds) {
  fdp_hat <- matrix(0, length(thresholds), length(thresholds))
  rejections <- matrix(0, length(thresholds), length(thresholds))
  
  for (t1 in seq_along(thresholds)) {
    for (t2 in seq_along(thresholds)) {
      fdp_hat[t1, t2] <- estimate_fdr(p_values, c(thresholds[t1], thresholds[t2]))
      rejections[t1, t2] <- count_rejections(p_values, c(thresholds[t1], thresholds[t2]))
    }
  }
  
  list(
    fdr = reshape_mat(fdp_hat, thresholds) |> rename(fdr_hat = value), 
    rejections = reshape_mat(rejections, thresholds) |> rename(rejections = value)
  )
}
