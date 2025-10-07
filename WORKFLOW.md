# Project Workflow Diagram

This document describes the complete analysis workflow of the Low-Volatility Cycles replication project.

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         INPUT DATA                               │
│                                                                   │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐  ┌────────┐│
│  │ CRSP Monthly│  │  Compustat   │  │   Market    │  │   FF   ││
│  │    Data     │  │    Annual    │  │   Returns   │  │ Factors││
│  └─────────────┘  └──────────────┘  └─────────────┘  └────────┘│
└─────────────────────────────────────────────────────────────────┘
           │                 │                │              │
           │                 │                │              │
           ▼                 ▼                ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA CLEANING                               │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  • Filter common stocks (shrcd 10, 11)                  │    │
│  │  • Filter exchanges (NYSE, AMEX, NASDAQ)                │    │
│  │  • Remove missing/invalid data                          │    │
│  │  • Calculate market capitalization                      │    │
│  │  • Calculate book equity (Fama-French method)           │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DATA MERGING                                  │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  • Merge CRSP & Compustat on permno                     │    │
│  │  • Align fiscal year with calendar year                 │    │
│  │  • Calculate Book-to-Market (B/M) ratios                │    │
│  │  • Calculate Book-to-Price (B/P) ratios                 │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BETA CALCULATION                              │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  • 60-month rolling window regressions                  │    │
│  │  • Stock returns ~ Market returns                       │    │
│  │  • Minimum 24 months required                           │    │
│  │  • Calculate beta for each stock-month                  │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 PORTFOLIO FORMATION                              │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  • Use NYSE large-cap stocks for breakpoints            │    │
│  │  • Sort into 10 decile portfolios by beta               │    │
│  │  • Portfolio 1 = Lowest beta (low volatility)           │    │
│  │  • Portfolio 10 = Highest beta (high volatility)        │    │
│  │  • Monthly rebalancing                                  │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              PORTFOLIO ANALYSIS                                  │
│                                                                   │
│  ┌──────────────────┐         ┌───────────────────────────┐     │
│  │ Portfolio Returns│         │   B/P Spreads             │     │
│  │                  │         │                           │     │
│  │ • Equal-weighted │         │ • Value-weighted B/P      │     │
│  │ • Value-weighted │         │ • By portfolio & date     │     │
│  │ • Long-short     │         │ • High-Low spread         │     │
│  └──────────────────┘         └───────────────────────────┘     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                  REGRESSION ANALYSIS                             │
│                                                                   │
│  ┌────────────────┐              ┌──────────────────────────┐   │
│  │  CAPM Model    │              │  Fama-French 4-Factor    │   │
│  │                │              │                          │   │
│  │  Rₚ - Rբ =     │              │  Rₚ - Rբ =               │   │
│  │  α + β(Rₘ-Rբ)  │              │  α + β₁(Rₘ-Rբ) +         │   │
│  │                │              │      β₂SMB +             │   │
│  │                │              │      β₃HML +             │   │
│  │                │              │      β₄UMD               │   │
│  └────────────────┘              └──────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      RESULTS OUTPUT                              │
│                                                                   │
│  ┌──────────────────┐              ┌──────────────────────┐     │
│  │     TABLES       │              │      FIGURES         │     │
│  │                  │              │                      │     │
│  │ • Table 1:       │              │ • Figure 1:          │     │
│  │   Summary Stats  │              │   B/P Spreads        │     │
│  │                  │              │                      │     │
│  │ • Table 2:       │              │ • Figure 2:          │     │
│  │   Portfolio      │              │   Cumulative Returns │     │
│  │   Characteristics│              │                      │     │
│  │                  │              │ • Figure 3:          │     │
│  │ • Table 3:       │              │   Alpha Comparison   │     │
│  │   CAPM Results   │              │                      │     │
│  │                  │              │                      │     │
│  │ • Table 4:       │              │                      │     │
│  │   FF4 Results    │              │                      │     │
│  └──────────────────┘              └──────────────────────┘     │
│                                                                   │
│  Output formats: CSV, LaTeX, PNG                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Function Dependencies

