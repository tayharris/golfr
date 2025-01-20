test_that("dg_field_updates returns a dataframe for default 'pga'", {
  with_mock_api({
    result <- dg_field_updates("pga")
    expect_s3_class(result, "data.frame")
  })
})

test_that("dg_field_updates for 'pga' has core top level columns", {
  with_mock_api({
    result <- dg_field_updates("pga")
    expected_cols <- c("current_round", "event_id", "event_name", "last_updated")
    expect_true(all(expected_cols %in% colnames(result)))
  })
})

test_that("dg_field_updates for 'euro' has additional expected columns in flattened structure", {
  httptest::with_mock_api({
    result <- dg_field_updates("euro")

    # Adjusting the column names to match the flattened structure
    additional_columns <- c("field.am", "field.country", "field.course", "field.dk_id", "field.dk_salary")

    for (col in additional_columns) {
      expect_true(col %in% names(result), info = paste("Missing additional column in flattened structure:", col))
    }
  })
})

