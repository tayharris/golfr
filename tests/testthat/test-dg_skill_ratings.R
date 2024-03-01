test_that("dg_skill_ratings basic functionality", {
  skip_on_cran()
  with_mock_api({
    result <- dg_skill_ratings()
    expect_true(is.data.frame(result), "Expected a data.frame")
  })
})

test_that("dg_skill_ratings input validation", {
  skip_on_cran()
  expect_error(dg_skill_ratings(INVALID_INPUTS))
})

#TODO Add more scenarios for different types of invalid inputs
