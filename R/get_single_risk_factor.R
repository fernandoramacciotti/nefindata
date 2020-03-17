require(xlsx)
require(dplyr)

# download single risk factor
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
  if (agg == 'daily' | agg == 'day') {
    return(df)
  } else if (agg == 'monthly' | agg == 'month') {
    if (missing(agg.func)) {
      stop('ERROR: must provide function to aggregate')
    } else {
      df %>% 
        select(-day) %>% 
        dplyr::group_by(year, month) %>% 
        dplyr::summarise_all(funs(!! agg.func))
    }
  }
}
