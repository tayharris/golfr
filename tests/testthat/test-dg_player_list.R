test_that("dg_player_list returns expected results", {
  result <- dg_player_list()

  # Check if the result is a dataframe
  expect_is(result, "data.frame")

  # Check if certain expected columns exist in the dataframe
  expect_true("player_name" %in% names(result))
  expect_true("player_id" %in% names(result))
  expect_true("last_name" %in% names(result))
  expect_true("first_name" %in% names(result))
  expect_true("country" %in% names(result))

  # Optionally, check certain values for the first player
  # Note: The actual values to check would depend on the order and content of the captured API response.
  expect_equal(result$player_name[1], "The first player's name from the captured response")
  expect_equal(result$country[1], "The first player's country from the captured response")
})
