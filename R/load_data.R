#' Load CRSP monthly stock data
#'
#' @param file_path Path to CRSP data file
#' @return Data frame with CRSP monthly stock data
load_crsp_data <- function(file_path) {
  if (!file.exists(file_path)) {
    warning("CRSP data file not found. Returning empty data frame.")
    return(data.frame())
  }
  
  data <- read.csv(file_path, stringsAsFactors = FALSE)
  return(data)
}

#' Load Compustat annual data
#'
#' @param file_path Path to Compustat data file
#' @return Data frame with Compustat annual data
load_compustat_data <- function(file_path) {
  if (!file.exists(file_path)) {
    warning("Compustat data file not found. Returning empty data frame.")
    return(data.frame())
  }
  
  data <- read.csv(file_path, stringsAsFactors = FALSE)
  return(data)
}

#' Load market returns data
#'
#' @param file_path Path to market returns file
#' @return Data frame with market returns
load_market_returns <- function(file_path) {
  if (!file.exists(file_path)) {
    warning("Market returns file not found. Returning empty data frame.")
    return(data.frame())
  }
  
  data <- read.csv(file_path, stringsAsFactors = FALSE)
  return(data)
}

#' Load Fama-French factor data
#'
#' @param file_path Path to Fama-French factors file
#' @return Data frame with FF factors
load_ff_factors <- function(file_path) {
  if (!file.exists(file_path)) {
    warning("Fama-French factors file not found. Returning empty data frame.")
    return(data.frame())
  }
  
  data <- read.csv(file_path, stringsAsFactors = FALSE)
  return(data)
}
