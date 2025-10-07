#' Run CAPM regressions for portfolios
#'
#' @param portfolio_returns Portfolio returns data
#' @param market_returns Market returns data
#' @return CAPM regression results
run_capm_regressions <- function(portfolio_returns, market_returns) {
  if (nrow(portfolio_returns) == 0 || nrow(market_returns) == 0) {
    return(data.frame())
  }
  
  # Prepare data
  mkt <- market_returns %>%
    mutate(date = as.Date(date)) %>%
    select(date, mkt_ret = ret, rf = rf)
  
  reg_data <- portfolio_returns %>%
    left_join(mkt, by = "date") %>%
    filter(!is.na(mkt_ret), !is.na(rf))
  
  # Run regressions for each portfolio
  capm_results <- reg_data %>%
    group_by(portfolio) %>%
    summarise(
      # Equal-weighted
      model_ew = list(lm(I(ret_ew - rf) ~ I(mkt_ret - rf))),
      # Value-weighted
      model_vw = list(lm(I(ret_vw - rf) ~ I(mkt_ret - rf))),
      .groups = "drop"
    ) %>%
    mutate(
      # Extract coefficients - EW
      alpha_ew = map_dbl(model_ew, ~coef(.x)[1]),
      beta_ew = map_dbl(model_ew, ~coef(.x)[2]),
      alpha_se_ew = map_dbl(model_ew, ~summary(.x)$coefficients[1, 2]),
      alpha_t_ew = map_dbl(model_ew, ~summary(.x)$coefficients[1, 3]),
      r2_ew = map_dbl(model_ew, ~summary(.x)$r.squared),
      # Extract coefficients - VW
      alpha_vw = map_dbl(model_vw, ~coef(.x)[1]),
      beta_vw = map_dbl(model_vw, ~coef(.x)[2]),
      alpha_se_vw = map_dbl(model_vw, ~summary(.x)$coefficients[1, 2]),
      alpha_t_vw = map_dbl(model_vw, ~summary(.x)$coefficients[1, 3]),
      r2_vw = map_dbl(model_vw, ~summary(.x)$r.squared)
    ) %>%
    select(-model_ew, -model_vw)
  
  # Also run for long-short portfolio
  ls_reg_data <- reg_data %>%
    filter(!is.na(ls_ret_ew), !is.na(ls_ret_vw)) %>%
    distinct(date, ls_ret_ew, ls_ret_vw, mkt_ret, rf)
  
  if (nrow(ls_reg_data) > 0) {
    ls_capm <- tibble(
      portfolio = 0,  # 0 indicates long-short
      alpha_ew = coef(lm(I(ls_ret_ew - rf) ~ I(mkt_ret - rf), data = ls_reg_data))[1],
      beta_ew = coef(lm(I(ls_ret_ew - rf) ~ I(mkt_ret - rf), data = ls_reg_data))[2],
      alpha_vw = coef(lm(I(ls_ret_vw - rf) ~ I(mkt_ret - rf), data = ls_reg_data))[1],
      beta_vw = coef(lm(I(ls_ret_vw - rf) ~ I(mkt_ret - rf), data = ls_reg_data))[2]
    )
    
    capm_results <- bind_rows(capm_results, ls_capm)
  }
  
  return(capm_results)
}

#' Run Fama-French 4-factor regressions
#'
#' @param portfolio_returns Portfolio returns data
#' @param ff_factors Fama-French factor data
#' @return FF4 regression results
run_ff4_regressions <- function(portfolio_returns, ff_factors) {
  if (nrow(portfolio_returns) == 0 || nrow(ff_factors) == 0) {
    return(data.frame())
  }
  
  # Prepare factors
  factors <- ff_factors %>%
    mutate(date = as.Date(date)) %>%
    select(date, mkt_rf = mkt_rf, smb = smb, hml = hml, umd = umd, rf = rf)
  
  reg_data <- portfolio_returns %>%
    left_join(factors, by = "date") %>%
    filter(!is.na(mkt_rf), !is.na(smb), !is.na(hml), !is.na(umd))
  
  # Run regressions for each portfolio
  ff4_results <- reg_data %>%
    group_by(portfolio) %>%
    summarise(
      # Equal-weighted
      model_ew = list(lm(I(ret_ew - rf) ~ mkt_rf + smb + hml + umd)),
      # Value-weighted
      model_vw = list(lm(I(ret_vw - rf) ~ mkt_rf + smb + hml + umd)),
      .groups = "drop"
    ) %>%
    mutate(
      # Extract coefficients - EW
      alpha_ew = map_dbl(model_ew, ~coef(.x)[1]),
      beta_mkt_ew = map_dbl(model_ew, ~coef(.x)[2]),
      beta_smb_ew = map_dbl(model_ew, ~coef(.x)[3]),
      beta_hml_ew = map_dbl(model_ew, ~coef(.x)[4]),
      beta_umd_ew = map_dbl(model_ew, ~coef(.x)[5]),
      alpha_t_ew = map_dbl(model_ew, ~summary(.x)$coefficients[1, 3]),
      r2_ew = map_dbl(model_ew, ~summary(.x)$r.squared),
      # Extract coefficients - VW
      alpha_vw = map_dbl(model_vw, ~coef(.x)[1]),
      beta_mkt_vw = map_dbl(model_vw, ~coef(.x)[2]),
      beta_smb_vw = map_dbl(model_vw, ~coef(.x)[3]),
      beta_hml_vw = map_dbl(model_vw, ~coef(.x)[4]),
      beta_umd_vw = map_dbl(model_vw, ~coef(.x)[5]),
      alpha_t_vw = map_dbl(model_vw, ~summary(.x)$coefficients[1, 3]),
      r2_vw = map_dbl(model_vw, ~summary(.x)$r.squared)
    ) %>%
    select(-model_ew, -model_vw)
  
  # Also run for long-short portfolio
  ls_reg_data <- reg_data %>%
    filter(!is.na(ls_ret_ew), !is.na(ls_ret_vw)) %>%
    distinct(date, ls_ret_ew, ls_ret_vw, mkt_rf, smb, hml, umd, rf)
  
  if (nrow(ls_reg_data) > 0) {
    model_ls_ew <- lm(I(ls_ret_ew - rf) ~ mkt_rf + smb + hml + umd, data = ls_reg_data)
    model_ls_vw <- lm(I(ls_ret_vw - rf) ~ mkt_rf + smb + hml + umd, data = ls_reg_data)
    
    ls_ff4 <- tibble(
      portfolio = 0,
      alpha_ew = coef(model_ls_ew)[1],
      beta_mkt_ew = coef(model_ls_ew)[2],
      beta_smb_ew = coef(model_ls_ew)[3],
      beta_hml_ew = coef(model_ls_ew)[4],
      beta_umd_ew = coef(model_ls_ew)[5],
      alpha_vw = coef(model_ls_vw)[1],
      beta_mkt_vw = coef(model_ls_vw)[2],
      beta_smb_vw = coef(model_ls_vw)[3],
      beta_hml_vw = coef(model_ls_vw)[4],
      beta_umd_vw = coef(model_ls_vw)[5]
    )
    
    ff4_results <- bind_rows(ff4_results, ls_ff4)
  }
  
  return(ff4_results)
}
