#' Download Cost of Capital
#'
#' Downloads and aggregates cost of capital of a given industrial sector, from NEFIN's website.
#' The user can also aggregate data in a monthly (default and how raw data is provided) and yearly fashion.
#'
#' @param sector Sector to download data. It can be one of the available sectors from NEFIN's website: ''Basic', 'Construction', 'Consumer', 'Energy', 'Finance', 'Manufacturing' and 'Other'.
#' @param agg Frequency to aggregate. It can be one of 'year' (or 'yearly'). If it is NULL or 'month' (or 'monthly'), then it is the raw data from the website.
#' @param agg.func A string that represents a function to aggregate. It can be any function that dplyr's `summarise()` function handles. If missing, then `last()` is used by deafult.
#' @param progress If it is TRUE, then it shows download progress.
#'
#' @return A dataframe with the data aggregated (or not)
#'
#' @import dplyr
#' @import readxl
#' @import purrr
#' @import httr
#' @import stringr
#' @export
#'
#' @examples
#'
#' my.sector <- 'Consumer'
#' agg <- 'year'
#' agg.func <- 'last'
#'
#' \dontrun{
#' df.out <- get_sector_cost_of_capital(my.sector, agg = agg, agg.func = agg.func)
#' }
get_sector_cost_of_capital <- function(sector,
                                       agg = NULL,
                                       agg.func = NULL,
                                       progress = TRUE) {
  message(paste('Collecting data of', sector, 'sector...'))
  # check if valid sector was chosen
  if (missing(sector)) {
    stop('ERROR: Please choose a valid sector. See documentation for valid options.')
  }
  # flexibility for some risk sectors spelling
  if (sector == 'Basic' | sector == 'Basic_products' | sector == 'Basic Products') {
    sector <- 'Basic%20Products'
  }
  if (sector == 'Others') {
    sector <- 'Other'
  }

  # risk sector URL and tmp file
  root.url <-  'http://nefin.com.br/Cost%20of%20Capital/'
  url.file <- paste0(sector, '.xls')
  # read excel
  # temp file
  httr::GET(paste0(root.url, url.file),
            httr::write_disk(tmp.file <- tempfile(fileext = ".xls")))
  df <- readxl::read_excel(tmp.file)
  # add month and year separated columns
  df <-
    df %>%
    dplyr::mutate(
      year = stringr::str_split(`Month/Year`, '/', simplify = T)[, 2] %>% as.numeric,
      month = stringr::str_split(`Month/Year`, '/', simplify = T)[, 1] %>% as.numeric) %>%
    dplyr::select(year, month, dplyr::everything()) %>%
    dplyr::select(-`Month/Year`)


  # check if aggregation was required
  if (is.null(agg)) {
    return(df)
  }
  if (agg == 'month' | agg == 'monthly') {
    return(df)
  } else if (is.null(agg.func)) {
    agg.func <- 'last' # defatul if missing
    message('WARNING: aggregation function not provided. Using last() by default.')
  }
  if (agg == 'yearly' | agg == 'year') {
    df %>%
      dplyr::select(-month) %>%
      dplyr::group_by(year) %>%
      dplyr::summarise_all(dplyr::funs(!! agg.func))
  }
}
