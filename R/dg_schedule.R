#' Fetch the Tour Schedule from DataGolf.
#'
#' @param tour A character string specifying the tour name.
#' @return A dataframe containing the schedule for the specified tour.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
dg_schedule <- function(tour = "pga") {

  api_key <-  dg_api_key()

  # Construct the API call URL
  call <- paste0("https://feeds.datagolf.com/get-schedule?", "&tour=", tour, "&key=", api_key)

  # Fetch the data from the API
  get_response <- GET(url = call)
  get_text <- content(get_response, "text", encoding = "UTF-8")
  get_json <- fromJSON(get_text, flatten = TRUE)

  # Convert the JSON data to a dataframe
  get_df <- get_json[["schedule"]]

  return(get_df)
}
