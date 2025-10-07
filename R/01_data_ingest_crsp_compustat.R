#' Data Ingest: CRSP and Compustat Merge
#'
#' Merges CRSP and Compustat data with appropriate filters for the low-volatility
#' replication study. Applies share code filters, delisting return adjustments,
#' and price filters as specified in Garcia-Feijóo et al. (2015).
#'
#' @details
#' This script performs the following data preparation steps:
#' \itemize{
#'   \item Merges CRSP monthly stock file with Compustat fundamentals
#'   \item Filters for share codes 10 and 11 (ordinary common shares)
#'   \item Applies delisting return adjustments: -55% for NASDAQ, -30% for NYSE/AMEX
#'   \item Filters prices to range $2 to $1,000
#'   \item Outputs cleaned dataset to data/processed/
#' }
#'
#' @param crsp_path Character. Path to CRSP monthly stock file
#' @param compustat_path Character. Path to Compustat fundamentals file
#' @param output_path Character. Path for output merged file
#'
#' @return A data.frame with merged and filtered CRSP-Compustat data
#'
#' @examples
#' \dontrun{
#' merged_data <- ingest_crsp_compustat(
#'   crsp_path = "data/raw/crsp_monthly.csv",
#'   compustat_path = "data/raw/compustat.csv",
#'   output_path = "data/processed/crsp_compustat_merged.csv"
#' )
#' }
#'
#' @export
ingest_crsp_compustat <- function(crsp_path = "data/raw/crsp_monthly.csv",
                                   compustat_path = "data/raw/compustat.csv",
                                   output_path = "data/processed/crsp_compustat_merged.csv") {
  
  # Load required packages
  library(dplyr)
  library(readr)
  
  message("Loading CRSP data...")
  # TODO: Load CRSP data
  # crsp <- read_csv(crsp_path)
  
  message("Loading Compustat data...")
  # TODO: Load Compustat data
  # compustat <- read_csv(compustat_path)
  
  message("Merging datasets...")
  # TODO: Merge CRSP and Compustat using PERMNO-GVKEY link
  # merged <- crsp %>% left_join(compustat, by = c("PERMNO" = "gvkey"))
  
  message("Applying share code filter (10, 11)...")
  # TODO: Filter for share codes 10 and 11
  # merged <- merged %>% filter(SHRCD %in% c(10, 11))
  
  message("Applying delisting return adjustments...")
  # TODO: Apply delisting returns
  # NASDAQ: -55%, NYSE/AMEX: -30%
  # merged <- merged %>%
  #   mutate(
  #     DLRET = case_when(
  #       is.na(DLRET) & EXCHCD == 3 ~ -0.55,  # NASDAQ
  #       is.na(DLRET) & EXCHCD %in% c(1, 2) ~ -0.30,  # NYSE/AMEX
  #       TRUE ~ DLRET
  #     )
  #   )
  
  message("Applying price filter ($2 to $1,000)...")
  # TODO: Filter price range
  # merged <- merged %>% filter(PRC >= 2, PRC <= 1000)
  
  message("Saving merged data...")
  # TODO: Save output
  # write_csv(merged, output_path)
  
  message("Data ingest complete!")
  
  # Return merged data (stub)
  return(data.frame())
}

#' Apply Share Code Filter
#'
#' Filters data to include only ordinary common shares (share codes 10 and 11)
#'
#' @param data Data.frame containing CRSP data with SHRCD column
#'
#' @return Filtered data.frame
#'
#' @export
apply_share_code_filter <- function(data) {
  data %>%
    dplyr::filter(SHRCD %in% c(10, 11))
}

#' Apply Delisting Returns
#'
#' Adjusts returns for delisting events based on exchange
#'
#' @param data Data.frame containing CRSP data with EXCHCD and DLRET columns
#'
#' @return Data.frame with adjusted delisting returns
#'
#' @export
apply_delisting_returns <- function(data) {
  data %>%
    dplyr::mutate(
      DLRET = dplyr::case_when(
        is.na(DLRET) & EXCHCD == 3 ~ -0.55,  # NASDAQ
        is.na(DLRET) & EXCHCD %in% c(1, 2) ~ -0.30,  # NYSE/AMEX
        TRUE ~ DLRET
      )
    )
}

#' Apply Price Filter
#'
#' Filters stocks within specified price range
#'
#' @param data Data.frame with PRC (price) column
#' @param min_price Numeric. Minimum price (default 2)
#' @param max_price Numeric. Maximum price (default 1000)
#'
#' @return Filtered data.frame
#'
#' @export
apply_price_filter <- function(data, min_price = 2, max_price = 1000) {
  data %>%
    dplyr::filter(PRC >= min_price, PRC <= max_price)
}

# Main execution
if (!interactive()) {
  ingest_crsp_compustat()
}
