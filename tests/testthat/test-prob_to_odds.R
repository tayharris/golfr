
test_that("Conversion works from .50 (50%) to -100", {
  expect_identical(
    prob_to_odds(.50),
    -100)
})


test_that("Conversion works from .20 (20%) to 400", {
  expect_identical(
    prob_to_odds(.20),
    400)
})

test_that("Conversion works from .80 (80%) to -400", {
  expect_identical(
    prob_to_odds(.80),
    -400)
})

