#' finds terms without a dictionary match
#'
#' Internal function to identify responses that are not
#' matched in the dictionary.
#'
#' @param x a list that contains responses and corresponding dictionary
#' matches #' responses without a match are stored with the NA or NULL
#' as the list reference.
#'
#' @return
#'
#' @examples
#' 
which_is_na <- function(x) {
  which(is.na(names(x)))
}

#' recode_gender
#'
#' \code{recode_gender} matches uncleaned gender responses to cleaned list using
#' an inbuilt or custom dictionary.
#'
#' @param gender a character vector of gender responses for recoding
#' @param dictionary a list that the contains gender responses and their
#'   replacement values. A built-in dictionary \code{example_dictionary} is used by
#'   default if an alternative dictionary is not supplied.
#' @param fill logical indicating if gender responses that are not found in
#'   dictionary should be filled with the uncleaned values during recoding
#'
#' @return
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
#'   dictionary = combined,
#'   fill = TRUE
#' ))
#' }
#' 
#' @export recode_gender

recode_gender <- function(gender = gender,
                          dictionary = gendercodeR::broad,
                          fill = FALSE) {
  x.name <- deparse(substitute(gender))
  dictionary.name <- deparse(substitute(dictionary))
  env <- parent.frame()

  if (class(dictionary) != "list") {
    stop(paste(dictionary.name, "is not a list"))
  }

  dictionary <- purrr::map(dictionary, tolower)

  # remove duplicates (if any) from dictionary
  dictionary <- (dictionary[!duplicated(names(dictionary), fromLast = TRUE)])

  # match using supplied dictionary
  recoded_list <- dictionary[tolower(trimws(gender))]

  # replace missing values with inputs
  if (fill == TRUE & length(gender[which_is_na(recoded_list)]) > 0) {
    message(
      paste(
        length(gender[which_is_na(recoded_list)]),
        "results not matched from the dictionary have been filled",
        "with the user inputted values"
      )
    )
    recoded_list[which_is_na(recoded_list)] <- gender[which_is_na(recoded_list)]
  }
  if (fill == FALSE) {
    recoded_list[which_is_na(recoded_list)] <- NA
  }

  # return the values of the named list
  purrr::flatten_chr(recoded_list)
}
