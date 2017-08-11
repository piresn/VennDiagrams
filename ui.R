library(shiny)
library(shinythemes)
library(shinyBS)

shinyUI(
  navbarPage(
    'Venn Diagrams', theme = shinytheme("united"),
    
    tabPanel(
      "Create",
      
      fluidPage(
        
        useShinyjs(),
        
        includeCSS("www/styles.css"),
        
        fluidRow(
          #verbatimTextOutput('debug'),
          
          column(2,
                 verticalLayout(
                   actionButton("inpBut", "Set groups", icon('database'))
                 )
          ),
          
          column(7,
                 
                 bsModal('inputwind', 'Input values', 'inpBut', size = 'large',
                         fluidRow(
                           column(4, 
                                  verticalLayout(
                                    textInput('namegroup1', 'Set name'),
                                    textAreaInput('group1', 'Elements',
                                                  rows = 8, resize = 'vertical')
                                  )),
                           column(4,
                                  verticalLayout(
                                    textInput('namegroup2', 'Set name'),
                                    textAreaInput('group2', 'Elements',
                                                  rows = 8, resize = 'vertical')
                                  )),
                           column(4,
                                  verticalLayout(
                                    textInput('namegroup3', 'Set name'),
                                    textAreaInput('group3', 'Elements',
                                                  rows = 8, resize = 'vertical')
                                  )
                           )
                         ),
                         fluidRow(
                           textOutput('sumGroup1'),
                           textOutput('sumGroup2'),
                           textOutput('sumGroup3')
                         ),
                         fluidRow(
                           actionLink("fillBut2", "Load Olympic gold medals example",
                                      class = 'actbut_style', icon('th'))),
                         fluidRow(
                           actionLink("resetInput", "Reset",
                                      class = 'actbut_style', icon('remove'))
                         ),
                         
                         bsAlert('alertGNchar'),
                         bsAlert('alertNchar')
                 ),
                 uiOutput('example', align = 'center'),
                 
                 plotOutput("venn"),
                 verticalLayout(
                   uiOutput('DownPNGBut'),
                   uiOutput('DownPDFBut')
                 )
          ),
          column(3,
                 tabsetPanel(id = 'tabs1',
                             tabPanel('Styles', icon = icon("paint-brush",
                                                            lib = 'font-awesome'),
                                      
                                      fluidRow(
                                        actionButton('style0But',
                                                     img(src='style0.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style1But',
                                                     img(src='style1.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style2But',
                                                     img(src='style2.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style3But',
                                                     img(src='style3.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style4But',
                                                     img(src='style4.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style5But',
                                                     img(src='style5.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style6But',
                                                     img(src='style6.png', align = 'middle'),
                                                     class = 'actbut_img'),
                                        actionButton('style7But',
                                                     img(src='style7.png', align = 'middle'),
                                                     class = 'actbut_img'))
                             ),
                             
                             tabPanel("Options", icon = icon("cogs",
                                                             lib = 'font-awesome'),
                                      
                                      h3('Diagram type'),
                                      
                                      uiOutput('ui_proport'),
                                      
                                      tags$hr(),
                                      
                                      h3('Colours'),
                                      
                                      helpText('You can use a different palette color for each set and set intersection colors below (multiple),
                                               or use the same color for all sets (mono)'),
                                      
                                      uiOutput('ui_sel_2'),
                                      
                                      h4('Colour palette'),                                      
                                      
                                      uiOutput('ui_sel_1'),
                                      
                                      actionButton('addBrewBut', 'Create a custom colour palette',
                                                   icon('user')),
                                      
                                      bsTooltip(id = 'addBrewBut', placement = 'left',
                                                title = 'Pick your own colors'),
                                      
                                      
                                      bsModal('intersectMod', 'Intersection color', 'intersBut',
                                              size = 'small',
                                              uiOutput('intersects')),
                                      
                                      tags$p(),
                                      
                                      conditionalPanel('input.colorify == "mono"',
                                                       actionButton('revBut', label = 'Reverse colors', icon('exchange'))
                                      ),
                                      
                                      bsTooltip(id = 'revBut', placement = 'left',
                                                title = 'Reverse the order of colours in the palette'),
                                      
                                      
                                      conditionalPanel('input.colorify == "multiple"',
                                                       actionButton('reshuffle', 'Reshuffle colors',
                                                                    icon('refresh')),
                                                       tags$p(),
                                                       actionButton('intersBut', 'Intersection colors',
                                                                    icon('dot-circle-o'))
                                      ),
                                      
                                      bsTooltip(id = 'reshuffle', placement = 'left',
                                                title = 'Reshuffle the circle colours'),
                                      
                                      bsTooltip(id = 'intersBut', placement = 'left',
                                                title = 'Set the colour of overlapping circles'),
                                      
                                      bsModal('inputcustombrew', 'Create a custom color scheme',
                                              'addBrewBut', size = 'small',
                                              textInput('customcolval', 'Pick colors',
                                                        #rows = 3, resize = 'none',
                                                        placeholder = 'E.g. violet lightgreen turquoise'),
                                              helpText('You can also use hex strings (e.g.#0000FF)')),
                                      
                                      tags$hr(),
                                      
                                      h3('Format text and lines'),
                                      
                                      actionButton('textBut', 'Text', icon('font')),
                                      
                                      bsModal('textMod', 'Format Text', 'textBut',
                                              size = 'small',
                                              uiOutput('ui_sel_3'),
                                              uiOutput('ui_sel_4')
                                      ),
                                      
                                      actionButton('bordersBut', 'Lines', icon('circle-o-notch')),
                                      
                                      bsModal('bordersMod', 'Format lines', 'bordersBut',
                                              size = 'small',
                                              uiOutput('ui_sel_5')
                                      )
                                      
                             )
                 )
          )
        )
      )
    ),
    tabPanel('Help',
             includeMarkdown("text/FAQ.md"),
             value = 'helptab'), # CSS selector
    
    tabPanel(
      'About',
      includeMarkdown("text/about.md")
    )
  ))
