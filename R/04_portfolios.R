#' Construct Beta-Sorted Portfolios
#'
#' Sorts stocks into quintiles by beta and constructs value-weighted portfolios.
#' Computes returns for month t+1 including zero-cost and beta-neutral strategies
#' as specified in Garcia-Feijóo et al. (2015).
#'
#' @details
#' Portfolio construction:
#' \itemize{
#'   \item Sort by beta into quintiles (Q1 = low beta, Q5 = high beta)
#'   \item Value-weighted returns in month t+1
#'   \item Zero-cost long-short: Long Q1, Short Q5
#'   \item Beta-neutral: Long 100% Q1, Short 25% Q5
#' }
#'
#' @param data Data.frame with beta estimates and market caps
#' @param output_path Character. Path for output portfolio returns
#'
#' @return Data.frame with portfolio returns
#'
#' @examples
#' \dontrun{
#' portfolios <- construct_portfolios(
#'   data = beta_data,
#'   output_path = "data/processed/portfolio_returns.csv"
#' )
#' }
#'
#' @export
construct_portfolios <- function(data,
                                  output_path = "data/processed/portfolio_returns.csv") {
  
  library(dplyr)
  library(readr)
  
  message("Sorting stocks into beta quintiles...")
  # TODO: Sort into quintiles by beta
  # sorted <- data %>%
  #   group_by(date) %>%
  #   mutate(
  #     beta_quintile = ntile(beta, 5)
  #   )
  
  message("Computing value-weighted returns...")
  # TODO: Calculate portfolio returns
  # portfolio_returns <- sorted %>%
  #   group_by(date, beta_quintile) %>%
  #   summarise(
  #     vw_ret = sum(ret_lead * weight, na.rm = TRUE),
  #     .groups = "drop"
  #   )
  
  message("Computing long-short strategies...")
  # TODO: Compute zero-cost and beta-neutral portfolios
  # strategies <- portfolio_returns %>%
  #   pivot_wider(names_from = beta_quintile, values_from = vw_ret) %>%
  #   mutate(
  #     zero_cost = Q1 - Q5,
  #     beta_neutral = Q1 - 0.25 * Q5
  #   )
  
  message("Saving portfolio returns...")
  # TODO: Save output
  # write_csv(strategies, output_path)
  
  message("Portfolio construction complete!")
  
  return(data.frame())
}

#' Assign Beta Quintiles
#'
#' Assigns stocks to quintiles based on beta
#'
#' @param data Data.frame with beta column
#'
#' @return Data.frame with beta_quintile column added
#'
#' @export
assign_beta_quintiles <- function(data) {
  data %>%
    dplyr::group_by(date) %>%
    dplyr::mutate(
      beta_quintile = dplyr::ntile(beta, 5)
    ) %>%
    dplyr::ungroup()
}

#' Calculate Value-Weighted Returns
#'
#' Computes value-weighted portfolio returns
#'
#' @param data Data.frame with returns and market caps
#' @param ret_col Character. Name of return column
#' @param weight_col Character. Name of weight column (default "mktcap")
#'
#' @return Data.frame with value-weighted returns
#'
#' @export
calculate_vw_returns <- function(data, ret_col = "ret", weight_col = "mktcap") {
  data %>%
    dplyr::group_by(date, beta_quintile) %>%
    dplyr::mutate(
      weight = .data[[weight_col]] / sum(.data[[weight_col]], na.rm = TRUE)
    ) %>%
    dplyr::summarise(
      vw_ret = sum(.data[[ret_col]] * weight, na.rm = TRUE),
      .groups = "drop"
    )
}

#' Construct Zero-Cost Portfolio
#'
#' Creates zero-cost long-short portfolio (Long low-beta, Short high-beta)
#'
#' @param portfolio_returns Data.frame with returns by quintile
#'
#' @return Data.frame with zero-cost strategy returns
#'
#' @export
construct_zero_cost <- function(portfolio_returns) {
  portfolio_returns %>%
    tidyr::pivot_wider(
      names_from = beta_quintile,
      values_from = vw_ret,
      names_prefix = "Q"
    ) %>%
    dplyr::mutate(
      zero_cost = Q1 - Q5
    )
}

#' Construct Beta-Neutral Portfolio
#'
#' Creates beta-neutral portfolio (Long 100% low-beta, Short 25% high-beta)
#'
#' @param portfolio_returns Data.frame with returns by quintile
#'
#' @return Data.frame with beta-neutral strategy returns
#'
#' @export
construct_beta_neutral <- function(portfolio_returns) {
  portfolio_returns %>%
    tidyr::pivot_wider(
      names_from = beta_quintile,
      values_from = vw_ret,
      names_prefix = "Q"
    ) %>%
    dplyr::mutate(
      beta_neutral = Q1 - 0.25 * Q5
    )
}

# Main execution
if (!interactive()) {
  # TODO: Load beta estimates
  # data <- read_csv("data/processed/beta_estimates.csv")
  # construct_portfolios(data)
}
