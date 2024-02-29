httptest::start_capturing("tests/testthat/fixtures")
httptest::capture_requests({
  # Make the actual API requests
  dg_schedule("pga")
  dg_player_list()
  dg_field_updates("pga")
})
httptest::stop_capturing()
