#' Save Plot for Discord
#'
#' Exports a ggplot2 or golfr_plot object as a high-quality PNG optimized for
#' Discord sharing. Uses ragg device for superior text rendering and supports
#' Discord's recommended image dimensions.
#'
#' @param plot A ggplot2 object or golfr_plot gtable
#' @param filename Output filename (default: auto-generated with timestamp)
#' @param width Plot width in pixels (default: 1200)
#' @param height Plot height in pixels (default: 800)
#' @param dpi Resolution in dots per inch (default: 300)
#' @param output_dir Output directory (default: current directory)
#' @return Invisibly returns the full path to the saved file
#' @export
#' @examples
#' \dontrun{
#' p <- plot_win_probabilities()
#' save_plot_discord(p, "win_probs.png")
#'
#' # Auto-generated filename with timestamp
#' save_plot_discord(p)
#' }
save_plot_discord <- function(plot,
                              filename = NULL,
                              width = 1200,
                              height = 800,
                              dpi = 300,
                              output_dir = ".") {

  # Auto-generate filename if not provided
  if (is.null(filename)) {
    timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
    filename <- glue::glue("golfr_plot_{timestamp}.png")
  }

  # Ensure output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Construct full path
  filepath <- file.path(output_dir, filename)

  # Convert dimensions from pixels to inches
  width_in <- width / dpi
  height_in <- height / dpi

  # Save using ragg for high-quality output
  ragg::agg_png(
    filename = filepath,
    width = width,
    height = height,
    units = "px",
    res = dpi,
    background = "#F0F0F0"
  )

  # Handle different plot types
  if (inherits(plot, "golfr_plot") || inherits(plot, "gtable")) {
    grid::grid.newpage()
    grid::grid.draw(plot)
  } else if (inherits(plot, "ggplot")) {
    print(plot)
  } else {
    dev.off()
    stop("plot must be a ggplot2 object or golfr_plot gtable")
  }

  dev.off()

  message(glue::glue("Plot saved to: {filepath}"))
  message(glue::glue("Dimensions: {width}x{height} px ({width_in:.2f}x{height_in:.2f} in @ {dpi} DPI)"))

  invisible(filepath)
}

#' Discord Image Presets
#'
#' Returns recommended dimensions for different Discord use cases
#'
#' @param preset Preset name: "standard", "wide", "tall", "embed", "banner" (default: "standard")
#' @return List with width, height, and dpi values
#' @export
#' @examples
#' \dontrun{
#' dims <- discord_presets("wide")
#' p <- plot_skill_ratings()
#' save_plot_discord(p, width = dims$width, height = dims$height)
#' }
discord_presets <- function(preset = "standard") {
  presets <- list(
    standard = list(width = 1200, height = 800, dpi = 300),
    wide = list(width = 1600, height = 900, dpi = 300),
    tall = list(width = 1000, height = 1400, dpi = 300),
    embed = list(width = 800, height = 600, dpi = 300),
    banner = list(width = 1920, height = 1080, dpi = 300),
    square = list(width = 1200, height = 1200, dpi = 300)
  )

  if (!preset %in% names(presets)) {
    stop("Unknown preset. Choose from: ", paste(names(presets), collapse = ", "))
  }

  presets[[preset]]
}

