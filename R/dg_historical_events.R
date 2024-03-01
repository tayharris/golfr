#' Fetch Historical Event List DataGolf.
#'
#' @return A dataframe of all historical events.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
dg_historical_events <- function(){

  apikey <-  dg_api_key()

  call <- paste0(
    "https://feeds.datagolf.com/historical-raw-data/event-list?&key=",apikey
  )

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text", encoding = "UTF-8")


  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = TRUE)

  # Converting into dataframe
  get_df <- as.data.frame(get_json)

  return(get_df)

}
