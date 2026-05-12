shiny::fluidPage(
  shiny::titlePanel("gendercoder"),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::fileInput(
        "file1",
        "Choose data file",
        multiple = FALSE,
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv",
          ".dta",
          ".sav",
          ".rds",
          ".rda",
          ".RData"
        ),
        placeholder = ".csv, .dta, .sav, .rds, .rda, or .RData"
      ),
      shiny::radioButtons(
        "dictionary",
        "Coding dictionary:",
        choiceValues = c("manylevels_en", "fewlevels_en"),
        choiceNames = c("Many levels - English", "Few levels - English"),
        selected = "manylevels_en"
      ),
      shiny::htmlOutput("varselect"),
      shiny::radioButtons(
        "dlformat",
        "Download format:",
        choiceValues = c(".csv", ".sav", ".dta", ".rds", ".rda"),
        choiceNames = c(".csv", ".sav (SPSS)", ".dta (Stata)", ".rds", ".rda"),
        selected = ".csv"
      ),
      shiny::downloadButton("downloadData", "Download")
    ),
    shiny::mainPanel(
      shiny::tableOutput("out1"),
      shiny::hr(),
      shiny::h2("Credits"),
      shiny::p("This is an implementation of the gendercoder R package."),
      shiny::p("This Shiny app was developed for local, interactive gender recoding.")
    )
  )
)
