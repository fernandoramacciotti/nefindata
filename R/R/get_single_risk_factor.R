#' Download Risk Factor
#'
#' Downloads and aggregates a chosen risk factor data from NEFIN's website.
#' The user can also aggregate data in a daily (default and how raw data is provided), monthly and yearly fashion.
#'
#' @param factor Risk factor to download. It can be one of the available factors from NEFIN's website: 'Market', 'SMB', 'HML', 'WML', 'IML', 'Rf' (Risk-free).
#' @param agg Frequency to aggregate. It can be one of 'year' (or 'yearly') and ('month' or 'monthly'). If it is NULL or 'day' (or 'daily'), then it is the raw data from the website.
#' @param agg.func A string that represents a function to aggregate. It can be any function that dplyr's `summarise()` function handles.
#' @param progress If it is TRUE, then it shows download progress.
#'
#' @return A dataframe with the data aggregated (or not)
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
                                   agg.func = 'last',
                                   progress = TRUE) {
  # check if valid factor was chosen
  if (missing(factor)) {
    stop('ERROR: Please choose a valid risk factor. See documentation for valid options.')
  }

  # risk factor URL and tmp file
  root.url <-  'http://nefin.com.br/Risk%20Factors/'
  if (factor == 'Rf') {
    # Risk free file patterns is different
    url.file <- 'Risk_Free.xls'
  } else {
    url.file <- paste0(factor, '_Factor.xls')
  }

  # create tmp if not exists (if so it does not crash)
  tmp.folder <- 'tmp-nefin'
  dir.create(file.path(getwd(), tmp.folder), showWarnings = FALSE)
  tmp.file <- file.path(getwd(), tmp.folder, url.file)

  # remove possible downloaded tmp file
  try({
    file.remove(tmp.file)
  })

  # download
  try({
    utils::download.file(
      url = paste0(root.url, url.file),
      method = 'auto',
      mode = "wb",
      quiet = !progress,
      destfile = tmp.file)
  })

  # read excel
  df <- readxl::read_excel(tmp.file)
  value.col <- names(df)[length(names(df))]

  # check if aggregation was required
  if (agg == 'daily' | agg == 'day' | is.null(agg)) {
    return(df)
  } else if (missing(agg.func)) {
      stop('ERROR: must provide function to aggregate')
    } else if (agg == 'monthly' | agg == 'month') {
      df %>%
        select(-day) %>%
        dplyr::group_by(year, month) %>%
        dplyr::summarise_all(funs(!! agg.func))
    } else if (agg == 'yearly' | agg == 'year') {
      df %>%
        select(-day, -month) %>%
        dplyr::group_by(year) %>%
        dplyr::summarise_all(funs(!! agg.func))
    }
}
