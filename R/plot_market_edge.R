#' Plot Market Edge Analysis
#'
#' Identifies and visualizes players with the biggest differences between DataGolf
#' predictions and market odds (implied probabilities). Highlights value opportunities
#' where DataGolf's model sees higher win probability than the betting markets.
#'
#' @param tour Tour to analyze (default: "pga")
#' @param market Betting market to analyze: "win", "top_5", "top_10", "top_20", "make_cut" (default: "win")
#' @param min_probability Minimum DataGolf probability to include (default: 0.01 for 1%)
#' @param top_n Number of biggest edges to display (default: 15)
#' @param show_negative Include negative edges (overvalued by market) (default: FALSE)
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' # Find best value for win market
#' plot_market_edge()
#'
#' # Top 5 market value analysis
#' plot_market_edge(market = "top_5", top_n = 20)
#'
#' # Show both positive and negative edges
#' plot_market_edge(show_negative = TRUE)
#' }
plot_market_edge <- function(tour = "pga",
                             market = "win",
                             min_probability = 0.01,
                             top_n = 15,
                             show_negative = FALSE,
                             branded = TRUE) {

  # Get predictions
  preds <- dg_pre_tournament_predictions(tour = tour)

  # Get market odds
  odds <- dg_outrights(tour = tour, market = market)

  # Get event name
  status <- dg_live_status(tour = tour)
  event_name <- if (nrow(status) > 0) status$event_name[1] else "Current Tournament"

  # Calculate average market odds across all books
  odds_avg <- odds |>
    dplyr::rowwise() |>
    dplyr::mutate(
      avg_odds = mean(dplyr::c_across(where(is.numeric)), na.rm = TRUE)
    ) |>
    dplyr::ungroup() |>
    dplyr::select(player_name, avg_odds) |>
    dplyr::mutate(
      market_prob = odds_to_prob(avg_odds)
    )

  # Join predictions with market probabilities
  prob_col <- dplyr::case_when(
    market == "win" ~ "win",
    market == "top_5" ~ "top_5",
    market == "top_10" ~ "top_10",
    market == "top_20" ~ "top_20",
    market == "make_cut" ~ "make_cut",
    TRUE ~ "win"
  )

  edge_data <- preds |>
    dplyr::inner_join(odds_avg, by = "player_name") |>
    dplyr::filter(!is.na(market_prob)) |>
    dplyr::mutate(
      dg_prob = !!rlang::sym(prob_col),
      edge = (dg_prob - market_prob) * 100,  # Edge in percentage points
      ev_ratio = dg_prob / market_prob  # Expected value ratio
    ) |>
    dplyr::filter(dg_prob >= min_probability)

  # Filter to top edges
  if (show_negative) {
    edge_data <- edge_data |>
      dplyr::arrange(dplyr::desc(abs(edge))) |>
      dplyr::slice(1:top_n)
  } else {
    edge_data <- edge_data |>
      dplyr::filter(edge > 0) |>
      dplyr::arrange(dplyr::desc(edge)) |>
      dplyr::slice(1:top_n)
  }

  edge_data <- edge_data |>
    dplyr::mutate(
      player_label = glue::glue("{player_name}\nDG: {scales::percent(dg_prob, accuracy = 0.1)} | Market: {scales::percent(market_prob, accuracy = 0.1)}")
    )

  # Create plot
  p <- ggplot2::ggplot(
    edge_data,
    ggplot2::aes(
      x = stats::reorder(player_name, edge),
      y = edge,
      fill = edge > 0
    )
  ) +
    ggplot2::geom_col(width = 0.7) +
    ggplot2::geom_hline(yintercept = 0, linetype = "solid", color = "#666666", linewidth = 0.8) +
    ggplot2::geom_text(
      ggplot2::aes(
        label = sprintf("%+.1f%%", edge),
        hjust = ifelse(edge > 0, -0.1, 1.1)
      ),
      fontface = "bold",
      size = 3.5
    ) +
    ggplot2::scale_fill_manual(
      values = c("TRUE" = "#2E7D32", "FALSE" = "#C62828"),
      guide = "none"
    ) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = glue::glue("{event_name} - Market Edge Analysis"),
      subtitle = glue::glue("{toupper(market)} Market: DataGolf vs Market Probabilities"),
      x = NULL,
      y = "Edge (DataGolf % - Market %) - Percentage Points",
      caption = glue::glue("Positive = DataGolf sees more value than market | Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(size = 10, hjust = 1),
      panel.grid.major.y = ggplot2::element_blank(),
      plot.caption = ggplot2::element_text(size = 9)
    )

  if (branded) {
    p <- add_branding_footer(
      p,
      data_source = "Data: DataGolf.com & Sportsbooks",
      package_info = TRUE
    )
  }

  p
}

