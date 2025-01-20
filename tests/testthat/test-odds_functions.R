test_that("odds_to_prob basic functionality", {
  expect_equal(odds_to_prob(-400), 0.8)
  expect_equal(odds_to_prob(400), 0.2)
  expect_equal(odds_to_prob(-100), 0.5)
})

test_that("odds_to_prob input validation", {
  expect_error(odds_to_prob("invalid"))
  expect_error(odds_to_prob(NULL))
})

test_that("prob_to_odds basic functionality", {
  expect_equal(prob_to_odds(0.8), -400)
  expect_equal(prob_to_odds(0.2), 400)
  expect_equal(prob_to_odds(0.5), -100)
})

test_that("prob_to_odds input validation", {
  expect_error(prob_to_odds("invalid"))
  expect_error(prob_to_odds(NULL))
  expect_error(prob_to_odds(1.1))  # Greater than 1
  expect_error(prob_to_odds(-0.1)) # Less than 0
})

test_that("odds conversion is reversible", {
  test_probs <- seq(0.01, 0.99, by = 0.1)
  for(p in test_probs) {
    odds <- prob_to_odds(p)
    back_to_prob <- odds_to_prob(odds)
    expect_equal(p, back_to_prob, tolerance = 0.01)
  }
})

test_that("odds_to_prob handles NA", {
  expect_equal(odds_to_prob(NA), NA_real_)
  expect_equal(odds_to_prob(c(100, NA, 200)), c(0.5, NA, 0.3333), tolerance = 0.0001)
})

test_that("prob_to_odds handles NA", {
  expect_equal(prob_to_odds(NA), NA_real_)
  expect_equal(prob_to_odds(c(0.5, NA, 0.75)), c(-100, NA, -300), tolerance = 0.1)
}) 