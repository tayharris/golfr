# Testing Graphics Functions - Quick Guide

Since R isn't available in the development environment, here's how to test the graphics functions on your local machine:

## Prerequisites

1. **R installed** (version 4.0+)
2. **DataGolf API key**
3. **Internet connection** (to fetch data from DataGolf API)

## Quick Test (5 minutes)

### Step 1: Set your API key

```r
# In R console
Sys.setenv(DATAGOLF_API_KEY = "your_api_key_here")
```

Or add to your `~/.Renviron` file:
```bash
DATAGOLF_API_KEY=your_api_key_here
```

### Step 2: Install dependencies

```r
install.packages(c("devtools", "ggplot2", "dplyr", "glue", "grid", "gtable",
                   "ragg", "scales", "tidyr", "httr", "jsonlite", "purrr", "rlang"))
```

### Step 3: Load the package

```r
# From the golfr directory
devtools::load_all()
```

### Step 4: Run the test script

```r
source("test_graphics_functions.R")
```

This will generate 8 test graphics in `./test_graphics/`:
1. Theme test (sample data)
2. Win probabilities
3. Skill ratings comparison
4. Strokes gained heatmap
5. **Market edge analysis**
6. **Best bets summary**
7. Rankings
8. Player spotlight

### Step 5: View the output

Open the PNG files in `./test_graphics/` directory to see the results!

---

## Manual Testing (Individual Functions)

If you want to test specific functions:

```r
library(golfr)

# Test 1: Simple theme
library(ggplot2)
test_data <- data.frame(
  player = c("Player A", "Player B", "Player C"),
  score = c(-5, -3, -1)
)

p <- ggplot(test_data, aes(x = player, y = score)) +
  geom_col(fill = golfr_colors("main")[1]) +
  theme_golfr()

print(p)  # View in RStudio plot pane
```

```r
# Test 2: Win probabilities
p <- plot_win_probabilities(tour = "pga", top_n = 10)
print(p)
```

```r
# Test 3: Market edge (your key feature!)
p <- plot_market_edge(tour = "pga", market = "win", top_n = 15)
print(p)

# Save it
save_plot_discord(p, "market_edge_test.png")
```

```r
# Test 4: Best bets
p <- plot_best_bets(tour = "pga", min_edge = 2.5)
print(p)
```

```r
# Test 5: Generate complete weekly bundle
create_weekly_bundle(tour = "pga", output_dir = "./my_graphics")
```

---

## Troubleshooting

### "R: command not found"
- Install R from https://cran.r-project.org/

### "DATAGOLF_API_KEY not set"
- Get API key from https://datagolf.com/api-access
- Set with `Sys.setenv(DATAGOLF_API_KEY = "your_key")`

### "Package 'ggplot2' not found"
- Install: `install.packages("ggplot2")`

### "API request failed [401]"
- Your API key is invalid or expired
- Check https://datagolf.com/api-access

### "No active tournament found"
- Some functions require an active tournament
- Try `tour = "pga"` during PGA Tour season

### Graphics look different than expected
- Make sure all dependencies are up to date
- Check that `ragg` is installed for high-quality rendering
- Try different `discord_presets()` for sizing

---

## What You Should See

### Win Probabilities
- Bar chart showing top players by win percentage
- Green bars with probabilities labeled
- Title with tournament name
- Footer with "golfr vX.X.X | Data: DataGolf.com"

### Market Edge Analysis
- Horizontal bar chart
- Green bars = positive edge (value bets)
- Red bars = negative edge (overvalued)
- Each bar shows edge in percentage points
- Labels show both DataGolf % and Market %

### Best Bets
- Multiple bars grouped by market (win, top_5, top_10)
- Player names with odds and edge %
- Color-coded by market type
- Only shows bets meeting minimum edge threshold

### Skill Ratings
- Faceted bar charts (one per player)
- Categories: Off Tee, Approach, Around Green, Putting
- Color-coded by skill category
- Horizontal line at 0 for reference

### Strokes Gained Heatmap
- Grid layout with players (rows) x skills (columns)
- Color gradient: Red (negative) → Gray (neutral) → Green (positive)
- Values displayed in each cell
- Darker green = stronger skill

---

## Next Steps After Testing

Once graphics look good:

1. **Commit test script**: `git add test_graphics_functions.R TESTING_GRAPHICS.md`
2. **Set up Discord bot**: See `examples/discord_bot_example.py`
3. **Create weekly posting schedule**:
   - Tuesday: Market edge when lines drop
   - Wednesday: Best bets
   - Thursday: Player spotlight + skill ratings
4. **Share with your community**!

---

## Example Weekly Workflow

```r
# Tuesday morning (when lines are fresh)
plot_market_edge(tour = "pga", market = "win") |>
  save_plot_discord("tuesday_edge.png")

# Post to Discord with your analysis

# Wednesday
plot_best_bets(tour = "pga", min_edge = 2.5) |>
  save_plot_discord("wednesday_bets.png")

# Thursday (player highlights)
plot_player_spotlight(c("Scottie Scheffler", "Rory McIlroy")) |>
  save_plot_discord("thursday_spotlight.png")

# Friday/Weekend (tournament tracking)
plot_win_probabilities(tour = "pga", type = "live") |>
  save_plot_discord("live_probs.png")
```

Enjoy your new graphics functions! 🏌️📊
