#' Get the Datagolf API key
#'
#' @return The API key as a string
#' @keywords internal
dg_api_key <- function() {
  key <- Sys.getenv("DG_API_KEY")
  
  if (key == "") {
    stop(
      "API key not set. Please follow these steps:\n",
      "1. Get your API key from https://datagolf.com/api-access\n",
      "2. Set it using one of these methods:\n",
      "   - For this session: Sys.setenv(DG_API_KEY = 'your_key')\n",
      "   - Permanently in .Renviron: \n",
      "     a. file.edit('~/.Renviron')\n",
      "     b. Add line: DG_API_KEY=your_key\n",
      "     c. Save and restart R\n",
      "3. Verify with: Sys.getenv('DG_API_KEY')"
    )
  }
  
  # Validate key format (if we know the expected format)
  if (!grepl("^[a-zA-Z0-9_-]+$", key)) {
    warning(
      "API key format looks invalid. A valid key should:\n",
      "1. Only contain letters, numbers, underscores, or hyphens\n",
      "2. Not contain spaces or special characters\n",
      "3. Not be surrounded by quotes\n",
      "\nCurrent key: ", key
    )
  }
  
  # Check key length (adjust min/max based on actual key format)
  if (nchar(key) < 8 || nchar(key) > 64) {
    warning(
      "API key length looks suspicious (", nchar(key), " characters).\n",
      "Please verify your key at https://datagolf.com/api-access"
    )
  }
  
  key
}
