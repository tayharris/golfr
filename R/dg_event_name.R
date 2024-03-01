#' Fetch the event name of a current tournament from DataGolf.
#'
#' @return Event name string object from current event.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
dg_event_name <- function(tour = "pga"){

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/pre-tournament?","&tour=",tour,"&key=",apikey)

  # Getting details in API
  get_response <- GET(url = call)


  # Converting content to text
  get_text <- content(get_response,
                      "text")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = FALSE)

  return(get_json$event_name)


}
