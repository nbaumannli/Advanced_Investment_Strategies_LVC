#!/usr/bin/env Rscript

# Main execution script for Low-Volatility Cycles replication
# This script runs the full analysis pipeline using targets

# Load required packages
if (!require("targets")) {
  install.packages("targets")
  library(targets)
}

# Check if renv is initialized
#if (!file.exists("renv.lock")) {
#  message("renv.lock not found. Initializing renv...")
#  if (!require("renv")) install.packages("renv")
#  renv::init()
#} else {
  # Restore packages from lockfile
#  if (!require("renv")) install.packages("renv")
#  message("Restoring packages from renv.lock...")
#  renv::restore()
#}

# Visualize the pipeline (optional)
message("\n=== Pipeline Structure ===")
tar_manifest()

# Run the pipeline
message("\n=== Running Analysis Pipeline ===")
tar_make()

# Print summary
message("\n=== Pipeline Summary ===")
tar_meta() %>%
  filter(complete == TRUE) %>%
  select(name, type, time, seconds) %>%
  print()

message("\n=== Analysis Complete ===")
message("Tables saved to: output/tables/")
message("Figures saved to: output/figures/")
