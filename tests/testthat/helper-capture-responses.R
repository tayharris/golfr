#' Capture API responses for testing
#' Not exported, only used internally for test setup
capture_test_responses <- function() {
  library(httptest)
  
  # Configure httptest
  httptest::with_mock_dir("tests/testthat", {
    # Function to safely capture API responses
    capture_endpoint <- function(fn, ...) {
      tryCatch({
        message(sprintf("Capturing response for %s...", deparse(substitute(fn))))
        result <- fn(...)
        message("Success!")
      }, error = function(e) {
        message(sprintf("Error capturing %s: %s", deparse(substitute(fn)), e$message))
      })
    }
    
    # Capture responses for all endpoints
    capture_endpoint(dg_schedule, "pga")
    capture_endpoint(dg_field_updates, "pga")
    capture_endpoint(dg_field_updates, "euro")
    capture_endpoint(dg_event_name, "pga")
    capture_endpoint(dg_historical_events)
    capture_endpoint(dg_historical_predictions, event_id = "14", year = "2024", odds_format = "percent")
    capture_endpoint(dg_historical_raw_data, year = "2024", event_id = "14", tour = "pga")
    capture_endpoint(dg_historical_event_info, event_id = "14", year = "2024", odds_format = "percent")
    capture_endpoint(dg_live_predictions)
    capture_endpoint(dg_live_stats)
    capture_endpoint(dg_live_status)
    capture_endpoint(dg_live_hole_scoring)
    capture_endpoint(dg_matchups)
    capture_endpoint(dg_outrights, tour = "pga", odds_format = "percent")
    capture_endpoint(dg_player_decomp)
    capture_endpoint(dg_player_list)
    capture_endpoint(dg_pre_tournament_predictions, tour = "pga", odds_format = "percent")
    capture_endpoint(dg_rankings)
    capture_endpoint(dg_skill_ratings)
    capture_endpoint(get_all_market_odds)
  })
  
  message("\nDone capturing responses!")
} 