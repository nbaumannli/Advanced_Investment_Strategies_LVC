#' Create Figure 1: Book-to-Price Spreads Over Time
#'
#' @param bp_spreads B/P spreads data
#' @return File path to saved figure
create_figure1_bp_spreads <- function(bp_spreads) {
  if (nrow(bp_spreads) == 0) {
    return(NULL)
  }
  
  dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
  
  p <- ggplot(bp_spreads %>% filter(portfolio %in% c(1, 10)), 
              aes(x = date, y = bp_vw, color = as.factor(portfolio))) +
    geom_line(linewidth = 1) +
    labs(
      title = "Book-to-Price Ratios: Low vs High Beta Portfolios",
      x = "Date",
      y = "Book-to-Price (Value-Weighted)",
      color = "Portfolio"
    ) +
    scale_color_manual(
      values = c("1" = "blue", "10" = "red"),
      labels = c("1" = "Low Beta (P1)", "10" = "High Beta (P10)")
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5, face = "bold")
    )
  
  filepath <- "output/figures/figure1_bp_spreads.png"
  ggsave(filepath, p, width = 10, height = 6, dpi = 300)
  
  return(filepath)
}

#' Create Figure 2: Portfolio Returns Over Time
#'
#' @param portfolio_returns Portfolio returns data
#' @return File path to saved figure
create_figure2_returns_over_time <- function(portfolio_returns) {
  if (nrow(portfolio_returns) == 0) {
    return(NULL)
  }
  
  dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
  
  # Calculate cumulative returns for selected portfolios
  cum_returns <- portfolio_returns %>%
    filter(portfolio %in% c(1, 10)) %>%
    group_by(portfolio) %>%
    arrange(date) %>%
    mutate(
      cum_ret_ew = cumprod(1 + ret_ew) - 1,
      cum_ret_vw = cumprod(1 + ret_vw) - 1
    ) %>%
    ungroup()
  
  p <- ggplot(cum_returns, aes(x = date, y = cum_ret_vw * 100, 
                                color = as.factor(portfolio))) +
    geom_line(linewidth = 1) +
    labs(
      title = "Cumulative Returns: Low vs High Beta Portfolios",
      x = "Date",
      y = "Cumulative Return (%)",
      color = "Portfolio"
    ) +
    scale_color_manual(
      values = c("1" = "blue", "10" = "red"),
      labels = c("1" = "Low Beta (P1)", "10" = "High Beta (P10)")
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5, face = "bold")
    )
  
  filepath <- "output/figures/figure2_returns_over_time.png"
  ggsave(filepath, p, width = 10, height = 6, dpi = 300)
  
  return(filepath)
}

#' Create Figure 3: Alpha Comparison (CAPM vs FF4)
#'
#' @param capm_results CAPM results
#' @param ff4_results FF4 results
#' @return File path to saved figure
create_figure3_alpha_comparison <- function(capm_results, ff4_results) {
  if (nrow(capm_results) == 0 || nrow(ff4_results) == 0) {
    return(NULL)
  }
  
  dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
  
  # Combine alphas
  alpha_data <- capm_results %>%
    select(portfolio, capm_alpha = alpha_vw) %>%
    left_join(
      ff4_results %>% select(portfolio, ff4_alpha = alpha_vw),
      by = "portfolio"
    ) %>%
    filter(portfolio != 0) %>%  # Exclude long-short
    pivot_longer(
      cols = c(capm_alpha, ff4_alpha),
      names_to = "model",
      values_to = "alpha"
    ) %>%
    mutate(
      model = recode(model,
                     "capm_alpha" = "CAPM",
                     "ff4_alpha" = "Fama-French 4-Factor")
    )
  
  p <- ggplot(alpha_data, aes(x = portfolio, y = alpha, fill = model)) +
    geom_bar(stat = "identity", position = "dodge") +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
    labs(
      title = "Portfolio Alphas: CAPM vs Fama-French 4-Factor",
      x = "Beta Portfolio (1=Low, 10=High)",
      y = "Alpha (% per month)",
      fill = "Model"
    ) +
    scale_fill_manual(values = c("CAPM" = "#4575b4", "Fama-French 4-Factor" = "#d73027")) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5, face = "bold")
    )
  
  filepath <- "output/figures/figure3_alpha_comparison.png"
  ggsave(filepath, p, width = 10, height = 6, dpi = 300)
  
  return(filepath)
}
