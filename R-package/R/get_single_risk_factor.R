#' Download Risk Factor
#'
#' Downloads and aggregates a chosen risk factor data from NEFIN's website.
#' The user can also aggregate data in a daily (default and how raw data is provided), monthly and yearly fashion.
#'
#' @param factor Risk factor to download. It can be one of the available factors from NEFIN's website: 'Market', 'SMB', 'HML', 'WML', 'IML', 'Rf' (Risk-free).
#' @param agg Frequency to aggregate. It can be one of 'year' (or 'yearly') and ('month' or 'monthly'). If it is NULL or 'day' (or 'daily'), then it is the raw data from the website.
#' @param agg.func A string that represents a function to aggregate. It can be any function that dplyr's `summarise()` function handles. If missing, then `last()` is used by deafult.
#' @param progress If it is TRUE, then it shows download progress.
#'
#' @return A dataframe with the data aggregated (or not)
#'
#' @import dplyr
#' @import readxl
#' @import purrr
#' @import httr
#' @export
#'
#' @examples
#'
#' my.factor <- 'Market'
#' agg <- 'month'
#' agg.func <- 'last'
#'
#' \dontrun{
#' df.out <- get_single_risk_factor(my.factor, agg = agg, agg.func = agg.func)
#' }
get_single_risk_factor <- function(factor,
                                   agg = 'daily',
                                   agg.func = NULL,
                                   progress = TRUE) {
  message(paste('Collecting data for factor', factor))
  # check if valid factor was chosen
  if (missing(factor)) {
    stop('ERROR: Please choose a valid risk factor. See documentation for valid options.')
  }
  # flexibility for some risk factors spelling
  if (factor == 'Mkt' | factor == 'Rm_minus_Rf') {
    factor <- 'Market'
  }
  if (factor == 'Risk Free' | factor == 'Risk free' | factor == 'Rf' | factor == 'Risk-free' | factor == 'Risk-Free') {
    factor <- 'Rf'
  }

  # risk factor URL and tmp file
  root.url <-  'http://nefin.com.br/Risk%20Factors/'
  if (factor == 'Rf') {
    # Risk free file patterns is different
    url.file <- 'Risk_Free.xls'
  } else {
    url.file <- paste0(factor, '_Factor.xls')
  }
  # read excel
  # temp file
  httr::GET(paste0(root.url, url.file),
            httr::write_disk(tmp.file <- tempfile(fileext = ".xls")))
  df <- readxl::read_excel(tmp.file)
  value.col <- names(df)[length(names(df))]

  # check if aggregation was required
  if (agg == 'daily' | agg == 'day' | is.null(agg)) {
    return(df)
  } else if (is.null(agg.func)) {
    agg.func <- 'last' # defatul if missing
    message('WARNING: aggregation function not provided. Using last() by default')
  }
  if (agg == 'monthly' | agg == 'month') {
    df %>%
      dplyr::select(-day) %>%
      dplyr::group_by(year, month) %>%
      dplyr::summarise_all(dplyr::funs(!! agg.func))
  } else if (agg == 'yearly' | agg == 'year') {
    df %>%
      dplyr::select(-day, -month) %>%
      dplyr::group_by(year) %>%
      dplyr::summarise_all(dplyr::funs(!! agg.func))
  }
}
