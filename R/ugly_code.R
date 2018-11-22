
option <- read_csv("data/GenderDictionary.csv")

library(dplyr)
library(readr)

## Can't require that the columns are actually called the same thing

option$Gender <- option$text
gender_free_text$Gender <- tolower(gender_free_text$Gender)
result <- left_join(gender_free_text, option, by = "Gender")

result <- result %>%
mutate(`broad (n of cats)` = case_when(
  `broad (n of cats)` = is.na(`broad (n of cats)`) ~ Gender,
  TRUE ~ `broad (n of cats)`
))

table(result$`broad (n of cats)`)
