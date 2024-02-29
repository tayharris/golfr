
dg_live_stats <- function(round = "event_avg", tour = "pga", display = "value"){

  apikey <-  dg_api_key()

  live = "https://feeds.datagolf.com/preds/live-tournament-stats?"

  call <- paste0(live,"&round=",round,"&tour=",tour,"&display=",display,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text", encoding = "UTF-8")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = TRUE)

  return(get_json[["data"]])

}
