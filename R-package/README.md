# nefindata
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/fernandoramacciotti/nefindata/blob/master/LICENSE) 
[![Documentation Status](https://readthedocs.org/projects/nefindata/badge/?version=latest)](http://nefindata.readthedocs.io/?badge=latest) 

Python and R packages to download data from NEFIN, the Brazilian Center for Research in Financial Economics of the University of São Paulo (http://www.nefin.com.br/)

Please [check our documentation](http://nefindata.readthedocs.io/?badge=latest) for more examples and detailed API reference.

# Installation
The R package can be installed via [devtools](https://github.com/r-lib/devtools) package. Make sure you have it installed and then run the following command:
```r
# install.packages('devtools') # uncomment if devtools needs to be installed
devtools::install_github('fernandoramacciotti/nefindata/R-package')
```

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

# Other data
Similar functions get other data such as. The syntax is similar as above.
* [Dividend Yield](http://www.nefin.com.br/dividend_yield.html): `get_dividend_yield()`
* [Illiquidity Index](http://www.nefin.com.br/illiquidity_index.html): `get_illiquidity_index()`
* [Loan Fees](http://www.nefin.com.br/loan_fees.html): `get_load_fees()`
* [Short Interest](http://www.nefin.com.br/short_interest.html): `get_short_interest()`

# Next Steps
Include data downloaders from
* [Portfolios](http://www.nefin.com.br/portfolios.html)
* [Spot Rate Curve](http://www.nefin.com.br/spot_rate_curve.html)
* [Volatility Index](http://www.nefin.com.br/volatility_index.html)