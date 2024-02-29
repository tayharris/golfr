dg_pre_tournament <- function(tour = "pga", odds_format = "percent") {

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
