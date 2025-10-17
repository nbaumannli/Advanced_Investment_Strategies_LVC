# Data Directory

This directory should contain the input data files required for the analysis.

## Required Data Files

### 1. CRSP Monthly Stock Data (`crsp_monthly.csv`)

**Required columns:**
- `permno`: Permanent security identifier
- `date`: Date (YYYY-MM-DD format)
- `ret`: Monthly return
- `prc`: Price (can be negative to indicate average of bid/ask)
- `shrout`: Shares outstanding (in thousands)
- `shrcd`: Share code (10 and 11 for common stocks)
- `exchcd`: Exchange code (1=NYSE, 2=AMEX, 3=NASDAQ)

**Source:** CRSP (Center for Research in Security Prices)

### 2. Compustat Annual Data (`compustat_annual.csv`)

**Required columns:**
- `permno`: Permanent security identifier (linked via CCM)
- `datadate`: Fiscal year end date
- `at`: Total assets
- `ceq`: Common/Ordinary equity
- `pstkrv`: Preferred stock - redemption value
- `pstkl`: Preferred stock - liquidating value
- `pstk`: Preferred stock - par value
- `txditc`: Deferred taxes and investment tax credit

**Source:** Compustat via WRDS

### 3. Market Returns (`market_returns.csv`)

**Required columns:**
- `date`: Date (YYYY-MM-DD format)
- `ret`: Market return
- `rf`: Risk-free rate

**Source:** CRSP or Kenneth French Data Library

### 4. Fama-French Factors (`ff_factors.csv`)

**Required columns:**
- `date`: Date (YYYY-MM-DD format)
- `mkt_rf`: Market excess return
- `smb`: Small Minus Big factor
- `hml`: High Minus Low factor
- `umd`: Up Minus Down (momentum) factor
- `rf`: Risk-free rate

**Source:** Kenneth French Data Library
- URL: http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html

Here’s your **README.md “Data Access”** section rewritten with that addition, integrated naturally and clearly into the existing flow:

---

## Data Access

### CRSP and Compustat (via tidy_finance SQLite Database)

The **CRSP** and **Compustat** datasets used in this project are accessed from a **local SQLite database** built from WRDS data and distributed as `/home/shared/data/tidy_finance.sqlite`.

To query or extract these datasets:

1. Ensure the database file `tidy_finance.sqlite` is available in the directory.
2. Run the provided R scripts located in the `data/` folder to generate the cleaned CSV files:
   
   * `data_gettering_overview_database_tidy_finance_SQL.R` → lists all tables and structures in the SQLite database
   * `data_gettering_compustat_annual data` → exports **compustat_annual.csv**
   * `data_gettering_CRSP_monthly.R` → exports **crsp_monthly.csv**

### Fama-French Factors and Market Returns

The **Fama-French 3-Factor** and **Momentum (UMD)** datasets are also stored in the same SQLite database (`tidy_finance.sqlite`), pre-downloaded from the **Kenneth R. French Data Library**.

* Factors are contained in:

  * `factors_ff3_monthly` — with columns `date`, `mkt_excess`, `smb`, `hml`, and `rf`
  * `factors_momentum_monthly` — with columns `date` and `mom` (momentum factor)

The following R scripts can be run from the `data/` folder to extract and prepare these datasets:
 * `data_gettering_market_returns.R`  → generates **market_returns.csv** (fields: `date`, `ret`, `rf`)
 * `data_gettering_fama_french_factors.R` → generates **ff_factors.csv** (fields: `date`, `mkt_rf`, `smb`, `hml`, `umd`, `rf`)


All scripts handle:

* Conversion of numeric date formats (`as.Date(date, origin = "1970-01-01")`)
* Data validation and type casting
* Export to the shared `/data` folder
* Each script connects to the database using `RSQLite` and `dbplyr`, performs column selection, type conversion, and exports a ready-to-use CSV file

---

### Original Source References

For transparency and reproducibility, the underlying datasets originate from:

* **WRDS (Wharton Research Data Services)**
  Access via institutional login:
  [https://wrds-www.wharton.upenn.edu/](https://wrds-www.wharton.upenn.edu/)

* **Kenneth R. French Data Library**
  Free and public access:
  [http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html)

---


## Sample Data Format

Example `crsp_monthly.csv`:
```csv
permno,date,ret,prc,shrout,shrcd,exchcd
10001,2000-01-31,0.0523,45.25,12000,10,1
10001,2000-02-29,-0.0123,44.70,12000,10,1
...
```

Example `ff_factors.csv`:
```csv
date,mkt_rf,smb,hml,umd,rf
2000-01-31,0.0234,0.0045,-0.0012,0.0067,0.0042
2000-02-29,-0.0156,0.0023,0.0089,-0.0034,0.0041
...
```

## Notes

- All data files should be in CSV format
- Date columns should be in YYYY-MM-DD format
- Returns should be in decimal format (e.g., 0.05 for 5%)
- Missing values should be represented as empty cells or NA
- Files are not included in the repository due to licensing restrictions

