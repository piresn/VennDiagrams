
shinyServer(function(input, output, session) {
  
  ##################################################
  # set initial values
  ##################################################
  
  # color schemes
  source('brews.R', local = TRUE)
  
  values <- reactiveValues()
  source('styles/style0.R', local = TRUE)
  
  ##################################################
  # User sets input
  ##################################################
  
  x <- reactive({
    try(a <- strsplit(c(input$group1, input$group2, input$group3), '\n'))
    try(names(a) <- c(input$namegroup1, input$namegroup2, input$namegroup3))
    
    b <- a
    
    for(i in 1:length(a)){
      if(length(a[[i]]) == 0) b[[i]] <- NULL
    }
    
    return(b)
  })
  
  ##################################################
  # Reset sets
  ##################################################
  
  observeEvent(input$resetInput, {
    
    for(i in c('namegroup1',
               'namegroup2',
               'namegroup3',
               'group1',
               'group2',
               'group3')){
      updateTextInput(session, inputId = i, value = character(0))
    }
  })
  
  ##################################################
  # Use example set
  ##################################################
  
  observeEvent(input$fillBut, {values$load_ex <- input$fillBut})
  observeEvent(input$fillBut2, {values$load_ex <- input$fillBut2})
  
  observeEvent(values$load_ex, {
    
    values$userfile <- read.csv('exampleset.csv',
                                header = TRUE, check.names = FALSE)
    
    for(i in c('namegroup1', 'namegroup2', 'namegroup3',
               'group1', 'group2', 'group3')){
      updateTextInput(session, inputId = i, value = character(0)) # Shiny doesn't allow setting to NULL
    }
    
    f <- values$userfile
    
    if(f != 0){
      try(
        for(i in 1:ncol(f)){
          updateTextInput(session, inputId = paste0("namegroup", i), value = names(f)[i])
          updateTextAreaInput(session, inputId = paste0("group", i),
                              value = paste(clean(f[,i]), collapse = '\n'))
        }
      )
    }
  })
  
  
  ##################################################
  # limit user input characters
  ##################################################

  x <- reactive({
    try(a <- strsplit(c(input$group1, input$group2, input$group3), '\n'))
    try(names(a) <- c(input$namegroup1, input$namegroup2, input$namegroup3))
    
    b <- a
    
    for(i in 1:length(a)){
      if(length(a[[i]]) == 0) b[[i]] <- NULL
    }
    
    return(b)
  })
  
  runjs("$('#namegroup1').attr('maxlength', 50)")
  runjs("$('#namegroup2').attr('maxlength', 50)")
  runjs("$('#namegroup3').attr('maxlength', 50)")
  
  runjs("$('#group1').attr('maxlength', 500000)")
  runjs("$('#group2').attr('maxlength', 500000)")
  runjs("$('#group3').attr('maxlength', 500000)")
  
  ##################################################
  # raise alerts character limit
  ##################################################
  
  observe({
    
    if(nchar(input$namegroup1) >= 50 |
       nchar(input$namegroup2) >= 50 |
       nchar(input$namegroup3) >= 50) {
      
      createAlert(session, 'alertGNchar',
                  alertId = 'Alertgn', title = "Oops",
                  content = "The lenght of each group's name cannot exceed 50 characters.")
      
    } else {closeAlert(session, 'Alertgn')}
  })
  
  observe({
    
    if(nchar(input$group1) >= 500000 |
       nchar(input$group2) >= 500000 |
       nchar(input$group3) >= 500000) {
      
      createAlert(session, 'alertNchar',
                  alertId = 'Alertn', title = "Oops",
                  content = "Each set can contain more than 500'000 characters.")
      
    } else {closeAlert(session, 'Alertn')}
  })
  
  ##################################################
  # Show sum elements
  ##################################################
  
  output$sumGroup1 <- renderPrint(
    try(cat(paste(names(values$X)[1],
                  "  ",
                  length(values$X[[1]]),
                  'elements')))
  )
  output$sumGroup2 <- renderPrint(
    try(cat(paste(names(values$X)[2],
                  "  ",
                  length(values$X[[2]]),
                  'elements')))  )
  output$sumGroup3 <- renderPrint(
    try(cat(paste(names(values$X)[3],
                  "  ",
                  length(values$X[[3]]),
                  'elements')))  )
  
  
  ##################################################
  # Update x() reactive
  ##################################################
  
  observe({values$X <- x()})
  
  ##################################################
  # Preset styles
  ##################################################
  
  observeEvent(input$style0But, {
    source('styles/style0.R', local = TRUE)
  })
  
  observeEvent(input$style1But, {
    source('styles/style1.R', local = TRUE)
  })
  
  observeEvent(input$style2But, {
    source('styles/style2.R', local = TRUE)
  })
  
  observeEvent(input$style3But, {
    source('styles/style3.R', local = TRUE)
  })
  
  observeEvent(input$style4But, {
    source('styles/style4.R', local = TRUE)
  })
  
  observeEvent(input$style5But, {
    source('styles/style5.R', local = TRUE)
  })
  
  observeEvent(input$style6But, {
    source('styles/style6.R', local = TRUE)
  })
  
  observeEvent(input$style7But, {
    source('styles/style7.R', local = TRUE)
  })
  
  ##################################################
  # Options UI
  ##################################################
  
  output$ui_proport <- renderUI({
    checkboxInput('weights', label = 'Draw an Euler diagram',
                  value = values$weights)
  })
  
  output$ui_sel_1 <- renderUI({
    fluidRow(
      
      selectInput('colscheme', label = NULL,
                  choices = names(brews), selected = values$colscheme)
      
    )
  })
  
  output$ui_sel_2 <- renderUI({
    
    radioButtons('colorify', NULL, choices = c('multiple', 'mono'),
                 selected = values$colorify)
    
  })
  
  output$intersects <- renderUI({
    
    fluidRow(
      
      column(6, 
             colourInput('inters1', label = '2-set intersection', value = values$inters1,
                         palette = 'limited', showColour = "background")),
      
      column(6,
             colourInput('inters2', label = '3-set intersection', value = values$inters2,
                         palette = 'limited', showColour = "background"))
    )
  })
  
  
  output$ui_sel_3 <- renderUI({
    
    fluidRow(
      h4('Inner numbers'),
      
      column(4,
             colourInput('fontcol', label = 'color', value = values$fontcol,
                         palette = 'limited', showColour = "background")),
      column(6,
             sliderInput('fontsize', 'size',
                         min = 0, max = 40, value = values$fontsize,
                         ticks = FALSE))
    )
  })
  
  output$ui_sel_4 <- renderUI({
    
    fluidRow(
      h4('Labels'),
      
      column(4,
             colourInput('lbcol', label = 'color', value = values$lbcol,
                         palette = 'limited', showColour = "background")
      ),
      column(6,
             sliderInput('labelsize', 'size',
                         min = 0, max = 40, value = values$labelsize,
                         ticks = FALSE))
    )
  })
  
  output$ui_sel_5 <- renderUI({
    
    fluidRow(
      column(2,
             colourInput('lwcol', label = 'color', value = values$lwcol,
                         palette = 'limited', showColour = "background")
      ),
      column(6,
             selectInput('lty', 'type',
                         choices = c('solid', 'dashed', 'dotted', 'longdash'),
                         selected = values$lty)
      ),
      column(4,
             sliderInput('lwd', 'width',
                         min = 0, max = 10, step = 1,
                         value = values$lwd, ticks = FALSE)
      )
    )
  })
  
  ##################################################
  # User actions
  ##################################################
  
  # custom color
  observeEvent(input$customcolval, {
    brews$Custom <- strsplit(input$customcolval, " ")[[1]]
    
    updateSelectInput(session, 'colscheme', selected = 'Custom')
  })
  
  # limit user input color palette
  runjs("$('#customcolval').attr('maxlength', 80)")
  
  # brews
  observe(values$cols <- brews[[values$colscheme]])
  
  # reshuffle colors
  observeEvent(input$reshuffle, {
    values$cols <- values$cols[sample(1:3)]
  })
  
  # reverse colors
  observeEvent(input$revBut, {
    values$cols <- rev(values$cols)
  })
  
  ##################################################
  # update parameters on UI input
  ##################################################
  
  # update parameters on user input
  observeEvent(input$weights, {values$weights <- input$weights})
  observeEvent(input$fontsize, {values$fontsize <- input$fontsize})
  observeEvent(input$labelsize, {values$labelsize <- input$labelsize})
  observeEvent(input$lwd, {values$lwd <- input$lwd})
  observeEvent(input$lwcol, {values$lwcol <- input$lwcol})
  observeEvent(input$lbcol, {values$lbcol <- input$lbcol})
  observeEvent(input$fontcol, {values$fontcol <- input$fontcol})
  observeEvent(input$lty, {values$lty <- input$lty})
  observeEvent(input$inters1, {values$inters1 <- input$inters1})
  observeEvent(input$inters2, {values$inters2 <- input$inters2})
  observeEvent(input$colorify, {values$colorify <- input$colorify})
  observeEvent(input$colscheme, {values$colscheme <- input$colscheme})
  
  ##################################################
  # Example button
  ##################################################
  
  output$example <- renderUI({
    
    if(!length(unlist(x()))){
      fluidRow(
        tags$br(),
        actionLink("fillBut", "Click to load an example",
                   class = 'actbut_style',
                   icon('th'))
      )
    }
  })
  
  ##################################################
  # Render plot
  ##################################################
  
  output$venn <- renderPlot({
    source('plot.R', local = TRUE)
  })
  
  ##################################################
  # PNG download
  ##################################################
  
  output$DownPNGBut <- renderUI({
    tagList(
      
      if(length(unlist(x()))){
        actionLink('downloadPNG', 'PNG',
                   icon('arrow-circle-down'),
                   class = 'actbut_style')
      },
      
      bsModal('Downpng_modal', "Export Venn diagram as a PNG",
              trigger = "downloadPNG", size = "small",
              
              downloadHandler(
                filename = 'Venndiagram.png',
                content = function(file){
                  png(file)
                  source('plot.R', local = TRUE)
                  dev.off()
                }
              )
      )
    )
  })
  
  ##################################################
  # PDF download
  ##################################################
  
  output$DownPDFBut <- renderUI({
    tagList(
      
      if(length(unlist(x()))){
        actionLink('downloadPDF', 'PDF',
                   icon('arrow-circle-down'),
                   class = 'actbut_style')
      },
      
      bsModal('Downpdf_modal', "Export Venn diagram as a PDF",
              trigger = "downloadPDF", size = "small",
              fluidRow(
                column(4,
                       numericInput('pdfsize', label = 'Size',
                                    value = 4,  min = 1, max = 20)),
                column(8, 
                       helpText('The size will affect the way lines and text are drawn')
                )),
              
              downloadHandler(
                filename = 'Venndiagram.pdf',
                content = function(file){
                  pdf(file, width = input$pdfsize, height = input$pdfsize)
                  source('plot.R', local = TRUE)
                  dev.off()
                }
              )
      )
    )
  })
  
  
  ##################################################
  # debugging
  ##################################################
  output$debug <- renderPrint({
    
  })
  
})


