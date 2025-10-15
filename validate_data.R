#' Validate Data Files
#' 
#' This script checks if your data files are properly formatted and ready for analysis.

library(tidyverse)

cat("=== Data Validation Tool ===\n\n")

# Function to check if file exists and has required columns
validate_file <- function(file_path, required_cols, file_description) {
  cat(sprintf("Checking %s...\n", file_description))
  
  if (!file.exists(file_path)) {
    cat(sprintf("  ❌ File not found: %s\n", file_path))
    return(FALSE)
  }
  
  tryCatch({
    data <- read.csv(file_path, nrows = 5)
    
    missing_cols <- setdiff(required_cols, names(data))
    if (length(missing_cols) > 0) {
      cat(sprintf("  ❌ Missing columns: %s\n", paste(missing_cols, collapse = ", ")))
      return(FALSE)
    }
    
    cat(sprintf("  ✓ File exists with %d rows\n", nrow(data)))
    cat(sprintf("  ✓ All required columns present\n"))
    cat(sprintf("  ✓ Preview:\n"))
    print(head(data, 3))
    cat("\n")
    return(TRUE)
    
  }, error = function(e) {
    cat(sprintf("  ❌ Error reading file: %s\n", e$message))
    return(FALSE)
  })
}

# Define required columns for each file
validations <- list(
  list(
    path = "data/crsp_monthly.csv",
    description = "CRSP Monthly Data",
    columns = c("permno", "date", "ret", "prc", "shrout", "shrcd", "exchcd")
  ),
  list(
    path = "data/compustat_annual.csv",
    description = "Compustat Annual Data",
    columns = c("permno", "datadate", "at", "ceq")
  ),
  list(
    path = "data/market_returns.csv",
    description = "Market Returns",
    columns = c("date", "ret", "rf")
  ),
  list(
    path = "data/ff_factors.csv",
    description = "Fama-French Factors",
    columns = c("date", "mkt_rf", "smb", "hml", "umd", "rf")
  )
)

# Run validations
results <- map_lgl(validations, function(v) {
  validate_file(v$path, v$columns, v$description)
})

# Summary
cat("\n=== Validation Summary ===\n")
if (all(results)) {
  cat("✓ All data files are valid and ready for analysis!\n")
  cat("\nYou can now run:\n")
  cat("  source('run_analysis.R')\n")
  cat("  # or\n")
  cat("  library(targets)\n")
  cat("  tar_make()\n")
} else {
  cat("❌ Some data files have issues. Please fix them before running the analysis.\n")
  cat("\nSee data/README.md for detailed data format requirements.\n")
  cat("\nOr generate test data with:\n")
  cat("  source('generate_test_data.R')\n")
}

# Additional checks
cat("\n=== Additional Checks ===\n")

# Check date formats
if (results[1]) {
  crsp <- read.csv("data/crsp_monthly.csv", nrows = 10)
  tryCatch({
    dates <- as.Date(crsp$date)
    if (any(is.na(dates))) {
      cat("⚠️  Some dates in CRSP data cannot be parsed\n")
      cat("   Expected format: YYYY-MM-DD\n")
    } else {
      cat("✓ CRSP dates are properly formatted\n")
    }
  }, error = function(e) {
    cat("⚠️  Error parsing CRSP dates:", e$message, "\n")
  })
}

# Check for negative returns indicating missing values
if (results[1]) {
  crsp <- read.csv("data/crsp_monthly.csv", nrows = 1000)
  missing_rets <- sum(is.na(crsp$ret))
  if (missing_rets > 0) {
    cat(sprintf("⚠️  Found %d missing returns in CRSP data (first 1000 rows)\n", missing_rets))
  } else {
    cat("✓ No obvious missing returns in CRSP data sample\n")
  }
}

cat("\n=== Validation Complete ===\n")
