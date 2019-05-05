
<!-- README.md is generated from README.Rmd. Please edit that file -->
gendercodeR
===========

The goal of gendercodeR is to allow simple re-coding of free-text gender responses.

Installation
------------

This package is not on CRAN. To use this package please run the following code:

``` r
devtools::install_github("ropenscilabs/gendercodeR")
library(gendercodeR)
```

Why would we do this?
---------------------

Researchers who collect self-reported demographic data from respondents occasionally collect gender using a free-text response option. This has the advantage of respecting the gender diversity of respondents without prompting users and potentially including misleading responses. However, this presents a challenge to researchers in that some inconsistencies in typography and spelling create a larger set of responses than would be required to fully capture the demographic characteristics of the sample.

For example, male participants may provide free-text responses as "male", "man", "mail", "mael". Non-binary participants may provide responses as "nonbinary", "enby", "non-binary", "non binary"

Manually coding of such free-text responses this is often not feasible with larger datasets. `gendercodeR()` uses dictionaries of common misspellings to re-code free-text responses into a consistent set of responses. The small number of responses not automatically re-coded by gendercodeR() can then be feasibly manually recoded.

Motivating example
------------------

`gendercodeR()` includes a sample dataset with actual free-text responses to the question "What is your gender?" from a number of studies of English-speaking participants. The sample dataset includes responses from 7756 participants. Naive coding identifies 103 unique responses to this item.

``` r
library(gendercodeR)
library(dplyr)

sample %>% 
  group_by(Gender) %>% 
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  knitr::kable(caption = "Summary of gender categories before coding")
```

| Gender                                                              |  count|
|:--------------------------------------------------------------------|------:|
| female                                                              |   1836|
| Male                                                                |   1755|
| Female                                                              |   1722|
| male                                                                |   1705|
| FEMALE                                                              |    113|
| Female                                                              |    113|
| MALE                                                                |    107|
| F                                                                   |     88|
| f                                                                   |     58|
| M                                                                   |     35|
| m                                                                   |     33|
| female                                                              |     24|
| Male                                                                |     21|
| woman                                                               |     19|
| male                                                                |      7|
| masculino                                                           |      7|
| Man                                                                 |      6|
| man                                                                 |      5|
| Woman                                                               |      4|
| female                                                              |      3|
| Femail                                                              |      3|
| femal                                                               |      3|
| femail                                                              |      2|
| Femalw                                                              |      2|
| Frmale                                                              |      2|
| Gender                                                              |      2|
| Mail                                                                |      2|
| MALE                                                                |      2|
| Masculino                                                           |      2|
| Nonbinary                                                           |      2|
| male                                                                |      1|
| Male                                                                |      1|
| %                                                                   |      1|
| 40                                                                  |      1|
| 54                                                                  |      1|
| Agender                                                             |      1|
| agender (woman)                                                     |      1|
| Androgynous                                                         |      1|
| Apache Helicopter... Just kidding. There are only two. I am a Male. |      1|
| Asian                                                               |      1|
| cis female                                                          |      1|
| Demale                                                              |      1|
| demigirl                                                            |      1|
| emale                                                               |      1|
| famela                                                              |      1|
| feamle                                                              |      1|
| fem                                                                 |      1|
| femae                                                               |      1|
| FEMAIIL                                                             |      1|
| Femaile                                                             |      1|
| femake                                                              |      1|
| Femal                                                               |      1|
| FEMAL                                                               |      1|
| femal3                                                              |      1|
| femald                                                              |      1|
| FEMale                                                              |      1|
| FEMALE                                                              |      1|
| female (Cisgender)                                                  |      1|
| Female (cisgender)                                                  |      1|
| Female to non-binary                                                |      1|
| Femalee                                                             |      1|
| Femalep                                                             |      1|
| femals                                                              |      1|
| femenina                                                            |      1|
| Feminine                                                            |      1|
| fenale                                                              |      1|
| fmale                                                               |      1|
| ftm                                                                 |      1|
| g                                                                   |      1|
| G                                                                   |      1|
| Gender is a social construct - I'm sexually female                  |      1|
| girl                                                                |      1|
| Girl                                                                |      1|
| mae                                                                 |      1|
| mael                                                                |      1|
| maill                                                               |      1|
| make                                                                |      1|
| Malae                                                               |      1|
| mALE                                                                |      1|
| MAle                                                                |      1|
| Male                                                                |      1|
| Male(Sex, Gender is a silly construct)                              |      1|
| Male.                                                               |      1|
| males                                                               |      1|
| MALR                                                                |      1|
| Man/Male                                                            |      1|
| maoe                                                                |      1|
| masculino                                                           |      1|
| Mslr                                                                |      1|
| nb                                                                  |      1|
| NB                                                                  |      1|
| non-binary                                                          |      1|
| Non-binary                                                          |      1|
| Non binary                                                          |      1|
| Non Binary                                                          |      1|
| Trans man                                                           |      1|
| transgender                                                         |      1|
| transgender female                                                  |      1|
| Transgender man                                                     |      1|
| transmale                                                           |      1|
| transmasculine                                                      |      1|
| Transsexual male (FTM)                                              |      1|
| woman                                                               |      1|

