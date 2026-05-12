bs4Dash::dashboardPage(
  title = "gendercoder",
  header = bs4Dash::dashboardHeader(
    title = "gendercoder",
    status = "white",
    border = TRUE
  ),
  sidebar = bs4Dash::dashboardSidebar(
    skin = "light",
    status = "primary",
    brandColor = "primary",
    bs4Dash::sidebarMenu(
      bs4Dash::menuItem("Recoder", tabName = "recoder", icon = shiny::icon("table"))
    )
  ),
  body = bs4Dash::dashboardBody(
    bs4Dash::tabItems(
      bs4Dash::tabItem(
        tabName = "recoder",
        shiny::fluidRow(
          bs4Dash::box(
            title = "Input",
            width = 4,
            status = "primary",
            solidHeader = TRUE,
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
          bs4Dash::box(
            title = "Preview",
            width = 8,
            status = "primary",
            solidHeader = TRUE,
            shiny::tableOutput("out1")
          )
        )
      )
    )
  )
)
