#' Estimate CAPM Betas
#'
#' Estimates CAPM betas using rolling 60-month windows with minimum 24 months
#' of data. Includes month t in the estimation window as per Garcia-Feijóo et al. (2015).
#'
#' @details
#' For each stock-month:
#' \itemize{
#'   \item Uses 60 months of data (including current month t)
#'   \item Requires minimum 24 valid observations
#'   \item Estimates beta via OLS regression: R_i - R_f = alpha + beta * (R_m - R_f)
#'   \item Handles missing data appropriately
#' }
#'
#' @param data Data.frame with stock returns and market returns
#' @param output_path Character. Path for output file with estimated betas
#' @param window_months Integer. Rolling window length (default 60)
#' @param min_months Integer. Minimum observations required (default 24)
#'
#' @return Data.frame with estimated betas
#'
#' @examples
#' \dontrun{
#' beta_estimates <- estimate_betas(
#'   data = largecap_data,
#'   output_path = "data/processed/beta_estimates.csv"
#' )
#' }
#'
#' @export
estimate_betas <- function(data,
                           output_path = "data/processed/beta_estimates.csv",
                           window_months = 60,
                           min_months = 24) {
  
  library(dplyr)
  library(tidyr)
  library(slider)
  library(readr)
  
  message("Estimating CAPM betas with rolling windows...")
  
  # TODO: Implement rolling beta estimation
  # betas <- data %>%
  #   group_by(PERMNO) %>%
  #   arrange(date) %>%
  #   mutate(
  #     beta = slider::slide_dbl(
  #       .x = cur_data(),
  #       .f = ~estimate_single_beta(.x),
  #       .before = window_months - 1,
  #       .complete = FALSE
  #     )
  #   )
  
  message("Saving beta estimates...")
  # TODO: Save output
  # write_csv(betas, output_path)
  
  message("Beta estimation complete!")
  
  return(data.frame())
}

#' Estimate Single Stock Beta
#'
#' Estimates CAPM beta for a single stock using available data
#'
#' @param data Data.frame with excess returns for one stock
#' @param min_obs Integer. Minimum observations required (default 24)
#'
#' @return Numeric beta estimate or NA
#'
#' @export
estimate_single_beta <- function(data, min_obs = 24) {
  
  # Check if sufficient data
  valid_obs <- sum(!is.na(data$excess_ret) & !is.na(data$mkt_excess_ret))
  
  if (valid_obs < min_obs) {
    return(NA_real_)
  }
  
  # Estimate beta via OLS
  tryCatch({
    model <- lm(excess_ret ~ mkt_excess_ret, data = data)
    beta <- coef(model)[2]
    return(as.numeric(beta))
  }, error = function(e) {
    return(NA_real_)
  })
}

#' Compute Excess Returns
#'
#' Calculates excess returns over risk-free rate
#'
#' @param returns Numeric vector of returns
#' @param rf Numeric vector of risk-free rates
#'
#' @return Numeric vector of excess returns
#'
#' @export
compute_excess_returns <- function(returns, rf) {
  returns - rf
}

#' Rolling Beta Estimation
#'
#' Applies rolling window beta estimation to panel data
#'
#' @param data Data.frame with stock and market returns
#' @param window Integer. Window length in months
#' @param min_obs Integer. Minimum observations
#'
#' @return Data.frame with beta column added
#'
#' @export
rolling_beta_estimation <- function(data, window = 60, min_obs = 24) {
  data %>%
    dplyr::group_by(PERMNO) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(
      beta = slider::slide_dbl(
        .x = list(excess_ret = excess_ret, mkt_excess_ret = mkt_excess_ret),
        .f = function(x) {
          if (sum(!is.na(x$excess_ret)) < min_obs) return(NA_real_)
          
          tryCatch({
            model <- lm(excess_ret ~ mkt_excess_ret, data = as.data.frame(x))
            as.numeric(coef(model)[2])
          }, error = function(e) NA_real_)
        },
        .before = window - 1,
        .complete = FALSE
      )
    ) %>%
    dplyr::ungroup()
}

# Main execution
if (!interactive()) {
  # TODO: Load large-cap data
  # data <- read_csv("data/processed/largecap_universe.csv")
  # estimate_betas(data)
}
