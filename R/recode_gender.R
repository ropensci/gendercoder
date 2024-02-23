#' recode_gender
#'
#' \code{recode_gender} matches uncleaned gender responses to cleaned list using
#' an built-in or custom dictionary.
#'
#' @param gender a character vector of gender responses for recoding
#' @param dictionary a list that the contains gender responses and their
#'   replacement values. A built-in dictionary \code{manylevels_en} is used by
#'   default if an alternative dictionary is not supplied.
#' @param retain_unmatched logical indicating if gender responses that are not found in
#'   dictionary should be filled with the uncleaned values during recoding
#'
#' @return a character vector of recoded genders
#'
#' @examples
#'
#'
#' df <- data.frame(
#'   stringsAsFactors = FALSE,
#'   gender = c("male", "MALE", "mle", "I am male", "femail", "female", "enby"),
#'   age = c(34L, 37L, 77L, 52L, 68L, 67L, 83L)
#' )
#'
#' dplyr::mutate(df, recoded_gender = recode_gender(gender,
#'   dictionary = manylevels_en,
#'   retain_unmatched = TRUE
#' ))
#'
#' @export recode_gender
recode_gender <- function(gender = gender,
                          dictionary = gendercoder::manylevels_en,
                          retain_unmatched = FALSE) {
  if (!is.vector(dictionary) || class(dictionary) != "character") {
    stop("The supplied dictionary must be a character vector.")
  }

  dictionary <- tolower(dictionary)
  names(dictionary) <- tolower(names(dictionary))
  dictionary <- dictionary[!duplicated(names(dictionary))]

  gender_lower <- tolower(trimws(gender))
  recoded <- dictionary[gender_lower]

  if (retain_unmatched) {
    unmatched_indices <- which(is.na(recoded))
    if (length(unmatched_indices) > 0) {
      message("Some results not matched from the dictionary have been filled with the original values.")
      recoded[unmatched_indices] <- gender[unmatched_indices]
    }
  }

  unname(recoded)
}
