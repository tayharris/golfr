library(httptest)

# Define a list of API request calls as functions
api_requests <- list(
  function() dg_schedule("pga"),
  function() dg_field_updates("pga"),
  function() dg_event_name("pga"),
  function() dg_historical_events(),
  function() dg_historical_predictions(event_id = "14", year = "2022", odds_format = "percent"),
  function() dg_historical_raw_data(year = "2022", event_id = "14", tour = "pga"),
  function() dg_historical_event_info(event_id = "14", year = "2022", odds_format = "percent", format = "json"),
  function() dg_live_predictions(),
  function() dg_live_stats(),
  function() dg_live_status(),
  function() dg_live_hole_scoring(),
  function() dg_matchups(),
  function() dg_outrights(),
  function() dg_player_decomp(),
  function() dg_player_list(),
  function() dg_pre_tournament_predictions(tour = "pga", odds_format = "percent"),
  function() dg_rankings(),
  function() dg_schedule(),
  function() dg_skill_ratings(),
  function() get_all_market_odds()
)

# Start capturing
httptest::start_capturing("tests/testthat/fixtures")

# Loop through each API request, execute it, and handle success or error
for (api_request in api_requests) {
  tryCatch({
    api_request()
    cat("Successfully captured:", deparse(substitute(api_request)), "\n")
  }, error = function(e) {
    cat("Error capturing:", deparse(substitute(api_request)), "\nError message:", e$message, "\n")
  })
}

# Stop capturing
httptest::stop_capturing()
