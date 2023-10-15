library(tidyverse)
library(rgl)
library(shiny)
ui <- fluidPage(
  sliderInput("N", "Sample Size", 5, 500, 10),
  sliderInput("beta_1", "beta_1", -2, 2, 1, step = 0.1),
  sliderInput("beta_2", "beta_2", -2, 2, -1, step = 0.1),
  sliderInput("sigma", "sigma", 0.001, 10, 1),
  fluidRow(
    column(plotOutput("rss"), width = 4),
    column(rglwidgetOutput("surface"), width = 4)
  )
)

server <- function(input, output) {
  generate_data <- reactive({
    X <- matrix(rnorm(input$N * 2), input$N, 2)
    beta <- c(input$beta_1, input$beta_2)
    y <- X %*% beta + rnorm(input$N, 0, input$sigma)
    data.frame(X = X, y = y)
  })
  
  beta_hat <- reactive({
    X <- generate_data()
    coef(lm(y ~ ., data = X))
  })

  output$rss <- renderPlot({
    grid <- expand.grid(
      seq(input$beta_1 - 1, input$beta_1 + 2, length.out = n_grid),
      seq(input$beta_2 - 2, input$beta_2 + 2, length.out = n_grid)
    )

    data <- generate_data()
    X <- as.matrix(data[, 1:2])
    y <- data$y
    
    errors <- list()
    for (i in seq_len(nrow(grid))) {
      y_hat <- X %*% t(grid[i, ])
      errors[[i]] <- data.frame(
        beta_1 = grid[i, 1],
        beta_2 = grid[i, 2],
        RSS = sum((y - y_hat) ^ 2)
      )
    }

    beta_ <- beta_hat()
    errors <- bind_rows(errors)
    ggplot(errors, aes(beta_1, beta_2)) +
      geom_tile(aes(fill = RSS, col = RSS)) +
      stat_contour(aes(z = RSS), col = "black", bins = 10) +
      geom_point(data = data.frame(beta_1 = input$beta_1, beta_2 = input$beta_2), size = 5, col = "red") +
      geom_point(data = data.frame(beta_1 = beta_[2], beta_2 = beta_[3]), size = 5, col = "purple") +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      scale_fill_distiller(direction = 1) +
      scale_color_distiller(direction = 1) +
      coord_fixed()
  })

  output$surface <- renderRglwidget({
    beta_ <- beta_hat()
    
    open3d(useNULL=T)
    plot3d(generate_data())
    planes3d(input$beta_1, input$beta_2, -1, col = "red", alpha = 0.3)
    planes3d(beta_[2], beta_[3], -1, col = "purple", alpha = 0.3)
    rglwidget()
  })
}

shinyApp(ui, server)
