context("Testing get_api_key function")

test_that("get_api_key fetches the API key when set", {

  # Temporarily set the environment variable for this test
  withr::local_envvar(c(DG_API_KEY = "mock_api_key"))

  # Test if the function fetches the key correctly
  expect_equal(get_api_key(), "mock_api_key")
})

test_that("get_api_key throws an error when API key is not set", {

  # Temporarily unset the environment variable for this test
  withr::local_envvar(c(DG_API_KEY = NULL))

  # Check if the function throws the expected error
  expect_error(get_api_key(), "API key not set. Please set it using Sys.setenv(API_KEY = 'your_key').")
})
