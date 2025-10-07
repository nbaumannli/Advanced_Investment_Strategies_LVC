# Test beta estimation functions

test_that("beta estimation requires minimum observations", {
  # Test data with insufficient observations
  test_data <- data.frame(
    excess_ret = c(0.01, 0.02),
    mkt_excess_ret = c(0.015, 0.025)
  )
  
  source("../../R/03_beta_estimation.R")
  beta <- estimate_single_beta(test_data, min_obs = 24)
  
  # Should return NA with insufficient data
  expect_true(is.na(beta))
})

test_that("beta estimation works with sufficient data", {
  # Create test data with known beta
  set.seed(123)
  n <- 60
  mkt_ret <- rnorm(n, 0.01, 0.05)
  stock_ret <- 0.005 + 1.2 * mkt_ret + rnorm(n, 0, 0.02)
  
  test_data <- data.frame(
    excess_ret = stock_ret,
    mkt_excess_ret = mkt_ret
  )
  
  source("../../R/03_beta_estimation.R")
  beta <- estimate_single_beta(test_data, min_obs = 24)
  
  # Beta should be close to 1.2
  expect_true(!is.na(beta))
  expect_true(beta > 0.8 & beta < 1.6)  # Reasonable range given noise
})

test_that("excess returns are computed correctly", {
  returns <- c(0.05, 0.03, 0.07)
  rf <- c(0.02, 0.02, 0.02)
  
  source("../../R/03_beta_estimation.R")
  excess <- compute_excess_returns(returns, rf)
  
  expect_equal(excess, c(0.03, 0.01, 0.05))
})
