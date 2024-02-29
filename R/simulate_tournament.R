simulate_golf_tournaments <- function(df, n_simulations = 1000, n_rounds = 4) {
  set.seed(420)  # Ensure reproducibility

  simulations <- vector("list", n_simulations)

  for (i in 1:n_simulations) {
    simulation <- df %>%
      mutate(simulated_total_score = map2_dbl(sg_tot, std_dev, ~sum(rnorm(n_rounds, .x, .y)))) %>%
      arrange(desc(simulated_total_score)) %>%
      mutate(rank = row_number())

    simulations[[i]] <- select(simulation, id, dg_id, golfer, rank, simulated_total_score)
  }

  all_simulations_df <- bind_rows(simulations, .id = "simulation_id")

  summary_df <- all_simulations_df %>%
    group_by(id, dg_id, golfer) %>%
    summarise(
      win_count = sum(rank == 1),
      top_5_count = sum(rank <= 5),
      top_10_count = sum(rank <= 10),
      top_20_count = sum(rank <= 20),
      top_40_count = sum(rank <= 40),
      avg_score = mean(simulated_total_score),
      total_simulations = n(),
      .groups = 'drop'
    ) %>%
    mutate(
      win_prob = win_count / total_simulations,
      top_5_prob = top_5_count / total_simulations,
      top_10_prob = top_10_count / total_simulations,
      top_20_prob = top_20_count / total_simulations,
      top_40_prob = top_40_count / total_simulations
    ) %>%
    rowwise() %>%
    mutate(
      win_odds = prob_to_odds(win_prob),
      top_5_odds = prob_to_odds(top_5_prob),
      top_10_odds = prob_to_odds(top_10_prob),
      top_20_odds = prob_to_odds(top_20_prob),
      top_40_odds = prob_to_odds(top_40_prob)
    ) %>%
    ungroup()

  return(summary_df)
}
