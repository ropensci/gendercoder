context("gender_recode")
library(gendercoder)

test_that("Recodes common typos",{
          expect_match(recode_gender("enby", dictionary = manylevels_en, retain_unmatched = TRUE), "non-binary")
          expect_match(recode_gender("mlae", dictionary = manylevels_en, retain_unmatched = TRUE), "man")
          expect_match(recode_gender("famela", dictionary = manylevels_en, retain_unmatched = TRUE), "woman")
          expect_match(recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = TRUE), "sex and gender diverse")
          expect_match(recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = FALSE), "sex and gender diverse")

})

test_that("Dictionaries generate different outcomes", {

  expect_true(recode_gender("enby", dictionary = manylevels_en, retain_unmatched = TRUE) !=
                recode_gender("enby", dictionary = fewlevels_en, retain_unmatched = TRUE))
})

test_that("Leaves blanks if retain_unmatched = FALSE", {
  expect_true(is.na(recode_gender("apache", dictionary = fewlevels_en, retain_unmatched = FALSE)))

})

test_that("Warns regarding replacement", {
  expect_message(recode_gender(c("mlae", "fish"), retain_unmatched = TRUE),
                 regexp = "Results not matched from the dictionary have been filled with the user inputted values")
})

test_that("Input matches output length", {
  expect_equal(length(1:3), length(recode_gender(1:3)))
})

test_that("Error if dictionary not supplied as a character vector", {
  expect_error(recode_gender(c("mlae"), dictionary = 1:7),
                 regexp = "The supplied dictionary is not a character vector")
})
