# _targets.R file
# Targets pipeline for Low-Volatility Cycles replication

library(targets)
library(tarchetypes)

# Set target-specific options such as packages.
tar_option_set(
  packages = c(
    "dplyr",
    "tidyr",
    "readr",
    "ggplot2",
    "slider",
    "sandwich",
    "lmtest",
    "kableExtra"
  )
)

# Source all R scripts
source("R/01_data_ingest_crsp_compustat.R")
source("R/02_largecap_breakpoints.R")
source("R/03_beta_estimation.R")
source("R/04_portfolios.R")
source("R/05_bp_spread.R")
source("R/06_factor_regs.R")
source("R/07_figures_tables.R")

# Define the pipeline
list(
  # Step 1: Data ingestion and merging
  tar_target(
    name = crsp_compustat_merged,
    command = ingest_crsp_compustat(
      crsp_path = "data/raw/crsp_monthly.csv",
      compustat_path = "data/raw/compustat.csv",
      output_path = "data/processed/crsp_compustat_merged.csv"
    )
  ),
  
  # Step 2: Compute large-cap breakpoints
  tar_target(
    name = largecap_universe,
    command = compute_largecap_breakpoints(
      data = crsp_compustat_merged,
      output_path = "data/processed/largecap_universe.csv"
    )
  ),
  
  # Step 3: Estimate betas
  tar_target(
    name = beta_estimates,
    command = estimate_betas(
      data = largecap_universe,
      output_path = "data/processed/beta_estimates.csv",
      window_months = 60,
      min_months = 24
    )
  ),
  
  # Step 4: Construct portfolios
  tar_target(
    name = portfolio_returns,
    command = construct_portfolios(
      data = beta_estimates,
      output_path = "data/processed/portfolio_returns.csv"
    )
  ),
  
  # Step 5: Compute B/P spread
  tar_target(
    name = bp_spread,
    command = compute_bp_spread(
      data = beta_estimates,
      output_path = "data/processed/bp_spread.csv"
    )
  ),
  
  # Step 6: Load Fama-French factors
  tar_target(
    name = ff_factors,
    command = readr::read_csv("data/raw/ff_factors.csv")
  ),
  
  # Step 7: Run factor regressions
  tar_target(
    name = factor_regressions,
    command = run_factor_regressions(
      portfolio_returns = portfolio_returns,
      factor_returns = ff_factors,
      output_path = "output/tables/factor_regressions.csv",
      lag_order = 12
    )
  ),
  
  # Step 8: Generate figures and tables
  tar_target(
    name = output_figures_tables,
    command = generate_figures_tables(
      portfolio_data = beta_estimates,
      returns_data = portfolio_returns,
      regression_data = factor_regressions,
      spread_data = bp_spread
    )
  )
)
