
# test_that("test dg_api_key() fetches the API key when set", {

#
#   # Temporarily set the environment variable for this test
#   withr::local_envvar(c(DG_API_KEY = "mock_api_key"))
#
#   # Test if the function fetches the key correctly

#   expect_equal( dg_api_key(), "mock_api_key")
# })
#
# test_that("dg_api_key() throws an error when API key is not set", {

#   # Ensure the environment variable is cleared
#   withr::local_envvar(c(DG_API_KEY = NULL))
#
#   # The error message to be matched exactly as it appears in the function
#   error_msg <- "API key not set. Please set it using Sys.setenv(DG_API_KEY = 'your_key')."
#
#   # Check if the function throws the expected error with the exact message

#   expect_error( dg_api_key(), error_msg, fixed = TRUE)

