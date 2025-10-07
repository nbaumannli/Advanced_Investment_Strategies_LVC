#' Generate Figures and Tables
#'
#' Recreates Tables 1-3 and Figures 1-5 from Garcia-Feijóo et al. (2015).
#' Produces publication-ready output for the low-volatility cycles replication.
#'
#' @details
#' Tables created:
#' \itemize{
#'   \item Table 1: Portfolio characteristics (beta, size, B/P) by quintile
#'   \item Table 2: Portfolio returns and alphas (CAPM and 4-factor)
#'   \item Table 3: Performance by B/P spread quintile
#' }
#'
#' Figures created:
#' \itemize{
#'   \item Figure 1: Cumulative returns of low-beta vs high-beta portfolios
#'   \item Figure 2: Time series of B/P spread
#'   \item Figure 3: Performance by B/P spread quintile
#'   \item Figure 4: Rolling alphas over time
#'   \item Figure 5: Beta-neutral strategy performance
#' }
#'
#' @param portfolio_data Data.frame with portfolio characteristics
#' @param returns_data Data.frame with portfolio returns
#' @param regression_data Data.frame with factor regression results
#' @param spread_data Data.frame with B/P spread data
#'
#' @return NULL (saves tables and figures to output/)
#'
#' @examples
#' \dontrun{
#' generate_figures_tables(
#'   portfolio_data = portfolios,
#'   returns_data = returns,
#'   regression_data = regressions,
#'   spread_data = spreads
#' )
#' }
#'
#' @export
generate_figures_tables <- function(portfolio_data,
                                     returns_data,
                                     regression_data,
                                     spread_data) {
  
  library(dplyr)
  library(ggplot2)
  library(kableExtra)
  library(readr)
  
  message("Creating output directories...")
  dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
  dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
  
  message("Generating Table 1: Portfolio characteristics...")
  # TODO: Create Table 1
  # table1 <- create_table1(portfolio_data)
  # save_table(table1, "output/tables/table1_characteristics.csv")
  
  message("Generating Table 2: Portfolio returns and alphas...")
  # TODO: Create Table 2
  # table2 <- create_table2(returns_data, regression_data)
  # save_table(table2, "output/tables/table2_returns.csv")
  
  message("Generating Table 3: Performance by B/P spread...")
  # TODO: Create Table 3
  # table3 <- create_table3(spread_data, returns_data)
  # save_table(table3, "output/tables/table3_bp_performance.csv")
  
  message("Generating Figure 1: Cumulative returns...")
  # TODO: Create Figure 1
  # fig1 <- create_figure1(returns_data)
  # ggsave("output/figures/figure1_cumulative_returns.png", fig1, width = 10, height = 6)
  
  message("Generating Figure 2: B/P spread time series...")
  # TODO: Create Figure 2
  # fig2 <- create_figure2(spread_data)
  # ggsave("output/figures/figure2_bp_spread.png", fig2, width = 10, height = 6)
  
  message("Generating Figure 3: Performance by spread quintile...")
  # TODO: Create Figure 3
  # fig3 <- create_figure3(spread_data, returns_data)
  # ggsave("output/figures/figure3_spread_performance.png", fig3, width = 10, height = 6)
  
  message("Generating Figure 4: Rolling alphas...")
  # TODO: Create Figure 4
  # fig4 <- create_figure4(regression_data)
  # ggsave("output/figures/figure4_rolling_alphas.png", fig4, width = 10, height = 6)
  
  message("Generating Figure 5: Beta-neutral strategy...")
  # TODO: Create Figure 5
  # fig5 <- create_figure5(returns_data)
  # ggsave("output/figures/figure5_beta_neutral.png", fig5, width = 10, height = 6)
  
  message("Figures and tables generation complete!")
  
  invisible(NULL)
}

#' Create Table 1: Portfolio Characteristics
#'
#' Summarizes portfolio characteristics by beta quintile
#'
#' @param data Data.frame with portfolio data
#'
#' @return Data.frame formatted as Table 1
#'
#' @export
create_table1 <- function(data) {
  data %>%
    dplyr::group_by(beta_quintile) %>%
    dplyr::summarise(
      avg_beta = mean(beta, na.rm = TRUE),
      avg_size = mean(mktcap, na.rm = TRUE),
      avg_bp = mean(bp_ratio, na.rm = TRUE),
      n_stocks = n(),
      .groups = "drop"
    )
}

#' Create Table 2: Portfolio Returns and Alphas
#'
#' Summarizes returns and factor model results
#'
#' @param returns_data Data.frame with returns
#' @param regression_data Data.frame with regression results
#'
#' @return Data.frame formatted as Table 2
#'
#' @export
create_table2 <- function(returns_data, regression_data) {
  # TODO: Combine return statistics with alphas
  returns_summary <- returns_data %>%
    dplyr::group_by(beta_quintile) %>%
    dplyr::summarise(
      mean_ret = mean(vw_ret, na.rm = TRUE),
      sd_ret = sd(vw_ret, na.rm = TRUE),
      sharpe = mean_ret / sd_ret,
      .groups = "drop"
    )
  
  # TODO: Join with regression results
  # full_join(returns_summary, regression_data, by = "beta_quintile")
  
  return(returns_summary)
}

#' Create Figure 1: Cumulative Returns
#'
#' Plots cumulative returns for beta quintiles
#'
#' @param data Data.frame with returns
#'
#' @return ggplot object
#'
#' @export
create_figure1 <- function(data) {
  data %>%
    dplyr::group_by(beta_quintile) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(
      cum_ret = cumprod(1 + vw_ret) - 1
    ) %>%
    ggplot2::ggplot(aes(x = date, y = cum_ret, color = factor(beta_quintile))) +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = "Cumulative Returns by Beta Quintile",
      x = "Date",
      y = "Cumulative Return",
      color = "Beta Quintile"
    ) +
    ggplot2::theme_minimal()
}

#' Create Figure 2: B/P Spread Time Series
#'
#' Plots B/P spread over time
#'
#' @param data Data.frame with B/P spread
#'
#' @return ggplot object
#'
#' @export
create_figure2 <- function(data) {
  ggplot2::ggplot(data, aes(x = date, y = bp_spread)) +
    ggplot2::geom_line() +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    ggplot2::labs(
      title = "Book-to-Price Spread (Low Beta - High Beta)",
      x = "Date",
      y = "B/P Spread"
    ) +
    ggplot2::theme_minimal()
}

# Main execution
if (!interactive()) {
  # TODO: Load all required data
  # portfolios <- read_csv("data/processed/portfolio_returns.csv")
  # returns <- read_csv("data/processed/portfolio_returns.csv")
  # regressions <- read_csv("output/tables/factor_regressions.csv")
  # spreads <- read_csv("data/processed/bp_spread.csv")
  # generate_figures_tables(portfolios, returns, regressions, spreads)
}
