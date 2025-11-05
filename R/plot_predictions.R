#' Plot Win Probabilities
#'
#' Visualizes tournament win probabilities for top contenders. Can show either
#' pre-tournament predictions or live updating probabilities during a tournament.
#'
#' @param tour Tour to fetch data for (default: "pga")
#' @param top_n Number of top contenders to show (default: 15)
#' @param type Type of prediction: "pre" for pre-tournament or "live" for live (default: "pre")
#' @param odds_format Format for odds display: "percent", "american", "decimal" (default: "percent")
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' # Pre-tournament win probabilities
#' plot_win_probabilities()
#'
#' # Live win probabilities during tournament
#' plot_win_probabilities(type = "live", top_n = 10)
#' }
plot_win_probabilities <- function(tour = "pga",
                                   top_n = 15,
                                   type = "pre",
                                   odds_format = "percent",
                                   branded = TRUE) {

  # Get predictions based on type
  if (type == "live") {
    preds <- dg_live_predictions(tour = tour, odds_format = odds_format)
    title_suffix <- "Live Predictions"
  } else {
    preds <- dg_pre_tournament_predictions(tour = tour)
    title_suffix <- "Pre-Tournament Predictions"
  }

  # Get event name
  status <- dg_live_status(tour = tour)
  event_name <- if (nrow(status) > 0) status$event_name[1] else "Current Tournament"

  # Filter to top N by win probability
  preds_top <- preds |>
    dplyr::arrange(dplyr::desc(win)) |>
    dplyr::slice(1:top_n) |>
    dplyr::mutate(
      win_pct = win * 100,
      player_display = glue::glue("{dplyr::row_number()}. {player_name}")
    )

  # Create plot
  p <- ggplot2::ggplot(
    preds_top,
    ggplot2::aes(x = stats::reorder(player_display, win_pct), y = win_pct)
  ) +
    ggplot2::geom_col(fill = "#1565C0", width = 0.7) +
    ggplot2::geom_text(
      ggplot2::aes(label = sprintf("%.1f%%", win_pct)),
      hjust = -0.2,
      color = "#2C3E50",
      fontface = "bold",
      size = 3.5
    ) +
    ggplot2::coord_flip() +
    ggplot2::scale_y_continuous(
      labels = function(x) paste0(x, "%"),
      expand = ggplot2::expansion(mult = c(0, 0.15))
    ) +
    ggplot2::labs(
      title = event_name,
      subtitle = glue::glue("{title_suffix} - Top {top_n} Win Probability"),
      x = NULL,
      y = "Win Probability",
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(size = 10, hjust = 1),
      panel.grid.major.y = ggplot2::element_blank()
    )

  if (branded) {
    p <- add_branding_footer(p, data_source = "Data: DataGolf.com")
  }

  p
}

