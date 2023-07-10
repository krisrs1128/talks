fdp_hat <- function(m) {
  m_sort <- sort(abs(m))
  fdp <- tibble(t = m_sort, fdp = 0)
  
  for (j in seq_along(m_sort)) {
    fdp$fdp[j] <- sum(m < -m_sort[j]) / max(1, sum(m > m_sort[j]))
  }
  
  fdp
}

#' @importFrom dplyr slice_min
#' @importFrom magrittr %>%
#' @export
tau_q <- function(fdp, q) {
  if (!any(na.omit(fdp$fdp) < q)) {
    return(NA)
  }
  
  fdp |>
    filter(fdp < q) |>
    slice_min(t) |>
    pull(t) %>%
    .[[1]]
}

inclusion <- function(s_hat) {
  s_hat <- 1.0 * s_hat
  colMeans(s_hat / rowSums(s_hat))
}

consolidate <- function(s_hat, q) {
  I_hat <- inclusion(s_hat)
  ix <- order(I_hat)
  I_sort <- cumsum(I_hat[ix])
  j_star <- max(which(I_sort <= q))
  I_hat > I_hat[ix[j_star]]
}

selections <- function(m, tau) {
  m > tau
}

#' @export
multiple_data_splitting <- function(ms, q = 0.1) {
  s_hat <- matrix(FALSE, length(ms), length(ms[[1]]))
  
  for (k in seq_along(ms)) {
    fdp <- fdp_hat(ms[[k]])
    tau <- tau_q(fdp, q)
    s_hat[k, ] <- selections(ms[[k]], tau)
  }
  
  consolidate(s_hat, q)
}

glmnet_mirror <- function(x, y) {
  ix <- sample(nrow(x), 0.5 * nrow(x))
  beta1 <- cv.glmnet(x[ix, ], y[ix], family = "binomial", alpha = 0, intercept = FALSE) |>
    coef() %>%
    .[-1]
  beta2 <- cv.glmnet(x[-ix, ], y[-ix], family = "binomial", alpha = 0, intercept = FALSE) |>
    coef() %>%
    .[-1]
  sign(beta1 * beta2) * (abs(beta1) + abs(beta2))
}