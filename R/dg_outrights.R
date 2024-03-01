# Outright (Finish Position) Odds
# Returns the most recent win, top 5, top 10, top 20, make/miss cut, and first round leader odds offered at 11 sportsbooks alongside the corresponding predictions from our model.
# To view a list of sportsbooks currently being tracked, visit this page.
# Data corresponds to Finish Position Betting Tool page.
# Endpoint: https://feeds.datagolf.com/betting-tools/outrights?tour=[ tour ]&market=[ market ]
# &odds_format=[ odds_format ]&file_format=[ file_format ]&key=374c4...
# PARAMETER
# DESCRIPTION
# OPTIONS
# tour optional
# Specifies the tour.
# pga (default), euro, kft, opp (opposite field PGA TOUR event), alt
# market required
# Specifies the match-up market.
# win, top_5, top_10, top_20, mc, make_cut, frl
# odds_format optional
# Specifies the odds format.
# percent, american, decimal (default), fraction
# file_format optional
# Specifies the file format.
# json (default), csv
#' Fetches betting market matchups for current week tour tournament with a set market for win, top 5, top 10, top 20, miss cut, make cut, and first round leader.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @param market A character string specifying the market (default is "win").
#' @param odds_format A character string specifying the odds format (default is "percent").
#' @param file_format A character string specifying the file format (default is "json").
#' @return A dataframe containing betting market matchups for current week tour tournament with a set market of full tournament, round, or threeball.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr relocate

dg_outrights <- function(tour = "pga", market = "win", odds_format = "percent", file_format = "json"){

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/betting-tools/outrights?","&tour=",tour,"&market=",market,"&odds_format=",odds_format,"&file_format=",file_format,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text", encoding = "UTF-8")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = TRUE)

  # Converting into dataframe
  get_df <- as.data.frame(get_json$odds) %>%
    relocate("dg_id","player_name")

}
