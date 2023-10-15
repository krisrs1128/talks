library(tidyverse)
library(rgl)

N <- 10
sigma <- 1
X <- matrix(rnorm(N * 2), N, 2)
beta <- c(1, 3)
y <- X %*% beta + rnorm(N, 0, sigma)

data <- data.frame(X = X, y = y)
n_grid <- 25
grid <- expand.grid(
  seq(0, 2, length.out = n_grid),
  seq(2, 4, length.out = n_grid)
)

errors <- list()
for (i in seq_len(nrow(grid))) {
  y_hat <- X %*% t(grid[i, ])
  errors[[i]] <- data.frame(
    beta_1 = grid[i, 1],
    beta_2 = grid[i, 2],
    RSS = sum((y - y_hat) ^ 2)
  )
}

errors <- bind_rows(errors)
fit <- lm(y ~ X.1 + X.2, data = data)
beta_hat <- coef(fit)

ggplot(errors, aes(beta_1, beta_2)) +
  geom_tile(aes(fill = RSS, col = RSS)) +
  stat_contour(aes(z = RSS), col = "black", bins = 10) +
  geom_point(data = data.frame(beta_1 = beta[1], beta_2 = beta[2]), size = 5, col = "red") +
  geom_point(data = data.frame(beta_1 = beta_hat[2], beta_2 = beta_hat[3]), size = 5, col = "purple") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_distiller(direction = 1) +
  scale_color_distiller(direction = 1) +
  coord_fixed()

plot3d(data)
planes3d(beta[1], beta[2], -1, col = "red", alpha = 0.3)
planes3d(beta_hat[2], beta_hat[3], -1, col = "purple", alpha = 0.3)


