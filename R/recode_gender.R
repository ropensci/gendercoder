
which_is_na <- function(x) {
  which(is.na(names(x)))
}

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
#' \dontrun{
#'
#' df <- data.frame(
#'   stringsAsFactors = FALSE,
#'   gender = c("male", "MALE", "mle", "I am male", "femail", "female", "enby"),
#'   age = c(34L, 37L, 77L, 52L, 68L, 67L, 83L)
#' )
#'
#' df %>% mutate(recoded_gender = recode_gender(gender,
#'   dictionary = manylevels_en,
#'   retain_unmatched = TRUE
#' ))
#' }
#'
#' @export recode_gender

recode_gender <- function(gender = gender,
                          dictionary = gendercoder::manylevels_en,
                          retain_unmatched = FALSE) {

  if (class(dictionary) != "character") {
    stop(paste({{ dictionary }}, "is not a character vector"))
  }

  dictionary <- tolower(dictionary)
  names(dictionary) <- tolower(names(dictionary))

  # remove duplicates (if any) from dictionary
  dictionary <- dictionary[!duplicated(names(dictionary), fromLast = TRUE)]

  # match using supplied dictionary
  recoded<- dictionary[tolower(trimws(gender))]

  # replace missing values with inputs
  if (retain_unmatched == TRUE & length(gender[which_is_na(recoded)]) > 0) {
      message(
        paste(
         # length(gender[which_is_na(recoded)]),
          "Results not matched from the dictionary have been filled",
          "with the user inputted values"
        )
      )

      recoded[is.na(recoded)] <-  gender[is.na(recoded)]
}
    unname( recoded )

}
