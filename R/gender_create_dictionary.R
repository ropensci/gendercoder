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

  if (!is.numeric(max_distance) ||
      length(max_distance) != 1L ||
      is.na(max_distance) ||
      !is.finite(max_distance) ||
      max_distance < 0) {
    stop(
      "max_distance must be a single finite non-negative number",
      call. = FALSE
    )
  }

  dictionary <- normalize_gender_dictionary(dictionary)

  gender_clean <- tolower(trimws(gender))
  unmatched <- unique(gender_clean[is.na(dictionary[gender_clean])])
  unmatched <- unmatched[!is.na(unmatched) & nzchar(unmatched)]

  if (length(unmatched) == 0L) {
    return(character())
  }

  dictionary_names <- names(dictionary)
  distances <- utils::adist(unmatched, dictionary_names)
  closest <- max.col(-distances, ties.method = "first")
  minimum_distances <- distances[cbind(seq_along(unmatched), closest)]
  keep <- minimum_distances <= max_distance

  suggestions <- unname(dictionary[closest[keep]])
  names(suggestions) <- unmatched[keep]

  suggestions
}
