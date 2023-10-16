library(ggplot2)
library(dplyr)
library(rgl)
library(shiny)
theme_set(theme_classic())

ui <- fluidPage(
  sliderInput("N", "Sample Size", 5, 500, 10),
  sliderInput("beta_1", "beta_1", -2, 2, 1, step = 0.1),
  sliderInput("beta_2", "beta_2", -2, 2, 1, step = 0.1),
  sliderInput("rho", "rho", 0, 1, 0),
  sliderInput("sigma", "sigma", 0.001, 10, 1),
  fluidRow(
    column(plotOutput("beta_hats"), width = 4),
    column(rglwidgetOutput("surface"), width = 4)
  )
)

server <- function(input, output) {
  generate_data <- reactive({
    X <- matrix(rnorm(input$N * 2), input$N, 2)
    X <- X %*% matrix(c(1, sqrt(input$rho), sqrt(input$rho), 1), nrow = 2)
    
    beta <- c(input$beta_1, input$beta_2)
    mu <- X %*% beta
    y <- mu + rnorm(input$N, 0, input$sigma)
    data.frame(X = X, y = y, y_mean = mu)
  })
  
  beta_hat <- reactive({
    X <- generate_data()
    coef(lm(y ~ X.1 + X.2, data = X))
  })
  
  output$beta_hats <- renderPlot({
    beta_hats <- list()
    for (i in seq_len(200)) {
      X <- generate_data()
      X$y <- X$y_mean + rnorm(input$N, 0, input$sigma)
      beta_hats[[i]] <- coef(lm(y ~ X.1 + X.2, data = X))
    }
    
    bind_rows(beta_hats) |>
      ggplot(aes(X.1, X.2)) +
      geom_point() +
      geom_point(data = data.frame(X.1 = input$beta_1, X.2 = input$beta_2), size = 5, col = "red") +
      coord_fixed() +
      scale_x_continuous(limits = c(input$beta_1 - 1.5 * input$sigma, input$beta_1 + 1.5 * input$sigma)) +
      scale_y_continuous(limits = c(input$beta_2 - 1.5 * input$sigma, input$beta_2 + 1.5 * input$sigma)) +
      labs(
        title = "Simulated Estimates",
        x = expression(hat(beta)[1]),
        y = expression(hat(beta)[2])
      ) +
      theme(
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14)
      )
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