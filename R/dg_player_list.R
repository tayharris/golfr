#' Fetch the Player List from DataGolf.
#'
#' @return A dataframe containing the list of players.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
dg_player_list <- function() {

  api_key <- get_api_key()

  # Construct the API call URL
  call <- paste0("https://feeds.datagolf.com/get-player-list?", "&key=", api_key)

  # Fetch the data from the API
  get_response <- GET(url = call)
  get_text <- content(get_response, "text", encoding = "UTF-8")
  get_json <- fromJSON(get_text, flatten = TRUE)

  # Convert the JSON data to a dataframe
  get_df <- as.data.frame(get_json)

  return(get_df)
}
