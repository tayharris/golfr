
test_that("dg_live_stats basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_live_stats()
    expect_true(is.data.frame(result), "Expected a data.frame")
    # Add more checks as needed
  })
})

test_that("dg_live_stats input validation", {
  skip_on_cran()
  expect_error(dg_live_stats(INVALID_INPUTS))
  # Add more scenarios for different types of invalid inputs
})
