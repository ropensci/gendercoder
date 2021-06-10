library(shiny)
library(haven)
library(gendercoder)
library(dplyr)
library(DT)
library(rlang)
library(readr)

shinyServer(function(input, output) {

    df <- reactive({
        req(input$file1)

        inFile <- input$file1
        if (is.null(inFile)) return(NULL)

        if (grepl(".sav$", inFile$name)) df <- read_sav(inFile$datapath)
        if (grepl(".dta$", inFile$name)) df <- read_dta(inFile$datapath)
        if (grepl(".csv$", inFile$name)) df <- read_csv(inFile$datapath)

        df

        })


    df_out <-  reactive({

        if(input$dictionary == "broad_en") {df_out <- df() %>% bind_cols(gender_coded = recode_gender(df()[[input$vars]], broad_en))}
        if(input$dictionary == "narrow_en") {df_out <- df() %>% bind_cols(gender_coded = recode_gender(df()[[input$vars]], narrow_en))}

        df_out

        })

    # Generate the gender selection
    output$varselect <- renderUI({

        # Variable selection:
        selectInput("vars", "Gender Column:",
                    names(df()), names(df()), multiple = FALSE)
    })

    # Create the output data

    output$downloadData <- downloadHandler(

      filename = function() {
        paste(sub(".sav|.csv|.dta", "", input$file1$name), "_coded",  input$dlformat, sep='')
      },
      content = function(file) {

          if (input$dlformat == ".csv") write_csv(df_out(), file)
          if (input$dlformat == ".sav") write_sav(df_out(), file)
          if (input$dlformat == ".dta") write_dta(df_out(), file)
      }
    )

    output$out1 <-  renderDT({df_out()})


})

