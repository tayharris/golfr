.onLoad <- function(libname, pkgname) {
  api_key <- Sys.getenv("DG_API_KEY")
  if (api_key == "") {
    message("Datagolf.com API key not found.")
    new_key <- readline(prompt = "Enter your API key and it will be added to sys env: ")
    Sys.setenv(DG_API_KEY = new_key)
  }
}
