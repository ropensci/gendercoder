getDictionary <- function() {
  GenderDictionary <- readr::read_csv(system.file("extdata", "GenderDictionary.csv", package = "gendercodeR"))
}
