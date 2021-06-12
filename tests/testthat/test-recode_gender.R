context("gender_recode")
library(gendercoder)

test_that("Recodes common typos",{
          expect_match(recode_gender("enby", dictionary = broad, retain_unmatched = TRUE), "non-binary")
          expect_match(recode_gender("mlae", dictionary = broad, retain_unmatched = TRUE), "male")
          expect_match(recode_gender("famela", dictionary = broad, retain_unmatched = TRUE), "female")
          expect_match(recode_gender("enby", dictionary = narrow, retain_unmatched = TRUE), "sex and gender diverse")
          expect_match(recode_gender("enby", dictionary = narrow, retain_unmatched = FALSE), "sex and gender diverse")

})

test_that("Dictionaries generate different outcomes", {
  expect_true(recode_gender("enby", dictionary = broad, retain_unmatched = TRUE) !=
                recode_gender("enby", dictionary = narrow, retain_unmatched = TRUE))
})

test_that("Leaves blanks if retain_unmatched = FALSE", {
  expect_true(is.na(recode_gender("apache", dictionary = narrow, retain_unmatched = FALSE)))
})

test_that("Warns regarding replacement", {
  expect_message(recode_gender(c("mlae", "fish"), retain_unmatched = TRUE),
                 regexp = "1 results not matched from the dictionary have been retain_unmatcheded with the user inputted values")
})

test_that("Input matches output length", {
  expect_equal(length(1:3), length(recode_gender(1:3)))
})
