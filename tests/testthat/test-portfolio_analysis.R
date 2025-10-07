# Test for portfolio analysis functions
library(testthat)

test_that("calculate_bp_spreads handles empty input", {
  result <- calculate_bp_spreads(data.frame())
  expect_equal(nrow(result), 0)
})

test_that("calculate_portfolio_returns handles empty input", {
  result <- calculate_portfolio_returns(data.frame())
  expect_equal(nrow(result), 0)
})

test_that("calculate_bp_spreads computes correctly", {
  # Create sample portfolio data
  sample_data <- data.frame(
    date = rep(as.Date("2020-01-01"), 20),
    portfolio = rep(1:10, each = 2),
    bp = runif(20, 0.5, 2),
    mktcap = runif(20, 100, 1000)
  )
  
  result <- calculate_bp_spreads(sample_data)
  
  expect_true(all(c("bp_mean", "bp_median", "bp_vw") %in% names(result)))
  expect_equal(nrow(result), 10)  # One row per portfolio
})
