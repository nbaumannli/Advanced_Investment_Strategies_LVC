# Contributing to Advanced Investment Strategies LVC

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## How to Contribute

### Reporting Bugs
- Use the GitHub issue tracker
- Describe the bug in detail
- Include steps to reproduce
- Mention your R version and operating system

### Suggesting Enhancements
- Open an issue with the "enhancement" label
- Clearly describe the proposed feature
- Explain why it would be useful

### Code Contributions

#### Setup Development Environment
1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Advanced_Investment_Strategies_LVC.git
   cd Advanced_Investment_Strategies_LVC
   ```
3. Open in RStudio
4. Restore packages: `renv::restore()`

#### Making Changes
1. Create a new branch:
   ```bash
   git checkout -b feature/my-new-feature
   ```
2. Make your changes
3. Test your changes thoroughly
4. Update documentation as needed

#### Code Style
Follow the [tidyverse style guide](https://style.tidyverse.org/):
- Use `<-` for assignment (not `=`)
- Use snake_case for variable names
- Indent with 2 spaces
- Maximum line length: 80 characters
- Comment your code clearly

Example:
```r
#' Calculate portfolio returns
#'
#' @param data Portfolio data
#' @return Returns by portfolio
calculate_returns <- function(data) {
  results <- data %>%
    group_by(portfolio) %>%
    summarise(
      ret_ew = mean(ret, na.rm = TRUE),
      ret_vw = weighted.mean(ret, mktcap, na.rm = TRUE)
    )
  
  return(results)
}
```

#### Testing
- Add tests for new functions in `tests/testthat/`
- Run all tests before submitting:
  ```r
  source("tests/run_tests.R")
  ```
- Ensure all tests pass

#### Documentation
- Add roxygen2 comments to functions
- Update README.md if adding major features
- Add examples in docstrings

#### Commit Messages
Use clear, descriptive commit messages:
- Good: "Add momentum factor to portfolio analysis"
- Bad: "Update code"

Format:
```
Short (50 chars or less) summary

More detailed explanatory text, if necessary. Wrap at 72 characters.
Explain the problem this commit solves and why you chose this approach.

- Bullet points are okay
- Use present tense ("Add feature" not "Added feature")
```

#### Pull Request Process
1. Update documentation
2. Add tests for new functionality
3. Ensure all tests pass
4. Update CHANGELOG.md (if exists)
5. Submit PR with clear description
6. Link any related issues

### Code Review Process
- Maintainers will review your PR
- Address any feedback
- Once approved, your PR will be merged

## Project Structure

```
Advanced_Investment_Strategies_LVC/
├── R/                    # R functions (one topic per file)
├── data/                 # Input data (not in repo)
├── output/              # Generated outputs (not in repo)
├── tests/               # Unit tests
├── _targets.R           # Workflow definition
├── renv.lock           # Package versions
└── README.md           # Main documentation
```

## Development Workflow

### Adding a New Analysis Function

1. Create the function in an appropriate R/ file:
   ```r
   # R/my_analysis.R
   
   #' My new analysis function
   #'
   #' @param data Input data
   #' @return Analysis results
   my_analysis_function <- function(data) {
     # Your code here
     return(results)
   }
   ```

2. Add a target in `_targets.R`:
   ```r
   tar_target(
     my_analysis_result,
     my_analysis_function(merged_data),
     format = "rds"
   )
   ```

3. Add tests in `tests/testthat/`:
   ```r
   # tests/testthat/test-my_analysis.R
   
   test_that("my_analysis_function works correctly", {
     test_data <- data.frame(x = 1:10, y = 11:20)
     result <- my_analysis_function(test_data)
     expect_true(!is.null(result))
   })
   ```

4. Test locally:
   ```r
   tar_source()
   tar_make()
   ```

### Adding a New Table or Figure

Follow the same pattern as existing `create_table*` and `create_figure*` functions.

## Questions?

Feel free to open an issue for any questions about contributing!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
