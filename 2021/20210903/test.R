
broken <- function() {
  x <- 1
  y <- "test"
  x + y
}

better_name <- function(x) {
  if (x==1) {
    print("x is one")
  }
  x
}

x <- 10
u <- 5