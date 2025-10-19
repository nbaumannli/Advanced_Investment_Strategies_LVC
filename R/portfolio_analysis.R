#' Calculate Book-to-Price spreads for portfolios
#'
#' @param beta_portfolios Portfolio data
#' @return B/P spreads by portfolio and date
#' B/P spreads by date with robust handling of missing buckets
#' Expects columns: date, portfolio, bp, and either w_lag or mktcap for weights.
calculate_bp_spreads <- function(df) {
  stopifnot(all(c("date","portfolio","bp") %in% names(df)))
  wvar <- if ("w_lag" %in% names(df)) "w_lag" else if ("mktcap" %in% names(df)) "mktcap" else NULL
  if (is.null(wvar)) stop("Need a weight column: w_lag or mktcap")

  gp <- df %>%
    dplyr::filter(is.finite(bp)) %>%
    dplyr::group_by(date, portfolio) %>%
    dplyr::summarise(
      bp_mean   = mean(bp, na.rm = TRUE),
      bp_median = median(bp, na.rm = TRUE),
      bp_vw     = stats::weighted.mean(bp, .data[[wvar]], na.rm = TRUE),
      n_stocks  = dplyr::n(),
      .groups   = "drop"
    )

  # pick lowest and highest *available* bucket each month
  low  <- gp %>%
    dplyr::group_by(date) %>%
    dplyr::slice_min(order_by = portfolio, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::transmute(date, low_portfolio = portfolio, bp_low = bp_vw)

  high <- gp %>%
    dplyr::group_by(date) %>%
    dplyr::slice_max(order_by = portfolio, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::transmute(date, high_portfolio = portfolio, bp_high = bp_vw)

  dplyr::left_join(gp, dplyr::left_join(low, high, by = "date"), by = "date") %>%
    dplyr::mutate(bp_spread_hl = bp_high - bp_low)
}

#' Calculate portfolio returns (formation at t, holding at t+1)
#' @param beta_portfolios Data with: permno, date, portfolio, ret, and either
#'   a size column (mktcap/me/size/mve/marketcap) or prc & shrout.
#' @return Tibble of portfolio returns by holding date (EW, VW) + long–short
calculate_portfolio_returns <- function(beta_portfolios) {
  if (nrow(beta_portfolios) == 0) return(dplyr::tibble())

  bp <- beta_portfolios %>%
    dplyr::mutate(
      date      = as.Date(date),
      portfolio = suppressWarnings(as.numeric(portfolio)),
      ret       = suppressWarnings(as.numeric(ret)),
      prc       = suppressWarnings(as.numeric(prc)),
      shrout    = suppressWarnings(as.numeric(shrout))
    )

  # Standardize a market-cap column ("size_std")
  size_candidates <- c("mktcap","me","size","marketcap","mve","market_equity")
  have <- intersect(names(bp), size_candidates)
  if (length(have) > 0) {
    best <- have[which.max(vapply(
      have,
      function(x) sum(is.finite(suppressWarnings(as.numeric(bp[[x]]))), na.rm = TRUE),
      1L
    ))]
    bp <- bp %>% dplyr::mutate(size_std = suppressWarnings(as.numeric(.data[[best]])))
  } else {
    bp <- bp %>% dplyr::mutate(size_std = NA_real_)
  }

  # If missing, construct size from CRSP fields
  if (sum(is.finite(bp$size_std), na.rm = TRUE) == 0L) {
    bp <- bp %>% dplyr::mutate(
      size_std = dplyr::if_else(is.finite(prc) & is.finite(shrout),
                                abs(prc) * shrout * 1000, NA_real_)
    )
  }

  # Formation at t, hold in t+1
  bp <- bp %>%
    dplyr::arrange(permno, date) %>%
    dplyr::group_by(permno) %>%
    dplyr::mutate(
      w_t     = suppressWarnings(as.numeric(size_std)),
      ret_t1  = dplyr::lead(ret),
      date_t1 = dplyr::lead(date)
    ) %>%
    dplyr::ungroup()

  # Aggregate by holding month t+1 using t-weights
  portfolio_returns <- bp %>%
    dplyr::filter(is.finite(date_t1), is.finite(ret_t1), !is.na(portfolio)) %>%
    dplyr::group_by(date = date_t1, portfolio) %>%
    dplyr::summarise(
      ret_ew = mean(ret_t1, na.rm = TRUE),
      ret_vw = {
        w <- suppressWarnings(as.numeric(w_t))
        w[!is.finite(w) | w <= 0] <- NA_real_
        if (sum(is.finite(w)) == 0) NA_real_ else {
          x <- suppressWarnings(as.numeric(ret_t1))
          sum(x * w, na.rm = TRUE) / sum(w, na.rm = TRUE)
        }
      },
      n_stocks = dplyr::n(),
      .groups = "drop"
    ) %>%
    dplyr::group_by(date) %>%
    dplyr::mutate(
      .low_p  = suppressWarnings(min(portfolio, na.rm = TRUE)),
      .high_p = suppressWarnings(max(portfolio, na.rm = TRUE)),
      ls_ret_ew = dplyr::first(ret_ew[portfolio == .low_p],  default = NA_real_) -
        dplyr::first(ret_ew[portfolio == .high_p], default = NA_real_),
      ls_ret_vw = dplyr::first(ret_vw[portfolio == .low_p],  default = NA_real_) -
        dplyr::first(ret_vw[portfolio == .high_p], default = NA_real_)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(-.low_p, -.high_p)

  portfolio_returns
}

