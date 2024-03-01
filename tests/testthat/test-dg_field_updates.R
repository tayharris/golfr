test_that("dg_field_updates returns a dataframe for default 'pga'", {
  httptest::with_mock_api({
    result <- dg_field_updates("pga")
    expect_s3_class(result, "data.frame", "dg_field_updates should return a dataframe for 'pga'.")
  })
})

test_that("dg_field_updates for 'pga' has core top level columns", {
  httptest::with_mock_api({
    result <- dg_field_updates("pga")
    core_columns <- c("event_name", "current_round", "field", "last_updated")

    for (col in core_columns) {
      expect_true(col %in% names(result), info = paste("Missing core top-level column:", col))
    }
  })
})

test_that("dg_field_updates for 'euro' has core columns in 'field' sublist", {
  httptest::with_mock_api({
    result <- dg_field_updates("euro")

    expect_true("field" %in% names(result), "Result should have a 'field' sublist.")

    # Assuming 'field' is a list element and itself a data frame
    field_df <- result[["field"]]

    expect_s3_class(field_df, "data.frame", "'field' sublist should be a dataframe.")

    core_columns <- c("dg_id", "player_name")

    for (col in core_columns) {
      expect_true(col %in% names(field_df), info = paste("Missing core column in 'field' sublist:", col))
    }
  })
})

test_that("dg_field_updates for 'euro' has additional expected columns", {
  httptest::with_mock_api({
    result <- dg_field_updates("euro")

    # Assuming 'field' is a list element and itself a data frame
    field_df <- result[["field"]]

    additional_columns <- c("am", "country", "course", "dk_id", "dk_salary")

    for (col in additional_columns) {
      expect_true(col %in% names(field_df), info = paste("Missing additional column in 'field' sublist:", col))
    }
  })
})
