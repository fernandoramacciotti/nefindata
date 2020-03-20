import pandas as pd

# constants
ROOT_URL = "http://nefin.com.br/Predictability/"
FILENAME = "loan_fees"
FILE_EXT = ".xls"
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
def get_loan_fees(agg=None, agg_func=None):
    """Download Loan Fees from NEFIN's website.
    
    Args:
        agg (str, optional): Frequency to aggregate. Either 'year' (or 'yearly') and 'month' (or 'monhtly'). Defaults to None.
        agg_func (str, optional): Function to apply at aggreagtion (e.g. 'last' or 'mean'). If it is None, then it defaults to 'last'.
    
    Returns:
        pandas.core.dataframe: Pandas dataframe with (aggregated) time series
    """
    # get url
    url = ROOT_URL + FILENAME + FILE_EXT
    # read xls
    print(f"Getting Loan Fees data...")
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
