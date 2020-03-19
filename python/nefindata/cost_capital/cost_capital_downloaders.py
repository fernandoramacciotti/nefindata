import pandas as pd


# constants
ROOT_URL = "http://nefin.com.br/Cost%20of%20Capital/"
FILE_EXT = ".xls"
SECTORS_FILES = {
    "Basic": ROOT_URL + "Basic%20Products" + FILE_EXT,
    "Basic Products": ROOT_URL + "Basic%20Products" + FILE_EXT,
    "Basic_Products": ROOT_URL + "Basic%20Products" + FILE_EXT,
    "Basic_products": ROOT_URL + "Basic%20Products" + FILE_EXT,
    "Construction": ROOT_URL + "Construction" + FILE_EXT,
    "Consumer": ROOT_URL + "Consumer" + FILE_EXT,
    "Energy": ROOT_URL + "Energy" + FILE_EXT,
    "Finance": ROOT_URL + "Finance" + FILE_EXT,
    "Manufacturing": ROOT_URL + "Manufacturing" + FILE_EXT,
    "Other": ROOT_URL + "Other" + FILE_EXT,
    "Others": ROOT_URL + "Other" + FILE_EXT,
}
# dict with aggregation name and pandas resampling frequency
RESAMPLE_FREQ = {
    "year": "BY",
    "yearly": "BY",
}
# Identity aggregations
IDENTITY_AGG = ["day", "daily", "month", "monthly", None]

# functions
def get_sector_cost_of_capital(sector, agg=None, agg_func=None):
    """Download data of an industrial sector cost of capital from NEFIN's website.
    Data is available for 1, 5, 10 and 20-year projects.
    
    Args:
        sector (str): Industry sector to download. Options are: 'Basic', 'Construction', 'Consumer', 'Energy', 'Finance', 'Manufacturing' and 'Other'.
        agg (str, optional): Frequency to aggregate. Either 'year' or 'yearly'). Defaults to None.
        agg_func (str, optional): Function to apply at aggreagtion (e.g. 'last' or 'mean'). If it is None, then it defaults to 'last'.
    
    Returns:
        pandas.core.dataframe: Pandas dataframe with (aggregated) time series of chosen sector
    """
    # get url
    url = SECTORS_FILES[sector]
    # read xls
    print(f"Getting data of {sector} sector...")
    df = pd.read_excel(url)
    # set index as a datetime from columns year, month, day
    df["datetime"] = pd.to_datetime(df["Month/Year"], format="%m/%Y")
    df.set_index(["datetime"], inplace=True)
    df.drop(["Month/Year"], axis=1, inplace=True)

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
