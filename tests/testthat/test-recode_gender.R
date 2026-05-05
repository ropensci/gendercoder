stopifnot(
  grepl("non-binary", recode_gender("enby", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("mlae", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("famela", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("sex and gender diverse", recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("sex and gender diverse", recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = FALSE))
)

stopifnot(
  recode_gender("enby", dictionary = manylevels_en, retain_unmatched = TRUE) !=
    recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = TRUE)
)

stopifnot(is.na(recode_gender("apache", dictionary = fewlevels_en, retain_unmatched = FALSE)))

message_output <- capture.output(
  invisible(recode_gender(c("mlae", "fish"), retain_unmatched = TRUE)),
  type = "message"
)
stopifnot(grepl(
  "Results not matched from the dictionary have been filled with the user inputted values",
  message_output
))

stopifnot(identical(length(1:3), length(recode_gender(1:3))))

error_message <- tryCatch(
  recode_gender(c("mlae"), dictionary = 1:7),
  error = conditionMessage
)
stopifnot(grepl("The supplied dictionary is not a character vector", error_message))
