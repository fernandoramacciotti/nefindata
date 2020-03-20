import pandas as pd


# constants
ROOT_URL = "http://nefin.com.br/Risk%20Factors/"
FILE_EXT = ".xls"
FACTORS_FILES = {
    "Mkt": ROOT_URL + "Market_Factor" + FILE_EXT,
    "Market": ROOT_URL + "Market_Factor" + FILE_EXT,
    "Rm_minus_Rf": ROOT_URL + "Market_Factor" + FILE_EXT,
    "SMB": ROOT_URL + "SMB_Factor" + FILE_EXT,
    "HML": ROOT_URL + "HML_Factor" + FILE_EXT,
    "WML": ROOT_URL + "WML_Factor" + FILE_EXT,
    "IML": ROOT_URL + "IML_Factor" + FILE_EXT,
    "Rf": ROOT_URL + "Risk_Free" + FILE_EXT,
    "Risk_free": ROOT_URL + "Risk_Free" + FILE_EXT,
    "Risk Free": ROOT_URL + "Risk_Free" + FILE_EXT,
    "Risk free": ROOT_URL + "Risk_Free" + FILE_EXT,
    "Risk-free": ROOT_URL + "Risk_Free" + FILE_EXT,
    "Risk-Free": ROOT_URL + "Risk_Free" + FILE_EXT,
}
# dict with aggregation name and pandas resampling frequency
RESAMPLE_FREQ = {
    "month": "BM",
    "monthly": "BM",
    "year": "BY",
    "yearly": "BY",
}
# Identity aggregations
IDENTITY_AGG = ["day", "daily", None]

# functions
def get_single_risk_factor(factor, agg=None, agg_func=None):
    """Download a risk factor time series data from NEFIN's website.
    
    Args:
        factor (str): Risk factor to download. Options are: 'Market', 'SMB', 'HML', 'WML', 'IML' and 'Rf'.
        agg (str, optional): Frequency to aggregate. Either 'year' (or 'yearly') and 'month' (or 'monhtly'). Defaults to None.
        agg_func (str, optional): Function to apply at aggreagtion (e.g. 'last' or 'mean'). If it is None, then it defaults to 'last'.
    
    Returns:
        pandas.core.dataframe: Pandas dataframe with (aggregated) time series of chosen risk factor
    """
    # get url
    url = FACTORS_FILES[factor]
    # read xls
    print(f"Getting data for factor {factor}...")
    df = pd.read_excel(url)
    # set index as a datetime from columns year, month, day
    dt = [f"{y}-{m}-{d}" for y, m, d in zip(df.year, df.month, df.day)]
    df["datetime"] = pd.to_datetime(dt, format="%Y-%m-%d")
    df.set_index(["datetime"], inplace=True)
    df.drop(["year", "month", "day"], axis=1, inplace=True)

    # aggregate if desired
    if agg not in IDENTITY_AGG:
        if agg_func is None:
            print(
                "\n\nWARNING: aggregation function not provided. Using last() by default\n"
            )
            agg_func = "last"
        # resample
        df = df.resample(RESAMPLE_FREQ[agg]).apply(agg_func)
    print("Done!")
    return df


def get_risk_factors(factors=None, agg=None, agg_func=None):
    """Download a risk factor time series data from NEFIN's website.
    
    Args:
        factors (str or list-like): Risk factors to download. Options are one or more out of: 'Market', 'SMB', 'HML', 'WML', 'IML' and 'Rf'. If 'all' or None, then all factors will be downloaded.
        agg (str, optional): Frequency to aggregate. Either 'year' (or 'yearly') and 'month' (or 'monhtly'). Defaults to None.
        agg_func (str, optional): Function to apply at aggreagtion (e.g. 'last' or 'mean'). If it is None, then it defaults to 'last'.
    
    Returns:
        pandas.core.dataframe: Pandas dataframe with (aggregated) time series of chosen risk factors
    """
    # all factors conditions
    if (factors is None) or (isinstance(factors, str) and factors == "all"):
        factors = ["Market", "SMB", "HML", "WML", "IML", "Rf"]
    # if just one, then convert to list (for iteration)
    if isinstance(factors, str) and factors in FACTORS_FILES.keys():
        factors = [factors]
    # holder of partial data frames
    list_dfs = list()
    # checker for duplicated factors (due to name flexibilities for some factors)
    urls_visited = list()
    # loop over desired factors
    for factor in set(factors):  # set to avoid duplicated
        if factor in urls_visited:
            continue
        else:
            urls_visited.append(FACTORS_FILES[factor])
        list_dfs.append(get_single_risk_factor(factor, agg=agg, agg_func=agg_func))

    # concat all
    return pd.concat(list_dfs, axis=1, join="outer")
