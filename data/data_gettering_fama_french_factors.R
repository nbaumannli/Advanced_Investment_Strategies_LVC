# Data gathering script for Fama-French Factors dataset from tidy_finance SQLite database

# ------------------------------------------------------------------------------
# Required columns for Fama-French Factors (target CSV: ff_factors.csv)
# ------------------------------------------------------------------------------
# date   : Date (YYYY-MM-DD format)
# mkt_rf : Market excess return
# smb    : Small Minus Big factor
# hml    : High Minus Low factor
# umd    : Up Minus Down (momentum) factor
# rf     : Risk-free rate
# ------------------------------------------------------------------------------

# Ensure required DB packages are installed and loaded
# packages <- c("dplyr", "dbplyr", "DBI", "RSQLite", "readr")
# installed <- packages %in% rownames(installed.packages())
# if (any(!installed)) install.packages(packages[!installed])
# lapply(packages, library, character.only = TRUE)

# ------------------------------------------------------------------------------
# Fama-French Factors dataset (using 'factors_ff3_monthly' and 'factors_momentum_monthly' tables)
# ------------------------------------------------------------------------------

# Connect to the tidy_finance SQLite database
db_path <- "/home/shared/data/tidy_finance.sqlite"
con <- dbConnect(RSQLite::SQLite(), db_path, extended_types = TRUE)

# List all tables in the database
DBI::dbListTables(con)
# View column names for a specific table, e.g. "factors_ff3_monthly"
DBI::dbListFields(con, "factors_ff3_monthly")
DBI::dbListFields(con, "factors_momentum_monthly")
# Peek at the schema of the table / data format
DBI::dbGetQuery(con, "PRAGMA table_info(factors_ff3_monthly);")
DBI::dbGetQuery(con, "PRAGMA table_info(factors_momentum_monthly);")

# 1) Source data
ff3 <- tbl(con, "factors_ff3_monthly") %>%
  select(date, mkt_excess, smb, hml, rf)

mom <- tbl(con, "factors_momentum_monthly") %>%
  select(date, umd = mom)   # <- use 'mom' column as UMD

# 2) Join and transform
ff_factors <- ff3 %>%
  inner_join(mom, by = "date") %>%
  arrange(date) %>%
  collect() %>%
  mutate(
    # Robust date parsing: handle numeric offsets or ISO strings
    date = if (is.numeric(date)) as.Date(as.integer(date), origin = "1970-01-01") else as.Date(date),
    mkt_rf = as.numeric(mkt_excess),
    smb    = as.numeric(smb),
    hml    = as.numeric(hml),
    umd    = as.numeric(umd),
    rf     = as.numeric(rf)
  ) %>%
  select(date, mkt_rf, smb, hml, umd, rf)

# 3) Export to CSV
output_path <- "~/Advanced_Investment_Strategies_LVC/Advanced_Investment_Strategies_LVC/data/ff_factors.csv"
write_csv(ff_factors, output_path)
