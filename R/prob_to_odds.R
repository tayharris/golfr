#' Convert Probability to American Odds
#'
#' Converts a probability value to American odds format. American odds show how much 
#' money you would need to bet to win $100 (for favorites, negative numbers) or how 
#' much money you would win on a $100 bet (for underdogs, positive numbers).
#'
#' @param prob A numeric probability value between 0 and 1
#'
#' @return A numeric value representing American odds:
#'   * Negative values for favorites (probability >= 0.5)
#'   * Positive values for underdogs (probability < 0.5)
#'
#' @details
#' The function handles two cases:
#' * For favorites (prob >= 0.5): odds = -(prob/(1-prob)) * 100
#' * For underdogs (prob < 0.5): odds = ((1-prob)/prob) * 100
#'
#' Results are rounded to 10 decimal places to ensure consistent numerical precision.
#'
#' @examples
#' # Convert 80% probability (favorite)
#' prob_to_odds(0.8)  # Returns -400
#'
#' # Convert 20% probability (underdog)
#' prob_to_odds(0.2)  # Returns 400
#'
#' @export

prob_to_odds <- function(prob) {
  # Input validation
  if (!is.numeric(prob) || prob < 0 || prob > 1) {
    stop("Probability must be between 0 and 1")
  }
  
  # Convert probability to American odds
  odds <- if (prob >= 0.5) {
    round(-(prob / (1 - prob)) * 100, 10)
  } else {
    round(((1 - prob) / prob) * 100, 10)
  }
  
  return(odds)
}
