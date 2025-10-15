Advanced_Investment_Strategies_LVC/
│
├── 📄 Documentation Files (9)
│   ├── README.md                    # Main project documentation
│   ├── QUICKSTART.md               # 5-minute getting started guide
│   ├── DOCS.md                     # Documentation index
│   ├── SUMMARY.md                  # Implementation summary
│   ├── PAPER_SUMMARY.md            # Paper methodology details
│   ├── REFERENCES.md               # Complete bibliography
│   ├── WORKFLOW.md                 # Visual workflow diagrams
│   ├── CONTRIBUTING.md             # Developer guidelines
│   └── CHANGELOG.md                # Version history
│
├── 📊 R Analysis Functions (7)
│   ├── R/load_data.R               # Data loading functions
│   ├── R/clean_data.R              # Data cleaning and merging
│   ├── R/calculate_betas.R         # Beta calculation and portfolio formation
│   ├── R/portfolio_analysis.R      # Portfolio returns and B/P spreads
│   ├── R/regressions.R             # CAPM and FF4 regressions
│   ├── R/create_tables.R           # Table generation
│   └── R/create_figures.R          # Figure generation
│
├── 🧪 Testing Infrastructure (4)
│   ├── tests/run_tests.R           # Test runner
│   └── tests/testthat/
│       ├── test-load_data.R        # Data loading tests
│       ├── test-clean_data.R       # Data cleaning tests
│       └── test-portfolio_analysis.R # Portfolio analysis tests
│
├── 🔧 Utility Scripts (4)
│   ├── generate_test_data.R        # Generate simulated data
│   ├── validate_data.R             # Validate data formats
│   ├── run_analysis.R              # Main execution script
│   └── Makefile                    # Convenience commands
│
├── ⚙️ Configuration Files (6)
│   ├── _targets.R                  # Workflow pipeline definition
│   ├── config.yaml                 # Analysis parameters
│   ├── renv.lock                   # R package dependencies
│   ├── .Rprofile                   # R environment setup
│   ├── Advanced_Investment_Strategies_LVC.Rproj  # RStudio project
│   └── .gitignore                  # Version control exclusions
│
├── 📚 Examples & Tutorials (1)
│   └── example_analysis.Rmd        # Interactive R Markdown notebook
│
├── 📁 Data Directory
│   └── data/
│       └── README.md               # Data format specifications
│
├── 📁 Output Directory
│   └── output/                     # Generated tables and figures (gitignored)
│       ├── tables/
│       └── figures/
│
├── 🔄 CI/CD
│   └── .github/workflows/
│       └── R-CMD-check.yaml        # GitHub Actions workflow
│
└── 📜 Legal
    └── LICENSE                     # MIT License

STATISTICS:
-----------
Total Files: 34
R Functions: ~720 lines
Tests: ~100 lines
Documentation: ~1,700 lines (markdown)
Total R Code: ~1,260 lines

KEY FEATURES:
-------------
✅ Complete data pipeline (CRSP/Compustat → Results)
✅ Beta-sorted portfolio formation
✅ CAPM & Fama-French 4-factor regressions
✅ 4 publication-ready tables
✅ 3 key visualizations
✅ Comprehensive documentation (9 files)
✅ Test suite with unit tests
✅ Simulated data generation
✅ Data validation utilities
✅ Reproducible workflow (renv + targets)
✅ CI/CD pipeline (GitHub Actions)
✅ Multiple execution methods
✅ Configurable analysis parameters

EXECUTION OPTIONS:
------------------
1. make all                    # Install, run, test
2. source("run_analysis.R")    # One-command execution
3. library(targets); tar_make() # Targets workflow
4. Step-by-step in R console   # Manual execution

DOCUMENTATION QUICK ACCESS:
----------------------------
New Users     → QUICKSTART.md
Researchers   → PAPER_SUMMARY.md
Developers    → CONTRIBUTING.md
Full Index    → DOCS.md
Implementation → SUMMARY.md
Workflow      → WORKFLOW.md
Citations     → REFERENCES.md
