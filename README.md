# nefindata
Python and R packages to download data from NEFIN, the Brazilian Center for Research in Financial Economics of the University of São Paulo (http://www.nefin.com.br/)


# Risk Factors
NEFIN's has been collecting historical financial data for risk factors such as Market Factor, SMB, WML, HML, IML and Risk Free.

Python package:
```python
from nefindata.risk_factors import get_risk_factors

factors = ['Mkt', 'SMB'] # for all factors, set it to 'all' or None
df = get_risk_factors(factors)
df_agg = get_risk_factors(factors, agg='month', agg_func='last')
# 
```

R package:
```r
library(nefindata)

factors <- c('Mkt', 'SMB') # for all factors, set it to 'all'
df <- get_risk_factors(factors)
df.agg <- get_risk_factors(factors, agg = 'month', agg.func = 'last')
```

# Next Steps
Include data downloaders from
* [Cost of Capital](http://www.nefin.com.br/cost_of_capital.html)
* [Dividend Yield](http://www.nefin.com.br/dividend_yield.html)
* [Illiquidity Index](http://www.nefin.com.br/illiquidity_index.html)
* [Loan Fees](http://www.nefin.com.br/loan_fees.html)
* [Portfolios](http://www.nefin.com.br/portfolios.html)
* [Short Interest](http://www.nefin.com.br/short_interest.html)
* [Spot Rate Curve](http://www.nefin.com.br/spot_rate_curve.html)
* [Volatility Index](http://www.nefin.com.br/volatility_index.html)