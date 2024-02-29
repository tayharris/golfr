#' Fetch the DataGolf API key from environment variables.
#'
#' This function retrieves the API key set in the environment variables.
#' @return A character string containing the API key.
#' @export
get_api_key <- function(){
  api_key <- Sys.getenv("DG_API_KEY")
  if (api_key == "") {
    stop("API key not set. Please set it using Sys.setenv(API_KEY = 'your_key').")
  }
  return(api_key)
  }
