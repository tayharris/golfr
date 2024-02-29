test_that("dg_schedule returns a result for 'pga'", {
  with_mock_api({
    result <- dg_schedule("pga")
    expect_false(is.null(result))
  })
})

test_that("dg_schedule result is a dataframe", {
  with_mock_api({
    result <- dg_schedule("pga")
    expect_s3_class(result, "data.frame")
  })
})

test_that("dg_schedule result has expected columns", {
  with_mock_api({
    result <- dg_schedule("pga")
    expected_cols <- c("course", "course_key", "event_id", "event_name",
                       "latitude", "location", "longitude", "start_date")

    for (col in expected_cols) {
      expect_true(col %in% names(result), info = paste("Missing column:", col))
    }
  })
})
