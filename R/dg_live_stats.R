# Returns live strokes-gained and traditional stats for every player during PGA Tour tournaments.
# Data corresponds to Live Tournament Stats page.
# Endpoint: https://feeds.datagolf.com/preds/live-tournament-stats?stats=[ stats ]&round=[ round ]&display=[ display ]&file_format=[ file_format ]&key

# PARAMETER
# DESCRIPTION
# OPTIONS
# stats optional
# Comma-separated list of statistics to be returned.
# sg_putt, sg_arg, sg_app, sg_ott, sg_t2g, sg_bs, sg_total, distance, accuracy, gir, prox_fw, prox_rgh, scrambling
# round optional
# Specifies the round.
# event_avg, 1, 2, 3, 4
# display optional
# Specifies how stats are displayed.
# value (default), rank
# file_format optional
# Specifies the file format.
# json (default), csv
#' Fetch Live Stats of Current Tournament from DataGolf.
#'
#' @param tour A character string specifying the tour name (default is "pga").
#' @param stats A vector string of stats with (default is "sg_ott", "distance", "accuracy", "sg_app", "gir", "prox_fw", "sg_putt", "scrambling").
#' @param round A character string specifying if single round or event average (default is "event_avg").
#' @param display A character string specifying how stats are displayed if value or rank (default is "value").
#' @param file_format A character string specifying the file format (default is "json").
#' @return A dataframe containing betting market matchups for current week tour tournament with a set market of full tournament, round, or threeball.
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON

dg_live_stats <- function(stats = c("sg_ott", "distance", "accuracy", "sg_app", "gir", "prox_fw", "sg_putt", "scrambling"),
                          round = "event_avg", tour = "pga", display = "value", file_format = "json") {

  # Ensure stats is a comma-separated string, even if input as a vector
  stats <- if (is.character(stats)) {
    if (length(stats) > 1) {
      paste(stats, collapse = ",")
    } else {
      stats
    }
  } else {
    stop("stats must be a character vector.")
  }

  apikey <- dg_api_key()

  live_url <- "https://feeds.datagolf.com/preds/live-tournament-stats?"

  call <- paste0(live_url, "stats=", stats, "&round=", round, "&tour=", tour,
                 "&display=", display, "&file_format=", file_format, "&key=", apikey)

  # Making the API call
  response <- GET(url = call)

  # Converting content to text
  content_text <- content(response, "text", encoding = "UTF-8")

  # Parsing data from JSON
  parsed_data <- fromJSON(content_text, flatten = TRUE)

  return(parsed_data[["data"]])
}
