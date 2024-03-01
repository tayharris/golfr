test_that("dg_live_predictions basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_live_predictions()
    expect_true(is.data.frame(result), "Expected a data.frame")
    # Add more checks as needed
  })
})

test_that("dg_live_predictions input validation", {
  skip_on_cran()
  expect_error(dg_live_predictions(INVALID_INPUTS))
  # Add more scenarios for different types of invalid inputs
})
