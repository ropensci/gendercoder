#' Gender column recoder
#'
#' Recodes gender column to
#'
#' @param input vector of gender responses
#' @param outputCol expansion for the text
#' @param optionalReplacements margin parameters; vector of length 4 (see \code{\link[graphics]{par}})
#' @param
#'
#'
#'
#' @return None
#'
#' @examples
#' plot_crayons()
#'
#' @export
genderRecode <-
  function(input, nCol = 5, optionalReplacements = F, keepOriginal = TRUE) {

    library(tidyverse)
    library(readr)

#
 input <- read_csv("data/gender-free-text.csv") # this would normally be specified in the function

## Need to check that the input is just a vector
if(ncol(input) != 1) {stop("input must be a single column")}

# load dictionary
dictionary <- read_csv("data/GenderDictionary.csv") # (some way of loading this in the package)

# Relabelling input column here and changing to tibble
genderFreeText <- data_frame(gender = str_to_lower(input[[1]]))

# joining keeping all originals
result <- left_join(genderFreeText, option, by = c("gender" = "Typos"))

result

}
