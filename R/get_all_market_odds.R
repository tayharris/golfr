#' Get All Market Odds
#' Fetches aggregated market odds for specified tours from DataGolf.
#' This function collects odds across several markets (win, top 5, top 10, top 20),
#' calculates consensus probabilities and odds, and returns a consolidated dataframe.
#' @param tour A character string specifying the tour for which to fetch odds.
#'   Recognized values are "pga", "euro", "opp", "liv", and "alt".
#'   The default is "pga".
#' @return A dataframe containing market odds, with consensus probabilities and odds.
#'   Each market's odds are suffixed with the market type (e.g., "_win").
#' @importFrom dplyr rowwise mutate ungroup rename_with select full_join c_across
#' @importFrom purrr reduce
#' @export

get_all_market_odds <- function(tour = "pga", market = "win") {
  odds_df <- dg_outrights(tour = tour, market = market, odds_format = "percent") %>%
    rowwise() %>%
    mutate(
      consensus_prob = mean(c_across(where(is.numeric) & !matches("dg_id")), na.rm = TRUE)
    ) %>%
    ungroup() %>%
    mutate(
      consensus_odds = ifelse(is.na(consensus_prob), NA, prob_to_odds(consensus_prob))
    )
  
  return(odds_df)
}
