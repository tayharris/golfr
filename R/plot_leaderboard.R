#' Plot Tournament Leaderboard
#'
#' Creates a visual leaderboard for the current tournament, showing player
#' positions, scores, and optionally strokes gained data. Designed for sharing
#' weekly tournament updates on Discord.
#'
#' @param tour Tour to fetch data for (default: "pga")
#' @param top_n Number of players to show (default: 20)
#' @param show_sg Logical, whether to include strokes gained metrics (default: FALSE)
#' @param sg_stat Strokes gained stat to show if show_sg = TRUE (default: "sg_total")
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' # Basic leaderboard
#' plot_leaderboard()
#'
#' # Top 10 with strokes gained
#' plot_leaderboard(top_n = 10, show_sg = TRUE)
#' }
plot_leaderboard <- function(tour = "pga",
                             top_n = 20,
                             show_sg = FALSE,
                             sg_stat = "sg_total",
                             branded = TRUE) {

  # Get tournament status
  status <- dg_live_status(tour = tour)

  if (nrow(status) == 0) {
    stop("No active tournament found for ", tour)
  }

  event_name <- status$event_name[1]
  current_round <- status$current_round[1]

  # Get live stats
  stats_to_fetch <- if (show_sg) c("sg_total", sg_stat) else NULL

  leaderboard <- dg_live_stats(
    tour = tour,
    stats = stats_to_fetch
  )

  # Filter to top N players
  leaderboard <- leaderboard |>
    dplyr::arrange(position) |>
    dplyr::slice(1:min(top_n, dplyr::n())) |>
    dplyr::mutate(
      player_display = glue::glue("{position}. {player_name}"),
      score_display = ifelse(
        total_to_par > 0,
        glue::glue("+{total_to_par}"),
        as.character(total_to_par)
      )
    )

  # Create base plot
  p <- ggplot2::ggplot(leaderboard, ggplot2::aes(
    x = stats::reorder(player_display, -position),
    y = total_to_par
  )) +
    ggplot2::geom_col(
      fill = ifelse(leaderboard$total_to_par < 0, "#2E7D32", "#C62828"),
      width = 0.7
    ) +
    ggplot2::geom_text(
      ggplot2::aes(label = score_display),
      hjust = ifelse(leaderboard$total_to_par < 0, 1.2, -0.2),
      color = "#2C3E50",
      fontface = "bold",
      size = 4
    ) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = event_name,
      subtitle = glue::glue("After Round {current_round} - Top {top_n}"),
      x = NULL,
      y = "Score to Par",
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(size = 11, hjust = 1),
      panel.grid.major.y = ggplot2::element_blank()
    )

  # Add strokes gained if requested
  if (show_sg && sg_stat %in% names(leaderboard)) {
    sg_data <- leaderboard |>
      dplyr::select(player_display, dplyr::all_of(sg_stat)) |>
      dplyr::rename(sg_value = 2)

    # Create inset plot
    p_sg <- ggplot2::ggplot(sg_data, ggplot2::aes(
      x = stats::reorder(player_display, -dplyr::row_number()),
      y = sg_value
    )) +
      ggplot2::geom_col(
        fill = ifelse(sg_data$sg_value > 0, "#66BB6A", "#EF5350"),
        width = 0.7
      ) +
      ggplot2::coord_flip() +
      ggplot2::labs(
        y = gsub("_", " ", toupper(sg_stat))
      ) +
      theme_golfr(base_size = 10) +
      ggplot2::theme(
        axis.text.y = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank(),
        panel.grid.major.y = ggplot2::element_blank()
      )

    # Combine plots would require patchwork - for now return main plot
    # Could add patchwork dependency for this
    message("Note: Strokes gained subplot not yet implemented. Add 'patchwork' for this feature.")
  }

  # Add branding if requested
  if (branded) {
    p <- add_branding_footer(
      p,
      data_source = "Data: DataGolf.com",
      package_info = TRUE
    )
  }

  p
}

#' Plot Current Field / Tournament Participants
#'
#' Shows all players in the current tournament field with key stats
#'
#' @param tour Tour to fetch data for (default: "pga")
#' @param stat Statistic to highlight (default: "total_to_par")
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_field()
#' }
plot_field <- function(tour = "pga",
                       stat = "total_to_par",
                       branded = TRUE) {

  status <- dg_live_status(tour = tour)

  if (nrow(status) == 0) {
    stop("No active tournament found for ", tour)
  }

  event_name <- status$event_name[1]
  current_round <- status$current_round[1]

  # Get all players
  field <- dg_live_stats(tour = tour)

  # Create summary statistics
  summary_stats <- data.frame(
    metric = c(
      "Total Players",
      "Made Cut",
      "Missed Cut",
      "Leader Score",
      "Last Place"
    ),
    value = c(
      nrow(field),
      sum(field$made_cut == TRUE, na.rm = TRUE),
      sum(field$made_cut == FALSE, na.rm = TRUE),
      min(field$total_to_par, na.rm = TRUE),
      max(field$total_to_par, na.rm = TRUE)
    )
  )

  # Create table plot
  p <- ggplot2::ggplot(summary_stats, ggplot2::aes(x = 1, y = dplyr::row_number())) +
    ggplot2::geom_text(
      ggplot2::aes(label = metric),
      x = 0.7,
      hjust = 1,
      fontface = "bold",
      size = 5
    ) +
    ggplot2::geom_text(
      ggplot2::aes(label = value),
      x = 0.8,
      hjust = 0,
      size = 5,
      color = "#1565C0"
    ) +
    ggplot2::xlim(0.5, 1.2) +
    ggplot2::labs(
      title = event_name,
      subtitle = glue::glue("Tournament Summary - Round {current_round}"),
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )

  if (branded) {
    p <- add_branding_footer(p, data_source = "Data: DataGolf.com")
  }

  p
}
