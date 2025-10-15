# References and Bibliography

## Primary Paper

**Garcia-Feijóo, L., Kochard, L., Sullivan, R. N., & Wang, P. (2015).** Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios. *Financial Analysts Journal*, 71(3), 47-60.  
DOI: [10.2469/faj.v71.n3.3](https://doi.org/10.2469/faj.v71.n3.3)

## Related Literature on Low-Volatility Anomaly

**Baker, M., Bradley, B., & Wurgler, J. (2011).** Benchmarks as Limits to Arbitrage: Understanding the Low-Volatility Anomaly. *Financial Analysts Journal*, 67(1), 40-54.

**Blitz, D., & Van Vliet, P. (2007).** The Volatility Effect: Lower Risk Without Lower Return. *Journal of Portfolio Management*, 34(1), 102-113.

**Ang, A., Hodrick, R. J., Xing, Y., & Zhang, X. (2006).** The Cross-Section of Volatility and Expected Returns. *Journal of Finance*, 61(1), 259-299.

**Frazzini, A., & Pedersen, L. H. (2014).** Betting Against Beta. *Journal of Financial Economics*, 111(1), 1-25.

## Asset Pricing Models

**Fama, E. F., & French, K. R. (1993).** Common Risk Factors in the Returns on Stocks and Bonds. *Journal of Financial Economics*, 33(1), 3-56.

**Carhart, M. M. (1997).** On Persistence in Mutual Fund Performance. *Journal of Finance*, 52(1), 57-82.

**Fama, E. F., & French, K. R. (2015).** A Five-Factor Asset Pricing Model. *Journal of Financial Economics*, 116(1), 1-22.

## Value and Momentum

**Asness, C. S., Moskowitz, T. J., & Pedersen, L. H. (2013).** Value and Momentum Everywhere. *Journal of Finance*, 68(3), 929-985.

**Jegadeesh, N., & Titman, S. (1993).** Returns to Buying Winners and Selling Losers: Implications for Stock Market Efficiency. *Journal of Finance*, 48(1), 65-91.

**Lakonishok, J., Shleifer, A., & Vishny, R. W. (1994).** Contrarian Investment, Extrapolation, and Risk. *Journal of Finance*, 49(5), 1541-1578.

## Low-Volatility and Value Interaction

**Asness, C. S., Frazzini, A., & Pedersen, L. H. (2014).** Low-Risk Investing without Industry Bets. *Financial Analysts Journal*, 70(4), 24-41.

**Novy-Marx, R. (2013).** The Other Side of Value: The Gross Profitability Premium. *Journal of Financial Economics*, 108(1), 1-28.

## Beta and CAPM

**Black, F., Jensen, M. C., & Scholes, M. (1972).** The Capital Asset Pricing Model: Some Empirical Tests. In *Studies in the Theory of Capital Markets* (pp. 79-121). Praeger Publishers Inc.

**Fama, E. F., & MacBeth, J. D. (1973).** Risk, Return, and Equilibrium: Empirical Tests. *Journal of Political Economy*, 81(3), 607-636.

## Data and Methodology

**Fama, E. F., & French, K. R. (1992).** The Cross-Section of Expected Stock Returns. *Journal of Finance*, 47(2), 427-465.

**Davis, J. L., Fama, E. F., & French, K. R. (2000).** Characteristics, Covariances, and Average Returns: 1929 to 1997. *Journal of Finance*, 55(1), 389-406.

## Data Sources

### CRSP (Center for Research in Security Prices)
- **Website:** [https://crsp.org/](https://crsp.org/)
- **Access:** Via WRDS (Wharton Research Data Services)
- **Coverage:** US stock market data from 1926

### Compustat
- **Website:** [https://www.spglobal.com/marketintelligence/en/solutions/sp-capital-iq-pro](https://www.spglobal.com/marketintelligence/en/solutions/sp-capital-iq-pro)
- **Access:** Via WRDS
- **Coverage:** Financial statements and fundamentals

### Kenneth French Data Library
- **Website:** [http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html)
- **Access:** Free download
- **Coverage:** Fama-French factors, momentum, industry portfolios

## R Packages Used

### Data Management
- **tidyverse:** Wickham, H. et al. (2019). Welcome to the tidyverse. *Journal of Open Source Software*, 4(43), 1686.
- **data.table:** Dowle, M., & Srinivasan, A. (2021). data.table: Extension of `data.frame`.

### Time Series
- **zoo:** Zeileis, A., & Grothendieck, G. (2005). zoo: S3 Infrastructure for Regular and Irregular Time Series. *Journal of Statistical Software*, 14(6), 1-27.
- **lubridate:** Grolemund, G., & Wickham, H. (2011). Dates and Times Made Easy with lubridate. *Journal of Statistical Software*, 40(3), 1-25.

### Regression and Statistics
- **broom:** Robinson, D., Hayes, A., & Couch, S. (2021). broom: Convert Statistical Objects into Tidy Tibbles.

### Visualization
- **ggplot2:** Wickham, H. (2016). *ggplot2: Elegant Graphics for Data Analysis*. Springer-Verlag New York.

### Workflow
- **targets:** Landau, W. M. (2021). The targets R package: a dynamic Make-like function-oriented pipeline toolkit for reproducibility and high-performance computing. *Journal of Open Source Software*, 6(57), 2959.

### Testing
- **testthat:** Wickham, H. (2011). testthat: Get Started with Testing. *The R Journal*, 3(1), 5-10.

## Reproducible Research

**Gentleman, R., & Temple Lang, D. (2007).** Statistical Analyses and Reproducible Research. *Journal of Computational and Graphical Statistics*, 16(1), 1-23.

**Peng, R. D. (2011).** Reproducible Research in Computational Science. *Science*, 334(6060), 1226-1227.

**Wilson, G., Bryan, J., Cranston, K., Kitzes, J., Nederbragt, L., & Teal, T. K. (2017).** Good Enough Practices in Scientific Computing. *PLOS Computational Biology*, 13(6), e1005510.

## Software and Tools

**R Core Team (2023).** R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria.  
URL: [https://www.R-project.org/](https://www.R-project.org/)

**RStudio Team (2023).** RStudio: Integrated Development Environment for R. RStudio, PBC, Boston, MA.  
URL: [http://www.rstudio.com/](http://www.rstudio.com/)

---

## Citation Format

If you use this replication code in your research, please cite both the original paper and this repository:

### BibTeX

```bibtex
@article{garcia2015low,
  title={Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios},
  author={Garcia-Feij{\'o}o, Luis and Kochard, Lawrence and Sullivan, Rodney N and Wang, Peng},
  journal={Financial Analysts Journal},
  volume={71},
  number={3},
  pages={47--60},
  year={2015},
  publisher={Taylor \& Francis}
}

@software{lvc_replication,
  title={Advanced Investment Strategies LVC: Replication Code},
  author={Advanced Investment Strategies LVC Contributors},
  year={2024},
  url={https://github.com/nbaumannli/Advanced_Investment_Strategies_LVC},
  note={R implementation of Garcia-Feij{\'o}o et al. (2015)}
}
```

### APA Style

Garcia-Feijóo, L., Kochard, L., Sullivan, R. N., & Wang, P. (2015). Low-volatility cycles: The influence of valuation and momentum on low-volatility portfolios. *Financial Analysts Journal*, 71(3), 47-60.

Advanced Investment Strategies LVC Contributors. (2024). *Advanced Investment Strategies LVC: Replication Code* [Software]. GitHub. https://github.com/nbaumannli/Advanced_Investment_Strategies_LVC
