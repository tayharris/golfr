test_that("dg_pre_tournament_predictions basic functionality", {
  with_mock_api({
    result <- dg_pre_tournament_predictions(tour = "pga", odds_format = "percent")
    expect_true(is.data.frame(result), "Expected a data.frame")
  })
})

test_that("dg_pre_tournament_predictions tour input validation", {
  expect_error(dg_pre_tournament_predictions(tour = "tay", odds_format = "percent"))
})

test_that("dg_pre_tournament_predictions odds_format input validation", {
  expect_error(dg_pre_tournament_predictions(tour = "pga", odds_format = "tay"))
})

#TODO Add more scenarios for different types of invalid inputs
