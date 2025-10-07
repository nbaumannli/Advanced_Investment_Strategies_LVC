# Test for data cleaning functions
library(testthat)

test_that("clean_crsp_data handles empty input", {
  result <- clean_crsp_data(data.frame())
  expect_equal(nrow(result), 0)
})

test_that("clean_compustat_data handles empty input", {
  result <- clean_compustat_data(data.frame())
  expect_equal(nrow(result), 0)
})

test_that("merge_crsp_compustat handles empty inputs", {
  result <- merge_crsp_compustat(data.frame(), data.frame())
  expect_equal(nrow(result), 0)
})

test_that("clean_crsp_data filters correctly", {
  # Create sample data
  sample_data <- data.frame(
    permno = c(1, 2, 3),
    date = as.Date(c("2020-01-01", "2020-02-01", "2020-03-01")),
    ret = c(0.05, NA, 0.03),
    prc = c(100, -50, 80),
    shrout = c(1000, 2000, 3000),
    shrcd = c(10, 11, 12),
    exchcd = c(1, 2, 3)
  )
  
  result <- clean_crsp_data(sample_data)
  
  # Should filter out NA returns and invalid share codes
  expect_true(nrow(result) < nrow(sample_data))
})
