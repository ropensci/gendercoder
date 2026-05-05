library(gendercoder)

test_file <- file.path("testthat", "test-recode_gender.R")
if (!file.exists(test_file)) {
  test_file <- file.path("tests", test_file)
}
source(test_file)
