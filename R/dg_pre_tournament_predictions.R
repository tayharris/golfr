#' Fetch Historical Predictions from DataGolf.
#'
#' @param tour string of tour to get back current week predictions for before tournament start (default is "pga").
#' @param odds_format A character string specifying the odds format (default is "percent").
#' @return A dataframe of event prediction.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'

dg_pre_tournament_predictions <- function(tour = "pga", odds_format = "percent") {

  # Check if 'tour' is not one of the allowed values
  if (!tour %in% c("pga", "euro", "opp", "liv", "alt")) {
    stop("tour is not a recognized value. Please use one of 'pga', 'euro', 'opp', 'liv', 'alt'.")
  }

  # Check if 'odds_format' is not one of the allowed values
  if (!odds_format %in% c("percent", "american", "decimal", "fraction")) {
    stop("odds_format is not a recognized value. Please use one of 'percent', 'american', 'decimal', 'fraction'.")
  }

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/pre-tournament?","&tour=",tour,"&odds_format=",odds_format,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)

  # Converting content to text
  get_text <- content(get, "text")

  # Parsing data in JSON
  get_json <- fromJSON(get_text, flatten = FALSE)

  # Extract the baseline_history_fit data
  df <- get_json[["baseline_history_fit"]]

  # Add the event_name column to the data frame
  df$event_name <- get_json$event_name

  df$tour <- tour

  return(df)
}
