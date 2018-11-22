#' Gender column recoder
#'
#' Recodes gender column to
#'
#' @param input A dataframe with a column with the name specified in gender column name
#' @param genderColName Gender information column text name
#' @param outputColName Output column name
#' @param optionalReplacements margin parameters; vector of length 4 (see \code{\link[graphics]{par}})
#' @param method explanation
#'
#'
#'
#' @return Returns the original dataframe
#'
#' @examples
#'
#'
#' @export
genderRecode <-
  function(input, genderColName = "Gender", method = "broad", outputColName = "GenderRecode") {

    library(tidyverse)
    library(readr)

## Need to check that the column name input is a character

    genderFreeText <- input[genderColName]

# load dictionary
suppressMessages( dictionary <- read_csv("data/GenderDictionary.csv") )# (some way of loading this in the package)

if(method == "narrow") {
  dictionary <- dictionary[c("Typos", "ThreeOptions")]
} else {
  dictionary <- dictionary[c("Typos", "BroadOptions")]
}
# Relabelling input column here and changing to tibble
genderFreeText <- data_frame(Typos = str_to_lower(genderFreeText[[1]]))

#
dictionary <- distinct(dictionary)

# joining keeping all originals
result <- left_join(genderFreeText,dictionary,  by = c("Typos"))


# Finding and printing unrecognised bits
unrec <- result$Typos[which(is.na(result$BroadOptions))]
unrecNum <- which(is.na(result$BroadOptions))
if(length(unrec) > 0) {
unrecognised <- data.frame(responses = unrec, "row numbers" = unrecNum)
print(unrecognised)
}

responses <- ifelse(is.na(result[[2]]),  result[[1]], result[[2]])

response <- cbind(input, responses)
names(response)[ length(response)] <- outputColName

return(response)
}
