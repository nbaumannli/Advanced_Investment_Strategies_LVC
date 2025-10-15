# Quick Start Guide for Low-Volatility Cycles Project

## Getting Started in 5 Minutes

### Step 1: Open the Project
```r
# In RStudio: File -> Open Project -> Select Advanced_Investment_Strategies_LVC.Rproj
# Or from terminal:
cd Advanced_Investment_Strategies_LVC
R
```

### Step 2: Install and Restore Packages
```r
# Install renv if not already installed
if (!require("renv")) install.packages("renv")

# Restore all project dependencies
renv::restore()
```

### Step 3: Prepare Your Data
Place your data files in the `data/` directory:
- `crsp_monthly.csv` - CRSP monthly stock data
- `compustat_annual.csv` - Compustat annual fundamentals
- `market_returns.csv` - Market returns and risk-free rate
- `ff_factors.csv` - Fama-French factors

See `data/README.md` for detailed data requirements.

### Step 4: Run the Analysis

#### Option A: Run Everything with One Command
```r
source("run_analysis.R")
```

#### Option B: Use targets Workflow
```r
library(targets)

# Visualize the pipeline
tar_visnetwork()

# Run all steps
tar_make()

# Load specific results
tar_load(table3)
tar_load(capm_results)
```

#### Option C: Step-by-Step Execution
```r
# Load packages
library(tidyverse)
library(targets)

# Source all functions
tar_source()

# Run individual steps
crsp_raw <- load_crsp_data("data/crsp_monthly.csv")
crsp_clean <- clean_crsp_data(crsp_raw)
# ... continue with other steps
```

### Step 5: View Results
```r
# View tables
list.files("output/tables")
table3 <- read.csv("output/tables/table3_capm_results.csv")
print(table3)

# View figures
list.files("output/figures")
# Open PNG files in your preferred viewer
```

## Running Tests
```r
# Install testthat if needed
if (!require("testthat")) install.packages("testthat")

# Run all tests
source("tests/run_tests.R")

# Or run tests directory
library(testthat)
test_dir("tests/testthat")
```

## Common Issues and Solutions

### Issue 1: Missing Data Files
**Error:** "CRSP data file not found"
**Solution:** Place your data files in the `data/` directory. See `data/README.md` for format requirements.

### Issue 2: Package Installation Errors
**Error:** Package installation fails
**Solution:** 
```r
# Try installing packages manually
install.packages(c("tidyverse", "targets", "tarchetypes", "zoo", "broom", "xtable"))
```

### Issue 3: Memory Issues with Large Datasets
**Solution:** 
```r
# Increase memory limit (Windows)
memory.limit(size = 16000)

# Use data.table for faster processing
library(data.table)
```

### Issue 4: Date Format Issues
**Solution:** Ensure dates in your CSV files are in YYYY-MM-DD format:
```r
# Example fix for your data
data <- data %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))
```

## Customization

### Modify Analysis Parameters
Edit `config.yaml` to change:
- Number of portfolios
- Beta estimation window
- Sample period
- Exchange filters

### Add Custom Analysis
Create new R scripts in `R/` directory and add targets in `_targets.R`:
```r
tar_target(
  my_custom_analysis,
  my_custom_function(portfolio_returns),
  format = "rds"
)
```

## Output Description

### Tables
- `table1_summary_stats.csv`: Dataset summary statistics
- `table2_portfolio_chars.csv`: Portfolio characteristics by beta decile
- `table3_capm_results.csv`: CAPM regression results with alphas
- `table4_ff4_results.csv`: Fama-French 4-factor model results

### Figures
- `figure1_bp_spreads.png`: B/P ratios over time for low vs high beta
- `figure2_returns_over_time.png`: Cumulative returns comparison
- `figure3_alpha_comparison.png`: Alpha comparison across models

## Next Steps

1. Review the methodology in the main `README.md`
2. Examine the paper: Garcia-Feijóo et al. (2015)
3. Customize the analysis for your research
4. Contribute improvements via Pull Requests

## Support

For issues or questions:
1. Check `README.md` for detailed documentation
2. Review function documentation in R/ scripts
3. Open an issue on GitHub
4. Contact the maintainer

Happy analyzing! 📊