Recoding using the `gender_coder()` function classifies all but 28 responses into pre-defined response categories.

``` r
sample %>% 
  head(10) %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, dictionary = broad)) %>% 
  knitr::kable(caption = "The broad dictionary applied to `head(sample)`")
```

| Gender | recoded\_gender |
|:-------|:----------------|
| FEMALE | female          |
| FEMAL  | female          |
| male   | male            |
| FEMALE | female          |
| female | female          |
| male   | male            |
| feamle | female          |
| male   | male            |
| male   | male            |
| male   | male            |

``` r

sample %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, dictionary = broad)) %>% 
  filter(!is.na(recoded_gender)) %>% 
  group_by(recoded_gender) %>% 
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  knitr::kable(caption = "Summary of gender categories after use of the *broad* dictionary")
```

| recoded\_gender    |  count|
|:-------------------|------:|
| female             |   4018|
| male               |   3691|
| non-binary         |      8|
| transgender male   |      4|
| cis female         |      3|
| agender            |      1|
| androgynous        |      1|
| transgender        |      1|
| transgender female |      1|

In this dataset unclassified responses are a mix of unusual responses and apparent response errors (e.g. numbers and symbols). While some of these are genuinely missing (i.e. Gender = 40), other could be manually recoded, or added to a custom dictionary.

``` r

sample %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, dictionary = broad)) %>% 
  filter(is.na(recoded_gender)) %>% 
  knitr::kable(caption = "All responses not classified by the inbuilt dictionary")
```

| Gender                                                              | recoded\_gender |
|:--------------------------------------------------------------------|:----------------|
| 40                                                                  | NA              |
| Gender                                                              | NA              |
| agender (woman)                                                     | NA              |
| masculino                                                           | NA              |
| Male.                                                               | NA              |
| 54                                                                  | NA              |
| %                                                                   | NA              |
| Female to non-binary                                                | NA              |
| Asian                                                               | NA              |
| masculino                                                           | NA              |
| masculino                                                           | NA              |
| masculino                                                           | NA              |
| masculino                                                           | NA              |
| Man/Male                                                            | NA              |
| demigirl                                                            | NA              |
| femenina                                                            | NA              |
| masculino                                                           | NA              |
| Masculino                                                           | NA              |
| transmasculine                                                      | NA              |
| males                                                               | NA              |
| Gender                                                              | NA              |
| Gender is a social construct - I'm sexually female                  | NA              |
| Apache Helicopter... Just kidding. There are only two. I am a Male. | NA              |
| masculino                                                           | NA              |
| masculino                                                           | NA              |
| Male(Sex, Gender is a silly construct)                              | NA              |
| Transsexual male (FTM)                                              | NA              |
| Masculino                                                           | NA              |

