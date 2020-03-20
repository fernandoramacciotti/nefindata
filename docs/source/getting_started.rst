===============
Getting started
===============

Installation
------------
The python package can be installed via pip. Run the following command::

    pip install nefindata


The R package can be installed via `devtools <https://github.com/r-lib/devtools>`_ package. Make sure you have it installed and then run the following command::

    # install.packages('devtools') # uncomment if devtools needs to be installed
    devtools::install_github('fernandoramacciotti/nefindata/R')


Basic Usage
-----------

Risk Factors
############
Collect data of risk factors such as Market Factor, SMB, WML, HML, IML and Risk Free, from `NEFIN's website <http://www.nefin.com.br/risk_factors.html`>_.

Python package example::

    from nefindata.risk_factors import get_risk_factors

    factors = ['Mkt', 'SMB'] # for all factors, set it to 'all' or None
    df = get_risk_factors(factors)
    df_agg = get_risk_factors(factors, agg='month', agg_func='last')


R package example::

    library(nefindata)

    factors <- c('Mkt', 'SMB') # for all factors, set it to 'all'
    df <- get_risk_factors(factors)
    df.agg <- get_risk_factors(factors, agg = 'month', agg.func = 'last')



Cost of Capital
###############
Collect data of cost of capital for industrial sectors such as Basic Products, Construction, Consumer, Energy, Finance, Manufacturing and Other, from `NEFIN's website <http://www.nefin.com.br/cost_of_capital.html>`_.
Data is available for 1, 5, 10 and 20-year projects.

Python package example::

    from nefindata.cost_capital import get_sector_cost_of_capital

    sector = 'Basic'
    df = get_sector_cost_of_capital(sector)
    df_agg = get_sector_cost_of_capital(sector, agg='year', agg_func='last')


R package example::

    library(nefindata)

    sector <- 'Basic'
    df <- get_sector_cost_of_capital(sector)
    df.agg <- get_sector_cost_of_capital(sector, agg = 'year', agg.func = 'last')



Other data
##########

Similar functions get other data such as. The syntax is similar as above and are provided for both R and Python packages.

- `Dividend Yield <http://www.nefin.com.br/dividend_yield.html>`_: `get_dividend_yield()`
- `Illiquidity Index <http://www.nefin.com.br/illiquidity_index.html>`_: `get_illiquidity_index()`
- `Loan Fees <http://www.nefin.com.br/loan_fees.html>`_: `get_load_fees()`
- `Short Interest <http://www.nefin.com.br/short_interest.html>`_: `get_short_interest()`
