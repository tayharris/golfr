# golfr Graphics Functions for Discord

This guide covers the new visualization and graphics export features in the `golfr` package, designed for creating branded golf analytics graphics to share on Discord and social media.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Branded Theme](#branded-theme)
- [Graphics Functions](#graphics-functions)
- [Market Analysis Functions](#market-analysis-functions)
- [Export and Discord Integration](#export-and-discord-integration)
- [Discord Bot Integration](#discord-bot-integration)

---

## Installation

```r
# Install development version from GitHub
devtools::install_github("tayharris/golfr")

# Load the package
library(golfr)

# Set your DataGolf API key
Sys.setenv(DATAGOLF_API_KEY = "your_api_key_here")
```

---

## Quick Start

Generate all weekly graphics with one command:

```r
library(golfr)

# Generate complete weekly bundle
create_weekly_bundle(
  tour = "pga",
  output_dir = "./discord_graphics",
  graphics = c("win_probs", "skill_ratings", "sg_heatmap", "market_edge", "best_bets")
)
```

This creates 5 branded PNG files ready to share on Discord!

---

## Branded Theme

### `theme_golfr()`

A clean, professional ggplot2 theme inspired by FiveThirtyEight and hrbrthemes, optimized for golf analytics.

```r
library(ggplot2)

ggplot(data, aes(x = player, y = score)) +
  geom_col() +
  theme_golfr(base_size = 14)
```

**Features:**
- Light background with minimal grid lines
- Bold, readable typography
- Optimized for data visualization
- Works with any ggplot2 chart

### Color Palettes

```r
# Get golfr color palette
golfr_colors("main")              # Main palette (6 colors)
golfr_colors("sequential", n = 5) # Sequential palette
golfr_colors("diverging")         # Diverging palette (red-gray-green)
golfr_colors("strokes_gained")    # Strokes gained palette

# Use in ggplot2
ggplot(data, aes(x = category, y = value, fill = category)) +
  geom_col() +
  scale_fill_golfr("main") +
  theme_golfr()
```

### Branding Footer

```r
# Add package info and data source footer
p <- ggplot(...) + theme_golfr()
p_branded <- add_branding_footer(
  p,
  data_source = "Data: DataGolf.com",
  package_info = TRUE  # Adds "golfr vX.X.X"
)

# Add title block
p_final <- add_title_block(
  p_branded,
  title = "PGA Championship",
  subtitle = "Round 3 Analysis"
)
```

---

## Graphics Functions

### Win Probabilities

**`plot_win_probabilities()`** - Tournament win probabilities

```r
# Pre-tournament predictions
plot_win_probabilities(
  tour = "pga",
  top_n = 15,
  type = "pre",      # "pre" or "live"
  branded = TRUE
)

# Live predictions during tournament
plot_win_probabilities(tour = "pga", type = "live", top_n = 10)
```

### Finish Probabilities

**`plot_finish_probabilities()`** - Top 5/10/20 finish probabilities

```r
plot_finish_probabilities(
  tour = "pga",
  top_n = 10,
  branded = TRUE
)

# Specific players
plot_finish_probabilities(
  players = c("Scottie Scheffler", "Rory McIlroy")
)
```

### Skill Ratings Comparison

**`plot_skill_ratings()`** - Skill breakdown by category

```r
# Top 10 players
plot_skill_ratings(top_n = 10, branded = TRUE)

# Specific players
plot_skill_ratings(
  players = c("Scottie Scheffler", "Rory McIlroy", "Jon Rahm"),
  skills = c("sg_ott", "sg_app", "sg_arg", "sg_putt")
)
```

### Strokes Gained Heatmap

**`plot_sg_heatmap()`** - Visual heatmap of SG across categories

```r
plot_sg_heatmap(top_n = 15, branded = TRUE)

# Specific players
plot_sg_heatmap(
  players = c("Scottie Scheffler", "Rory McIlroy", "Jon Rahm")
)
```

### Rankings

**`plot_rankings()`** - DataGolf world rankings

```r
plot_rankings(top_n = 20, branded = TRUE)
```

---

## Market Analysis Functions

These functions help identify betting value by comparing DataGolf predictions to market odds.

### Market Edge Analysis

**`plot_market_edge()`** - Find players with biggest edge vs betting markets

```r
# Win market edge
plot_market_edge(
  tour = "pga",
  market = "win",
  top_n = 15,
  min_probability = 0.01,  # Only show players with >1% win prob
  show_negative = FALSE,   # Only show positive edges
  branded = TRUE
)

# Top 5 market
plot_market_edge(tour = "pga", market = "top_5", top_n = 20)

# Show both positive and negative edges
plot_market_edge(tour = "pga", show_negative = TRUE)
```

**Markets:** `"win"`, `"top_5"`, `"top_10"`, `"top_20"`, `"make_cut"`

**What is Edge?**
- Edge = DataGolf Probability - Market Implied Probability
- Positive edge = DataGolf sees more value than market
- Higher edge = bigger potential value bet

### Best Bets Summary

**`plot_best_bets()`** - Top value picks across multiple markets

```r
plot_best_bets(
  tour = "pga",
  markets = c("win", "top_5", "top_10"),
  picks_per_market = 3,
  min_edge = 2.0,  # Minimum 2% edge
  branded = TRUE
)
```

Shows your top betting picks with:
- Player name and odds
- Edge percentage
- Organized by market

### Player Spotlight

**`plot_player_spotlight()`** - Detailed player analysis

```r
plot_player_spotlight(
  players = c("Scottie Scheffler", "Rory McIlroy"),
  tour = "pga",
  include_odds = TRUE,
  branded = TRUE
)
```

Shows:
- Skill ratings breakdown
- Rankings (DataGolf & OWGR)
- Win/Top 5/Top 10/Top 20 probabilities
- Current betting odds

### Odds Comparison

**`plot_odds_comparison()`** - Compare odds across sportsbooks

```r
plot_odds_comparison(
  tour = "pga",
  market = "win",
  top_n = 8,
  branded = TRUE
)
```

---

## Export and Discord Integration

### Save Plots for Discord

**`save_plot_discord()`** - Export high-quality PNG optimized for Discord

```r
p <- plot_win_probabilities()

save_plot_discord(
  p,
  filename = "win_probs.png",
  width = 1200,    # pixels
  height = 800,    # pixels
  dpi = 300,
  output_dir = "./discord_graphics"
)
```

**Features:**
- Uses `ragg` for superior text rendering
- Optimized for Discord display
- High DPI for quality

### Discord Presets

**`discord_presets()`** - Pre-configured dimensions

```r
# Get preset dimensions
dims <- discord_presets("wide")

save_plot_discord(
  plot,
  width = dims$width,
  height = dims$height,
  dpi = dims$dpi
)
```

**Available Presets:**
- `"standard"` - 1200x800 (general use)
- `"wide"` - 1600x900 (desktop viewing)
- `"tall"` - 1000x1400 (vertical content)
- `"embed"` - 800x600 (compact embeds)
- `"banner"` - 1920x1080 (full HD)
- `"square"` - 1200x1200 (social media)

### Weekly Bundle

**`create_weekly_bundle()`** - Generate complete weekly graphics set

```r
create_weekly_bundle(
  tour = "pga",
  output_dir = "./discord_graphics",
  graphics = c(
    "win_probs",        # Win probabilities
    "skill_ratings",    # Skill comparison
    "sg_heatmap",       # Strokes gained heatmap
    "market_edge",      # Market edge analysis
    "best_bets",        # Best betting value
    "player_spotlight"  # Player spotlight
  ),
  spotlight_players = c("Scottie Scheffler", "Rory McIlroy"),
  preset = "standard"
)
```

**Returns:** Named vector of file paths for all created graphics

---

## Discord Bot Integration

### Python Discord Bot Example

See `examples/discord_bot_example.py` for a complete Discord bot implementation using `rpy2`.

**Bot Commands:**
- `!golf weekly [tour]` - Generate all weekly graphics
- `!golf edge [tour] [market] [top_n]` - Market edge analysis
- `!golf bets [tour] [min_edge]` - Best betting picks
- `!golf spotlight <player1> [player2]...` - Player spotlight
- `!golf skills [tour] [top_n]` - Skill ratings
- `!golf heatmap [top_n]` - Strokes gained heatmap
- `!golf winprobs [tour] [top_n]` - Win probabilities
- `!golf rankings [top_n]` - World rankings

### R Script Example

See `examples/discord_graphics_example.R` for standalone R script examples.

---

## Function Reference

### Visualization Functions

| Function | Description |
|----------|-------------|
| `plot_win_probabilities()` | Tournament win probabilities |
| `plot_finish_probabilities()` | Top 5/10/20 finish probabilities |
| `plot_skill_ratings()` | Skill ratings comparison by category |
| `plot_sg_heatmap()` | Strokes gained heatmap |
| `plot_rankings()` | DataGolf world rankings |
| `plot_market_edge()` | Market edge analysis (DG vs betting markets) |
| `plot_best_bets()` | Best betting value picks |
| `plot_player_spotlight()` | Detailed player analysis |
| `plot_odds_comparison()` | Odds comparison across sportsbooks |

### Theme & Branding

| Function | Description |
|----------|-------------|
| `theme_golfr()` | Professional ggplot2 theme |
| `golfr_colors()` | Color palettes |
| `scale_color_golfr()` | ggplot2 color scale |
| `scale_fill_golfr()` | ggplot2 fill scale |
| `add_branding_footer()` | Add package/data source footer |
| `add_title_block()` | Add prominent title block |

### Export Functions

| Function | Description |
|----------|-------------|
| `save_plot_discord()` | Save plot as Discord-optimized PNG |
| `discord_presets()` | Get preset dimensions |
| `create_weekly_bundle()` | Generate complete weekly graphics set |

---

## Tours Supported

- `"pga"` - PGA Tour
- `"euro"` - DP World Tour (European Tour)
- `"liv"` - LIV Golf
- `"opp"` - Opposite field events
- `"kft"` - Korn Ferry Tour

---

## Tips for Great Graphics

1. **Use branded = TRUE** for all Discord posts to include footer
2. **Standard preset** works best for most Discord channels
3. **Market edge analysis** is most useful Tuesday-Wednesday when lines are first posted
4. **Player spotlight** great for featured matchups or favorites
5. **Weekly bundle** perfect for posting all graphics at once
6. **Skill heatmap** shows patterns across multiple players quickly
7. **Best bets** gives actionable picks in one graphic

---

## Examples

### Example 1: Weekly Graphics Workflow

```r
# Tuesday: Post market edge when lines drop
plot_market_edge(tour = "pga", market = "win") |>
  save_plot_discord("tuesday_edge.png")

# Wednesday: Post best bets
plot_best_bets(tour = "pga", min_edge = 2.5) |>
  save_plot_discord("wednesday_bets.png")

# Thursday: Post skill ratings and spotlight
create_weekly_bundle(
  graphics = c("skill_ratings", "player_spotlight"),
  spotlight_players = c("Scottie Scheffler", "Rory McIlroy")
)
```

### Example 2: Tournament Week Analysis

```r
# Pre-tournament
plot_win_probabilities(type = "pre", top_n = 20)
plot_market_edge(market = "win", show_negative = FALSE)

# During tournament
plot_win_probabilities(type = "live", top_n = 10)
plot_finish_probabilities(players = c("Leader 1", "Leader 2", "Leader 3"))
```

---

## Support

- Package: https://github.com/tayharris/golfr
- Issues: https://github.com/tayharris/golfr/issues
- DataGolf API: https://datagolf.com/api-access

---

**Happy graphing!** ⛳📊🏌️
