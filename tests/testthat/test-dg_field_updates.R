test_that("dg_field_updates returns a dataframe for default 'pga'", {
  httptest::with_mock_api({
    result <- dg_field_updates("pga")
    print(class(result))
    expect_true(is.data.frame(result), "dg_field_updates should return a dataframe for 'pga'.")
  })
})

test_that("dg_field_updates for 'pga' has core top level columns", {
  httptest::with_mock_api({
    result <- dg_field_updates("pga")
    core_columns <- c("event_name", "current_round",  "last_updated") # need to add field back later
    for (col in core_columns) {
      expect_true(col %in% names(result), info = paste("Missing core top-level column:", col))
    }
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

