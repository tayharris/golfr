#' Fetch Historical Predictions from DataGolf.
#'
#' @param event_id string of event id (default is "14") The Masters.
#' @param year string of year (default is "2022").
#' @param odds_format A character string specifying the odds format (default is "percent").
#' @return A dataframe of raw data from a historical event prediction.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'


dg_historical_predictions <- function(
    event_id = "14",
    year = "2022",
    odds_format = "percent",
    format = "json"
){

  apikey <- dg_api_key()

  call <- paste0(
    "https://feeds.datagolf.com/preds/pre-tournament-archive?",

    "&event_id=", event_id,

    "&year=", year,

    "&odds_format=", odds_format,

    "&format=", format,

    "&key=", apikey

  )

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text", encoding = "UTF-8")


  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = TRUE)

  # Check if `$baseline_history_fit` exists and return it if it does,
  # otherwise return `$baseline`
  if (!is.null(get_json$baseline_history_fit)) {
    # Convert the desired part of the list to a dataframe
    result_df <- as.data.frame(get_json$baseline_history_fit)
  } else if (!is.null(get_json$baseline)) {
    # Convert the desired part of the list to a dataframe
    result_df <- as.data.frame(get_json$baseline)
  } else {
    stop("Neither baseline_history_fit nor baseline is available in the response.")
  }

  return(result_df)
}
