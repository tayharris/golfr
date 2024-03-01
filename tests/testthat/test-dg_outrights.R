test_that("dg_outrights basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_outrights(tour = "pga", odds_format = "percent")
    expect_true(is.data.frame(result), "Expected a data.frame")
  })
})

test_that("dg_outrights input validation", {
  skip_on_cran()
  expect_error(dg_outrights(INVALID_INPUTS))
})
