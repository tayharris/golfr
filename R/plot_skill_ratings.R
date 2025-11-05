#' Plot Skill Ratings Comparison
#'
#' Visualizes skill ratings for top players, breaking down performance across
#' different aspects of the game (driving, approach, short game, putting).
#' Perfect for weekly skill analysis posts.
#'
#' @param players Character vector of player names (default: top 10 from rankings)
#' @param top_n If players not specified, show top N ranked players (default: 10)
#' @param skills Character vector of skills to show (default: c("sg_ott", "sg_app", "sg_arg", "sg_putt"))
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' # Top 10 players skill breakdown
#' plot_skill_ratings()
#'
#' # Specific players
#' plot_skill_ratings(players = c("Scottie Scheffler", "Rory McIlroy"))
#' }
plot_skill_ratings <- function(players = NULL,
                               top_n = 10,
                               skills = c("sg_ott", "sg_app", "sg_arg", "sg_putt"),
                               branded = TRUE) {

  # Get skill ratings
  ratings <- dg_skill_ratings()

  # Filter to specific players or top N
  if (!is.null(players)) {
    ratings <- ratings |>
      dplyr::filter(player_name %in% players)

    if (nrow(ratings) == 0) {
      stop("No players found matching: ", paste(players, collapse = ", "))
    }
  } else {
    # Get top N from rankings
    rankings <- dg_rankings()
    top_players <- rankings |>
      dplyr::arrange(datagolf_rank) |>
      dplyr::slice(1:top_n) |>
      dplyr::pull(player_name)

    ratings <- ratings |>
      dplyr::filter(player_name %in% top_players)
  }

  # Reshape data for plotting
  ratings_long <- ratings |>
    dplyr::select(player_name, dplyr::all_of(skills)) |>
    tidyr::pivot_longer(
      cols = -player_name,
      names_to = "skill",
      values_to = "rating"
    ) |>
    dplyr::mutate(
      skill_label = dplyr::case_when(
        skill == "sg_ott" ~ "Off the Tee",
        skill == "sg_app" ~ "Approach",
        skill == "sg_arg" ~ "Around Green",
        skill == "sg_putt" ~ "Putting",
        skill == "sg_t2g" ~ "Tee to Green",
        skill == "sg_total" ~ "Total",
        TRUE ~ skill
      )
    )

  # Create plot
  p <- ggplot2::ggplot(
    ratings_long,
    ggplot2::aes(x = skill_label, y = rating, fill = skill_label)
  ) +
    ggplot2::geom_col(width = 0.7) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "#666666") +
    ggplot2::facet_wrap(~player_name, ncol = 2) +
    scale_fill_golfr("main") +
    ggplot2::labs(
      title = "Player Skill Ratings Comparison",
      subtitle = "Strokes Gained per Round by Category",
      x = NULL,
      y = "Strokes Gained per Round",
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      legend.position = "none",
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 9),
      strip.text = ggplot2::element_text(size = 11, face = "bold")
    )

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

#' Plot Top Players Rankings
#'
#' Creates a bar chart of the current top-ranked players
#'
#' @param top_n Number of players to show (default: 20)
#' @param metric Ranking metric to use (default: "datagolf_rank")
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_rankings()
#' plot_rankings(top_n = 30)
#' }
plot_rankings <- function(top_n = 20,
                          metric = "datagolf_rank",
                          branded = TRUE) {

  rankings <- dg_rankings() |>
    dplyr::arrange(!!rlang::sym(metric)) |>
    dplyr::slice(1:top_n) |>
    dplyr::mutate(
      player_display = glue::glue("{!!rlang::sym(metric)}. {player_name}")
    )

  p <- ggplot2::ggplot(
    rankings,
    ggplot2::aes(
      x = stats::reorder(player_display, -!!rlang::sym(metric)),
      y = primary_tour
    )
  ) +
    ggplot2::geom_col(fill = "#2E7D32", width = 0.7) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "DataGolf World Rankings",
      subtitle = glue::glue("Top {top_n} Players"),
      x = NULL,
      y = NULL,
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(size = 10, hjust = 1),
      axis.text.x = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank()
    )

  if (branded) {
    p <- add_branding_footer(p, data_source = "Data: DataGolf.com")
  }

  p
}

#' Plot Strokes Gained Heatmap
#'
#' Creates a heatmap showing strokes gained across categories for multiple players
#'
#' @param players Character vector of player names (default: top 15 from rankings)
#' @param top_n If players not specified, show top N ranked players (default: 15)
#' @param branded Logical, whether to add branding footer (default: TRUE)
#' @return A ggplot2 object or golfr_plot gtable (if branded = TRUE)
#' @export
#' @examples
#' \dontrun{
#' plot_sg_heatmap()
#' plot_sg_heatmap(players = c("Scottie Scheffler", "Rory McIlroy", "Jon Rahm"))
#' }
plot_sg_heatmap <- function(players = NULL,
                            top_n = 15,
                            branded = TRUE) {

  # Get skill ratings
  ratings <- dg_skill_ratings()

  # Filter to specific players or top N
  if (!is.null(players)) {
    ratings <- ratings |>
      dplyr::filter(player_name %in% players)
  } else {
    rankings <- dg_rankings()
    top_players <- rankings |>
      dplyr::arrange(datagolf_rank) |>
      dplyr::slice(1:top_n) |>
      dplyr::pull(player_name)

    ratings <- ratings |>
      dplyr::filter(player_name %in% top_players)
  }

  # Reshape for heatmap
  ratings_long <- ratings |>
    dplyr::select(player_name, sg_ott, sg_app, sg_arg, sg_putt, sg_total) |>
    tidyr::pivot_longer(
      cols = -player_name,
      names_to = "skill",
      values_to = "rating"
    ) |>
    dplyr::mutate(
      skill_label = dplyr::case_when(
        skill == "sg_ott" ~ "Off Tee",
        skill == "sg_app" ~ "Approach",
        skill == "sg_arg" ~ "Around Green",
        skill == "sg_putt" ~ "Putting",
        skill == "sg_total" ~ "TOTAL",
        TRUE ~ skill
      )
    )

  # Create heatmap
  p <- ggplot2::ggplot(
    ratings_long,
    ggplot2::aes(x = skill_label, y = player_name, fill = rating)
  ) +
    ggplot2::geom_tile(color = "white", linewidth = 1) +
    ggplot2::geom_text(
      ggplot2::aes(label = sprintf("%.2f", rating)),
      color = "white",
      fontface = "bold",
      size = 3.5
    ) +
    ggplot2::scale_fill_gradient2(
      low = "#C62828",
      mid = "#F0F0F0",
      high = "#2E7D32",
      midpoint = 0,
      name = "Strokes\nGained"
    ) +
    ggplot2::labs(
      title = "Strokes Gained Heatmap",
      subtitle = "Performance by Category (per round)",
      x = NULL,
      y = NULL,
      caption = glue::glue("Updated: {Sys.time()}")
    ) +
    theme_golfr() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 0, hjust = 0.5),
      axis.text.y = ggplot2::element_text(size = 10),
      panel.grid = ggplot2::element_blank()
    )

  if (branded) {
    p <- add_branding_footer(p, data_source = "Data: DataGolf.com")
  }

  p
}
