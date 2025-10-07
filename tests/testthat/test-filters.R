# Test data filter functions

test_that("share code filter works correctly", {
  # Create test data
  test_data <- data.frame(
    PERMNO = 1:5,
    SHRCD = c(10, 11, 12, 10, 11),
    RET = c(0.01, 0.02, 0.03, 0.04, 0.05)
  )
  
  # Apply filter
  source("../../R/01_data_ingest_crsp_compustat.R")
  filtered <- apply_share_code_filter(test_data)
  
  # Check results
  expect_equal(nrow(filtered), 3)
  expect_true(all(filtered$SHRCD %in% c(10, 11)))
  expect_equal(filtered$PERMNO, c(1, 2, 4, 5))
})

test_that("delisting returns are applied correctly", {
  # Create test data
  test_data <- data.frame(
    PERMNO = 1:4,
    EXCHCD = c(1, 2, 3, 1),  # NYSE, AMEX, NASDAQ, NYSE
    DLRET = c(NA, NA, NA, -0.10)
  )
  
  source("../../R/01_data_ingest_crsp_compustat.R")
  adjusted <- apply_delisting_returns(test_data)
  
  # Check delisting return adjustments
  expect_equal(adjusted$DLRET[1], -0.30)  # NYSE default
  expect_equal(adjusted$DLRET[2], -0.30)  # AMEX default
  expect_equal(adjusted$DLRET[3], -0.55)  # NASDAQ default
  expect_equal(adjusted$DLRET[4], -0.10)  # Already specified
})

test_that("price filter works correctly", {
  # Create test data
  test_data <- data.frame(
    PERMNO = 1:5,
    PRC = c(1.5, 5, 100, 1500, 50)
  )
  
  source("../../R/01_data_ingest_crsp_compustat.R")
  filtered <- apply_price_filter(test_data, min_price = 2, max_price = 1000)
  
  # Check results
  expect_equal(nrow(filtered), 3)
  expect_true(all(filtered$PRC >= 2))
  expect_true(all(filtered$PRC <= 1000))
  expect_equal(filtered$PERMNO, c(2, 3, 5))
})
