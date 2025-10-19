#' Generate Simulated Data for Testing
#'
#' This script creates simulated CRSP, Compustat, market returns, and FF factor data
#' for testing the analysis pipeline without requiring actual data access.

library(tidyverse)
library(lubridate)

set.seed(12345)

# Parameters
n_stocks <- 500
start_date <- as.Date("2000-01-31")
end_date <- as.Date("2020-12-31")
dates <- seq(start_date, end_date, by = "month")
n_months <- length(dates)

cat("Generating simulated data...\n")

# 1. Generate CRSP Monthly Data
cat("Generating CRSP data...\n")

permnos <- 10000 + 1:n_stocks

crsp_data <- expand_grid(
  permno = permnos,
  date = dates
) %>%
  mutate(
    # Simulate returns with some persistence
    ret = rnorm(n(), mean = 0.01, sd = 0.08),
    # Simulate prices with drift
    prc = 50 * exp(cumsum(rnorm(n(), 0.0005, 0.02))),
    # Shares outstanding (in thousands)
    shrout = runif(n(), 5000, 50000),
    # Share code: mostly 10 and 11
    shrcd = sample(c(10, 11), n(), replace = TRUE, prob = c(0.7, 0.3)),
    # Exchange code: NYSE, AMEX, NASDAQ
    exchcd = sample(c(1, 2, 3), n(), replace = TRUE, prob = c(0.5, 0.2, 0.3))
  ) %>%
  arrange(permno, date)

# Save CRSP data
dir.create("data", showWarnings = FALSE)
write.csv(crsp_data, "data/crsp_monthly.csv", row.names = FALSE)
cat("  Saved: data/crsp_monthly.csv\n")

# 2. Generate Compustat Annual Data
cat("Generating Compustat data...\n")

years <- year(start_date):year(end_date)

compustat_data <- expand_grid(
  permno = permnos,
  year = years
) %>%
  mutate(
    # Fiscal year end date (June 30)
    datadate = as.Date(paste0(year, "-06-30")),
    # Total assets
    at = runif(n(), 100, 10000),
    # Common equity (60-80% of assets)
    ceq = at * runif(n(), 0.6, 0.8),
    # Preferred stock components (mostly NA or small)
    pstkrv = if_else(runif(n()) < 0.2, runif(n(), 0, 50), NA_real_),
    pstkl = if_else(is.na(pstkrv) & runif(n()) < 0.1, runif(n(), 0, 50), NA_real_),
    pstk = if_else(is.na(pstkrv) & is.na(pstkl) & runif(n()) < 0.3,
                   runif(n(), 0, 50), NA_real_),
    # Deferred taxes (10-20% of equity)
    txditc = ceq * runif(n(), 0.1, 0.2)
  ) %>%
  arrange(permno, datadate)

write.csv(compustat_data, "data/compustat_annual.csv", row.names = FALSE)
cat("  Saved: data/compustat_annual.csv\n")

# 3. Generate Market Returns
cat("Generating market returns...\n")

market_returns <- tibble(
  date = dates,
  ret = rnorm(n_months, mean = 0.008, sd = 0.045),
  rf = runif(n_months, 0.0015, 0.004)
)

write.csv(market_returns, "data/market_returns.csv", row.names = FALSE)
cat("  Saved: data/market_returns.csv\n")

# 4. Generate Fama-French Factors
cat("Generating Fama-French factors...\n")

ff_factors <- tibble(
  date = dates,
  mkt_rf = rnorm(n_months, mean = 0.007, sd = 0.045),
  smb = rnorm(n_months, mean = 0.002, sd = 0.025),
  hml = rnorm(n_months, mean = 0.003, sd = 0.028),
  umd = rnorm(n_months, mean = 0.006, sd = 0.035),
  rf = runif(n_months, 0.0015, 0.004)
)

write.csv(ff_factors, "data/ff_factors.csv", row.names = FALSE)
cat("  Saved: data/ff_factors.csv\n")

# Summary
cat("\n=== Data Generation Complete ===\n")
cat(sprintf("Number of stocks: %d\n", n_stocks))
cat(sprintf("Date range: %s to %s\n", start_date, end_date))
cat(sprintf("Number of months: %d\n", n_months))
cat(sprintf("CRSP observations: %d\n", nrow(crsp_data)))
cat(sprintf("Compustat observations: %d\n", nrow(compustat_data)))
cat("\nFiles created in data/ directory:\n")
cat("  - crsp_monthly.csv\n")
cat("  - compustat_annual.csv\n")
cat("  - market_returns.csv\n")
cat("  - ff_factors.csv\n")
cat("\nYou can now run the analysis with:\n")
cat("  source('run_analysis.R')\n")
cat("  # or\n")
cat("  library(targets)\n")
cat("  tar_make()\n")

