# Test for data loading functions
library(testthat)

test_that("load_crsp_data handles missing files gracefully", {
  result <- load_crsp_data("nonexistent_file.csv")
  expect_equal(nrow(result), 0)
  expect_s3_class(result, "data.frame")
})

test_that("load_compustat_data handles missing files gracefully", {
  result <- load_compustat_data("nonexistent_file.csv")
  expect_equal(nrow(result), 0)
  expect_s3_class(result, "data.frame")
})

test_that("load_market_returns handles missing files gracefully", {
  result <- load_market_returns("nonexistent_file.csv")
  expect_equal(nrow(result), 0)
  expect_s3_class(result, "data.frame")
})

test_that("load_ff_factors handles missing files gracefully", {
  result <- load_ff_factors("nonexistent_file.csv")
  expect_equal(nrow(result), 0)
  expect_s3_class(result, "data.frame")
})
