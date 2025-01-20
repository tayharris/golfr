# Set a dummy API key for testing
Sys.setenv(DG_API_KEY = "FAKE_KEY_FOR_TESTING")

# Configure httptest
library(httptest)

# To record real responses, temporarily uncomment and run:
# capture_test_responses()
