

# Data gattering script for CRSP Monthly dataset from tidy_finance SQLite database


# ------------------------------------------------------------------------------
# Required columns for CRSP Monthly Stock Data according to the "Data Directory"
# ------------------------------------------------------------------------------
# permno : Permanent security identifier
# date   : Date (YYYY-MM-DD format)
# ret    : Monthly return
# prc    : Price (can be negative to indicate average of bid/ask)
# shrout : Shares outstanding (in thousands)
# shrcd  : Share code
#          - 10 and 11 indicate common stocks
# exchcd : Exchange code
#          - 1 = NYSE
#          - 2 = AMEX
#          - 3 = NASDAQ
# ------------------------------------------------------------------------------


# Ensure required DB packages are installed and loaded
packages <- c("dplyr", "dbplyr", "DBI", "RSQLite", "readr")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) install.packages(packages[!installed])
lapply(packages, library, character.only = TRUE)


# Connect to the tidy_finance SQLite database
db_path <- "/home/shared/data/tidy_finance.sqlite"
con <- dbConnect(RSQLite::SQLite(), db_path, extended_types = TRUE)

tidy_finance <- dbConnect(
  SQLite(),
  db_path,
  extended_types = TRUE
)

# List all tables in the database
DBI::dbListTables(con)
# View column names for a specific table, e.g. "crsp_monthly"
DBI::dbListFields(con, "crsp_monthly")
# Peek at the schema of the table / data format
DBI::dbGetQuery(con, "PRAGMA table_info(crsp_monthly);")

# Setup
con <- tidy_finance
cm  <- tbl(con, "crsp_monthly")

# Quick schema peek (optional)
DBI::dbGetQuery(con, "PRAGMA table_info(crsp_monthly);")

#It seams that we have the following labels which we need:
# ------------------------------------------------------------------------------
# Columns used for final CRSP Monthly dataset
# ------------------------------------------------------------------------------
# Final Column | Source Column        | Transformation / Notes
# ------------------------------------------------------------------------------
# permno       | permno               | as.integer
# date         | date                 | as.Date
# ret          | ret                  | as.numeric
# prc          | prc                  | as.numeric
# shrout       | shrout               | as.numeric
# exchcd       | exchange or primaryexch | Map text/letter → numeric code:
# _             |                      |   NYSE / N → 1
# _             |                      |   AMEX / A → 2
# _             |                      |   NASDAQ / Q → 3
# shrcd        | (not in database)    | set to NA or proxy 10 (common stock)
# ------------------------------------------------------------------------------

#Important: we do not have shrcd in the labels of "crsp_monthly"
# we gona set itto NA or proxy 10 (common stock)

# Data validation steps
# 1) permno — type & sanity
cm %>%
  summarise(
    n = n(),
    n_na = sum(is.na(permno)),
    min_permno = min(permno, na.rm = TRUE),
    max_permno = max(permno, na.rm = TRUE),
    distinct_permno = n_distinct(permno)
  ) %>% collect()
# Expect: n_na = 0, reasonable ranges, many distinct IDs.

# 2) date — ISO format & range
cm %>%
  summarise(
    n_na = sum(is.na(date)),
    min_date = min(date, na.rm = TRUE),
    max_date = max(date, na.rm = TRUE)
  ) %>% collect()
# Sample parse check in R (ISO 'YYYY-MM-DD' should parse cleanly)
cm %>% select(date) %>% head(20) %>% collect() %>%
  mutate(parsed_ok = !is.na(as.Date(date)))
# Expect: dates look like YYYY-MM-DD, parsed_ok is TRUE for all sampled rows.


# 3) ret — numeric & distribution
cm %>%
  summarise(
    n_na = sum(is.na(ret)),
    min_ret = min(ret, na.rm = TRUE),
    mean_ret = mean(ret, na.rm = TRUE),
    median_ret = median(ret, na.rm = TRUE),  # ok if supported
    max_ret = max(ret, na.rm = TRUE)
  ) %>%
  collect()
# Expect: numeric decimals (e.g., −1 to big positives), some NAs are normal.

# 4) prc — allow negatives (CRSP convention)
cm %>%
  summarise(
    n_na        = sum(is.na(prc)),
    min_prc     = min(prc, na.rm = TRUE),
    mean_prc    = mean(prc, na.rm = TRUE),
    max_prc     = max(prc, na.rm = TRUE),
    any_negative = sum(prc < 0, na.rm = TRUE)
  ) %>% collect()
# Expect: any_negative > 0 is okay (CRSP negative price sign convention).


# 5) shrout — numeric (thousands)
cm %>%
  summarise(
    n_na    = sum(is.na(ret)),
    min_ret = min(ret, na.rm = TRUE),
    mean_ret= mean(ret, na.rm = TRUE),
    max_ret = max(ret, na.rm = TRUE)
  ) %>% collect()

# 6) exchcd — derive from labels (discover labels)
# We’ll see which label column is populated and with what values.
# Distinct labels for both candidates
lab_primary <- cm %>% count(primaryexch, sort = TRUE) %>% collect()
lab_exchange <- cm %>% count(exchange, sort = TRUE) %>% collect()

lab_primary
lab_exchange
# Expect: labels like “NYSE”, “AMEX”, “NASDAQ” (maybe “NYSE American”, “Nasdaq” variants).
# Keep these outputs—we’ll map them to 1/2/3 precisely.
# form the output we learned that: primaryexch has letter labels N, A, Q & exchange has text labels NYSE, AMEX, NASDAQ.

#Since we have everything except shrcd, you can build your final dataset directly from this one table, without joining to msf_v2.


# Build final crsp_monthly dataset


# Connect if not already
# con <- dbConnect(RSQLite::SQLite(), "/home/shared/data/tidy_finance.sqlite")

crsp_monthly <- tbl(con, "crsp_monthly") %>%
  mutate(
    # Map exchange labels → CRSP numeric codes
    exchcd = case_when(
      exchange %in% c("NYSE", "New York Stock Exchange") ~ 1L,
      exchange %in% c("AMEX", "NYSE American", "American Stock Exchange") ~ 2L,
      exchange %in% c("NASDAQ", "Nasdaq", "NASDAQ Stock Market") ~ 3L,
      primaryexch == "N" ~ 1L,
      primaryexch == "A" ~ 2L,
      primaryexch == "Q" ~ 3L,
      TRUE ~ NA_integer_
    ),
    shrcd = 10L
  ) %>%
  # Keep only major exchanges
  filter(exchcd %in% c(1L, 2L, 3L)) %>%
  # Keep only the required variables
  select(permno, date, ret, prc, shrout, shrcd, exchcd) %>%
  collect() %>%
  mutate(
    date   = as.Date(date),
    permno = as.integer(permno),
    ret    = as.numeric(ret),
    prc    = as.numeric(prc),
    shrout = as.numeric(shrout),
    shrcd  = as.integer(shrcd),
    exchcd = as.integer(exchcd)
  ) %>%
  arrange(permno, date)

# 4) Export to CSV
output_path <- "~/Advanced_Investment_Strategies_LVC/Advanced_Investment_Strategies_LVC/data/crsp_monthly.csv"
write_csv(crsp_monthly, output_path)



