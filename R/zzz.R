.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to the genderCodeR package\n
This package attempts to remove typos from free text gender data
The defaults that we used are specific to our context and your data may be
different.We offer two categorisations, board and narrow both are opinionated
about how gender descriptors collapse into categories as these are cultrally
specific they may not be suitiable for your data. In particularly we makes
opinionated choices about some responses that we want to acknowledge are
potentially problematic.
      In particular,
        •	Intersex is recoded as 'Other'
        •	Responses where people indicate they are trans and indicate their
          identified gender are recoded as the identified gender
          (e.g. 'Male to Female' is recoded as Female). We wish to acknowledge
          that this may not reflect how some individuals would classify
          themselves when given these categories and in some contexts may make
          systematic errors. The broad coding dictionary attempts to avoid these
          issues as much as possible - however users can provide a custom
          dictionary to add to or overwrite our coding decisions if they feel
          this is more appropriate. We welcome people to update the inbuilt
          dictionary where desired responses are missing.
        •	The 'broad' coding seperates out those who identify as trans
          female/male or cis female/male into seperate categories it should not
          be assumed that all people who discribe as male/female are cis, if you
          are assessing trans status we recommend a two part question see:

          Bauer, Greta & Braimoh, Jessica & Scheim, Ayden & Dharma, Christoffer.
          (2017).
          Transgender-inclusive measures of sex/gender for population surveys:
          Mixed-methods evaluation and recommendations.
          PLoS ONE. 12.
                        ")
}
