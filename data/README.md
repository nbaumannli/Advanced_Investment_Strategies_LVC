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

## Data Access

### CRSP and Compustat
Access via WRDS (Wharton Research Data Services):
1. Institutional subscription required
2. Navigate to WRDS website: https://wrds-www.wharton.upenn.edu/
3. Query the data using the web interface or SAS/R packages

### Fama-French Factors
Free access from Kenneth French's website:
1. Download from: http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html
2. Select "Fama/French 3 Factors" and "Momentum Factor (Mom)"
3. Convert to CSV format with appropriate column names

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
