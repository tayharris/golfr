with_mock_api({
  test_that("dg_player_decomp basic functionality", {
  skip_on_cran()

  result <- dg_player_decomp()
  expect_true(is.data.frame(result), "Expected a data.frame")
  # Add more checks as needed
  })

  test_that("dg_player_decomp input validation", {
    skip_on_cran()
    expect_error(dg_player_decomp(INVALID_INPUTS))
  })
})
