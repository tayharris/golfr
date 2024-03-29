#' Fetch Golfer Skill Ratings from DataGolf.
#'
#' @return A dataframe containing golfers skill ratings for each golfer with id as dg_id.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
dg_skill_ratings <- function(){

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/skill-ratings?&key=",apikey)

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
    relocate("dg_id","player_name")

}