```
load_data.R
    ├── load_crsp_data()
    ├── load_compustat_data()
    ├── load_market_returns()
    └── load_ff_factors()
            │
            ▼
clean_data.R
    ├── clean_crsp_data()
    ├── clean_compustat_data()
    └── merge_crsp_compustat()
            │
            ▼
calculate_betas.R
    ├── calculate_rolling_betas()
    ├── calculate_nyse_breakpoints()
    └── form_beta_portfolios()
            │
            ▼
portfolio_analysis.R
    ├── calculate_bp_spreads()
    └── calculate_portfolio_returns()
            │
            ▼
regressions.R
    ├── run_capm_regressions()
    └── run_ff4_regressions()
            │
            ▼
create_tables.R                      create_figures.R
    ├── create_table1_summary_stats()    ├── create_figure1_bp_spreads()
    ├── create_table2_portfolio_chars()  ├── create_figure2_returns_over_time()
    ├── create_table3_capm_results()     ├── create_figure3_alpha_comparison()
    ├── create_table4_ff4_results()      │
    └── save_all_tables()                │
            │                            │
            └────────────────────────────┘
                        │
                        ▼
                   OUTPUT FILES
```

## Targets Pipeline DAG

The `targets` package manages dependencies automatically:

```
crsp_raw ──┐
           ├─→ crsp_clean ──┐
compustat  │                ├─→ merged_data ──┐
_raw ──────┘                │                 │
                            │                 ├─→ stock_betas ──┐
market_returns ─────────────┘                 │                 │
                                              │                 ├─→ nyse_breakpoints
                                              │                 │            │
                                              │                 │            ▼
                                              │                 └──→ beta_portfolios
                                              │                              │
                                              │                              ├─→ bp_spreads ──→ figure1
                                              │                              │
                                              │                              ├─→ portfolio_returns
                                              │                              │         │
                                              └──────────────────────────────┘         │
                                                                                       │
ff_factors ────────────────────────────────────────────────────────────────────────┐  │
                                                                                    │  │
market_returns (again) ─────────────────────────────────────────────────────────┐  │  │
                                                                                 │  │  │
                                                                                 ▼  ▼  ▼
                                                                           ┌─────────────────┐
                                                                           │  REGRESSIONS    │
                                                                           │                 │
                                                                           │  capm_results   │
                                                                           │  ff4_results    │
                                                                           └─────────────────┘
                                                                                    │
                                    ┌───────────────────────────────────────────────┼────────┐
                                    │                                               │        │
                                    ▼                                               ▼        ▼
                              ┌──────────┐                                    ┌─────────────────┐
                              │  TABLES  │                                    │    FIGURES      │
                              │          │                                    │                 │
                              │  table1  │                                    │    figure2      │
                              │  table2  │                                    │    figure3      │
                              │  table3  │                                    │                 │
                              │  table4  │                                    └─────────────────┘
                              └──────────┘
                                    │
                                    ▼
                            ┌──────────────┐
                            │  save_tables │
                            └──────────────┘
```

## Execution Flow

### Option 1: Using Targets (Recommended)
```r
library(targets)
tar_make()  # Runs entire pipeline, only recomputes changed targets
```

### Option 2: Using run_analysis.R
```r
source("run_analysis.R")  # Initializes renv and runs targets
```

### Option 3: Using Makefile
```bash
make all  # Installs packages, runs analysis, runs tests
```

### Option 4: Step by Step
```r
# Source functions
tar_source()

# Run individual steps manually
crsp_raw <- load_crsp_data("data/crsp_monthly.csv")
crsp_clean <- clean_crsp_data(crsp_raw)
# ... continue with other steps
```

## Key Design Principles

1. **Modularity**: Each R script handles one aspect (loading, cleaning, analysis)
2. **Reproducibility**: Using `renv` for packages, `targets` for workflow
3. **Testability**: Unit tests for each major function
4. **Documentation**: Roxygen comments, comprehensive README files
5. **Flexibility**: Configuration via `config.yaml`, easy to modify

## Performance Considerations

- **Data Size**: With full CRSP/Compustat (millions of rows), expect:
  - Data loading: 1-5 minutes
  - Beta calculation: 10-30 minutes (rolling window regressions)
  - Portfolio formation: 1-5 minutes
  - Regressions: < 1 minute
  - Total: ~30-60 minutes for full sample

- **Optimization Tips**:
  - Use `data.table` for large datasets
  - Parallelize beta calculations if needed
  - Cache intermediate results with `targets`
  - Use value-weighted portfolios to reduce computation

## Error Handling

Each function includes:
- Input validation (empty data frames return empty results)
- Graceful handling of missing files
- Informative warning messages
- Type checking and conversion

## Testing Strategy

1. **Unit Tests**: Individual functions with small datasets
2. **Integration Tests**: Full pipeline with simulated data
3. **Validation Tests**: Compare output to known results
4. **Continuous Integration**: GitHub Actions runs tests on push
