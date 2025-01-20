library(httptest)

# Configure mock behavior
httptest::set_requester(function (request) {
  # Standardize the API key in URLs
  request$url <- gsub("key=[^&]*", "key=FAKE_KEY_FOR_TESTING", request$url)
  request
}) 