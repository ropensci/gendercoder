stopifnot(
  grepl("non-binary", recode_gender("enby", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("mlae", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("famela", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("my sex is female", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("makle", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("female only", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("masculine", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("genderfluid", recode_gender("gender-fluid", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("\u7537", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("\u5973", dictionary = manylevels_en, retain_unmatched = TRUE)),
  grepl("sex and gender diverse", recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("my sex is female", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("makle", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("woman", recode_gender("female only", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("man", recode_gender("masculine", dictionary = fewlevels_en, retain_unmatched = TRUE)),
  grepl("sex and gender diverse", recode_gender("gender-fluid", dictionary = fewlevels_en, retain_unmatched = TRUE)),
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

dictionary_error <- tryCatch(
  gender_create_dictionary("maile", dictionary = 1:7),
  error = conditionMessage
)
stopifnot(grepl("The supplied dictionary is not a character vector", dictionary_error))

distance_error <- tryCatch(
  gender_create_dictionary("maile", max_distance = -1),
  error = conditionMessage
)
stopifnot(grepl("max_distance must be a single non-negative number", distance_error))

app_test_data <- data.frame(gender = c("male", "enby"), stringsAsFactors = FALSE)
app_csv <- tempfile(fileext = ".csv")
app_rds <- tempfile(fileext = ".rds")
app_rda <- tempfile(fileext = ".rda")
utils::write.csv(app_test_data, app_csv, row.names = FALSE)
saveRDS(app_test_data, app_rds)
save(app_test_data, file = app_rda, version = 2)

stopifnot(identical(as.data.frame(gendercoder:::read_app_data(app_csv)), app_test_data))
stopifnot(identical(gendercoder:::read_app_data(app_rds), app_test_data))
stopifnot(identical(gendercoder:::read_app_data(app_rda), app_test_data))

unsupported_error <- tryCatch(
  gendercoder:::read_app_data(tempfile(fileext = ".txt")),
  error = conditionMessage
)
stopifnot(grepl("Unsupported file type: txt", unsupported_error))

empty_rda <- tempfile(fileext = ".rda")
save(list = character(), file = empty_rda)
empty_rda_error <- tryCatch(
  gendercoder:::read_app_data(empty_rda),
  error = conditionMessage
)
stopifnot(grepl("The R data file does not contain any objects", empty_rda_error))

if (requireNamespace("shiny", quietly = TRUE)) {
  shiny_namespace <- asNamespace("shiny")
  original_run_app <- get("runApp", envir = shiny_namespace)
  unlockBinding("runApp", shiny_namespace)
  assign(
    "runApp",
    function(appDir, ...) list(appDir = appDir, args = list(...)),
    envir = shiny_namespace
  )
  lockBinding("runApp", shiny_namespace)

  app_launch <- gendercoder_app(launch.browser = FALSE)

  unlockBinding("runApp", shiny_namespace)
  assign("runApp", original_run_app, envir = shiny_namespace)
  lockBinding("runApp", shiny_namespace)

  stopifnot(
    identical(app_launch$args$launch.browser, FALSE),
    grepl("app$", app_launch$appDir)
  )
}

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
