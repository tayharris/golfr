#' Fetch Historical Raw Data for Tournament from DataGolf.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @param year A character string specifying the year of the tournament (default is "2022").
#' @param event_id A character string specifying the event id of the tournament (default is "14") Scottie Scheffler Masters.
#' @return A dataframe containing raw data from the tournament with nested objects of scores, then nested rounds.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
dg_historical_raw_data <- function(
    year = "2022",
    event_id = "14",
    tour = "pga"

){

  apikey <- dg_api_key()

  call <- paste0(
    "https://feeds.datagolf.com/historical-raw-data/rounds?tour=",tour,"&event_id=",event_id,"&year=",year,"&key=",apikey
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
