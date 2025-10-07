library(testthat)

# Source all functions
source("R/load_data.R")
source("R/clean_data.R")
source("R/calculate_betas.R")
source("R/portfolio_analysis.R")
source("R/regressions.R")
source("R/create_tables.R")
source("R/create_figures.R")

# Run all tests
test_dir("tests/testthat")