Options within the function
---------------------------

### dictionary

The package provides two inbuilt dictionaries. The use of these is controlled using the `dictionary` argument. The first `dictionary = broad` provides corrects spelling and standardises terms while maintaining the diversity of responses. This is the default dictionary for gendercodeR() as it preserves as much gender diversity as possible.

However in some cases you may wish to collapse gender into a smaller set of categories by using the `narrow` dictionary (`dictionary = narrow`). This dictionary contains only three gender categories, "male", "female", and "sex and gender diverse".

The "male" category includes all participants who indicate that they are

-   male
-   trans male (including female to male transgender respondents)
-   cis male

The "female" category includes all participants who indicate that they are

-   female
-   trans female (including male to female transgender respondents)
-   cis female

The "sex and gender diverse" category includes all participants who indicate that they are

-   agender
-   androgynous
-   intersex
-   non-binary
-   gender-queer

``` r
sample %>% 
  head(10) %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, dictionary = narrow)) %>% 
  knitr::kable(caption = "The narrow dictionary applied to `head(sample)`")
```

| Gender | recoded\_gender |
|:-------|:----------------|
| FEMALE | female          |
| FEMAL  | female          |
| male   | male            |
| FEMALE | female          |
| female | female          |
| male   | male            |
| feamle | female          |
| male   | male            |
| male   | male            |
| male   | male            |

``` r

sample %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, dictionary = narrow)) %>% 
  group_by(recoded_gender) %>% 
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  knitr::kable(caption = "Summary of gender categories after use of the *narrow* dictionary")
```

| recoded\_gender        |  count|
|:-----------------------|------:|
| female                 |   4022|
| male                   |   3695|
| NA                     |     28|
| sex and gender diverse |     11|

You can also specify a custom dictionary to replace or supplement the inbuilt dictionary. The custom dictionary should be a list in the following format.

``` r
# name of the list element is the user input value and the list element is the 
# replacement value corresponding to that name as a lower case string.
custom_dictionary <- list(
  masculino = "male",
  hombre = "male",
  mujer = "female",
  femenina = "female"
)

str(custom_dictionary)
#> List of 4
#>  $ masculino: chr "male"
#>  $ hombre   : chr "male"
#>  $ mujer    : chr "female"
#>  $ femenina : chr "female"
```

Custom dictionaries can be used in place of an inbuilt dictionary or can supplement the inbuilt dictionary by providing a vector of lists to the dictionary argument. Where the lists contain duplicated elements the last version of the duplicated value will be used for re-coding. This allows you to use the inbuilt dictionary but change the coding of one or more responses from that dictionary. Here the addition of Spanish terms allows for recoding of 11 previously uncoded responses.

``` r

sample %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, 
                                        dictionary = c(narrow, 
                                                       custom_dictionary))) %>% 
  group_by(recoded_gender) %>% 
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  knitr::kable(caption = "Summary of gender categories after use of the combined dictionaries")
```

| recoded\_gender        |  count|
|:-----------------------|------:|
| female                 |   4023|
| male                   |   3705|
| NA                     |     17|
| sex and gender diverse |     11|

``` r


sample %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, 
                                        dictionary = c(narrow, 
                                                       custom_dictionary))) %>% 
  filter(is.na(recoded_gender)) %>% 
  knitr::kable(caption = "All responses not classified by the combined dictionaries")
```

| Gender                                                              | recoded\_gender |
|:--------------------------------------------------------------------|:----------------|
| 40                                                                  | NA              |
| Gender                                                              | NA              |
| agender (woman)                                                     | NA              |
| Male.                                                               | NA              |
| 54                                                                  | NA              |
| %                                                                   | NA              |
| Female to non-binary                                                | NA              |
| Asian                                                               | NA              |
| Man/Male                                                            | NA              |
| demigirl                                                            | NA              |
| transmasculine                                                      | NA              |
| males                                                               | NA              |
| Gender                                                              | NA              |
| Gender is a social construct - I'm sexually female                  | NA              |
| Apache Helicopter... Just kidding. There are only two. I am a Male. | NA              |
| Male(Sex, Gender is a silly construct)                              | NA              |
| Transsexual male (FTM)                                              | NA              |

