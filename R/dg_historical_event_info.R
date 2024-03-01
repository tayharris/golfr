#' Fetch Info for a Historical Event from DataGolf.
#'
#' @param event_id string of event id (default is "14") The Masters.
#' @param year string of year (default is "2022").
#' @param odds_format A character string specifying the odds format (default is "percent").
#' @return A dataframe of info from a historical event.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'


dg_historical_event_info <- function(
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


  # Assuming 'parsed_data' contains the necessary fields directly or within a nested structure.
  # You might need to adjust the access method based on the actual structure of 'parsed_data'.
  # This example assumes 'parsed_data' is a list directly containing the fields.
  df <- data.frame(
    event_id = get_json$event_id,
    event_name = get_json$event_name,
    event_completed = get_json$event_completed,
    models_available = get_json$models_available
  )

  return(df)
}
