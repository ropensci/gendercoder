#' Launch Shiny App
#'
#' Code your data interactively in a shiny app that runs locally in RStudio or your web browser (recommended). It does not connect to the web at all, so your data are completely private.
#'
#' @param ... arguments to pass to shiny::runApp
#'
#' @export
#'
#' @examples
#' \dontrun{ gendercoder_app() }
#'
gendercoder_app <- function(...) {
  pckgs <- c("shiny", "shinydashboard", "readr",
             "rlang", "DT", "dplyr", "haven")
  names(pckgs) <- pckgs
  req_pckgs <- sapply(pckgs, requireNamespace, quietly = TRUE)

  if (all(req_pckgs)) {
    shiny::runApp(appDir = system.file("app", package = "gendercoder"), ...)
  } else {
    warning("You need to install the following packages to run the app: ",
            paste(names(req_pckgs[!req_pckgs]), collapse = ", "))
  }
}
