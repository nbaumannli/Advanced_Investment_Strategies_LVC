#' Compute Large-Cap Breakpoints
#'
#' Computes NYSE market capitalization breakpoints and filters for top third
#' (large-cap universe) as specified in Garcia-Feijóo et al. (2015).
#'
#' @details
#' Uses NYSE stocks only to determine breakpoints, then applies to full universe.
#' Keeps stocks in the top third by market capitalization.
#'
#' @param data Data.frame with stock data including EXCHCD and market cap
#' @param output_path Character. Path for output file
#'
#' @return Data.frame filtered to large-cap universe
#'
#' @examples
#' \dontrun{
#' largecap_data <- compute_largecap_breakpoints(
#'   data = merged_data,
#'   output_path = "data/processed/largecap_universe.csv"
#' )
#' }
#'
#' @export
compute_largecap_breakpoints <- function(data,
                                          output_path = "data/processed/largecap_universe.csv") {
  
  library(dplyr)
  library(readr)
  
  message("Computing NYSE breakpoints for market cap...")
  # TODO: Compute NYSE breakpoints
  # nyse_breakpoints <- data %>%
  #   filter(EXCHCD == 1) %>%  # NYSE only
  #   group_by(date) %>%
  #   summarise(
  #     mktcap_33rd = quantile(MKTCAP, 0.33, na.rm = TRUE),
  #     mktcap_67th = quantile(MKTCAP, 0.67, na.rm = TRUE)
  #   )
  
  message("Filtering for top third (large-cap)...")
  # TODO: Apply breakpoints to full universe
  # largecap <- data %>%
  #   left_join(nyse_breakpoints, by = "date") %>%
  #   filter(MKTCAP >= mktcap_67th)
  
  message("Saving large-cap universe...")
  # TODO: Save output
  # write_csv(largecap, output_path)
  
  message("Large-cap breakpoint computation complete!")
  
  return(data.frame())
}

#' Calculate NYSE Breakpoints
#'
#' Computes market cap breakpoints using NYSE stocks only
#'
#' @param data Data.frame with EXCHCD and MKTCAP columns
#' @param percentiles Numeric vector of percentiles (default c(0.33, 0.67))
#'
#' @return Data.frame with breakpoints by date
#'
#' @export
calculate_nyse_breakpoints <- function(data, percentiles = c(0.33, 0.67)) {
  data %>%
    dplyr::filter(EXCHCD == 1) %>%  # NYSE only
    dplyr::group_by(date) %>%
    dplyr::summarise(
      mktcap_33rd = quantile(MKTCAP, percentiles[1], na.rm = TRUE),
      mktcap_67th = quantile(MKTCAP, percentiles[2], na.rm = TRUE),
      .groups = "drop"
    )
}

#' Filter Top Market Cap Tercile
#'
#' Keeps only stocks in the top third by market capitalization
#'
#' @param data Data.frame with stock data
#' @param breakpoints Data.frame with NYSE breakpoints
#'
#' @return Filtered data.frame
#'
#' @export
filter_top_tercile <- function(data, breakpoints) {
  data %>%
    dplyr::left_join(breakpoints, by = "date") %>%
    dplyr::filter(MKTCAP >= mktcap_67th) %>%
    dplyr::select(-mktcap_33rd, -mktcap_67th)
}

# Main execution
if (!interactive()) {
  # TODO: Load processed data
  # data <- read_csv("data/processed/crsp_compustat_merged.csv")
  # compute_largecap_breakpoints(data)
}
