# Data gathering script for Compustat Annual dataset from tidy_finance SQLite database

# ------------------------------------------------------------------------------
# Required columns for Compustat Annual (target CSV: compustat_annual.csv)
# ------------------------------------------------------------------------------
# permno  : Permanent security identifier (linked via CCM)
# datadate: Fiscal year end date (YYYY-MM-DD)
# at      : Total assets
# ceq     : Common/Ordinary equity
# pstkrv  : Preferred stock - redemption value
# pstkl   : Preferred stock - liquidating value
# pstk    : Preferred stock - par value
# txditc  : Deferred taxes and investment tax credit
# ------------------------------------------------------------------------------

# Ensure required DB packages are installed and loaded
packages <- c("dplyr", "dbplyr", "DBI", "RSQLite", "readr")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) install.packages(packages[!installed])
lapply(packages, library, character.only = TRUE)


# ------------------------------------------------------------------------------
# Compustat Annual dataset (shortcut version using 'compustat' and & "ccmxpf_linktable" table)
# ------------------------------------------------------------------------------


db_path <- "/home/shared/data/tidy_finance.sqlite"
con <- dbConnect(RSQLite::SQLite(), db_path, extended_types = TRUE)

# List all tables in the database
DBI::dbListTables(con)
# View column names for a specific table, e.g. "compustat"
DBI::dbListFields(con, "compustat")
DBI::dbListFields(con, "ccmxpf_linktable")
# Peek at the schema of the table / data format
DBI::dbGetQuery(con, "PRAGMA table_info(compustat);")
DBI::dbGetQuery(con, "PRAGMA table_info(ccmxpf_linktable);")



# 1) Source data directly from 'compustat'
comp <- tbl(con, "compustat") %>%
  select(gvkey, datadate, at, ceq, pstkrv, pstkl, pstk, txditc)

# 2) Link to CRSP via CCM
ccm <- tbl(con, "ccmxpf_linktable") %>%
  transmute(
    gvkey,
    permno = lpermno,
    linkdt,
    linkenddt,
    linktype,
    linkprim
  ) %>%
  filter(
    !is.na(permno),
    linktype %in% c("LC","LU","LS","LX"),
    linkprim %in% c("P","C")
  ) %>%
  mutate(linkenddt = coalesce(linkenddt, as.Date("9999-12-31")))

# 3) Join & filter for valid link dates
compustat_linked <- comp %>%
  inner_join(ccm, by = "gvkey") %>%
  filter(datadate >= linkdt, datadate <= linkenddt)

# 4) Final dataset
compustat_annual <- compustat_linked %>%
  transmute(
    permno   = as.integer(permno),
    datadate = as.Date(datadate),
    at       = as.numeric(at),
    ceq      = as.numeric(ceq),
    pstkrv   = as.numeric(pstkrv),
    pstkl    = as.numeric(pstkl),
    pstk     = as.numeric(pstk),
    txditc   = as.numeric(txditc)
  ) %>%
  arrange(permno, datadate) %>%
  collect()

# 5) Export to CSV
output_path <- "~/Advanced_Investment_Strategies_LVC/Advanced_Investment_Strategies_LVC/data/compustat_annual.csv"
write_csv(compustat_annual, output_path)