#' Plot Player Spotlight
#'
#' Creates a detailed spotlight graphic for specific players showing their
#' skill ratings, predictions, current odds, and recent form. Perfect for
#' weekly player highlights.
#'
#' @param players Character vector of 1-4 player names to spotlight
#' @param tour Tour for current tournament context (default: "pga")
#' @param include_odds Include current betting odds (default: TRUE)
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_player_spotlight("Scottie Scheffler")
#' plot_player_spotlight(c("Scottie Scheffler", "Rory McIlroy"))
#' }
plot_player_spotlight <- function(players,
                                  tour = "pga",
                                  include_odds = TRUE,
                                  branded = TRUE) {

  if (length(players) == 0 || length(players) > 4) {
    stop("Please provide 1-4 player names")
  }

  # Get event name
  status <- dg_live_status(tour = tour)
  event_name <- if (nrow(status) > 0) status$event_name[1] else "Current Tournament"

  # Get skill ratings
  skills <- dg_skill_ratings() |>
    dplyr::filter(player_name %in% players) |>
    dplyr::select(player_name, sg_ott, sg_app, sg_arg, sg_putt, sg_total)

  # Get rankings
  rankings <- dg_rankings() |>
    dplyr::filter(player_name %in% players) |>
    dplyr::select(player_name, datagolf_rank, owgr_rank)

  # Get predictions
  preds <- dg_pre_tournament_predictions(tour = tour) |>
    dplyr::filter(player_name %in% players) |>
    dplyr::select(player_name, win, top_5, top_10, top_20)

  # Combine data
  player_data <- skills |>
    dplyr::left_join(rankings, by = "player_name") |>
    dplyr::left_join(preds, by = "player_name")

  # Get odds if requested
  if (include_odds) {
    odds <- dg_outrights(tour = tour, market = "win") |>
      dplyr::filter(player_name %in% players) |>
      dplyr::rowwise() |>
      dplyr::mutate(avg_odds = mean(dplyr::c_across(where(is.numeric)), na.rm = TRUE)) |>
      dplyr::ungroup() |>
      dplyr::select(player_name, avg_odds)

    player_data <- player_data |>
      dplyr::left_join(odds, by = "player_name")
  }

  # Reshape skill data for plotting
  skills_long <- player_data |>
    dplyr::select(player_name, sg_ott, sg_app, sg_arg, sg_putt) |>
    tidyr::pivot_longer(
      cols = -player_name,
      names_to = "skill",
      values_to = "value"
    ) |>
    dplyr::mutate(
      skill_label = dplyr::case_when(
        skill == "sg_ott" ~ "Off Tee",
        skill == "sg_app" ~ "Approach",
        skill == "sg_arg" ~ "Around Green",
        skill == "sg_putt" ~ "Putting",
        TRUE ~ skill
      )
    )

  # Create skill ratings plot
  p_skills <- ggplot2::ggplot(
    skills_long,
    ggplot2::aes(x = skill_label, y = value, fill = skill_label)
  ) +
    ggplot2::geom_col(width = 0.7) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed") +
    ggplot2::facet_wrap(~player_name, ncol = 2) +
    scale_fill_golfr("main") +
    ggplot2::labs(
      title = glue::glue("Player Spotlight - {event_name}"),
      subtitle = "Skill Ratings (Strokes Gained per Round)",
      x = NULL,
      y = "Strokes Gained"
    ) +
    theme_golfr(base_size = 12) +
    ggplot2::theme(
      legend.position = "none",
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      strip.text = ggplot2::element_text(size = 12, face = "bold")
    )

  # Add summary stats as caption
  summary_text <- player_data |>
    dplyr::mutate(
      player_summary = glue::glue(
        "{player_name}: Rank #{datagolf_rank} | Win: {scales::percent(win, accuracy = 0.1)} | SG Total: {sprintf('%+.2f', sg_total)}{if (include_odds) paste0(' | Odds: ', sprintf('%+d', avg_odds)) else ''}"
      )
    ) |>
    dplyr::pull(player_summary) |>
    paste(collapse = "\n")

  p_skills <- p_skills +
    ggplot2::labs(caption = summary_text)

  if (branded) {
    p_skills <- add_branding_footer(
      p_skills,
      data_source = "Data: DataGolf.com",
      package_info = TRUE
    )
  }

  p_skills
}

