# Data gathering script for Market Returns dataset from tidy_finance SQLite database

# ------------------------------------------------------------------------------
# Required columns for Market Returns (target CSV: market_returns.csv)
# ------------------------------------------------------------------------------
# date : Date (YYYY-MM-DD format)
# ret  : Market return
# rf   : Risk-free rate
# Source: CRSP or Kenneth French Data Library
# ------------------------------------------------------------------------------

# Ensure required DB packages are installed and loaded
# packages <- c("dplyr", "dbplyr", "DBI", "RSQLite", "readr")
# installed <- packages %in% rownames(installed.packages())
# if (any(!installed)) install.packages(packages[!installed])
# lapply(packages, library, character.only = TRUE)

# ------------------------------------------------------------------------------
# Market Returns dataset (using 'factors_ff3_monthly' table)
# ------------------------------------------------------------------------------

# Connect to the tidy_finance SQLite database
db_path <- "/home/shared/data/tidy_finance.sqlite"
con <- dbConnect(RSQLite::SQLite(), db_path, extended_types = TRUE)

# List all tables in the database
DBI::dbListTables(con)
# View column names for a specific table, e.g. "factors_ff3_monthly"
DBI::dbListFields(con, "factors_ff3_monthly")
# Peek at the schema of the table / data format
DBI::dbGetQuery(con, "PRAGMA table_info(factors_ff3_monthly);")


# 1) Source data from Fama-French 3-Factor monthly table
# Table fields: date, mkt_excess, smb, hml, rf

ff3 <- tbl(con, "factors_ff3_monthly")

market_returns <- ff3 %>%
  transmute(
    # keep raw fields; don't convert to Date inside SQL
    date        = date,
    mkt_excess  = mkt_excess,
    rf          = rf
  ) %>%
  arrange(date) %>%
  collect() %>%
  mutate(
    # convert integer day offsets to Date
    date = as.Date(date, origin = "1970-01-01"),
    # your table already uses decimals (e.g., 0.0296). Keep as-is:
    ret  = as.numeric(mkt_excess),
    rf   = as.numeric(rf)
  ) %>%
  select(date, ret, rf)


# 3) Export to CSV
output_path <- "~/Advanced_Investment_Strategies_LVC/Advanced_Investment_Strategies_LVC/data/market_returns.csv"
write_csv(market_returns, output_path)
