#' Download Market Illiquidity Index
#'
#' Downloads and aggregates Market Illiquidity Index data from NEFIN's website.
#' The user can also aggregate data in a monthly (default) and yearly fashion.
#'
#' @param agg Frequency to aggregate. It can be year' (or 'yearly'). If it is NULL or 'month' (or 'monthly') then it is the raw data from the website.
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
#' df.out <- get_illiquidity_index(agg = agg, agg.func = agg.func)
#' }
get_illiquidity_index <- function(agg = 'month',
                                  agg.func = NULL,
                                  progress = TRUE) {
  message('Collecting Market Illiquidity Index data')
  # URL and tmp file
  root.url <-  'http://www.nefin.com.br/Risk%20Factors/'
  url.file <- 'Market_Liquidity.xls'
  # read excel
  # temp file
  httr::GET(paste0(root.url, url.file),
            httr::write_disk(tmp.file <- tempfile(fileext = ".xls")))
  df <- readxl::read_excel(tmp.file)
  value.col <- names(df)[length(names(df))]

  # check if aggregation was required
  if (agg == 'month' | agg == 'monthly' | is.null(agg)) {
    return(df)
  } else if (is.null(agg.func)) {
    agg.func <- 'last' # defatul if missing
    message('WARNING: aggregation function not provided. Using last() by default')
  }
  if (agg == 'yearly' | agg == 'year') {
    df %>%
      dplyr::select(-day, -month) %>%
      dplyr::group_by(year) %>%
      dplyr::summarise_all(dplyr::funs(!! agg.func))
  }
}
