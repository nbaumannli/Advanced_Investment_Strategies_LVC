# Advanced Investment Strategies: Low-Volatility Cycles

This project replicates the empirical analysis from **"Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios"** by Garcia-Feijóo et al. (2015).

> 📚 **New to this project?** Check out [QUICKSTART.md](QUICKSTART.md) for a 5-minute getting started guide, or see [DOCS.md](DOCS.md) for the complete documentation index.

## Overview

The paper examines how valuation (Book-to-Price ratios) and momentum affect low-volatility portfolio returns. This implementation:

- Cleans CRSP and Compustat data
- Forms NYSE large-cap beta-sorted portfolios
- Computes Book-to-Price (B/P) spreads across beta portfolios
- Runs CAPM and Fama-French 4-factor regressions
- Recreates key tables and figures from the paper

## Project Structure

```
Advanced_Investment_Strategies_LVC/
├── R/                          # R scripts with functions
│   ├── load_data.R            # Data loading functions
│   ├── clean_data.R           # Data cleaning and merging
│   ├── calculate_betas.R      # Beta calculation and portfolio formation
│   ├── portfolio_analysis.R   # Portfolio returns and B/P spreads
│   ├── regressions.R          # CAPM and FF4 regressions
│   ├── create_tables.R        # Table generation
│   └── create_figures.R       # Figure generation
├── data/                       # Input data (not included)
│   ├── crsp_monthly.csv       # CRSP monthly stock data
│   ├── compustat_annual.csv   # Compustat annual data
│   ├── market_returns.csv     # Market returns
│   └── ff_factors.csv         # Fama-French factors
├── output/                     # Generated outputs
│   ├── tables/                # CSV and LaTeX tables
│   └── figures/               # PNG figures
├── tests/                      # Unit tests
├── _targets.R                 # Targets workflow pipeline
├── renv.lock                  # R package dependencies
├── Advanced_Investment_Strategies_LVC.Rproj  # RStudio project
├── LICENSE                     # MIT License
└── README.md                  # This file
```

## Setup

### Prerequisites

- R (≥ 4.3.0)
- RStudio (recommended)
- Access to CRSP and Compustat databases

### Installation

1. Clone the repository:
```bash
git clone https://github.com/nbaumannli/Advanced_Investment_Strategies_LVC.git
cd Advanced_Investment_Strategies_LVC
```

2. Install renv and restore packages:
```r
install.packages("renv")
renv::restore()
```

### Data Preparation

Place your data files in the `data/` directory:

1. **CRSP Monthly Data** (`crsp_monthly.csv`):
   - Required columns: `permno`, `date`, `ret`, `prc`, `shrout`, `shrcd`, `exchcd`
   
2. **Compustat Annual Data** (`compustat_annual.csv`):
   - Required columns: `permno`, `datadate`, `at`, `ceq`, `pstkrv`, `pstkl`, `pstk`, `txditc`
   
3. **Market Returns** (`market_returns.csv`):
   - Required columns: `date`, `ret`, `rf`
   
4. **Fama-French Factors** (`ff_factors.csv`):
   - Required columns: `date`, `mkt_rf`, `smb`, `hml`, `umd`, `rf`

## Running the Analysis

### Using targets

The entire pipeline is managed by `targets`. To run the full analysis:

```r
library(targets)

# Visualize the pipeline
tar_visnetwork()

# Run the entire pipeline
tar_make()

# Load specific results
tar_load(table3)
tar_load(figure1)
```

### Manual Execution

Alternatively, source individual functions:

```r
source("R/load_data.R")
source("R/clean_data.R")
# ... etc

# Run analysis step by step
crsp_data <- load_crsp_data("data/crsp_monthly.csv")
crsp_clean <- clean_crsp_data(crsp_data)
# ... etc
```

## Methodology

### Portfolio Formation

1. **Beta Calculation**: 60-month rolling window regressions against market returns
2. **NYSE Breakpoints**: Use NYSE large-cap stocks (top 50% by market cap) to set decile breakpoints
3. **Portfolio Assignment**: Assign all stocks to decile portfolios based on beta
4. **Rebalancing**: Monthly rebalancing

### Analysis

1. **Book-to-Price Spreads**: Calculate value-weighted B/P ratios for each portfolio
2. **CAPM Regressions**: Run time-series regressions of excess returns on market excess returns
3. **FF4 Regressions**: Run regressions on Mkt-RF, SMB, HML, and UMD factors

## Output

### Tables

- **Table 1**: Summary statistics of the merged dataset
- **Table 2**: Portfolio characteristics (beta, market cap, B/P ratio)
- **Table 3**: CAPM regression results (alphas, betas, t-stats)
- **Table 4**: Fama-French 4-factor regression results

### Figures

- **Figure 1**: Book-to-Price spreads over time (Low vs High beta)
- **Figure 2**: Cumulative returns over time
- **Figure 3**: Alpha comparison (CAPM vs FF4)

All outputs are saved in `output/tables/` and `output/figures/`.

## Testing

Run tests using:

```r
library(testthat)
test_dir("tests/testthat")
```

## Dependencies

Key packages (managed by renv):

- `targets`: Workflow management
- `tidyverse`: Data manipulation and visualization
- `lubridate`: Date handling
- `zoo`: Rolling calculations
- `data.table`: Fast data operations
- `broom`: Tidy regression output
- `ggplot2`: Visualizations
- `xtable`: LaTeX tables

## Citation

Garcia-Feijóo, L., Kochard, L., Sullivan, R. N., & Wang, P. (2015). Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios. *Financial Analysts Journal*, 71(3), 47-60.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Contact

For questions or issues, please open an issue on GitHub.

## Testing Without Real Data

If you don't have access to CRSP/Compustat data, you can generate simulated data for testing:

```r
source("generate_test_data.R")
```

This will create sample CSV files in the `data/` directory that match the expected format. You can then run the full analysis pipeline with this simulated data to test the code and understand the workflow.

> ⚠️ **Note:** Simulated data is for testing purposes only and will not produce meaningful research results.
