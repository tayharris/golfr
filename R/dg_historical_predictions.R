# Historical archive of our PGA Tour pre-tournament predictions.
# Data corresponds to Predictions Archive page.
# Endpoint: https://feeds.datagolf.com/preds/pre-tournament-archive?event_id=[ event_id ]&year=[ year ]&odds_format=[ odds_format ]&file_format=[ file_format ]&key=374c4...
# PARAMETER
# DESCRIPTION
# OPTIONS
# event_id optional
# Specifies the event.

# year optional
# Specifies the calendar year (not season) of the event.
# 2020, 2021, 2022 (default)

# odds_format optional
# Specifies the odds format.
# percent (default), american, decimal, fraction



dg_historical_preds <- function(
    event_id = "14",
    year = "2022",
    odds_format = "percent"
){

  apikey <- dg_api_key()

  call <- paste0(
    "https://feeds.datagolf.com/preds/pre-tournament-archive?",

    "&event_id=", event_id,

    "&year=", year,

    "&odds_format=", odds_format,

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

  # Converting into dataframe
  get_df <- as.data.frame(get_json)

  return(get_json)

}
