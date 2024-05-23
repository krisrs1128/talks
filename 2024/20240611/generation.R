library(SummarizedExperiment)
library(tidyverse)

N <- 500
x <- matrix(rnorm(6 * N), 6, N)
x[1:3, 1:(N / 2)] <- x[1:3, 1:(N / 2)] + 2

exper_group <- SummarizedExperiment(
  SimpleList(counts = x),
  colData = data.frame(group = rep(c("A", "B"), each = N / 2))
)
rownames(exper_group) <- 1:6

u <- runif(N / 2)
x <- matrix(nrow = 6, ncol = N)

for (j in 1:6) {
  f <- multimedia:::spline_fun(knots = seq(0.1, 0.9, 0.2), sd = 0, D = 1)
  if (j > 3) {
    x[j, ] <- c(f(u), f(u)) + rnorm(N, sd = 0.2)
  } else {
    f2 <- multimedia:::spline_fun(knots = seq(0.1, 0.9, 0.2), sd = 0, D = 1)
    x[j, ] <- c(f(u), exp(-1) * f(u)) + rnorm(N, sd = 0.2)
  }
}

exper_ts <- SummarizedExperiment(
  SimpleList(counts = x),
  colData = data.frame(group = rep(c("A", "B"), each = N / 2), time = c(u, u))
)
rownames(exper_ts) <- 1:6
#saveRDS(exper_ts, "exper_ts.rds")

###############################################################################
# Code for generating some figures on some of the slides
###############################################################################

u <- seq(-4, 4, length.out = 300)
tibble(
  u = u,
  density = dnorm(u)
) |>
  ggplot() +
    geom_area(aes(u, density)) +
    theme_void()
#ggsave("figure/gaussian.svg", width=8, height = 3)

tibble(
  u = seq(0, 15),
  density = dpois(u, 4)
) |>
  ggplot() +
    geom_col(aes(u, density)) +
    theme_void()
#ggsave("figure/poisson.svg", width=8, height = 3)

tibble(
  u = seq(0, 40),
  density = dnbinom(u, 1, 0.1)
) |>
  ggplot() +
    geom_col(aes(u, density)) +
    theme_void()
#ggsave("figure/nbinom.svg", width=8, height = 3)