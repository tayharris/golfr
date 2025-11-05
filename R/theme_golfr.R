#' golfr ggplot2 Theme
#'
#' A clean, professional ggplot2 theme inspired by FiveThirtyEight and hrbrthemes,
#' optimized for golf analytics visualizations. Features a light background with
#' minimal grid lines and emphasis on data over decoration.
#'
#' @param base_size Base font size (default: 14)
#' @param base_family Base font family (default: "sans")
#' @param plot_margin Plot margin (default: margin(10, 10, 10, 10))
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   theme_golfr()
#' }
theme_golfr <- function(base_size = 14,
                        base_family = "sans",
                        plot_margin = ggplot2::margin(10, 10, 10, 10)) {

  # Color palette
  bg_color <- "#F0F0F0"
  text_color <- "#2C3E50"
  grid_color <- "#CCCCCC"

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # Overall
      plot.background = ggplot2::element_rect(fill = bg_color, color = NA),
      panel.background = ggplot2::element_rect(fill = bg_color, color = NA),
      panel.border = ggplot2::element_blank(),

      # Grid lines - minimal, only major
      panel.grid.major = ggplot2::element_line(color = grid_color, linewidth = 0.3),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),

      # Axes
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(color = text_color, size = base_size * 0.85),
      axis.title = ggplot2::element_text(color = text_color, size = base_size * 0.95,
                                         face = "bold"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 10)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 10)),

      # Plot titles and captions
      plot.title = ggplot2::element_text(
        color = text_color,
        size = base_size * 1.4,
        face = "bold",
        hjust = 0,
        margin = ggplot2::margin(b = 8)
      ),
      plot.subtitle = ggplot2::element_text(
        color = text_color,
        size = base_size * 1.1,
        hjust = 0,
        margin = ggplot2::margin(b = 12)
      ),
      plot.caption = ggplot2::element_text(
        color = text_color,
        size = base_size * 0.75,
        hjust = 1,
        margin = ggplot2::margin(t = 10)
      ),

      # Legend
      legend.background = ggplot2::element_rect(fill = bg_color, color = NA),
      legend.key = ggplot2::element_rect(fill = bg_color, color = NA),
      legend.text = ggplot2::element_text(color = text_color, size = base_size * 0.85),
      legend.title = ggplot2::element_text(color = text_color, size = base_size * 0.95,
                                           face = "bold"),
      legend.position = "top",
      legend.justification = "left",

      # Faceting
      strip.background = ggplot2::element_rect(fill = "#E0E0E0", color = NA),
      strip.text = ggplot2::element_text(color = text_color, size = base_size * 0.95,
                                         face = "bold", margin = ggplot2::margin(5, 5, 5, 5)),

      # Margins
      plot.margin = plot_margin
    )
}

#' golfr Color Palettes
#'
#' Color palettes for golf analytics visualizations
#'
#' @param palette Name of palette: "main", "sequential", "diverging", "strokes_gained"
#' @param n Number of colors to return (for sequential/diverging)
#' @return Character vector of hex colors
#' @export
#' @examples
#' \dontrun{
#' golfr_colors("main")
#' golfr_colors("sequential", n = 5)
#' }
golfr_colors <- function(palette = "main", n = NULL) {
  palettes <- list(
    main = c(
      "#2E7D32",  # Golf green
      "#1565C0",  # Blue
      "#F57C00",  # Orange
      "#C62828",  # Red
      "#6A1B9A",  # Purple
      "#00695C"   # Teal
    ),
    sequential = c("#E8F5E9", "#A5D6A7", "#66BB6A", "#43A047", "#2E7D32", "#1B5E20"),
    diverging = c("#C62828", "#EF5350", "#FFCDD2", "#F0F0F0", "#C5E1A5", "#66BB6A", "#2E7D32"),
    strokes_gained = c(
      "#C62828",  # Very negative (red)
      "#EF5350",  # Negative (light red)
      "#F0F0F0",  # Neutral (gray)
      "#66BB6A",  # Positive (light green)
      "#2E7D32"   # Very positive (green)
    )
  )

  colors <- palettes[[palette]]

  if (!is.null(n)) {
    if (n <= length(colors)) {
      colors <- colors[1:n]
    } else {
      colors <- grDevices::colorRampPalette(colors)(n)
    }
  }

  colors
}

#' golfr ggplot2 Scale - Color
#'
#' Discrete color scale using golfr color palette
#'
#' @param palette Palette name (default: "main")
#' @param ... Additional arguments passed to scale_color_manual
#' @return A ggplot2 scale object
#' @export
scale_color_golfr <- function(palette = "main", ...) {
  ggplot2::scale_color_manual(values = golfr_colors(palette), ...)
}

#' golfr ggplot2 Scale - Fill
#'
#' Discrete fill scale using golfr color palette
#'
#' @param palette Palette name (default: "main")
#' @param ... Additional arguments passed to scale_fill_manual
#' @return A ggplot2 scale object
#' @export
scale_fill_golfr <- function(palette = "main", ...) {
  ggplot2::scale_fill_manual(values = golfr_colors(palette), ...)
}
