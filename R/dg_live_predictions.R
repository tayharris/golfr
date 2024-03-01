# Live Model Predictions
# Returns live (updating at 5 minute intervals) finish probabilities for ongoing PGA and European Tour tournaments.
# Data corresponds to Live Predictive Model page.
# Endpoint: https://feeds.datagolf.com/preds/in-play?tour=[ tour ]&dead_heat=[ dead_heat ]&odds_format=[ odds_format ]&file_format=[ file_format ]&key=374c4...
# PARAMETER
# DESCRIPTION
# OPTIONS
# tour optional
# Specifies the tour.
# pga (default), euro, opp (opposite field PGA TOUR event), alt
# dead_heat optional
# Adjusts odds for dead-heat rules.
# no (default), yes
# odds_format optional
# Specifies the odds format.
# percent (default), american, decimal, fraction
# file_format optional
# Specifies the file format.
# json (default), csv

#' Fetch DataGolf live tournament predictions for a specific tour.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @param odds_format A character string specifying the odds format (default is "percent").
#' @param format A character string specifying the file format (default is "json").
#' @return A dataframe containing predictions for a live event.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON

dg_live_predictions <- function(tour = "pga", odds_format = "percent", format = "json") {
  apikey <-  dg_api_key()

  live = "https://feeds.datagolf.com/preds/in-play?"

  call <- paste0(live, "&tour=", tour, "&odds_format=", odds_format, "&format=", format, "&key=", apikey)

  # Getting details from the API
  get <- GET(url = call)

  # Converting content to text
  get_text <- content(get, "text", encoding = "UTF-8")

  # Parsing data in JSON
  get_json <- fromJSON(get_text, flatten = TRUE)

  # Convert the 'data' list to a dataframe
  df <- as.data.frame(get_json$data)

  # Add the 'event_id' column to the dataframe
  df$event_id <- get_json$event_id

  return(df)
}


