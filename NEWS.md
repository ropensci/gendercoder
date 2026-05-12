# gendercoder 0.1.1

* Expanded the package description for CRAN resubmission.
* Updated the interactive app example to use `if (interactive())`.
* Reduced optional package dependencies by using base R in vignettes and the
  local interactive app where possible.

# gendercoder 0.1.0

* Added Unicode dictionary entries and additional requested dictionary terms.
* Added a local Shiny app for interactive recoding of CSV, Stata, SPSS, RDS, and R data files.
* Added `gender_create_dictionary()` to help create reviewable custom dictionaries from fuzzy match suggestions.
* Updated examples and documentation for dependency-light package checks.
* Added a package hex sticker.

* Added NEWS.md to track package updates
* Changed dictionary names, now use `manylevels_en` in place of `broad` and `fewlevels_en` in place of `narrow`
* Refactored core functionality to use named character vectors in place of lists.
