test_that("dg_live_status basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_live_status()
    expect_true(is.data.frame(result), "Expected a data.frame")
    # Add more checks as needed
  })
})

test_that("dg_live_status input validation", {
  skip_on_cran()
  expect_error(dg_live_status(INVALID_INPUTS))
  # Add more scenarios for different types of invalid inputs
})
