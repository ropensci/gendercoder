context("gender_recode")
library(gendercodeR)

test_that("Recodes common typos",{
          expect_match(recode_gender("enby", dictionary = broad, fill = TRUE), "non-binary")
          expect_match(recode_gender("mlae", dictionary = broad, fill = TRUE), "male")
          expect_match(recode_gender("famela", dictionary = broad, fill = TRUE), "female")
          expect_match(recode_gender("enby", dictionary = narrow, fill = TRUE), "sex and gender diverse")
          expect_match(recode_gender("enby", dictionary = narrow, fill = FALSE), "sex and gender diverse")

})

test_that("Dictionaries generate different outcomes", {
  expect_true(recode_gender("enby", dictionary = broad, fill = TRUE) !=
                recode_gender("enby", dictionary = narrow, fill = TRUE))
})

test_that("Leaves blanks if fill = FALSE", {
  expect_true(is.na(recode_gender("apache", dictionary = narrow, fill = FALSE)))
})

test_that("Warns regarding replacement", {
  expect_message(recode_gender(c("mlae", "fish"), fill = TRUE),
                 regexp = "1 results not matched from the dictionary have been filled with the user inputted values")
})

test_that("Input matches output length", {
  expect_equal(length(1:3), length(recode_gender(1:3)))
})
