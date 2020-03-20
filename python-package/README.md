# nefindata
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/fernandoramacciotti/nefindata/blob/master/LICENSE) 
[![Documentation Status](https://readthedocs.org/projects/nefindata/badge/?version=latest)](http://nefindata.readthedocs.io/?badge=latest) 
[![PyPI pyversions](https://img.shields.io/pypi/pyversions/nefindata.svg)](https://pypi.python.org/pypi/nefindata/) 
[![PyPI version fury.io](https://badge.fury.io/py/nefindata.svg)](https://pypi.python.org/pypi/nefindata/) 
[![PyPI download total](https://img.shields.io/pypi/dt/nefindata.svg)](https://pypi.python.org/pypi/nefindata/) 

Python and R packages to download data from NEFIN, the Brazilian Center for Research in Financial Economics of the University of São Paulo (http://www.nefin.com.br/)

# Installation
The python package can be installed via pip. Run the following command:
```sh
pip install nefindata
```

# Risk Factors
Collect data of risk factors such as Market Factor, SMB, WML, HML, IML and Risk Free.

Usage example:
```python
from nefindata.risk_factors import get_risk_factors

factors = ['Mkt', 'SMB'] # for all factors, set it to 'all' or None
df = get_risk_factors(factors)
df_agg = get_risk_factors(factors, agg='month', agg_func='last')
```

# Cost of Capital
Collect data of cost of capital for industrial sectors such as Basic Products, Construction, Consumer, Energy, Finance, Manufacturing and Other.
Data is available for 1, 5, 10 and 20-year projects.

Usage example:
```python
from nefindata.cost_capital import get_sector_cost_of_capital

sector = 'Basic'
df = get_sector_cost_of_capital(sector)
df_agg = get_sector_cost_of_capital(sector, agg='year', agg_func='last')
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