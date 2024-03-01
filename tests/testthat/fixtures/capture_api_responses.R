httptest::start_capturing("tests/testthat/fixtures")
httptest::capture_requests({
  # Make the actual API requests
  dg_schedule("pga")
  dg_field_updates("pga")
  dg_event_name("pga")
  dg_historical_events()
  dg_historical_predictions(event_id = "14",
                            year = "2022",
                            odds_format = "percent")
  dg_historical_raw_data(
    year = "2022",
    event_id = "14",
    tour = "pga"
  )
  dg_historical_event_info(
    event_id = "14",
    year = "2022",
    odds_format = "percent",
    format = "json"
  )
  dg_live_predictions()
  dg_live_stats()
  dg_live_status()
  dg_live_hole_scoring()
  dg_matchups()
  dg_outrights()
  dg_player_decomp()
  dg_player_list()
  dg_pre_tournament_predictions()
  dg_rankings()
  dg_schedule()
  dg_skill_ratings()
  get_all_market_odds()
})
httptest::stop_capturing()
