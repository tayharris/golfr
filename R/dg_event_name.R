
dg_event_name <- function(tour = "pga"){

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/pre-tournament?","&tour=",tour,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = FALSE)

  return(get_json$event_name)


}
