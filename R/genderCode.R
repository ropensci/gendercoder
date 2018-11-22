#' Gender column recoder
#'
#' Recodes gender column to
#'
#' @param input A dataframe with a column with the name specified in gender column name
#' @param genderColName Gender information column text name
#' @param outputColName Provide object name for function to write unknown responses and
#' their locations to. If NA, the unrecognised responses will be printed but not saved.
#' @param method "broad" or "narrow". Broad returns responses classified into "female", "male",
#' "androgynous", "non-binary", "nonbinary", "transgender", "transgender male", "transgender female",
#'  "intersex", "agender". Narrow returns "female", "male", "other".
#'  @param optionalReplacements margin parameters; vector of length 4 (see \code{\link[graphics]{par}})
#'
#' @return Returns the original dataframe with the
#'
#' @examples
#'
#'
#' @export
genderRecode <-
  function(input, genderColName = "gender", method = "broad",
           outputColName = "gender_recode", saveUnrecognisedResponses = F) {

    # Coercing to data frame if necessary
    if(is.data.frame(input) == FALSE) {
      input <- data.frame(input)
    }

    if(length(input) == 1) {
      if(is.na(genderColName)) {
        names(genderColName) <- "gender"
          }
      names(input) <- genderColName
    }
    # Checking that the input has the gender col name
    if(all(names(input) != genderColName)) {
    stop("Your gender column name does not exist in the supplied input")
    }

    ## Need to check that the column name input is a character
    genderFreeText <- input[genderColName]

    # load dictionary
    # ideally we'd have some way of loading this in the package
    suppressMessages(dictionary <- read_csv("data/GenderDictionary.csv") )
    # Filter the dictionary to only use unique items
    dictionary <- distinct(dictionary)

    if(method == "narrow") {
      dictionary <- dictionary[c("Typos", "ThreeOptions")]
    } else {
      dictionary <- dictionary[c("Typos", "BroadOptions")]
    }
    # Relabelling input column here and changing to tibble
    genderFreeText <- data_frame(Typos = str_to_lower(genderFreeText[[1]]))

    # joining keeping all originals
    result <- left_join(genderFreeText,dictionary,  by = c("Typos"))

    # Finding and printing unrecognised bits
    unrec <- result$Typos[which(is.na(result[2]))]
    unrecNum <- which(is.na(result[2]))
    if(length(unrec) > 0) {
    unrecognisedResponses <- data.frame(responses = unrec,
                                        row.numbers = unrecNum)
    cat("\nThe following responses were not auto-recoded. The raw responses
        have been carried over to the recoded colum \n \n")
    print(group_by(unrecognisedResponses, responses) %>% count())
    # if "saveUnrecognisedResponses" = True, save as saveUnrecognisedResponses
    if(saveUnrecognisedResponses == T) {
      unrecognisedResponses <<- unrecognisedResponses}
    }

responses <- ifelse(is.na(result[[2]]),  result[[1]], result[[2]])

response <- cbind(input, responses, stringsAsFactors = FALSE)
names(response)[ length(response)] <- outputColName

return(response)
}
