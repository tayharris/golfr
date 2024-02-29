test_that("dg_field_updates returns expected results for euro", {
  result <- dg_field_updates("euro")

  # Check if the result is a dataframe
  expect_is(result, "data.frame")

  # Check if certain expected columns exist
  expect_true("am" %in% names(result))
  expect_true("country" %in% names(result))
  expect_true("course" %in% names(result))
  expect_true("dg_id" %in% names(result))
  expect_true("dk_id" %in% names(result))
  expect_true("dk_salary" %in% names(result))
  expect_true("player_name" %in% names(result))

  # Optionally, check certain values for the first player
  expect_equal(result$player_name[1], "Aphibarnrat, Kiradech")
  expect_equal(result$country[1], "THA")

  # Testing the case where there's no event this week
  no_event_result <- dg_field_updates("pga")
  expect_equal(no_event_result$error, "no pga event this week.")
})
