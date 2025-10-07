#' Compute Book-to-Price Spread
#'
#' Calculates monthly B/P spread between low-beta and high-beta portfolios,
#' then forms spread quintiles as specified in Garcia-Feijóo et al. (2015).
#'
#' @details
#' Spread calculation:
#' \itemize{
#'   \item Compute average B/P for low-beta (Q1) portfolio
#'   \item Compute average B/P for high-beta (Q5) portfolio
#'   \item B/P spread = Average B/P of Q1 - Average B/P of Q5
#'   \item Sort months into quintiles by B/P spread
#' }
#'
#' @param data Data.frame with portfolio assignments and B/P ratios
#' @param output_path Character. Path for output spread data
#'
#' @return Data.frame with B/P spreads and quintiles
#'
#' @examples
#' \dontrun{
#' bp_spread <- compute_bp_spread(
#'   data = portfolio_data,
#'   output_path = "data/processed/bp_spread.csv"
#' )
#' }
#'
#' @export
compute_bp_spread <- function(data,
                               output_path = "data/processed/bp_spread.csv") {
  
  library(dplyr)
  library(readr)
  
  message("Computing average B/P by beta quintile...")
  # TODO: Calculate average B/P for each quintile
  # bp_by_quintile <- data %>%
  #   group_by(date, beta_quintile) %>%
  #   summarise(
  #     avg_bp = mean(bp_ratio, na.rm = TRUE),
  #     .groups = "drop"
  #   )
  
  message("Calculating B/P spread (Q1 - Q5)...")
  # TODO: Compute spread
  # bp_spread <- bp_by_quintile %>%
  #   pivot_wider(names_from = beta_quintile, values_from = avg_bp) %>%
  #   mutate(
  #     bp_spread = Q1 - Q5
  #   )
  
  message("Forming spread quintiles...")
  # TODO: Assign spread quintiles
  # bp_spread <- bp_spread %>%
  #   mutate(
  #     spread_quintile = ntile(bp_spread, 5)
  #   )
  
  message("Saving B/P spread data...")
  # TODO: Save output
  # write_csv(bp_spread, output_path)
  
  message("B/P spread computation complete!")
  
  return(data.frame())
}

#' Calculate Book-to-Price Ratio
#'
#' Computes B/P ratio for each stock
#'
#' @param book_value Numeric vector of book values
#' @param market_value Numeric vector of market values
#'
#' @return Numeric vector of B/P ratios
#'
#' @export
calculate_bp_ratio <- function(book_value, market_value) {
  book_value / market_value
}

#' Compute Average B/P by Portfolio
#'
#' Calculates average B/P for each beta quintile
#'
#' @param data Data.frame with beta_quintile and bp_ratio columns
#'
#' @return Data.frame with average B/P by quintile and date
#'
#' @export
compute_avg_bp_by_quintile <- function(data) {
  data %>%
    dplyr::group_by(date, beta_quintile) %>%
    dplyr::summarise(
      avg_bp = mean(bp_ratio, na.rm = TRUE),
      .groups = "drop"
    )
}

#' Calculate B/P Spread
#'
#' Computes spread between low-beta and high-beta B/P
#'
#' @param bp_data Data.frame with average B/P by quintile
#'
#' @return Data.frame with B/P spread
#'
#' @export
calculate_bp_spread <- function(bp_data) {
  bp_data %>%
    tidyr::pivot_wider(
      names_from = beta_quintile,
      values_from = avg_bp,
      names_prefix = "Q"
    ) %>%
    dplyr::mutate(
      bp_spread = Q1 - Q5
    )
}

#' Assign Spread Quintiles
#'
#' Sorts months into quintiles based on B/P spread
#'
#' @param spread_data Data.frame with bp_spread column
#'
#' @return Data.frame with spread_quintile column added
#'
#' @export
assign_spread_quintiles <- function(spread_data) {
  spread_data %>%
    dplyr::mutate(
      spread_quintile = dplyr::ntile(bp_spread, 5)
    )
}

# Main execution
if (!interactive()) {
  # TODO: Load portfolio data with B/P ratios
  # data <- read_csv("data/processed/portfolio_returns.csv")
  # compute_bp_spread(data)
}