#' Create and Save Weekly Graphics Bundle
#'
#' Generates a complete set of weekly golf graphics for Discord posting.
#' Creates multiple visualizations in one call and saves them all.
#'
#' @param tour Tour to generate graphics for (default: "pga")
#' @param output_dir Output directory for all graphics (default: "./discord_graphics")
#' @param graphics Character vector of graphic types to generate. Options:
#'   "win_probs", "finish_probs", "skill_ratings", "rankings", "sg_heatmap", "odds",
#'   "market_edge", "best_bets", "player_spotlight"
#'   (default: c("win_probs", "skill_ratings", "sg_heatmap", "market_edge", "best_bets"))
#' @param spotlight_players Character vector of player names for spotlight (default: NULL, uses top 2)
#' @param preset Discord preset for dimensions (default: "standard")
#' @return Invisibly returns a named vector of file paths
#' @export
#' @examples
#' \dontrun{
#' # Generate recommended weekly graphics
#' create_weekly_bundle()
#'
#' # Generate specific graphics only
#' create_weekly_bundle(graphics = c("win_probs", "skill_ratings", "market_edge"))
#'
#' # Include player spotlight
#' create_weekly_bundle(
#'   graphics = c("skill_ratings", "player_spotlight"),
#'   spotlight_players = c("Scottie Scheffler", "Rory McIlroy")
#' )
#' }
create_weekly_bundle <- function(tour = "pga",
                                 output_dir = "./discord_graphics",
                                 graphics = c("win_probs", "skill_ratings",
                                             "sg_heatmap", "market_edge", "best_bets"),
                                 spotlight_players = NULL,
                                 preset = "standard") {

  # Create output directory
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Get dimensions
  dims <- discord_presets(preset)

  # Storage for file paths
  files <- c()

  message("Generating weekly graphics bundle for ", toupper(tour), "...\n")

  # Generate each requested graphic
  if ("win_probs" %in% graphics) {
    message("Creating win probabilities chart...")
    p <- plot_win_probabilities(tour = tour, type = "pre", top_n = 15, branded = TRUE)
    files["win_probs"] <- save_plot_discord(
      p,
      filename = "win_probabilities.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("finish_probs" %in% graphics) {
    message("Creating finish probabilities chart...")
    p <- plot_finish_probabilities(tour = tour, top_n = 10, branded = TRUE)
    files["finish_probs"] <- save_plot_discord(
      p,
      filename = "finish_probabilities.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("skill_ratings" %in% graphics) {
    message("Creating skill ratings comparison...")
    p <- plot_skill_ratings(top_n = 10, branded = TRUE)
    files["skill_ratings"] <- save_plot_discord(
      p,
      filename = "skill_ratings.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("rankings" %in% graphics) {
    message("Creating rankings chart...")
    p <- plot_rankings(top_n = 20, branded = TRUE)
    files["rankings"] <- save_plot_discord(
      p,
      filename = "rankings.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("sg_heatmap" %in% graphics) {
    message("Creating strokes gained heatmap...")
    p <- plot_sg_heatmap(top_n = 15, branded = TRUE)
    files["sg_heatmap"] <- save_plot_discord(
      p,
      filename = "sg_heatmap.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("odds" %in% graphics) {
    message("Creating odds comparison...")
    p <- plot_odds_comparison(tour = tour, market = "win", top_n = 8, branded = TRUE)
    files["odds"] <- save_plot_discord(
      p,
      filename = "odds_comparison.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("market_edge" %in% graphics) {
    message("Creating market edge analysis...")
    p <- plot_market_edge(tour = tour, market = "win", top_n = 15, branded = TRUE)
    files["market_edge"] <- save_plot_discord(
      p,
      filename = "market_edge.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("best_bets" %in% graphics) {
    message("Creating best bets summary...")
    p <- plot_best_bets(
      tour = tour,
      markets = c("win", "top_5", "top_10"),
      picks_per_market = 3,
      branded = TRUE
    )
    files["best_bets"] <- save_plot_discord(
      p,
      filename = "best_bets.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  if ("player_spotlight" %in% graphics) {
    message("Creating player spotlight...")

    # Determine which players to spotlight
    if (is.null(spotlight_players)) {
      # Use top 2 ranked players
      rankings <- dg_rankings()
      spotlight_players <- rankings |>
        dplyr::arrange(datagolf_rank) |>
        dplyr::slice(1:2) |>
        dplyr::pull(player_name)
    }

    p <- plot_player_spotlight(
      players = spotlight_players,
      tour = tour,
      branded = TRUE
    )
    files["player_spotlight"] <- save_plot_discord(
      p,
      filename = "player_spotlight.png",
      width = dims$width,
      height = dims$height,
      dpi = dims$dpi,
      output_dir = output_dir
    )
  }

  message("\n", length(files), " graphics created successfully!")
  message("Output directory: ", normalizePath(output_dir))

  invisible(files)
}
