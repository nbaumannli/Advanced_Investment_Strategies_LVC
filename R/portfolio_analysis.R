#' Calculate Book-to-Price spreads for portfolios
#'
#' @param beta_portfolios Portfolio data
#' @return B/P spreads by portfolio and date
calculate_bp_spreads <- function(beta_portfolios) {
  if (nrow(beta_portfolios) == 0) {
    return(data.frame())
  }
  
  bp_spreads <- beta_portfolios %>%
    filter(!is.na(bp), !is.infinite(bp)) %>%
    group_by(date, portfolio) %>%
    summarise(
      bp_mean = mean(bp, na.rm = TRUE),
      bp_median = median(bp, na.rm = TRUE),
      bp_vw = weighted.mean(bp, mktcap, na.rm = TRUE),
      n_stocks = n(),
      .groups = "drop"
    ) %>%
    # Calculate spread between high and low beta portfolios
    group_by(date) %>%
    mutate(
      bp_spread_hl = bp_vw[portfolio == 10] - bp_vw[portfolio == 1]
    ) %>%
    ungroup()
  
  return(bp_spreads)
}

#' Calculate portfolio returns
#'
#' @param beta_portfolios Portfolio data
#' @return Portfolio returns by date
calculate_portfolio_returns <- function(beta_portfolios) {
  if (nrow(beta_portfolios) == 0) {
    return(data.frame())
  }
  
  portfolio_returns <- beta_portfolios %>%
    group_by(date, portfolio) %>%
    summarise(
      # Equal-weighted returns
      ret_ew = mean(ret, na.rm = TRUE),
      # Value-weighted returns
      ret_vw = weighted.mean(ret, lag(mktcap), na.rm = TRUE),
      # Portfolio characteristics
      beta_avg = mean(beta, na.rm = TRUE),
      mktcap_avg = mean(mktcap, na.rm = TRUE),
      bp_avg = mean(bp, na.rm = TRUE),
      n_stocks = n(),
      .groups = "drop"
    ) %>%
    # Calculate long-short portfolio (low beta minus high beta)
    group_by(date) %>%
    mutate(
      ls_ret_ew = ret_ew[portfolio == 1] - ret_ew[portfolio == 10],
      ls_ret_vw = ret_vw[portfolio == 1] - ret_vw[portfolio == 10]
    ) %>%
    ungroup()
  
  return(portfolio_returns)
}
