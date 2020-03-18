# nefindata
Functions to download data from NEFIN, the Brazilian Center for Research in Financial Economics of the University of São Paulo (http://www.nefin.com.br/)


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
