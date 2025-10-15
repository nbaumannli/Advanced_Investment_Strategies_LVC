library(targets)
library(tarchetypes)

# Source all functions from R/ directory
tar_source()

# Set target-specific options
tar_option_set(
  packages = c(
    "tidyverse",
    "lubridate", 
    "zoo",
    "data.table",
    "broom",
    "ggplot2",
    "xtable"
  )
)

# Define the pipeline
list(
  # Data loading and cleaning
  tar_target(
    crsp_raw,
    load_crsp_data("data/crsp_monthly.csv"),
    format = "rds"
  ),
  
  tar_target(
    compustat_raw,
    load_compustat_data("data/compustat_annual.csv"),
    format = "rds"
  ),
  
  tar_target(
    crsp_clean,
    clean_crsp_data(crsp_raw),
    format = "rds"
  ),
  
  tar_target(
    compustat_clean,
    clean_compustat_data(compustat_raw),
    format = "rds"
  ),
  
  tar_target(
    merged_data,
    merge_crsp_compustat(crsp_clean, compustat_clean),
    format = "rds"
  ),
  
  # Beta calculation
  tar_target(
    market_returns,
    load_market_returns("data/market_returns.csv"),
    format = "rds"
  ),
  
  tar_target(
    stock_betas,
    calculate_rolling_betas(merged_data, market_returns),
    format = "rds"
  ),
  
  # Portfolio formation
  tar_target(
    nyse_breakpoints,
    calculate_nyse_breakpoints(stock_betas),
    format = "rds"
  ),
  
  tar_target(
    beta_portfolios,
    form_beta_portfolios(stock_betas, nyse_breakpoints),
    format = "rds"
  ),
  
  # Book-to-Price spreads
  tar_target(
    bp_spreads,
    calculate_bp_spreads(beta_portfolios),
    format = "rds"
  ),
  
  # Portfolio returns
  tar_target(
    portfolio_returns,
    calculate_portfolio_returns(beta_portfolios),
    format = "rds"
  ),
  
  # Factor data
  tar_target(
    ff_factors,
    load_ff_factors("data/ff_factors.csv"),
    format = "rds"
  ),
  
  # CAPM regressions
  tar_target(
    capm_results,
    run_capm_regressions(portfolio_returns, market_returns),
    format = "rds"
  ),
  
  # Fama-French 4-factor regressions
  tar_target(
    ff4_results,
    run_ff4_regressions(portfolio_returns, ff_factors),
    format = "rds"
  ),
  
  # Tables
  tar_target(
    table1,
    create_table1_summary_stats(merged_data),
    format = "rds"
  ),
  
  tar_target(
    table2,
    create_table2_portfolio_characteristics(beta_portfolios, bp_spreads),
    format = "rds"
  ),
  
  tar_target(
    table3,
    create_table3_capm_results(capm_results),
    format = "rds"
  ),
  
  tar_target(
    table4,
    create_table4_ff4_results(ff4_results),
    format = "rds"
  ),
  
  # Figures
  tar_target(
    figure1,
    create_figure1_bp_spreads(bp_spreads),
    format = "file"
  ),
  
  tar_target(
    figure2,
    create_figure2_returns_over_time(portfolio_returns),
    format = "file"
  ),
  
  tar_target(
    figure3,
    create_figure3_alpha_comparison(capm_results, ff4_results),
    format = "file"
  ),
  
  # Save outputs
  tar_target(
    save_tables,
    save_all_tables(table1, table2, table3, table4),
    format = "file"
  )
)
