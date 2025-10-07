#' Factor Regressions with Newey-West Standard Errors
#'
#' Runs CAPM and Fama-French 4-factor regressions with Newey-West standard errors
#' to account for overlapping windows. Replicates performance attribution analysis
#' from Garcia-Feijóo et al. (2015).
#'
#' @details
#' Models estimated:
#' \itemize{
#'   \item CAPM: R_p - R_f = alpha + beta * (R_m - R_f) + e
#'   \item 4-factor: R_p - R_f = alpha + b_MKT*MKT + b_SMB*SMB + b_HML*HML + b_MOM*MOM + e
#'   \item Uses Newey-West HAC standard errors for overlapping windows
#'   \item Estimates alphas and factor loadings for each portfolio/strategy
#' }
#'
#' @param portfolio_returns Data.frame with portfolio returns
#' @param factor_returns Data.frame with Fama-French factors
#' @param output_path Character. Path for output regression results
#' @param lag_order Integer. Lag order for Newey-West (default 12)
#'
#' @return Data.frame with regression results
#'
#' @examples
#' \dontrun{
#' reg_results <- run_factor_regressions(
#'   portfolio_returns = portfolios,
#'   factor_returns = ff_factors,
#'   output_path = "output/tables/factor_regressions.csv"
#' )
#' }
#'
#' @export
run_factor_regressions <- function(portfolio_returns,
                                    factor_returns,
                                    output_path = "output/tables/factor_regressions.csv",
                                    lag_order = 12) {
  
  library(dplyr)
  library(sandwich)
  library(lmtest)
  library(readr)
  
  message("Merging portfolio and factor returns...")
  # TODO: Merge data
  # merged <- portfolio_returns %>%
  #   left_join(factor_returns, by = "date")
  
  message("Running CAPM regressions...")
  # TODO: Estimate CAPM
  # capm_results <- run_capm_regressions(merged, lag_order)
  
  message("Running 4-factor regressions...")
  # TODO: Estimate 4-factor model
  # ff4_results <- run_ff4_regressions(merged, lag_order)
  
  message("Saving regression results...")
  # TODO: Save output
  # results <- bind_rows(capm_results, ff4_results)
  # write_csv(results, output_path)
  
  message("Factor regression analysis complete!")
  
  return(data.frame())
}

#' Run CAPM Regression
#'
#' Estimates CAPM with Newey-West standard errors
#'
#' @param data Data.frame with excess returns and market factor
#' @param lag Integer. Newey-West lag order
#'
#' @return List with regression results
#'
#' @export
run_capm_regression <- function(data, lag = 12) {
  
  # Estimate model
  model <- lm(excess_ret ~ mkt_rf, data = data)
  
  # Newey-West standard errors
  nw_vcov <- sandwich::NeweyWest(model, lag = lag)
  
  # Extract results
  coeftest_nw <- lmtest::coeftest(model, vcov = nw_vcov)
  
  return(list(
    model = model,
    coeftest = coeftest_nw,
    alpha = coef(model)[1],
    beta = coef(model)[2],
    alpha_tstat = coeftest_nw[1, 3],
    beta_tstat = coeftest_nw[2, 3]
  ))
}

#' Run Fama-French 4-Factor Regression
#'
#' Estimates 4-factor model (MKT, SMB, HML, MOM) with Newey-West SE
#'
#' @param data Data.frame with excess returns and factors
#' @param lag Integer. Newey-West lag order
#'
#' @return List with regression results
#'
#' @export
run_ff4_regression <- function(data, lag = 12) {
  
  # Estimate model
  model <- lm(excess_ret ~ mkt_rf + smb + hml + mom, data = data)
  
  # Newey-West standard errors
  nw_vcov <- sandwich::NeweyWest(model, lag = lag)
  
  # Extract results
  coeftest_nw <- lmtest::coeftest(model, vcov = nw_vcov)
  
  return(list(
    model = model,
    coeftest = coeftest_nw,
    alpha = coef(model)[1],
    alpha_tstat = coeftest_nw[1, 3],
    factor_loadings = coef(model)[-1],
    factor_tstats = coeftest_nw[-1, 3]
  ))
}

#' Compute Excess Returns for Regression
#'
#' Calculates excess returns over risk-free rate
#'
#' @param returns Numeric vector of portfolio returns
#' @param rf Numeric vector of risk-free rates
#'
#' @return Numeric vector of excess returns
#'
#' @export
compute_excess_ret <- function(returns, rf) {
  returns - rf
}

#' Extract Newey-West Results
#'
#' Extracts coefficient estimates and t-stats with Newey-West SE
#'
#' @param model lm object
#' @param lag Integer. Newey-West lag order
#'
#' @return Data.frame with coefficients and t-statistics
#'
#' @export
extract_nw_results <- function(model, lag = 12) {
  nw_vcov <- sandwich::NeweyWest(model, lag = lag)
  coeftest_nw <- lmtest::coeftest(model, vcov = nw_vcov)
  
  data.frame(
    term = rownames(coeftest_nw),
    estimate = coeftest_nw[, 1],
    std_error = coeftest_nw[, 2],
    t_statistic = coeftest_nw[, 3],
    p_value = coeftest_nw[, 4]
  )
}

# Main execution
if (!interactive()) {
  # TODO: Load portfolio returns and factor data
  # portfolios <- read_csv("data/processed/portfolio_returns.csv")
  # factors <- read_csv("data/raw/ff_factors.csv")
  # run_factor_regressions(portfolios, factors)
}
