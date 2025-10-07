# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-01-01

### Added
- Initial project structure with renv for dependency management
- Targets workflow for reproducible analysis pipeline
- Data loading functions for CRSP, Compustat, market returns, and Fama-French factors
- Data cleaning and merging functions
- Rolling beta calculation (60-month window)
- NYSE large-cap beta-sorted portfolio formation (deciles)
- Book-to-Price spread calculation
- CAPM regression analysis
- Fama-French 4-factor regression analysis
- Table generation (4 main tables):
  - Table 1: Summary statistics
  - Table 2: Portfolio characteristics
  - Table 3: CAPM results
  - Table 4: Fama-French 4-factor results
- Figure generation (3 main figures):
  - Figure 1: B/P spreads over time
  - Figure 2: Cumulative returns
  - Figure 3: Alpha comparison
- Comprehensive README with methodology
- Quick start guide (QUICKSTART.md)
- Contributing guidelines (CONTRIBUTING.md)
- Unit tests for core functions
- MIT License
- Data directory documentation
- Configuration file (config.yaml)
- Main execution script (run_analysis.R)

### Documentation
- Detailed README with project overview, setup instructions, and methodology
- Data README explaining required data formats and sources
- Quick start guide for new users
- Contributing guidelines for developers
- Roxygen2 documentation for all functions

### Testing
- Test suite using testthat
- Tests for data loading, cleaning, and portfolio analysis functions
- Test runner script

## [0.1.0] - 2024-01-01

### Added
- Initial repository setup
- Basic README with project title

---

## Version History

### Version 1.0.0
Complete implementation of Garcia-Feijóo et al. (2015) replication study with:
- Full data pipeline from CRSP/Compustat to final results
- Beta-sorted portfolio formation
- Multi-factor regression analysis
- Publication-ready tables and figures
- Comprehensive documentation

### Version 0.1.0
Initial project scaffold
