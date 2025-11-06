#!/usr/bin/env Rscript
#
# Quick Test Script - Generate Sample Graphics
# =============================================
# Run this to test the new graphics functions and see example output
#

# Check if required packages are installed
required_packages <- c("ggplot2", "dplyr", "glue", "grid", "gtable", "ragg", "scales", "tidyr")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if(length(missing_packages)) {
  cat("Installing missing packages:", paste(missing_packages, collapse=", "), "\n")
  install.packages(missing_packages)
}

# Load the package (assumes you're in the package directory)
devtools::load_all()

# Check for API key
if (Sys.getenv("DATAGOLF_API_KEY") == "") {
  cat("\n⚠️  WARNING: DATAGOLF_API_KEY not set!\n")
  cat("Set it with: Sys.setenv(DATAGOLF_API_KEY = 'your_key')\n\n")
  stop("API key required to fetch data")
}

# Create output directory
output_dir <- "./test_graphics"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

cat("\n🏌️  Testing golfr Graphics Functions\n")
cat("=====================================\n\n")

# Test 1: Theme and colors
cat("1. Testing theme_golfr() with sample data...\n")
tryCatch({
  library(ggplot2)

  # Simple test plot
  test_data <- data.frame(
    player = c("Player A", "Player B", "Player C", "Player D", "Player E"),
    score = c(-5, -3, -2, 0, 2)
  )

  p1 <- ggplot(test_data, aes(x = reorder(player, -score), y = score)) +
    geom_col(fill = golfr_colors("main")[1], width = 0.7) +
    coord_flip() +
    labs(title = "Test Theme", subtitle = "Sample Data") +
    theme_golfr()

  filepath1 <- file.path(output_dir, "01_theme_test.png")
  save_plot_discord(p1, filename = "01_theme_test.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath1, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 2: Win Probabilities
cat("2. Testing plot_win_probabilities()...\n")
tryCatch({
  p2 <- plot_win_probabilities(tour = "pga", top_n = 15, type = "pre", branded = TRUE)
  filepath2 <- save_plot_discord(p2, filename = "02_win_probs.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath2, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 3: Skill Ratings
cat("3. Testing plot_skill_ratings()...\n")
tryCatch({
  p3 <- plot_skill_ratings(top_n = 10, branded = TRUE)
  filepath3 <- save_plot_discord(p3, filename = "03_skill_ratings.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath3, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 4: Strokes Gained Heatmap
cat("4. Testing plot_sg_heatmap()...\n")
tryCatch({
  p4 <- plot_sg_heatmap(top_n = 15, branded = TRUE)
  filepath4 <- save_plot_discord(p4, filename = "04_sg_heatmap.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath4, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 5: Market Edge Analysis
cat("5. Testing plot_market_edge()...\n")
tryCatch({
  p5 <- plot_market_edge(tour = "pga", market = "win", top_n = 15, branded = TRUE)
  filepath5 <- save_plot_discord(p5, filename = "05_market_edge.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath5, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 6: Best Bets
cat("6. Testing plot_best_bets()...\n")
tryCatch({
  p6 <- plot_best_bets(
    tour = "pga",
    markets = c("win", "top_5", "top_10"),
    picks_per_market = 3,
    min_edge = 2.0,
    branded = TRUE
  )
  filepath6 <- save_plot_discord(p6, filename = "06_best_bets.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath6, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 7: Rankings
cat("7. Testing plot_rankings()...\n")
tryCatch({
  p7 <- plot_rankings(top_n = 20, branded = TRUE)
  filepath7 <- save_plot_discord(p7, filename = "07_rankings.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath7, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Test 8: Player Spotlight
cat("8. Testing plot_player_spotlight()...\n")
tryCatch({
  # Get top 2 ranked players dynamically
  rankings <- dg_rankings()
  top_players <- rankings |>
    dplyr::arrange(datagolf_rank) |>
    dplyr::slice(1:2) |>
    dplyr::pull(player_name)

  p8 <- plot_player_spotlight(players = top_players, tour = "pga", branded = TRUE)
  filepath8 <- save_plot_discord(p8, filename = "08_player_spotlight.png", output_dir = output_dir)
  cat("   ✓ Saved:", filepath8, "\n\n")
}, error = function(e) {
  cat("   ✗ Error:", conditionMessage(e), "\n\n")
})

# Summary
cat("\n✅ Testing Complete!\n")
cat("=====================\n")
cat("Output directory:", normalizePath(output_dir), "\n")
cat("\nGenerated files:\n")
files <- list.files(output_dir, pattern = "\\.png$", full.names = TRUE)
for (f in files) {
  cat("  -", basename(f), "\n")
}

cat("\nOpen the PNG files to preview the graphics!\n")
