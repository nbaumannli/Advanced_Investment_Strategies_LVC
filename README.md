# Advanced Investment Strategies: Low-Volatility Cycles

Replication of Garcia-Feijóo, Kochard, Sullivan & Wang (2015), "Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios" (Financial Analysts Journal, 1968–2012).

## Study Aims

This project replicates the key findings from Garcia-Feijóo et al. (2015) that demonstrate:

1. **Low-volatility anomaly**: Stocks with low beta historically outperform high-beta stocks on a risk-adjusted basis
2. **Value and momentum effects**: The performance of low-volatility strategies varies systematically with valuation spreads (B/P ratios) and momentum cycles
3. **Beta-neutral portfolios**: Construction and performance analysis of beta-neutral long-short portfolios
4. **Time-varying performance**: Analysis of periods when low-volatility strategies underperform and the role of valuation metrics in predicting these cycles

## Data Sources

- **CRSP**: Monthly stock returns and market data (1968-2012)
- **Compustat**: Book values and fundamentals
- **Fama-French factors**: Market, SMB, HML, and momentum factors for performance attribution

## Replication Steps

### 1. Setup Environment

```r
# Install renv for dependency management
install.packages("renv")
renv::restore()
```

### 2. Data Preparation

Run the scripts in order:

```r
source("R/01_data_ingest_crsp_compustat.R")
source("R/02_largecap_breakpoints.R")
```

**Key filters applied:**
- Share codes: 10 and 11 (ordinary common shares)
- Delisting returns: -55% for NASDAQ, -30% for NYSE/AMEX
- Price filter: $2 to $1,000
- Market cap: Top third by NYSE breakpoints (large-cap universe)

### 3. Beta Estimation

```r
source("R/03_beta_estimation.R")
```

- CAPM betas estimated from rolling 60-month windows
- Minimum 24 months of data required
- Includes month t in the estimation window

### 4. Portfolio Construction

```r
source("R/04_portfolios.R")
```

- Sort stocks into quintiles by beta
- Value-weighted returns in month t+1
- Zero-cost long-short: Long low-beta, short high-beta
- Beta-neutral: Long 100% low-beta, short 25% high-beta

### 5. Valuation Analysis

```r
source("R/05_bp_spread.R")
```

- Compute Book-to-Price (B/P) ratios
- Monthly B/P spread = Average B/P of low-beta portfolio - Average B/P of high-beta portfolio
- Form quintiles based on B/P spread

### 6. Performance Attribution

```r
source("R/06_factor_regs.R")
```

- Excess return regressions vs MKT (CAPM)
- Four-factor model: MKT, SMB, HML, MOM
- Newey-West standard errors for overlapping windows

### 7. Generate Output

```r
source("R/07_figures_tables.R")
```

Recreates:
- **Tables 1-3**: Portfolio characteristics, returns, and factor loadings
- **Figures 1-5**: Time-series plots of performance, spreads, and cycles

### 8. End-to-End Pipeline

Use the targets pipeline for reproducible execution:

```r
library(targets)
tar_make()
```

## Project Structure

```
.
├── R/
│   ├── 01_data_ingest_crsp_compustat.R
│   ├── 02_largecap_breakpoints.R
│   ├── 03_beta_estimation.R
│   ├── 04_portfolios.R
│   ├── 05_bp_spread.R
│   ├── 06_factor_regs.R
│   └── 07_figures_tables.R
├── data/
│   ├── raw/           # Raw CRSP/Compustat data
│   └── processed/     # Cleaned and merged datasets
├── output/
│   ├── figures/       # Replicated figures
│   └── tables/        # Replicated tables
├── tests/
│   └── testthat/      # Unit tests
├── _targets.R         # Targets pipeline
├── .Rproj             # RStudio project
├── renv.lock          # Package versions
└── README.md
```

## Testing

Run unit tests:

```r
library(testthat)
test_dir("tests/testthat")
```

Tests cover:
- Data filters (share codes, delisting returns, price ranges)
- Beta estimation (rolling windows, minimum observations)
- Portfolio weights (value-weighting, quintile sorting)

## CI/CD

GitHub Actions automatically runs R CMD check on push/PR. See `.github/workflows/R-CMD-check.yml`.

## References

Garcia-Feijóo, L., Kochard, L., Sullivan, R. N., & Wang, P. (2015). Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios. *Financial Analysts Journal*, 71(3), 47-60.

## License

MIT License - see LICENSE file for details.
