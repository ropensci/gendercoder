
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gendercodeR

The goal of gendercodeR is to allow simple recoding of freetext gender
responses.

## Why would we do this?

Researchers who collect self-reported demographic data from respondents
occasionally collect gender using a free-text response option. This has
the advantage of respecting the gender diversity of respondents.
However, this presents a challenge to researchers in that some
inconsistencies in typography and spelling create a larger set of
responses than would be required to fully capture the demographic
characteristics of the sample.

For example, male participants may provide freetext responses as “male”,
“man”, “mail”, “mael”. Non-binary participants may provide responses as
“nonbinary”, “enby”, “non-binary”, “non binary”

This package uses dictionaries of common mispellings to recode these
freetext responses into a consistent set of responses.

## Installation

This package is not on CRAN. To use this package please un the following
code:

``` r
devtools::install_github("ropenscilabs/gendercoder")
library(gendercoder)
```

## Example

You have a dataframe with the following format

``` r

library(gendercodeR)

df <- data.frame(stringsAsFactors=FALSE,
      gender = c("male", "MALE", "mle", "I am male", "femail", "female", "enby"),
         age = c(34L, 37L, 77L, 52L, 68L, 67L, 83L)
)

df
#>      gender age
#> 1      male  34
#> 2      MALE  37
#> 3       mle  77
#> 4 I am male  52
#> 5    femail  68
#> 6    female  67
#> 7      enby  83
```

Individuals have provided gender in a range of inconsistent formats.

Running the `genderRecode()` function will take the inputed dataset,
match freetext gender responses to the dictionary, create a new column
in the dataframe with the recoded gender response. For freetext gender
responses that are not in the dictionary the original freetext will be
copied to the recoded gender column.

``` r
genderRecoded <- genderRecode(df)
#> ── Attaching packages ────────────────────────────────────────────────────────── tidyverse 1.2.1 ──
#> ✔ ggplot2 2.2.1     ✔ purrr   0.2.5
#> ✔ tibble  1.4.2     ✔ dplyr   0.7.7
#> ✔ tidyr   0.8.2     ✔ stringr 1.3.1
#> ✔ readr   1.1.1     ✔ forcats 0.3.0
#> ── Conflicts ───────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> 
#> The following responses were not auto-recoded. The raw responses
#>         have been carried over to the recoded colum 
#>  
#> # A tibble: 1 x 2
#> # Groups:   responses [1]
#>   responses     n
#>   <fct>     <int>
#> 1 i am male     1

genderRecoded
#>      gender age gender_recode
#> 1      male  34          male
#> 2      MALE  37          male
#> 3       mle  77          male
#> 4 I am male  52     i am male
#> 5    femail  68        female
#> 6    female  67        female
#> 7      enby  83    non-binary
```

Parameters include

…
