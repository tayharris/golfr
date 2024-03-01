
test_that("get_all_market_odds basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- get_all_market_odds()
    expect_true(is.data.frame(result), "Expected a data.frame")
  })
})

test_that("get_all_market_odds input validation", {
  skip_on_cran()
  expect_error(get_all_market_odds(INVALID_INPUTS))
})

#TODO Add more scenarios for different types of invalid inputs
