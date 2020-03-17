require(readxl)
require(dplyr)
require(purrr)

isSingleString <- function(input) {
  is.character(input) & length(input) == 1
}

# download more than one risk factor and concatenate into single tibble
get_risk_factors <- function(factors, 
                             agg = 'month', 
                             agg.func = 'last',
                             progress = TRUE) {
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