#' Plot Best Bets Summary
#'
#' Creates a clean, shareable graphic showing your top betting picks based on
#' market edge analysis across multiple markets.
#'
#' @param tour Tour to analyze (default: "pga")
#' @param markets Character vector of markets to analyze (default: c("win", "top_5", "top_10"))
#' @param picks_per_market Number of picks per market (default: 3)
#' @param min_edge Minimum edge threshold in percentage points (default: 2.0)
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_best_bets()
#' plot_best_bets(markets = c("win", "top_10", "top_20"), picks_per_market = 5)
#' }
plot_best_bets <- function(tour = "pga",
                           markets = c("win", "top_5", "top_10"),
                           picks_per_market = 3,
                           min_edge = 2.0,
                           branded = TRUE) {

  # Get event name
  status <- dg_live_status(tour = tour)
  event_name <- if (nrow(status) > 0) status$event_name[1] else "Current Tournament"

  # Get predictions
  preds <- dg_pre_tournament_predictions(tour = tour)

  # Collect best bets across all markets
  all_bets <- list()

  for (mkt in markets) {
    # Get odds for this market
    odds <- dg_outrights(tour = tour, market = mkt)

    # Calculate average odds
    odds_avg <- odds |>
      dplyr::rowwise() |>
      dplyr::mutate(avg_odds = mean(dplyr::c_across(where(is.numeric)), na.rm = TRUE)) |>
      dplyr::ungroup() |>
      dplyr::select(player_name, avg_odds) |>
      dplyr::mutate(market_prob = odds_to_prob(avg_odds))

    # Get appropriate prediction column
    prob_col <- dplyr::case_when(
      mkt == "win" ~ "win",
      mkt == "top_5" ~ "top_5",
      mkt == "top_10" ~ "top_10",
      mkt == "top_20" ~ "top_20",
      mkt == "make_cut" ~ "make_cut",
      TRUE ~ "win"
    )

    # Calculate edge
    edge_data <- preds |>
      dplyr::inner_join(odds_avg, by = "player_name") |>
      dplyr::filter(!is.na(market_prob)) |>
      dplyr::mutate(
        dg_prob = !!rlang::sym(prob_col),
        edge = (dg_prob - market_prob) * 100,
        market = toupper(mkt)
      ) |>
      dplyr::filter(edge >= min_edge) |>
      dplyr::arrange(dplyr::desc(edge)) |>
      dplyr::slice(1:picks_per_market) |>
      dplyr::select(player_name, market, dg_prob, market_prob, avg_odds, edge)

    all_bets[[mkt]] <- edge_data
  }

  # Combine all markets
  bets_df <- dplyr::bind_rows(all_bets) |>
    dplyr::mutate(
      bet_label = glue::glue("{player_name}\n{market}: {sprintf('%+d', avg_odds)} ({sprintf('%+.1f%%', edge)} edge)")
    )

  if (nrow(bets_df) == 0) {
    stop("No bets found meeting the minimum edge criteria")
  }

  # Create plot
  p <- ggplot2::ggplot(
    bets_df,
    ggplot2::aes(
      x = stats::reorder(paste(market, player_name, sep = "_"), edge),
      y = edge,
      fill = market
    )
  ) +
    ggplot2::geom_col(width = 0.7) +
    ggplot2::geom_text(
      ggplot2::aes(label = player_name),
      hjust = -0.1,
      fontface = "bold",
      size = 3.5
    ) +
    ggplot2::geom_text(
      ggplot2::aes(label = sprintf("%+d odds", avg_odds)),
      hjust = -0.1,
      vjust = 1.5,
      size = 3
    ) +
    ggplot2::coord_flip() +
    scale_fill_golfr("main") +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.2))) +
    ggplot2::labs(
      title = glue::glue("{event_name} - Best Betting Value"),
      subtitle = glue::glue("Top {picks_per_market} Picks per Market (Min {min_edge}% Edge)"),
      x = NULL,
      y = "Edge (DataGolf % - Market %)",
      fill = "Market",
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank()
    )

  if (branded) {
    p <- add_branding_footer(
      p,
      data_source = "Data: DataGolf.com & Sportsbooks",
      package_info = TRUE
    )
  }

  p
}