### fill

The `fill` argument is used to determine the handling the re-coding of values not contained in the dictionary. By default, unmatched values are coded as NA. `fill = TRUE` will fill unmatched responses with the participant provided response.

``` r
sample %>% 
  mutate(recoded_gender = recode_gender(gender = Gender, 
                                        dictionary = c(narrow, 
                                                       custom_dictionary),
                                        fill = TRUE)) %>% 
  group_by(recoded_gender) %>% 
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  knitr::kable(caption = "Summary of gender categories after use of the combined dictionary and `fill = TRUE`")
#> 17 results not matched from the dictionary have been filled with the user inputted values
```

| recoded\_gender                                                     |  count|
|:--------------------------------------------------------------------|------:|
| female                                                              |   4023|
| male                                                                |   3705|
| sex and gender diverse                                              |     11|
| Gender                                                              |      2|
| %                                                                   |      1|
| 40                                                                  |      1|
| 54                                                                  |      1|
| agender (woman)                                                     |      1|
| Apache Helicopter... Just kidding. There are only two. I am a Male. |      1|
| Asian                                                               |      1|
| demigirl                                                            |      1|
| Female to non-binary                                                |      1|
| Gender is a social construct - I'm sexually female                  |      1|
| Male(Sex, Gender is a silly construct)                              |      1|
| Male.                                                               |      1|
| males                                                               |      1|
| Man/Male                                                            |      1|
| transmasculine                                                      |      1|
| Transsexual male (FTM)                                              |      1|

A disclaimer on gender
======================

This package attempts to remove typographical errors from free text gender data. The defaults that we used are specific to our context and your data may be different.

We offer two builtin dictionaries, board and narrow. Both are opinionated about how gender descriptors collapse into categories.

However, as these are culturally specific they may not be suitable for your data. In particularly the narrow setting makes opinionated choices about some responses that we want to acknowledge are potentially problematic. In particular,

-   In 'narrow' coding intersex responses are recoded as 'sex and gender diverse'
-   In 'narrow' responses where people indicate they are trans and indicate their identified gender are recoded as the identified gender (e.g. 'Male to Female' is recoded as Female). We wish to acknowledge that this may not reflect how some individuals would classify themselves when given these categories and in some contexts may make systematic errors. The broad coding dictionary attempts to avoid these issues as much as possible - however users can provide a custom dictionary to add to or overwrite our coding decisions if they feel this is more appropriate. We welcome people to update the inbuilt dictionary where desired responses are missing.
-   In both dictionaries we assume that typographical features such as spacing are not relevant to re-coding of the gender response (e.g. we assume that "genderqueer" and "gender queer" are equivalent). This is unlikely to be true for all contexts.

The 'broad' coding separates out those who identify as trans female/male or cis female/male into separate categories it should not be assumed that all people who describe as male/female are cis, if you are assessing trans status we recommend a two part question see:

Bauer, Greta & Braimoh, Jessica & Scheim, Ayden & Dharma, Christoffer. (2017). Transgender-inclusive measures of sex/gender for population surveys: Mixed-methods evaluation and recommendations. PLoS ONE. 12.

Contributing to this package
============================

This package is a reflection of cultural context of the package contributors we welcome issues and pull requests to make the package more inclusive and/or suitable for a broader range of cultural contexts. We particularly welcome addition of non-English dictionaries or of other genderdiverse responses to the broad and narrow dictionaries.

Acknowledgement of Country
==========================

We acknowledge the Wurundjeri people of the Kulin Nation as the custodians of the land on which this package was developed and pay respects to elders past, present and future.
