test_that("dg_rankings basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_rankings()
    expect_true(is.data.frame(result), "Expected a data.frame")
  })
})

test_that("dg_rankings input validation", {
  skip_on_cran()
  expect_error(dg_rankings(INVALID_INPUTS))
})

#TODO Add more scenarios for different types of invalid inputs
