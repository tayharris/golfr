# period optional
# Specifies time period.
# l24 (last 24 months) (default), l12 (last 12 months), ytd (year to date)

#' Fetch Golfer Approach Skill Breakdown from DataGolf.
#'
#' @return A dataframe containing golfers and their approach skill in the specified period.
#' @param period (default = "l24, last 24 months) other param options l12 (last 12 months) ytd (year to date).
#' @export
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
dg_approach <- function(period = "l24"){
  file_format = "json" # someday can make this a function param value if we want to support the csv input.
  # Check if 'period' is not one of the allowed values
  if (!period %in% c("l24", "l12", "ytd")) {
    stop("period is not a recognized value. Please use one of 'l24', 'l12', 'ytd'.")
  }

  apikey <-  dg_api_key()

  call <- paste0("https://feeds.datagolf.com/preds/approach-skill?period=",period,"&file_format=",file_format,"&key=",apikey)

  # Getting details in API
  get <- GET(url = call)


  # Converting content to text
  get_text <- content(get,
                      "text")

  # Parsing data in JSON
  get_json <- fromJSON(get_text,
                       flatten = FALSE)

  get_df <- as.data.frame(get_json)

}
