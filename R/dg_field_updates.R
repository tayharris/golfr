#' Fetch Field Updates from DataGolf.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @return A dataframe containing field updates for the specified tour.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
dg_field_updates <- function(tour = "pga") {

  api_key <- dg_api_key()

  # Construct the API call URL
  call <- paste0("https://feeds.datagolf.com/field-updates?", "&tour=", tour, "&key=", api_key)

  # Fetch the data from the API
  get_response <- GET(url = call)
  get_text <- content(get_response, "text", encoding = "UTF-8")
  get_json <- fromJSON(get_text, flatten = TRUE)

  # Convert the JSON data to a dataframe
  get_df <- as.data.frame(get_json)

  return(get_df)
}
