test_that("dg_schedule returns expected results", {
  result <- dg_schedule("pga")

  # Check if the result is a dataframe
  expect_is(result, "data.frame")

  # Check if certain expected columns exist in the dataframe
  expect_true("course" %in% names(result))
  expect_true("course_key" %in% names(result))
  expect_true("event_id" %in% names(result))
  expect_true("event_name" %in% names(result))
  expect_true("latitude" %in% names(result))
  expect_true("location" %in% names(result))
  expect_true("longitude" %in% names(result))
  expect_true("start_date" %in% names(result))

  # Optionally, check certain values for the first event
  expect_equal(result$event_name[1], "Fortinet Championship")
  expect_equal(result$location[1], "Napa County, CA")
})
