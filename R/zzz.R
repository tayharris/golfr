.onLoad <- function(libname, pkgname) {
  api_key <- Sys.getenv("DG_API_KEY")
  if (api_key == "") {
    message("API key not found!")
    new_key <- readline(prompt = "Please enter your API key: ")
    Sys.setenv(DG_API_KEY = new_key)
  }
}
