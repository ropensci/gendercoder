#' Create a custom dictionary from fuzzy matches
#'
#' \code{gender_create_dictionary} suggests dictionary entries for gender
#' responses that are not already matched exactly. The returned named character
#' vector is intended to be reviewed before it is combined with a built-in
#' dictionary and passed to \code{recode_gender()}.
#'
#' @param gender a character vector of gender responses for recoding
#' @param dictionary a character vector whose names are known gender responses
#'   and whose values are replacement values
#' @param max_distance maximum edit distance allowed for a suggested match
#'
#' @return a named character vector of suggested replacement values
#'
#' @examples
#' suggested <- gender_create_dictionary(
#'   c("maile", "unknown"),
#'   dictionary = manylevels_en,
#'   max_distance = 1
#' )
#' suggested
#'
#' @export
gender_create_dictionary <- function(gender,
                                     dictionary = gendercoder::manylevels_en,
                                     max_distance = 1) {
  gender <- as.character(gender)

  if (!is.character(dictionary)) {
    stop("The supplied dictionary is not a character vector")
  }

  if (!is.numeric(max_distance) || length(max_distance) != 1 || max_distance < 0) {
    stop("max_distance must be a single non-negative number")
  }

  dictionary <- tolower(dictionary)
  names(dictionary) <- tolower(names(dictionary))
  dictionary <- dictionary[!duplicated(names(dictionary))]

  gender_clean <- tolower(trimws(gender))
  unmatched <- unique(gender_clean[is.na(dictionary[gender_clean])])
  unmatched <- unmatched[!is.na(unmatched) & nzchar(unmatched)]

  suggestions <- character()
  dictionary_names <- names(dictionary)

  for (response in unmatched) {
    distances <- utils::adist(response, dictionary_names)
    closest <- which.min(distances)

    if (length(closest) == 1 && distances[[closest]] <= max_distance) {
      suggestions[response] <- dictionary[[closest]]
    }
  }

  suggestions
}
