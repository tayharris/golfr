# Match-Up & 3-Ball Odds
# Returns the most recent tournament match-up, round match-up, and 3-ball odds offered at 8 sportsbooks alongside the corresponding prediction from our model.
# To view a list of sportsbooks currently being tracked, visit this page.
# Data corresponds to 3 Ball & Matchups Betting Tool page.
# Endpoint: https://feeds.datagolf.com/betting-tools/matchups?tour=[ tour ]&market=[ market ]
# &odds_format=[ odds_format ]&file_format=[ file_format ]&key=374c4...
# PARAMETER
# DESCRIPTION
# OPTIONS
# tour optional
# Specifies the tour.
# pga (default), euro, opp (opposite field PGA TOUR event), alt
# market required
# Specifies the match-up market.
# tournament_matchups, round_matchups, 3_balls
# odds_format optional
# Specifies the odds format.
# percent, american, decimal (default), fraction
# file_format optional
# Specifies the file format.
# json (default), csv




dg_matchups <- function(tour = "pga", market = "tournament_matchups",odds_format = "percent"){

  apikey <-  dg_api_key()


  call <- paste0("https://feeds.datagolf.com/betting-tools/matchups?","&tour=",tour,"&market=",market,"&odds_format=",odds_format,"&key=",apikey)

  # Getting details in API
  get_pre <- GET(url = call)


  # Converting content to text
  get_pre_text <- content(get_pre,
                          "text", encoding = "UTF-8")
  get_pre_text

  # Parsing data in JSON
  get_pre_json <- jsonlite::fromJSON(get_pre_text,
                                     flatten = TRUE)
  get_pre_json

  # Converting into dataframe
  df <- as.data.frame(get_pre_json$match_list)
  return(df)
}
