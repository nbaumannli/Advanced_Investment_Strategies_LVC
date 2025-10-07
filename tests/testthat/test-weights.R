# Test portfolio construction functions

test_that("beta quintiles are assigned correctly", {
  # Create test data
  test_data <- data.frame(
    date = rep("2020-01", 100),
    PERMNO = 1:100,
    beta = seq(0.5, 1.5, length.out = 100)
  )
  
  source("../../R/04_portfolios.R")
  with_quintiles <- assign_beta_quintiles(test_data)
  
  # Check quintile assignment
  expect_true("beta_quintile" %in% names(with_quintiles))
  expect_equal(length(unique(with_quintiles$beta_quintile)), 5)
  
  # Check that lower betas get lower quintiles
  q1_betas <- with_quintiles$beta[with_quintiles$beta_quintile == 1]
  q5_betas <- with_quintiles$beta[with_quintiles$beta_quintile == 5]
  expect_true(mean(q1_betas) < mean(q5_betas))
})

test_that("value-weighted returns are computed correctly", {
  # Create test data
  test_data <- data.frame(
    date = rep("2020-01", 3),
    beta_quintile = c(1, 1, 1),
    ret = c(0.10, 0.05, 0.15),
    mktcap = c(100, 200, 100)
  )
  
  source("../../R/04_portfolios.R")
  vw_returns <- calculate_vw_returns(test_data)
  
  # Expected VW return: (100*0.10 + 200*0.05 + 100*0.15) / 400 = 35/400 = 0.0875
  expect_equal(nrow(vw_returns), 1)
  expect_equal(vw_returns$vw_ret[1], 0.0875)
})

test_that("zero-cost portfolio is constructed correctly", {
  # Create test data
  portfolio_returns <- data.frame(
    date = rep("2020-01", 5),
    beta_quintile = 1:5,
    vw_ret = c(0.08, 0.06, 0.05, 0.04, 0.03)
  )
  
  source("../../R/04_portfolios.R")
  zero_cost <- construct_zero_cost(portfolio_returns)
  
  # Zero-cost should be Q1 - Q5
  expect_equal(zero_cost$zero_cost[1], 0.08 - 0.03)
})

test_that("beta-neutral portfolio is constructed correctly", {
  # Create test data
  portfolio_returns <- data.frame(
    date = rep("2020-01", 5),
    beta_quintile = 1:5,
    vw_ret = c(0.08, 0.06, 0.05, 0.04, 0.04)
  )
  
  source("../../R/04_portfolios.R")
  beta_neutral <- construct_beta_neutral(portfolio_returns)
  
  # Beta-neutral should be Q1 - 0.25*Q5
  expect_equal(beta_neutral$beta_neutral[1], 0.08 - 0.25 * 0.04)
})
