#' Fetch Field Updates from DataGolf.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @param odds_format A character string specifying the odds format (default is "percent").
#' @param format A character string specifying the format (default is "json").
#' @return A dataframe containing field updates for the specified tour.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr relocate
#'
dg_player_decomp <- function(tour = "pga",odds_format ="percent", format = "json"){

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/player-decompositions?","&tour=",tour,"&format=",format,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text", encoding = "UTF-8")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = TRUE)

  # Converting into dataframe
  get_df <- as.data.frame(get_json$players) |>
    relocate("dg_id","player_name","country","sample_size")

}
