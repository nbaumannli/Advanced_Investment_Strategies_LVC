# --- Requires: dplyr, lubridate ------------------------------------------------
# library(dplyr); library(lubridate)

#' Clean CRSP data (paper-consistent)
#'
#' - Uses CRSP negative-price convention via abs(prc)
#' - Keeps NYSE/AMEX/NASDAQ (exchcd 1/2/3)
#' - Computes market cap in millions (shrout is in thousands)
#'
#' @param crsp_raw Raw CRSP data
#' @return Cleaned CRSP data
clean_crsp_data <- function(crsp_raw) {
  if (nrow(crsp_raw) == 0) return(crsp_raw)

  crsp_clean <- crsp_raw %>%
    dplyr::mutate(
      date   = as.Date(date),
      ret    = as.numeric(ret),
      prc    = abs(as.numeric(prc)),
      shrout = as.numeric(shrout),
      mktcap = prc * shrout * 1000    # USD (shrout is in thousands)
    ) %>%
    dplyr::filter(
      !is.na(ret), !is.na(prc), !is.na(shrout), !is.na(exchcd),
      shrout > 0,
      exchcd %in% c(1, 2, 3)      # NYSE / AMEX / NASDAQ
    )

  return(crsp_clean)
}

#' Clean Compustat data (paper-consistent)
#'
#' - Computes book equity per Fama–French (1992): BE = CEQ + TXDITC - PS
#' - December fiscal year-end only
#' - Requires >= 2 years per firm
#' - Deduplicates to one row per (permno, year) (keeps latest December if duplicates)
#'
#' @param compustat_raw Raw Compustat data (already linked to permno)
#' @return Cleaned Compustat data with columns: permno, datadate, year, be, at
clean_compustat_data <- function(compustat_raw) {
  if (nrow(compustat_raw) == 0) return(compustat_raw)

  compustat_clean <- compustat_raw %>%
    dplyr::mutate(
      datadate = as.Date(datadate),
      at    = as.numeric(at),
      ceq   = as.numeric(ceq),
      pstkrv= as.numeric(pstkrv),
      pstkl = as.numeric(pstkl),
      pstk  = as.numeric(pstk),
      txditc= as.numeric(txditc)
    ) %>%
    dplyr::mutate(
      ps = dplyr::coalesce(pstkrv, pstkl, pstk, 0),
      be = ceq + dplyr::coalesce(txditc, 0) - ps
    ) %>%
    dplyr::filter(lubridate::month(datadate) == 12) %>%
    dplyr::mutate(year = lubridate::year(datadate)) %>%
    dplyr::filter(!is.na(be), be > 0, !is.na(at), at > 0) %>%
    dplyr::arrange(permno, year, dplyr::desc(datadate)) %>%
    dplyr::distinct(permno, year, .keep_all = TRUE) %>%
    dplyr::group_by(permno) %>%
    dplyr::filter(dplyr::n() >= 2) %>%
    dplyr::ungroup() %>%
    # ---- NEW: treat Compustat numbers as millions -> convert to USD
    dplyr::mutate(
      be_usd = be * 1e6,
      at_usd = at * 1e6
    ) %>%
    dplyr::select(permno, datadate, year, be, at, be_usd, at_usd)

  compustat_clean
}

#' Merge CRSP and Compustat (clean one-to-many)
#'
#' - Uses last-December accounting year (t-1) for returns from Jul(t)..Jun(t+1)
#' - Assumes compustat_clean is unique per (permno, year)
#' - Computes book-to-market (bm) and book-to-price (bp = 1/bm)
#'
#' @param crsp_clean Cleaned CRSP data (can already be large-cap filtered)
#' @param compustat_clean Cleaned Compustat data from clean_compustat_data()
#' @return Merged dataset
# --- Requires dplyr, lubridate ---

merge_crsp_compustat <- function(crsp_clean, compustat_clean) {
  if (nrow(crsp_clean) == 0 || nrow(compustat_clean) == 0) return(data.frame())

  crsp_prep <- crsp_clean %>%
    dplyr::mutate(
      year      = lubridate::year(date),
      month     = lubridate::month(date),
      comp_year = dplyr::if_else(month >= 7, year, year - 1L)
    )

  compustat_prep <- compustat_clean %>%
    dplyr::mutate(year = if (!"year" %in% names(.)) lubridate::year(datadate) else year) %>%
    dplyr::filter(lubridate::month(datadate) == 12) %>%
    dplyr::arrange(permno, year, dplyr::desc(datadate)) %>%
    dplyr::distinct(permno, year, .keep_all = TRUE) %>%
    dplyr::select(permno, year, be_usd, at_usd)

  merged <- crsp_prep %>%
    dplyr::left_join(compustat_prep, by = c("permno", "comp_year" = "year")) %>%
    dplyr::filter(!is.na(mktcap), mktcap > 0, !is.na(be_usd), be_usd > 0) %>%
    dplyr::mutate(
      bm = be_usd / mktcap,   # Book-to-Market (BE/ME), both in USD
      bp = bm                 # Keep bp as alias used elsewhere (e.g., spreads)
    ) %>%
    dplyr::filter(is.finite(bm), bm > 0)

  merged
}
