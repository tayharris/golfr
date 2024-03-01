#' Fetch Golfer Rankings from DataGolf.
#'
#' @return A dataframe containing field updates for the specified tour.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
dg_rankings <- function(){

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/get-dg-rankings?","&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = FALSE)

  get_df <- as.data.frame(get_json$rankings) %>%
    relocate("dg_id","player_name","datagolf_rank","primary_tour","dg_skill_estimate")

}
