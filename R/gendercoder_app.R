#' Launch the gendercoder Shiny app
#'
#' Code data interactively in a Shiny app that runs locally in RStudio or a web
#' browser. The app supports CSV, Stata, SPSS, RDS, and R data files. Stata
#' and SPSS files require the optional \pkg{haven} package.
#'
#' @param ... arguments to pass to \code{shiny::runApp()}
#'
#' @return Called for its side effect of launching a Shiny app.
#' @export
#'
#' @examples
#' if (interactive()) {
#' gendercoder_app()
#' }
gendercoder_app <- function(...) {
  packages <- "shiny"
  launch_gendercoder_app(packages, ...)
}

launch_gendercoder_app <- function(packages, ...) {
  if (!check_app_packages(packages)) {
    return(invisible(FALSE))
  }

  shiny::runApp(appDir = system.file("app", package = "gendercoder"), ...)
}

check_app_packages <- function(packages) {
  available <- vapply(packages, requireNamespace, logical(1), quietly = TRUE)

  if (!all(available)) {
    warning(
      "You need to install the following packages to run the app: ",
      paste(packages[!available], collapse = ", "),
      call. = FALSE
    )
    return(FALSE)
  }

  TRUE
}

require_app_packages <- function(packages) {
  if (!check_app_packages(packages)) {
    stop(
      "Install the missing package before using this file type.",
      call. = FALSE
    )
  }

  TRUE
}

read_app_data <- function(path, name = path) {
  extension <- tolower(tools::file_ext(name))

  switch(extension,
    csv = utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE),
    dta = {
      require_app_packages("haven")
      haven::read_dta(path)
    },
    sav = {
      require_app_packages("haven")
      haven::read_sav(path)
    },
    rds = readRDS(path),
    rda = read_first_r_data_object(path),
    rdata = read_first_r_data_object(path),
    stop("Unsupported file type: ", extension, call. = FALSE)
  )
}

read_first_r_data_object <- function(path) {
  data_env <- new.env(parent = emptyenv())
  object_names <- load(path, envir = data_env)

  if (length(object_names) == 0) {
    stop("The R data file does not contain any objects", call. = FALSE)
  }

  data_env[[object_names[[1]]]]
}

write_app_data <- function(data, file, extension) {
  switch(tolower(extension),
    ".csv" = utils::write.csv(data, file, row.names = FALSE, na = ""),
    ".sav" = {
      require_app_packages("haven")
      haven::write_sav(data, file)
    },
    ".dta" = {
      require_app_packages("haven")
      haven::write_dta(data, file)
    },
    ".rds" = saveRDS(data, file),
    ".rda" = {
      recoded_data <- data
      save(recoded_data, file = file, version = 2)
    },
    stop("Unsupported file type: ", extension, call. = FALSE)
  )
}
