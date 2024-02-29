test_that("dg_player_list returns a result", {
  result <- dg_player_list()
  expect_false(is.null(result), "dg_player_list should not return NULL.")
})

test_that("dg_player_list result is a dataframe", {
  result <- dg_player_list()
  expect_is(result, "data.frame", "dg_player_list should return a dataframe.")
})

test_that("dg_player_list result has expected columns", {
  result <- dg_player_list()
  expected_cols <- c("amateur", "country", "country_code", "dg_id", "player_name")

  for (col in expected_cols) {
    expect_true(col %in% names(result), info = paste("Missing column:", col))
  }
})
