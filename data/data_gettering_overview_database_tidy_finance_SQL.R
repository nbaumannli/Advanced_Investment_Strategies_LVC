# Data exploration script: List all tables and peek schemas in tidy_finance SQLite database

# ------------------------------------------------------------------------------
# Purpose (target CSV: tables_inventory.csv)
# ------------------------------------------------------------------------------
# - List all tables available in the SQLite database
# - Show column names for each table
# - (Optional) Report approximate row counts per table
# - Save a compact inventory CSV to your repo for reference
# ------------------------------------------------------------------------------

# Ensure required DB packages are installed and loaded
# packages <- c("DBI", "RSQLite", "dplyr", "purrr", "readr")
# installed <- packages %in% rownames(installed.packages())
# if (any(!installed)) install.packages(packages[!installed])
# lapply(packages, library, character.only = TRUE)

# ------------------------------------------------------------------------------
# Connect to the tidy_finance SQLite database
# ------------------------------------------------------------------------------
db_path <- "/home/shared/data/tidy_finance.sqlite"
con <- dbConnect(RSQLite::SQLite(), db_path, extended_types = TRUE)

# ------------------------------------------------------------------------------
# 1) List all tables
# ------------------------------------------------------------------------------
tables <- DBI::dbListTables(con)
tables

# ------------------------------------------------------------------------------
# 2) For each table: get columns and (optional) row counts
#    NOTE: Counting rows can be slow on very large tables; set `with_counts = FALSE`
# ------------------------------------------------------------------------------
with_counts <- TRUE

# Safe helpers
safe_fields <- purrr::safely(DBI::dbListFields)
safe_count  <- purrr::safely(function(tbl) {
  # Use SQL to avoid loading data into R
  DBI::dbGetQuery(con, paste0("SELECT COUNT(*) AS n FROM ", tbl))$n[1]
})

inventory <- tibble::tibble(
  table = tables
) %>%
  mutate(
    columns_list = purrr::map(table, ~ {
      res <- safe_fields(con, .x)
      if (!is.null(res$result)) res$result else character(0)
    }),
    n_cols = purrr::map_int(columns_list, length),
    n_rows = if (with_counts) purrr::map_int(table, ~ {
      res <- safe_count(.x)
      if (!is.null(res$result)) res$result else NA_integer_
    }) else NA_integer_
  )

# Print a readable snapshot to console
inventory

# ------------------------------------------------------------------------------
# 3) (Optional) Unnest columns to a long form for quick scanning
# ------------------------------------------------------------------------------
inventory_long <- inventory %>%
  tidyr::unnest_longer(columns_list, values_to = "column", indices_include = FALSE)

# Show first few rows
head(inventory_long, 30)

# ------------------------------------------------------------------------------
# 4) Export inventory CSV to repository
# ------------------------------------------------------------------------------
out_dir <- "~/Advanced_Investment_Strategies_LVC/Advanced_Investment_Strategies_LVC/data"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Save compact table-level overview
readr::write_csv(inventory, file.path(out_dir, "tables_inventory.csv"))

# Save column-level long view
readr::write_csv(inventory_long, file.path(out_dir, "tables_inventory_columns.csv"))

# ------------------------------------------------------------------------------
# 5) (Optional) Peek first 5 rows of a specific table (change name as needed)
# ------------------------------------------------------------------------------
# DBI::dbGetQuery(con, "SELECT * FROM crsp_monthly LIMIT 5;")

# Done.
