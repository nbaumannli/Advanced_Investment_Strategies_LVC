#' Calculate rolling betas for stocks
#'
#' @param merged_data Merged CRSP-Compustat data
#' @param market_returns Market returns data
#' @param window Rolling window in months (default 60)
#' @return Data with calculated betas
calculate_rolling_betas <- function(merged_data, market_returns, window = 60) {
  if (nrow(merged_data) == 0 || nrow(market_returns) == 0) {
    return(data.frame())
  }
  
  # Prepare market returns
  mkt <- market_returns %>%
    mutate(date = as.Date(date)) %>%
    select(date, mkt_ret = ret)
  
  # Join with stock returns
  data_with_mkt <- merged_data %>%
    left_join(mkt, by = "date") %>%
    filter(!is.na(mkt_ret))
  
  # Calculate rolling betas for each stock
  betas <- data_with_mkt %>%
    arrange(permno, date) %>%
    group_by(permno) %>%
    mutate(
      # Calculate beta using rolling 60-month window
      beta = zoo::rollapplyr(
        1:n(),
        width = window,
        FUN = function(idx) {
          if (length(idx) < 24) return(NA)  # Require at least 24 months
          model <- lm(ret ~ mkt_ret, data = data_with_mkt[idx, ])
          coef(model)[2]
        },
        fill = NA,
        partial = FALSE
      )
    ) %>%
    ungroup() %>%
    filter(!is.na(beta))
  
  return(betas)
}

#' Calculate NYSE breakpoints for beta portfolios
#'
#' @param stock_betas Data with stock betas
#' @param n_portfolios Number of portfolios (default 10)
#' @return NYSE breakpoints by date
calculate_nyse_breakpoints <- function(stock_betas, n_portfolios = 10) {
  if (nrow(stock_betas) == 0) {
    return(data.frame())
  }
  
  breakpoints <- stock_betas %>%
    filter(exchcd == 1) %>%  # NYSE stocks only
    # Focus on large-cap: top 50% by market cap
    group_by(date) %>%
    filter(mktcap >= median(mktcap, na.rm = TRUE)) %>%
    summarise(
      breakpoints = list(
        quantile(beta, probs = seq(0, 1, length.out = n_portfolios + 1), na.rm = TRUE)
      ),
      .groups = "drop"
    )
  
  return(breakpoints)
}

#' Form beta-sorted portfolios
#'
#' @param stock_betas Data with stock betas
#' @param nyse_breakpoints NYSE breakpoints
#' @return Portfolio assignments
form_beta_portfolios <- function(stock_betas, nyse_breakpoints) {
  if (nrow(stock_betas) == 0 || nrow(nyse_breakpoints) == 0) {
    return(data.frame())
  }
  
  portfolios <- stock_betas %>%
    left_join(nyse_breakpoints, by = "date") %>%
    rowwise() %>%
    mutate(
      portfolio = findInterval(beta, unlist(breakpoints), left.open = FALSE)
    ) %>%
    ungroup() %>%
    # Ensure portfolio is between 1 and 10
    mutate(portfolio = pmin(pmax(portfolio, 1), 10))
  
  return(portfolios)
}
