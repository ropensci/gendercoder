shiny::shinyServer(function(input, output) {
  uploaded_data <- shiny::reactive({
    shiny::req(input$file1)
    read_app_data(input$file1$datapath, input$file1$name)
  })

  output$varselect <- shiny::renderUI({
    shiny::selectInput(
      "vars",
      "Gender column:",
      names(uploaded_data()),
      names(uploaded_data()),
      multiple = FALSE
    )
  })

  coded_data <- shiny::reactive({
    shiny::req(input$vars)

    dictionary <- switch(input$dictionary,
      manylevels_en = gendercoder::manylevels_en,
      fewlevels_en = gendercoder::fewlevels_en
    )

    data <- uploaded_data()
    data$recoded_gender <- gendercoder::recode_gender(data[[input$vars]], dictionary)
    data
  })

  output$out1 <- DT::renderDT({
    data <- coded_data()
    DT::datatable(data[, c(input$vars, "recoded_gender"), drop = FALSE])
  })

  output$downloadData <- shiny::downloadHandler(
    filename = function() {
      paste0(tools::file_path_sans_ext(input$file1$name), "_coded", input$dlformat)
    },
    content = function(file) {
      data <- coded_data()

      switch(input$dlformat,
        ".csv" = readr::write_csv(data, file),
        ".sav" = haven::write_sav(data, file),
        ".dta" = haven::write_dta(data, file),
        ".rds" = saveRDS(data, file),
        ".rda" = {
          recoded_data <- data
          save(recoded_data, file = file, version = 2)
        }
      )
    }
  )
})
