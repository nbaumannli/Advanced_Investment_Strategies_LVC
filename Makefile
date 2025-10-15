.PHONY: help install test run clean all

help:
	@echo "Available targets:"
	@echo "  make install    - Install R packages using renv"
	@echo "  make test       - Run all tests"
	@echo "  make run        - Run the full analysis pipeline"
	@echo "  make clean      - Remove generated outputs"
	@echo "  make all        - Install packages, run analysis, and run tests"

install:
	Rscript -e "if (!require('renv')) install.packages('renv'); renv::restore()"

test:
	Rscript tests/run_tests.R

run:
	Rscript run_analysis.R

clean:
	rm -rf output/
	rm -rf _targets/
	@echo "Cleaned output directories"

all: install run test
	@echo "Complete workflow finished successfully"
