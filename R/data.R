#' Gender code dictionary
#'
#' Inbuilt dictionary of potential freetext gender responses and ways to recode
#' them using \code{\link{genderRecode}}.
#'
#' @format A data frame with three variables:
#' \describe{
#' \item{\code{entries}}{users' freetext responses}
#' \item{\code{broad}}{recoding returned by \code{genderRecode(method = "broad")}}
#' \item{\code{narrow}}{recoding returned by \code{genderRecode(method = "narrow")}}
#' }
"gender_code_dictionary"
