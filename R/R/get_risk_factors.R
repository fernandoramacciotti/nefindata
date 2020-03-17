#' Download One or More Risk Factors
#'
#' Downloads and aggregates a chosen risk factors data from NEFIN's website. If more than one factor is provided, then the resulting data frame is the full join of single factor's dataframe.
#' The user can also aggregate data in a daily (default and how raw data is provided), monthly and yearly fashion.
#'
#' @param factors Risk factors to download. If it is 'all', then all factors are concatenated. It can be one or more of the available factors from NEFIN's website: 'Market', 'SMB', 'HML', 'WML', 'IML', 'Rf' (Risk-free).
#' @param agg Frequency to aggregate. It can be one of 'year' (or 'yearly') and ('month' or 'monthly'). If it is NULL or 'day' (or 'daily'), then it is the raw data from the website.
#' @param agg.func A string that represents a function to aggregate. It can be any function that dplyr's `summarise()` function handles.
#' @param progress If it is TRUE, then it shows download progress.
#'
#' @return A dataframe with the data aggregated (or not)
#' @export
#'
#' @examples
#'
#' agg <- 'month'
#' agg.func <- 'last'
#'
#' df.out <- get_risk_factors('all', agg = agg, agg.func = agg.func)
#' print(head(df.out))
get_risk_factors <- function(factors,
                             agg = 'month',
                             agg.func = 'last',
                             progress = TRUE) {
  # check if string
  isSingleString <- function(input) {
    is.character(input) & length(input) == 1
  }
  # check if valid factor was chosen
  if (missing(factors)) {
    stop('ERROR: Please choose a valid risk factor. See documentation for valid options.')
  }
  # all factors
  all.factors <- c('Market', 'SMB', 'HML', 'WML', 'IML', 'Rf')
  # check if factors is string and is 'all'
  if (isSingleString(factors)) {
    if (tolower(factors) == 'all') {
      factors <- all.factors
    }
  }

  # init empty df with columns
  if (agg == 'daily' | agg == 'day') {
    df <- dplyr::tibble(year = numeric(), month = numeric(), day = numeric())
  } else {
    df <- dplyr::tibble(year = numeric(), month = numeric())
  }
  # loop over factors
  for (factor in factors) {
    # download risk df
    tmp <- get_single_risk_factor(factor = factor,
                                  agg = agg,
                                  agg.func = agg.func,
                                  progress = progress)
    # full join
    df <-
      df %>%
      dplyr::full_join(tmp)
  }
  # return
  df
}
