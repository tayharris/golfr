#' Add Branding Footer to ggplot
#'
#' Adds a professional footer to a ggplot object using gtable, including package
#' information and data source attribution. This creates a polished, branded
#' graphic suitable for sharing on Discord or social media.
#'
#' @param plot A ggplot2 object
#' @param data_source Character string describing the data source (default: "Data: DataGolf.com")
#' @param package_info Logical, whether to include package info (default: TRUE)
#' @param footer_text Custom footer text (overrides data_source and package_info if provided)
#' @param footer_height Height of footer in cm (default: 1.2)
#' @param text_size Footer text size (default: 9)
#' @param text_color Footer text color (default: "#666666")
#' @param bg_color Footer background color (default: "#F0F0F0")
#' @return A gtable object with footer attached
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   theme_golfr()
#' add_branding_footer(p)
#' }
add_branding_footer <- function(plot,
                                data_source = "Data: DataGolf.com",
                                package_info = TRUE,
                                footer_text = NULL,
                                footer_height = 1.2,
                                text_size = 9,
                                text_color = "#666666",
                                bg_color = "#F0F0F0") {

  # Convert ggplot to gtable
  gt <- ggplot2::ggplotGrob(plot)

  # Create footer text
  if (!is.null(footer_text)) {
    footer_label <- footer_text
  } else {
    footer_parts <- c()

    if (package_info) {
      pkg_version <- utils::packageVersion("golfr")
      footer_parts <- c(footer_parts, glue::glue("golfr v{pkg_version}"))
    }

    if (!is.null(data_source) && data_source != "") {
      footer_parts <- c(footer_parts, data_source)
    }

    footer_label <- paste(footer_parts, collapse = " | ")
  }

  # Create footer grob
  footer_grob <- grid::textGrob(
    label = footer_label,
    x = 0.02,
    hjust = 0,
    gp = grid::gpar(
      fontsize = text_size,
      col = text_color,
      fontface = "italic"
    )
  )

  # Create background for footer
  footer_bg <- grid::rectGrob(
    gp = grid::gpar(fill = bg_color, col = NA)
  )

  # Combine background and text into single grob
  footer_combined <- grid::grobTree(footer_bg, footer_grob)

  # Add footer row to gtable
  gt <- gtable::gtable_add_rows(gt, grid::unit(footer_height, "cm"), pos = -1)
  gt <- gtable::gtable_add_grob(
    gt,
    footer_combined,
    t = nrow(gt),
    l = 1,
    r = ncol(gt),
    name = "footer"
  )

  # Return the modified gtable
  class(gt) <- c("golfr_plot", class(gt))
  gt
}

#' Add Title Block to ggplot
#'
#' Adds a prominent title block above a ggplot, useful for tournament names
#' or weekly summaries. Works with add_branding_footer for complete branding.
#'
#' @param plot A ggplot2 object or golfr_plot gtable
#' @param title Main title text
#' @param subtitle Optional subtitle text
#' @param title_height Height of title block in cm (default: 2.0)
#' @param title_size Title text size (default: 18)
#' @param subtitle_size Subtitle text size (default: 14)
#' @param text_color Text color (default: "#2C3E50")
#' @param bg_color Background color (default: "#E0E0E0")
#' @return A gtable object with title block attached
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   theme_golfr()
#' p_branded <- add_title_block(p, "Tournament Leaderboard", "Round 3")
#' add_branding_footer(p_branded)
#' }
add_title_block <- function(plot,
                            title,
                            subtitle = NULL,
                            title_height = 2.0,
                            title_size = 18,
                            subtitle_size = 14,
                            text_color = "#2C3E50",
                            bg_color = "#E0E0E0") {

  # Convert to gtable if needed
  if (inherits(plot, "ggplot")) {
    gt <- ggplot2::ggplotGrob(plot)
  } else {
    gt <- plot
  }

  # Create title grobs
  title_grob <- grid::textGrob(
    label = title,
    x = 0.02,
    y = if (!is.null(subtitle)) 0.65 else 0.5,
    hjust = 0,
    vjust = 0.5,
    gp = grid::gpar(
      fontsize = title_size,
      col = text_color,
      fontface = "bold"
    )
  )

  # Create background
  title_bg <- grid::rectGrob(
    gp = grid::gpar(fill = bg_color, col = NA)
  )

  # Combine elements
  if (!is.null(subtitle)) {
    subtitle_grob <- grid::textGrob(
      label = subtitle,
      x = 0.02,
      y = 0.35,
      hjust = 0,
      vjust = 0.5,
      gp = grid::gpar(
        fontsize = subtitle_size,
        col = text_color
      )
    )
    title_combined <- grid::grobTree(title_bg, title_grob, subtitle_grob)
  } else {
    title_combined <- grid::grobTree(title_bg, title_grob)
  }

  # Add title row to gtable
  gt <- gtable::gtable_add_rows(gt, grid::unit(title_height, "cm"), pos = 0)
  gt <- gtable::gtable_add_grob(
    gt,
    title_combined,
    t = 1,
    l = 1,
    r = ncol(gt),
    name = "title_block"
  )

  # Return the modified gtable
  class(gt) <- c("golfr_plot", class(gt))
  gt
}

#' Print method for golfr_plot
#'
#' @param x A golfr_plot object
#' @param ... Additional arguments (ignored)
#' @export
print.golfr_plot <- function(x, ...) {
  grid::grid.newpage()
  grid::grid.draw(x)
}
