# Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios

## Paper Summary

**Authors:** Luis Garcia-Feijóo, Lawrence Kochard, Rodney N. Sullivan, and Peng Wang  
**Journal:** Financial Analysts Journal, Volume 71, Number 3, 2015  
**Pages:** 47-60  
**DOI:** 10.2469/faj.v71.n3.3

## Abstract

This paper examines the relationship between the low-volatility anomaly and two well-documented factors: valuation (book-to-price ratios) and momentum. The authors demonstrate that:

1. **Low-volatility stocks exhibit cyclical patterns** in their relative performance
2. **These cycles are closely linked to valuation metrics** - specifically book-to-price (B/P) ratios
3. **The low-volatility premium varies significantly over time** based on market conditions

## Key Findings

### 1. Low-Volatility Anomaly
- Portfolios of low-beta (low-volatility) stocks have historically outperformed high-beta stocks on a risk-adjusted basis
- This contradicts traditional CAPM predictions where higher risk should yield higher returns

### 2. Book-to-Price Dynamics
- Low-beta stocks tend to have higher book-to-price ratios (i.e., they are "cheaper" or "value" stocks)
- The B/P spread between low-beta and high-beta portfolios fluctuates over time
- When this spread is wide, the low-volatility premium tends to be larger

### 3. Momentum Effects
- The performance of low-volatility strategies is influenced by momentum
- Recent performance trends affect the attractiveness of low-beta stocks
- Controlling for momentum reduces but doesn't eliminate the low-volatility premium

### 4. Multi-Factor Analysis
The authors show that:
- **CAPM:** Significant positive alphas for low-beta portfolios
- **Fama-French 3-Factor:** Reduced but still significant alphas, with strong value (HML) loadings
- **4-Factor (with Momentum):** Further reduced alphas, showing momentum plays a role

## Methodology

### Portfolio Formation
1. **Universe:** NYSE, AMEX, and NASDAQ stocks
2. **Sample Period:** 1968-2013 (primary analysis)
3. **Beta Calculation:** 60-month rolling window regressions
4. **Portfolio Construction:** 
   - Sort stocks into deciles based on beta
   - Use NYSE large-cap stocks to set breakpoints
   - Rebalance monthly
5. **Weighting:** Both equal-weighted and value-weighted portfolios

### Analysis Approach
1. Calculate book-to-price ratios for each portfolio
2. Examine time-series variation in B/P spreads
3. Run CAPM and multi-factor regressions:
   - CAPM: Rᵢₜ - Rբₜ = αᵢ + βᵢ(Rₘₜ - Rբₜ) + εᵢₜ
   - FF3: Add SMB and HML factors
   - FF4: Add UMD (momentum) factor
4. Analyze performance during different market regimes

### Key Metrics
- **Alpha:** Risk-adjusted excess return
- **Beta:** Market sensitivity
- **B/P Spread:** Difference in book-to-price ratios between low and high beta portfolios
- **Sharpe Ratio:** Risk-adjusted performance measure

## Main Results (Table Highlights)

### Table 2: Portfolio Characteristics
- Portfolio 1 (Low Beta): Average beta ≈ 0.5-0.6, High B/P
- Portfolio 10 (High Beta): Average beta ≈ 1.4-1.6, Low B/P
- Clear monotonic relationship between beta and B/P

### Table 3: CAPM Alphas
- Low-beta portfolios show significant positive alphas
- High-beta portfolios show negative or insignificant alphas
- Long-short (P1-P10) portfolio has significant positive alpha

### Table 4: Fama-French 4-Factor Alphas
- Alphas reduced but many remain significant
- Strong HML loadings for low-beta portfolios (value tilt)
- Momentum loadings vary across portfolios

### Figures
- **Figure 1:** B/P spread time series showing cyclical patterns
- **Figure 2:** Cumulative returns of low vs. high beta portfolios
- **Figure 3:** Alpha comparison across different factor models

## Investment Implications

1. **Low-volatility investing can be enhanced** by considering valuation metrics
2. **Timing matters:** The low-volatility premium is not constant
3. **Multi-factor exposure:** Low-volatility strategies have implicit tilts toward value and sometimes momentum
4. **Risk management:** Understanding these dynamics helps in portfolio construction and risk budgeting

## Replication Details

This repository replicates the core analysis:

### What's Included
- ✅ Data cleaning pipeline (CRSP/Compustat)
- ✅ Beta calculation (60-month rolling)
- ✅ Portfolio formation (NYSE large-cap breakpoints)
- ✅ Book-to-price spread analysis
- ✅ CAPM regressions
- ✅ Fama-French 4-factor regressions
- ✅ Table generation
- ✅ Figure generation

### Extensions (Possible)
- Subperiod analysis
- International markets
- Alternative beta measures (realized volatility, idiosyncratic risk)
- Additional factor models (5-factor, q-factor)
- Dynamic portfolio strategies

## Citations

### Primary Paper
Garcia-Feijóo, L., Kochard, L., Sullivan, R. N., & Wang, P. (2015). Low-Volatility Cycles: The Influence of Valuation and Momentum on Low-Volatility Portfolios. *Financial Analysts Journal*, 71(3), 47-60.

### Related Literature
- Baker, M., Bradley, B., & Wurgler, J. (2011). Benchmarks as Limits to Arbitrage
- Asness, C. S., Frazzini, A., & Pedersen, L. H. (2014). Low-Risk Investing without Industry Bets
- Blitz, D., & Van Vliet, P. (2007). The Volatility Effect

## Data Sources

- **CRSP:** Stock returns, prices, shares outstanding, market cap
- **Compustat:** Fundamentals for book equity calculation
- **Kenneth French Data Library:** Fama-French factors, market returns

## Contact

For questions about the replication:
- Open an issue on GitHub
- Review the code in `R/` directory
- Check documentation in README.md and QUICKSTART.md
