#' Fetch Live Status Info from DataGolf.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @return A dataframe containing status info of current tournament for given tour.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON

dg_live_status <- function(tour = "pga", odds_format = "percent"){

  apikey <-  dg_api_key()

  live = "https://feeds.datagolf.com/preds/in-play?"

  call <- paste0(live,"&tour=",tour, "&odds_format=",odds_format,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text", encoding = "UTF-8")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = TRUE)

  # Converting into dataframe
  df <- as.data.frame(get_json$info)

  return(df)

}


