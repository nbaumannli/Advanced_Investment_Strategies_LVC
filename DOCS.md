# Documentation Index

Welcome to the Advanced Investment Strategies LVC project documentation. This index helps you navigate the various documentation files.

## 📚 Main Documentation

### [README.md](README.md) - **START HERE**
Complete project overview including:
- Project structure and setup
- Installation instructions
- Methodology explanation
- Running the analysis
- Output description

### [QUICKSTART.md](QUICKSTART.md)
Quick 5-minute guide to get up and running:
- Minimal setup steps
- Running your first analysis
- Common issues and solutions
- Next steps

### [PAPER_SUMMARY.md](PAPER_SUMMARY.md)
Detailed summary of the replicated paper:
- Research question and methodology
- Key findings and results
- Investment implications
- Replication coverage

### [REFERENCES.md](REFERENCES.md)
Complete bibliography and citations:
- Primary paper reference
- Related literature
- Data sources
- Software and tools
- Citation formats (BibTeX, APA)

## 🔧 Development Documentation

### [CONTRIBUTING.md](CONTRIBUTING.md)
Guidelines for contributors:
- How to contribute
- Code style guide
- Development workflow
- Pull request process

### [CHANGELOG.md](CHANGELOG.md)
Version history and changes:
- Release notes
- Feature additions
- Bug fixes
- Breaking changes

## 📂 Directory Documentation

### [data/README.md](data/README.md)
Data requirements and formats:
- Required data files
- Column specifications
- Data sources
- Sample formats

## 📝 Analysis Examples

### [example_analysis.Rmd](example_analysis.Rmd)
Interactive R Markdown notebook:
- Complete walkthrough
- Code examples
- Visualization examples
- Interpretation guide

## 🔨 Utility Scripts

### [generate_test_data.R](generate_test_data.R)
Generate simulated data for testing:
- Creates sample datasets
- No real data access needed
- Good for learning and testing

### [run_analysis.R](run_analysis.R)
Main execution script:
- One-command analysis
- Full pipeline execution
- Results summary

### [Makefile](Makefile)
Command shortcuts:
- `make install` - Install packages
- `make run` - Run analysis
- `make test` - Run tests
- `make clean` - Clean outputs

## 📊 Code Organization

### R/ Directory
Function library organized by purpose:

1. **[R/load_data.R](R/load_data.R)** - Data loading
2. **[R/clean_data.R](R/clean_data.R)** - Data cleaning and merging
3. **[R/calculate_betas.R](R/calculate_betas.R)** - Beta calculation and portfolio formation
4. **[R/portfolio_analysis.R](R/portfolio_analysis.R)** - Portfolio returns and B/P spreads
5. **[R/regressions.R](R/regressions.R)** - CAPM and FF4 regressions
6. **[R/create_tables.R](R/create_tables.R)** - Table generation
7. **[R/create_figures.R](R/create_figures.R)** - Figure generation

### Tests Directory
Unit tests for validation:

1. **[tests/run_tests.R](tests/run_tests.R)** - Test runner
2. **[tests/testthat/test-load_data.R](tests/testthat/test-load_data.R)** - Data loading tests
3. **[tests/testthat/test-clean_data.R](tests/testthat/test-clean_data.R)** - Data cleaning tests
4. **[tests/testthat/test-portfolio_analysis.R](tests/testthat/test-portfolio_analysis.R)** - Portfolio analysis tests

## ⚙️ Configuration Files

### [_targets.R](_targets.R)
Workflow pipeline definition:
- Defines analysis steps
- Manages dependencies
- Ensures reproducibility

### [config.yaml](config.yaml)
Analysis parameters:
- Portfolio settings
- Sample period
- Data filters
- Output options

### [renv.lock](renv.lock)
Package dependencies:
- R package versions
- Ensures reproducibility
- Managed by renv

### [Advanced_Investment_Strategies_LVC.Rproj](Advanced_Investment_Strategies_LVC.Rproj)
RStudio project file:
- Project settings
- IDE configuration

### [.Rprofile](.Rprofile)
R environment setup:
- Activates renv on startup
- Project initialization

### [.gitignore](.gitignore)
Version control exclusions:
- Data files (sensitive)
- Generated outputs
- Temporary files

## 🚀 CI/CD

### [.github/workflows/R-CMD-check.yaml](.github/workflows/R-CMD-check.yaml)
GitHub Actions workflow:
- Automated testing
- Multi-platform checks
- Continuous integration

## 📄 Legal

### [LICENSE](LICENSE)
MIT License:
- Usage terms
- Copyright information
- Permissions and limitations

## 🗺️ Recommended Reading Order

### For New Users:
1. [README.md](README.md) - Understand the project
2. [PAPER_SUMMARY.md](PAPER_SUMMARY.md) - Understand the research
3. [QUICKSTART.md](QUICKSTART.md) - Get started quickly
4. [data/README.md](data/README.md) - Prepare your data
5. [example_analysis.Rmd](example_analysis.Rmd) - See it in action

### For Developers:
1. [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
2. [_targets.R](_targets.R) - Workflow structure
3. R function files - Implementation details
4. [tests/](tests/) - Test suite
5. [CHANGELOG.md](CHANGELOG.md) - Version history

### For Researchers:
1. [PAPER_SUMMARY.md](PAPER_SUMMARY.md) - Original paper details
2. [README.md](README.md) - Methodology
3. [R/](R/) - Implementation
4. [example_analysis.Rmd](example_analysis.Rmd) - Analysis examples
5. [config.yaml](config.yaml) - Customization options

## 📞 Getting Help

1. **Quick questions**: Check [QUICKSTART.md](QUICKSTART.md)
2. **Common issues**: See troubleshooting in [QUICKSTART.md](QUICKSTART.md)
3. **Detailed setup**: Read [README.md](README.md)
4. **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)
5. **Bug reports**: Open an issue on GitHub

## 🔄 Keeping Documentation Updated

When contributing, please update relevant documentation:
- Add new features to README.md
- Update CHANGELOG.md with changes
- Add examples to example_analysis.Rmd if applicable
- Update this index if adding new documentation

---

**Last Updated:** 2024-01-01  
**Version:** 1.0.0
