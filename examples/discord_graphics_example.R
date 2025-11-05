#!/usr/bin/env Rscript
#
# Example R Script: Generating Discord Graphics with golfr
# =========================================================
#
# This script demonstrates how to use the golfr package to generate
# branded golf analytics graphics suitable for sharing on Discord.
#

library(golfr)

# Set your DataGolf API key (or set DATAGOLF_API_KEY environment variable)
# Sys.setenv(DATAGOLF_API_KEY = "your_api_key_here")

# =============================================================================
# Example 1: Generate Complete Weekly Bundle
# =============================================================================
# This creates all recommended weekly graphics in one call

cat("Generating weekly graphics bundle...\n")
files <- create_weekly_bundle(
  tour = "pga",
  output_dir = "./discord_graphics",
  graphics = c("win_probs", "skill_ratings", "sg_heatmap", "market_edge", "best_bets"),
  preset = "standard"  # 1200x800 pixels
)

cat("\nGenerated files:\n")
print(files)


# =============================================================================
# Example 2: Market Edge Analysis (Find Value Bets)
# =============================================================================
# Identify players where DataGolf sees more value than betting markets

cat("\n\nGenerating market edge analysis...\n")
p_edge <- plot_market_edge(
  tour = "pga",
  market = "win",         # Options: "win", "top_5", "top_10", "top_20", "make_cut"
  top_n = 15,            # Show top 15 edges
  show_negative = FALSE, # Only show positive edges (value bets)
  branded = TRUE
)

save_plot_discord(
  p_edge,
  filename = "market_edge_win.png",
  output_dir = "./discord_graphics",
  width = 1200,
  height = 800
)


# =============================================================================
# Example 3: Best Bets Summary
# =============================================================================
# Get top betting picks across multiple markets

cat("\nGenerating best bets summary...\n")
p_bets <- plot_best_bets(
  tour = "pga",
  markets = c("win", "top_5", "top_10"),  # Analyze multiple markets
  picks_per_market = 3,                   # Top 3 per market
  min_edge = 2.0,                         # Minimum 2% edge
  branded = TRUE
)

save_plot_discord(
  p_bets,
  filename = "best_bets.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 4: Player Spotlight
# =============================================================================
# Detailed analysis of specific players

cat("\nGenerating player spotlight...\n")
p_spotlight <- plot_player_spotlight(
  players = c("Scottie Scheffler", "Rory McIlroy"),
  tour = "pga",
  include_odds = TRUE,
  branded = TRUE
)

save_plot_discord(
  p_spotlight,
  filename = "player_spotlight.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 5: Skill Ratings Comparison
# =============================================================================
# Compare skill ratings across categories for top players

cat("\nGenerating skill ratings comparison...\n")
p_skills <- plot_skill_ratings(
  top_n = 10,
  skills = c("sg_ott", "sg_app", "sg_arg", "sg_putt"),
  branded = TRUE
)

save_plot_discord(
  p_skills,
  filename = "skill_ratings.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 6: Strokes Gained Heatmap
# =============================================================================
# Visual heatmap showing SG performance across categories

cat("\nGenerating strokes gained heatmap...\n")
p_heatmap <- plot_sg_heatmap(
  top_n = 15,
  branded = TRUE
)

save_plot_discord(
  p_heatmap,
  filename = "sg_heatmap.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 7: Win Probabilities
# =============================================================================
# Tournament win probabilities

cat("\nGenerating win probabilities...\n")
p_win <- plot_win_probabilities(
  tour = "pga",
  top_n = 15,
  type = "pre",  # "pre" for pre-tournament, "live" during tournament
  branded = TRUE
)

save_plot_discord(
  p_win,
  filename = "win_probabilities.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 8: Finish Probabilities
# =============================================================================
# Top 5/10/20 finish probabilities

cat("\nGenerating finish probabilities...\n")
p_finish <- plot_finish_probabilities(
  tour = "pga",
  top_n = 10,
  branded = TRUE
)

save_plot_discord(
  p_finish,
  filename = "finish_probabilities.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 9: Rankings
# =============================================================================
# DataGolf world rankings

cat("\nGenerating rankings...\n")
p_rankings <- plot_rankings(
  top_n = 20,
  branded = TRUE
)

save_plot_discord(
  p_rankings,
  filename = "rankings.png",
  output_dir = "./discord_graphics"
)


# =============================================================================
# Example 10: Custom Dimensions for Different Discord Uses
# =============================================================================
# Use different preset sizes

cat("\nGenerating graphics with different sizes...\n")

# Wide format for desktop viewing
dims_wide <- discord_presets("wide")
p_wide <- plot_market_edge(tour = "pga", market = "top_5")
save_plot_discord(
  p_wide,
  filename = "market_edge_wide.png",
  output_dir = "./discord_graphics",
  width = dims_wide$width,
  height = dims_wide$height
)

# Square format for social media
dims_square <- discord_presets("square")
p_square <- plot_sg_heatmap(top_n = 12)
save_plot_discord(
  p_square,
  filename = "heatmap_square.png",
  output_dir = "./discord_graphics",
  width = dims_square$width,
  height = dims_square$height
)


# =============================================================================
# Example 11: Using the Branded Theme Standalone
# =============================================================================
# You can use theme_golfr() with your own ggplot2 code

library(ggplot2)

# Custom plot with golfr theme
rankings_data <- dg_rankings()

p_custom <- ggplot(rankings_data[1:20, ], aes(x = reorder(player_name, -datagolf_rank), y = datagolf_rank)) +
  geom_col(fill = golfr_colors("main")[1]) +
  coord_flip() +
  labs(
    title = "Top 20 DataGolf Rankings",
    x = NULL,
    y = "Rank"
  ) +
  theme_golfr(base_size = 14)  # Use golfr theme

# Add branding footer
p_custom_branded <- add_branding_footer(
  p_custom,
  data_source = "Data: DataGolf.com",
  package_info = TRUE
)

save_plot_discord(
  p_custom_branded,
  filename = "custom_with_theme.png",
  output_dir = "./discord_graphics"
)


cat("\n\n✅ All examples complete! Check ./discord_graphics/ directory\n")
cat("You can now share these graphics on Discord or social media.\n")
