# nefindata
Python and R packages to download data from NEFIN, the Brazilian Center for Research in Financial Economics of the University of São Paulo (http://www.nefin.com.br/)


# Risk Factors
Collect data of risk factors such as Market Factor, SMB, WML, HML, IML and Risk Free.

Usage example:
```r
library(nefindata)

factors <- c('Mkt', 'SMB') # for all factors, set it to 'all'
df <- get_risk_factors(factors)
df.agg <- get_risk_factors(factors, agg = 'month', agg.func = 'last')
```
# Cost of Capital
Collect data of cost of capital for industrial sectors such as Basic Products, Construction, Consumer, Energy, Finance, Manufacturing and Other.
Data is available for 1, 5, 10 and 20-year projects.

Usage example:
```r
library(nefindata)

sector <- 'Basic'
df <- get_sector_cost_of_capital(sector)
df.agg <- get_sector_cost_of_capital(sector, agg = 'year', agg.func = 'last')
```

# Next Steps
Include data downloaders from
* [Dividend Yield](http://www.nefin.com.br/dividend_yield.html)
* [Illiquidity Index](http://www.nefin.com.br/illiquidity_index.html)
* [Loan Fees](http://www.nefin.com.br/loan_fees.html)
* [Portfolios](http://www.nefin.com.br/portfolios.html)
* [Short Interest](http://www.nefin.com.br/short_interest.html)
* [Spot Rate Curve](http://www.nefin.com.br/spot_rate_curve.html)
* [Volatility Index](http://www.nefin.com.br/volatility_index.html)