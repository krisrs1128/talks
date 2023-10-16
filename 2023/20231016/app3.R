library(ggplot2)
library(rgl)
library(shiny)
theme_set(theme_classic())

ui <- fluidPage(
  sliderInput("N", "Sample Size", 5, 500, 150),
  sliderInput("beta_1", "beta_1", -2, 2, 1, step = 0.1),
  sliderInput("beta_2", "beta_2", -2, 2, 1, step = 0.1),
  sliderInput("n_irrelevant", "irrelevant_features", 0, 100, 15),
  sliderInput("sigma", "sigma", 0.001, 10, 1),
  fluidRow(
    column(plotOutput("beta_hats"), width = 4),
    column(plotOutput("surface"), width = 4)
  )
)

server <- function(input, output) {
  generate_data <- reactive({
    X <- matrix(rnorm(input$N * 2), input$N, 2)
    X <- cbind(X, matrix(rnorm(input$N * input$n_irrelevant), nrow = input$N, ncol = input$n_irrelevant))
    
    beta <- c(input$beta_1, input$beta_2, rep(0, input$n_irrelevant))
    mu <- X %*% beta
    y <- mu + rnorm(input$N, 0, input$sigma)
    data.frame(X = X, y = y, y_mean = mu)
  })
  
  beta_hat <- reactive({
    X <- generate_data() |>
      select(y, starts_with("X"))
    coef(lm(y ~ ., data = X))
  })
  
  output$beta_hats <- renderPlot({
    beta_hats <- list()
    for (i in seq_len(200)) {
      X <- generate_data()
      X$y <- X$y_mean + rnorm(input$N, 0, input$sigma)
      beta_hats[[i]] <- X |>
        select(y, starts_with("X")) |>
        lm(y ~ ., data = _) |>
        coef()
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
  
  output$surface <- renderPlot({
    generate_data() |>
      select(starts_with("X"), y, y_mean) |>
      pivot_longer(starts_with("X"), names_to = "dimension") |>
      separate("dimension", c("X", "dimension"), convert = TRUE) |>
      filter(dimension < 16) |>
      ggplot(aes(value, y)) +
      geom_point() +
      facet_wrap(~ dimension)
  })
}

shinyApp(ui, server)