get_all_market_odds <- function() {

  # Predefined markets
  markets <- c("win", "top_5", "top_10", "top_20")

  # Initialize an empty list for storing processed odds dataframes for each market
  market_odds_list <- list()

  for (market in markets) {
    # Fetch odds for the current market
    market_odds <- dg_outrights("pga", market, "percent") %>%
      select(-datagolf.baseline, -datagolf.baseline_history_fit, -player_name) %>%
      rowwise() %>%
      # Calculate consensus probability across all numeric columns except `dg_id`
      mutate(consensus_prob = mean(c_across(where(is.numeric) & !all_of("dg_id")), na.rm = TRUE)) %>%
      ungroup() %>%
      # Calculate consensus odds based on the consensus probability
      mutate(consensus_odds = prob_to_odds(consensus_prob))

    # Dynamically add market suffix to columns (except for `dg_id`)
    market_suffix <- tolower(market)
    market_odds <- market_odds %>%
      rename_with(~ ifelse(.x != "dg_id", paste0(.x, "_", market_suffix), .x), everything())

    # Store the processed dataframe for the current market
    market_odds_list[[market]] <- market_odds
  }

  # Combine all market dataframes into one, joining by 'dg_id'
  all_market_odds <- reduce(market_odds_list, full_join, by = "dg_id")

  # Ensure only selected bookmakers and consensus columns are included in the output
  final_cols <- c("dg_id", grep("consensus_prob_|consensus_odds_|bovada_|betonline_|betcris_", names(all_market_odds), value = TRUE))
  all_market_odds <- all_market_odds %>% select(all_of(final_cols))

  return(all_market_odds)
}
