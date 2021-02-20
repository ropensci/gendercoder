
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gendercodeR

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/gendercodeR)](https://CRAN.R-project.org/package=gendercodeR)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

The goal of gendercodeR is to allow simple re-coding of free-text gender
responses. This is intended to permit representation of gender
diversity, while managing troll-responses and the workload implications
of manual coding.

## Installation

This package is not on CRAN. To use this package please run the
following code:

``` r
devtools::install_github("ropenscilabs/gendercodeR")
library(gendercodeR)
```

## Basic use

The gendercoder package permits the efficient re-coding of free-text
gender responses within a tidyverse pipeline. It contains two in-built
output dictionaries, a default `broad` dictionary which corrects
spelling and standardises terms while maintaining the diversity of
responses and a `narrow` dictionary which contains only three gender
categories, “male”, “female”, and “sex and gender diverse”.

The core function, `gender_recode()`, takes 3 arguments,

  - `gender` the vector of free-text gender,

  - `dictionary` the preferred dictionary, and

  - `fill` a logical indicating whether original values should be
    carried over if there is no match.

Basic usage is demonstrated below.

``` r
library(gendercodeR)

tibble(gender = c("male", "MALE", "mle", "I am male", "femail", "female", "enby")) %>% 
  mutate(broad_gender  = recode_gender(gender, dictionary = broad, fill = TRUE),
         narrow_gender = recode_gender(gender, dictionary = narrow, fill = FALSE)
  )
#> 1 results not matched from the dictionary have been filled with the user inputted values
#> # A tibble: 7 x 3
#>   gender    broad_gender narrow_gender         
#>   <chr>     <chr>        <chr>                 
#> 1 male      male         male                  
#> 2 MALE      male         male                  
#> 3 mle       male         male                  
#> 4 I am male I am male    <NA>                  
#> 5 femail    female       female                
#> 6 female    female       female                
#> 7 enby      non-binary   sex and gender diverse
```

## Contributing to this package

This package is a reflection of cultural context of the package
contributors we welcome issues and pull requests to make the package
more inclusive and/or suitable for a broader range of cultural contexts.
We particularly welcome addition of non-English dictionaries or of other
genderdiverse responses to the broad and narrow dictionaries.

## Citation Information

Please cite this package as:

Kothe, E., Beaudry, J., Singleton Thorn, F., & McGuire, R. (2018).
gendercodeR (0.0.0.9000) \[Computer software\]. rOpenSci.
<https://docs.ropensci.org/gendercodeR/>

## Acknowledgement of Country

We acknowledge the Wurundjeri people of the Kulin Nation as the
custodians of the land on which this package was developed and pay
respects to elders past, present and future.
