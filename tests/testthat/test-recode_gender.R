stopifnot(
  grepl("non-binary", recode_gender("enby", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("mlae", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("famela", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("\u7537", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("\u5973", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("sex and gender diverse", recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("sex and gender diverse", recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = FALSE)),
  grepl("man", recode_gender("\u7537", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("\u5973", dictionary = fewlevels_en, retain_unmatched = TRUE))
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

app_test_data <- data.frame(gender = c("male", "enby"), stringsAsFactors = FALSE)
app_rds <- tempfile(fileext = ".rds")
app_rda <- tempfile(fileext = ".rda")
saveRDS(app_test_data, app_rds)
save(app_test_data, file = app_rda, version = 2)

stopifnot(identical(gendercoder:::read_app_data(app_rds), app_test_data))
stopifnot(identical(gendercoder:::read_app_data(app_rda), app_test_data))

suggested_dictionary <- gender_create_dictionary(
  c("maile", "I am male", "apache"),
  dictionary = manylevels_en,
  max_distance = 1
)
stopifnot(
  identical(suggested_dictionary[["maile"]], "man"),
  !("I am male" %in% names(suggested_dictionary)),
  !("apache" %in% names(suggested_dictionary))
)

combined_dictionary <- c(suggested_dictionary, manylevels_en)
stopifnot(identical(
  recode_gender("maile", dictionary = combined_dictionary),
  "man"
))
