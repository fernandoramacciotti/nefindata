#' Download Dividend Yield
#'
#' Downloads and aggregates dividend yield data from NEFIN's website.
#' The user can also aggregate data in a daily (default and how raw data is provided), monthly and yearly fashion.
#'
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
#' agg <- 'month'
#' agg.func <- 'last'
#'
#' \dontrun{
#' df.out <- get_divdend_yield(agg = agg, agg.func = agg.func)
#' }
get_divdend_yield <- function(agg = 'daily',
                              agg.func = NULL,
                              progress = TRUE) {
  message('Collecting Dividend Yield data')
  # URL and tmp file
  root.url <-  'http://www.nefin.com.br/Predictability/'
  url.file <- 'dividend_yield.xls'
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
