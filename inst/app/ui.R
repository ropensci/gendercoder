library(shiny)
library(shinydashboard)
library(DT)

dashboardPage(
    dashboardHeader(title = "Gendercoder app"),
    dashboardSidebar(
        fileInput("file1", "Choose data File",
                  multiple = FALSE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv", 
                             ".dta", 
                             ".sav"), 
                placeholder = ".dta, .sav, or .csv"),
        
        
        
        # Control
        radioButtons("dictionary", "Coding dictionary:",   
                     choiceValues = c("broad", 'narrow'),
                     choiceNames = c("Broad", 'Narrow'),
                     selected = "broad"), 
        
        # Variable selection:
        htmlOutput("varselect"),
        
        radioButtons("dlformat", "Download format:",
                     choiceValues = c(".csv", ".sav", ".dta"),
                     choiceNames = c(".csv", ".sav (SPSS)", ".dta (STATA)"),
                     selected = ".csv"),
        
        downloadButton("downloadData", "Download")
        
    ),
    dashboardBody(
        
        DTOutput("out1"),
        
        hr(),
        
        h2("Credits"),
        p("This is an implementation of the gendercoder R package, developed by Jennifer Beaudry, Emily Kothe, Felix Singleton Thorn, Rhydwyn McGuire, Nicholas Tierney and Mathew Ling."),
        p("Development began on unceded Wurundjeri land, at the rOpenSci ozunconf, 2018."), 
        p("This Shiny app was developed by Mathew Ling (@Lingtax)")
        

    )
)
