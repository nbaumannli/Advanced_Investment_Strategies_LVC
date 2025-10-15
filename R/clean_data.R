#' Clean CRSP data
#'
#' @param crsp_raw Raw CRSP data
#' @return Cleaned CRSP data
clean_crsp_data <- function(crsp_raw) {
  if (nrow(crsp_raw) == 0) {
    return(crsp_raw)
  }
  
  crsp_clean <- crsp_raw %>%
    mutate(
      date = as.Date(date),
      ret = as.numeric(ret),
      prc = abs(as.numeric(prc)),
      shrout = as.numeric(shrout),
      mktcap = abs(prc) * shrout / 1000  # Market cap in millions
    ) %>%
    filter(
      !is.na(ret),
      !is.na(prc),
      !is.na(shrout),
      prc > 0,
      shrout > 0
    ) %>%
    # Keep only common stocks (share codes 10, 11)
    filter(shrcd %in% c(10, 11)) %>%
    # Keep only NYSE, AMEX, NASDAQ (exchange codes 1, 2, 3)
    filter(exchcd %in% c(1, 2, 3))
  
  return(crsp_clean)
}

#' Clean Compustat data
#'
#' @param compustat_raw Raw Compustat data
#' @return Cleaned Compustat data
clean_compustat_data <- function(compustat_raw) {
  if (nrow(compustat_raw) == 0) {
    return(compustat_raw)
  }
  
  compustat_clean <- compustat_raw %>%
    mutate(
      datadate = as.Date(datadate),
      at = as.numeric(at),          # Total assets
      ceq = as.numeric(ceq),         # Common equity
      pstkrv = as.numeric(pstkrv),   # Preferred stock - redemption value
      pstkl = as.numeric(pstkl),     # Preferred stock - liquidating value
      pstk = as.numeric(pstk),       # Preferred stock - par value
      txditc = as.numeric(txditc)    # Deferred taxes and investment tax credit
    ) %>%
    # Calculate book equity following Fama-French
    mutate(
      ps = coalesce(pstkrv, pstkl, pstk, 0),
      be = ceq + coalesce(txditc, 0) - ps
    ) %>%
    filter(
      !is.na(be),
      be > 0,
      !is.na(at),
      at > 0
    )
  
  return(compustat_clean)
}

#' Merge CRSP and Compustat data
#'
#' @param crsp_clean Cleaned CRSP data
#' @param compustat_clean Cleaned Compustat data
#' @return Merged dataset
merge_crsp_compustat <- function(crsp_clean, compustat_clean) {
  if (nrow(crsp_clean) == 0 || nrow(compustat_clean) == 0) {
    return(data.frame())
  }
  
  # Prepare Compustat data with fiscal year end alignment
  compustat_prep <- compustat_clean %>%
    mutate(
      year = year(datadate),
      month = month(datadate)
    ) %>%
    select(permno, year, be, at)
  
  # Prepare CRSP data
  crsp_prep <- crsp_clean %>%
    mutate(
      year = year(date),
      month = month(date)
    )
  
  # Merge: Book equity from t-1 matched to returns from July of year t to June of t+1
  merged <- crsp_prep %>%
    mutate(comp_year = if_else(month >= 7, year, year - 1)) %>%
    left_join(
      compustat_prep,
      by = c("permno", "comp_year" = "year")
    ) %>%
    # Calculate book-to-market ratio
    mutate(
      bm = be / mktcap,
      bp = 1 / bm  # Book-to-price is inverse of price-to-book
    ) %>%
    filter(!is.na(bm), bm > 0)
  
  return(merged)
}
