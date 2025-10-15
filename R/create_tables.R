#' Create Table 1: Summary Statistics
#'
#' @param merged_data Merged CRSP-Compustat data
#' @return Summary statistics table
create_table1_summary_stats <- function(merged_data) {
  if (nrow(merged_data) == 0) {
    return(data.frame())
  }
  
  table1 <- merged_data %>%
    summarise(
      n_obs = n(),
      n_stocks = n_distinct(permno),
      mean_ret = mean(ret, na.rm = TRUE) * 100,
      sd_ret = sd(ret, na.rm = TRUE) * 100,
      mean_mktcap = mean(mktcap, na.rm = TRUE),
      median_mktcap = median(mktcap, na.rm = TRUE),
      mean_bm = mean(bm, na.rm = TRUE),
      median_bm = median(bm, na.rm = TRUE)
    )
  
  return(table1)
}

#' Create Table 2: Portfolio Characteristics
#'
#' @param beta_portfolios Portfolio data
#' @param bp_spreads B/P spreads
#' @return Portfolio characteristics table
create_table2_portfolio_characteristics <- function(beta_portfolios, bp_spreads) {
  if (nrow(beta_portfolios) == 0) {
    return(data.frame())
  }
  
  table2 <- beta_portfolios %>%
    group_by(portfolio) %>%
    summarise(
      beta_avg = mean(beta, na.rm = TRUE),
      mktcap_avg = mean(mktcap, na.rm = TRUE),
      bp_avg = mean(bp, na.rm = TRUE),
      n_stocks_avg = n() / n_distinct(date),
      .groups = "drop"
    )
  
  return(table2)
}

#' Create Table 3: CAPM Results
#'
#' @param capm_results CAPM regression results
#' @return CAPM results table
create_table3_capm_results <- function(capm_results) {
  if (nrow(capm_results) == 0) {
    return(data.frame())
  }
  
  table3 <- capm_results %>%
    select(portfolio, alpha_ew, alpha_t_ew, beta_ew, r2_ew,
           alpha_vw, alpha_t_vw, beta_vw, r2_vw) %>%
    mutate(
      alpha_ew = alpha_ew * 100,  # Convert to percentage
      alpha_vw = alpha_vw * 100
    )
  
  return(table3)
}

#' Create Table 4: Fama-French 4-Factor Results
#'
#' @param ff4_results FF4 regression results
#' @return FF4 results table
create_table4_ff4_results <- function(ff4_results) {
  if (nrow(ff4_results) == 0) {
    return(data.frame())
  }
  
  table4 <- ff4_results %>%
    select(portfolio, alpha_ew, alpha_t_ew, beta_mkt_ew, beta_smb_ew, 
           beta_hml_ew, beta_umd_ew, r2_ew,
           alpha_vw, alpha_t_vw, beta_mkt_vw, beta_smb_vw,
           beta_hml_vw, beta_umd_vw, r2_vw) %>%
    mutate(
      alpha_ew = alpha_ew * 100,  # Convert to percentage
      alpha_vw = alpha_vw * 100
    )
  
  return(table4)
}

#' Save all tables to output directory
#'
#' @param table1 Summary statistics
#' @param table2 Portfolio characteristics
#' @param table3 CAPM results
#' @param table4 FF4 results
#' @return File paths
save_all_tables <- function(table1, table2, table3, table4) {
  dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
  
  # Save as CSV
  write.csv(table1, "output/tables/table1_summary_stats.csv", row.names = FALSE)
  write.csv(table2, "output/tables/table2_portfolio_chars.csv", row.names = FALSE)
  write.csv(table3, "output/tables/table3_capm_results.csv", row.names = FALSE)
  write.csv(table4, "output/tables/table4_ff4_results.csv", row.names = FALSE)
  
  # Also save as LaTeX tables using xtable
  sink("output/tables/table1_latex.tex")
  print(xtable::xtable(table1, digits = 3), include.rownames = FALSE)
  sink()
  
  sink("output/tables/table2_latex.tex")
  print(xtable::xtable(table2, digits = 3), include.rownames = FALSE)
  sink()
  
  sink("output/tables/table3_latex.tex")
  print(xtable::xtable(table3, digits = 3), include.rownames = FALSE)
  sink()
  
  sink("output/tables/table4_latex.tex")
  print(xtable::xtable(table4, digits = 3), include.rownames = FALSE)
  sink()
  
  return(c(
    "output/tables/table1_summary_stats.csv",
    "output/tables/table2_portfolio_chars.csv",
    "output/tables/table3_capm_results.csv",
    "output/tables/table4_ff4_results.csv"
  ))
}