#' Plot Top 5/10/20 Finish Probabilities
#'
#' Shows probabilities for top finishes (Top 5, Top 10, Top 20) for leading contenders
#'
#' @param tour Tour to fetch data for (default: "pga")
#' @param players Character vector of player names (default: top 10 by win probability)
#' @param top_n If players not specified, show top N by win probability (default: 10)
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_finish_probabilities()
#' plot_finish_probabilities(players = c("Scottie Scheffler", "Rory McIlroy"))
#' }
plot_finish_probabilities <- function(tour = "pga",
                                      players = NULL,
                                      top_n = 10,
                                      branded = TRUE) {

  # Get predictions
  preds <- dg_pre_tournament_predictions(tour = tour)

  # Filter to specific players or top N
  if (!is.null(players)) {
    preds <- preds |>
      dplyr::filter(player_name %in% players)
  } else {
    preds <- preds |>
      dplyr::arrange(dplyr::desc(win)) |>
      dplyr::slice(1:top_n)
  }

  # Get event name
  status <- dg_live_status(tour = tour)
  event_name <- if (nrow(status) > 0) status$event_name[1] else "Current Tournament"

  # Reshape for plotting
  preds_long <- preds |>
    dplyr::select(player_name, top_5, top_10, top_20) |>
    tidyr::pivot_longer(
      cols = -player_name,
      names_to = "finish",
      values_to = "probability"
    ) |>
    dplyr::mutate(
      finish_label = dplyr::case_when(
        finish == "top_5" ~ "Top 5",
        finish == "top_10" ~ "Top 10",
        finish == "top_20" ~ "Top 20",
        TRUE ~ finish
      ),
      prob_pct = probability * 100
    )

  # Create plot
  p <- ggplot2::ggplot(
    preds_long,
    ggplot2::aes(x = player_name, y = prob_pct, fill = finish_label)
  ) +
    ggplot2::geom_col(position = "dodge", width = 0.7) +
    scale_fill_golfr("main") +
    ggplot2::scale_y_continuous(
      labels = function(x) paste0(x, "%")
    ) +
    ggplot2::labs(
      title = event_name,
      subtitle = "Finish Probabilities by Player",
      x = NULL,
      y = "Probability",
      fill = "Finish",
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 9),
      legend.position = "top"
    )

  if (branded) {
    p <- add_branding_footer(p, data_source = "Data: DataGolf.com")
  }

  p
}

#' Plot Odds Comparison Across Sportsbooks
#'
#' Compares outright odds for a player across multiple sportsbooks to find
#' the best value. Great for weekly betting analysis posts.
#'
#' @param tour Tour to fetch data for (default: "pga")
#' @param players Character vector of player names to compare (default: top 8 favorites)
#' @param market Betting market: "win", "top_5", "top_10", "top_20", "make_cut" (default: "win")
#' @param top_n If players not specified, show top N favorites (default: 8)
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_odds_comparison()
#' plot_odds_comparison(market = "top_5", top_n = 12)
#' }
plot_odds_comparison <- function(tour = "pga",
                                 players = NULL,
                                 market = "win",
                                 top_n = 8,
                                 branded = TRUE) {

  # Get odds data
  odds <- dg_outrights(tour = tour, market = market)

  # Get event name
  status <- dg_live_status(tour = tour)
  event_name <- if (nrow(status) > 0) status$event_name[1] else "Current Tournament"

  # Filter to specific players or top N
  if (!is.null(players)) {
    odds <- odds |>
      dplyr::filter(player_name %in% players)
  } else {
    # Get players with best average odds (lowest odds = favorites)
    avg_odds <- odds |>
      dplyr::group_by(player_name) |>
      dplyr::summarize(avg_odds = mean(c_across(where(is.numeric)), na.rm = TRUE), .groups = "drop") |>
      dplyr::arrange(avg_odds) |>
      dplyr::slice(1:top_n)

    odds <- odds |>
      dplyr::filter(player_name %in% avg_odds$player_name)
  }

  # Reshape for plotting - select numeric columns (odds from different books)
  odds_long <- odds |>
    dplyr::select(player_name, where(is.numeric)) |>
    tidyr::pivot_longer(
      cols = -player_name,
      names_to = "sportsbook",
      values_to = "odds"
    ) |>
    dplyr::filter(!is.na(odds))

  # Create plot
  p <- ggplot2::ggplot(
    odds_long,
    ggplot2::aes(x = player_name, y = odds, color = sportsbook, group = sportsbook)
  ) +
    ggplot2::geom_line(linewidth = 1.2, alpha = 0.7) +
    ggplot2::geom_point(size = 2.5, alpha = 0.8) +
    scale_color_golfr("main") +
    ggplot2::labs(
      title = event_name,
      subtitle = glue::glue("Odds Comparison - {toupper(market)} Market"),
      x = NULL,
      y = "American Odds",
      color = "Sportsbook",
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 9),
      legend.position = "right"
    )

  if (branded) {
    p <- add_branding_footer(p, data_source = "Data: DataGolf.com & Sportsbooks")
  }

  p
}
