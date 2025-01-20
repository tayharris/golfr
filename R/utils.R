#' Make an API call to Datagolf
#'
#' @param endpoint The API endpoint
#' @param params Query parameters
#' @param base_url The base URL (defaults to feeds.datagolf.com)
#' @return The API response
#' @keywords internal
dg_api_call <- function(endpoint, params = list(), base_url = "https://feeds.datagolf.com") {
  # Add API key to params
  params$key <- dg_api_key()
  
  # Ensure consistent parameter ordering
  params <- params[order(names(params))]
  
  # Construct URL with consistent parameter ordering
  url <- file.path(base_url, endpoint)
  
  resp <- httr::GET(
    url = url,
    query = params
  )
  
  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "API request failed [%s]: %s",
        httr::status_code(resp),
        httr::content(resp, "text")
      )
    )
  }
  
  httr::content(resp)
}

#' Convert American odds to probability
#'
#' @param odds Numeric American odds (e.g., -400 or +400)
#' @return Probability between 0 and 1
#' @export
odds_to_prob <- function(odds) {
  # Special case: single NA input
  if (length(odds) == 1 && is.na(odds)) {
    return(NA_real_)
  }
  
  if (!is.numeric(odds) && !is.na(odds)) {
    stop("Odds must be numeric")
  }
  
  # For vectors, process non-NA values and keep NAs
  result <- odds
  result[!is.na(odds)] <- round(ifelse(odds[!is.na(odds)] > 0,
                                      100 / (odds[!is.na(odds)] + 100),
                                      abs(odds[!is.na(odds)]) / (abs(odds[!is.na(odds)]) + 100)), 4)
  result
}

#' Convert probability to American odds
#'
#' @param prob Numeric probability between 0 and 1
#' @return American odds (negative for favorites, positive for underdogs)
#' @export
prob_to_odds <- function(prob) {
  # Special case: single NA input
  if (length(prob) == 1 && is.na(prob)) {
    return(NA_real_)
  }
  
  if (!is.numeric(prob) && !is.na(prob)) {
    stop("Probability must be numeric")
  }
  
  if (any(prob[!is.na(prob)] < 0) || any(prob[!is.na(prob)] > 1)) {
    stop("Probability must be between 0 and 1")
  }
  
  # For vectors, process non-NA values and keep NAs
  result <- prob
  result[!is.na(prob)] <- round(ifelse(prob[!is.na(prob)] >= 0.5,
                                      -100 * prob[!is.na(prob)] / (1 - prob[!is.na(prob)]),
                                      100 * (1 - prob[!is.na(prob)]) / prob[!is.na(prob)]))
  result
} 