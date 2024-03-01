test_that("dg_matchups basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_matchups()
    expect_true(is.data.frame(result), "Expected a data.frame")
    # Add more checks as needed
  })
})

test_that("dg_matchups input validation", {
  skip_on_cran()
  expect_error(dg_matchups(INVALID_INPUTS))
})
