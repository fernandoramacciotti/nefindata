import pandas as pd


# constants
ROOT_URL = "http://nefin.com.br/Risk%20Factors/"
FILENAME = "Market_Liquidity"
FILE_EXT = ".xls"
# dict with aggregation name and pandas resampling frequency
RESAMPLE_FREQ = {
    "year": "BY",
    "yearly": "BY",
}
# Identity aggregations
IDENTITY_AGG = ["day", "daily", "month", "monthly", None]

# functions
def get_illiquidity_index(agg=None, agg_func=None):
    """Download Market Illiquidity Index data from NEFIN's website.
    
    Args:
        agg (str, optional): Frequency to aggregate. Either 'year' or 'yearly'. Defaults to None. Monthly data is the default.
        agg_func (str, optional): Function to apply at aggreagtion (e.g. 'last' or 'mean'). If it is None, then it defaults to 'last'.
    
    Returns:
        pandas.core.dataframe: Pandas dataframe with (aggregated) time series
    """
    # get url
    url = ROOT_URL + FILENAME + FILE_EXT
    # read xls
    print(f"Getting Market Illiquidity Index data...")
    df = pd.read_excel(url)
    # set index as a datetime from columns year, month, day
    dt = [f"{y}-{m}-01" for y, m in zip(df.year, df.month)]
    df["datetime"] = pd.to_datetime(dt, format="%Y-%m")
    df.set_index(["datetime"], inplace=True)
    df.drop(["year", "month"], axis=1, inplace=True)

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
