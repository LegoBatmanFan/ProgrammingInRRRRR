#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# Created by: Lena Horsley
# Date: 3 March 2020 
# Developing Data Products

library(shiny)
library(shinyWidgets)
library(leaflet)
require(rCharts)
options(RCHART_LIB = 'polycharts')
source("fileLoad.R")

crimeTypeList <- c(
  "ARSON","BATTERY", "MOTOR_VEHICLE_THEFT", "THEFT", "WEAPONS_VIOLATION"
)

shinyUI(
    navbarPage("2017 Chicago Crime Data",
           tabPanel(p("Line Graph"),
                
                    sidebarPanel(
                                 selectizeInput(inputId = "myCrimes", 
                                        label = "Select up to 5 crime types. Remove a selection by clicking on it and then pressing DELETE",
                                        choices = sort(unique(as.character(myCrimeTotalsFinal$PrimaryType))),
                                        #choices = crimeTypeList,
                                        selected = crimeTypeList,
                                        multiple=TRUE,
                                        options = list(maxItems = 5L))
                                        ),
                    mainPanel(br(),
                              p("Line graph of crimes from 1 Jan 2017 to 31 Dec 2017"),
                              showOutput("chart2", "polycharts"),
                              br(),
                              br(),
                              br(),
                              p("Scatter plot of crimes from 1 Jan 2017 to 31 Dec 2017"),
                              plotlyOutput("plot1"))
                    ),
           tabPanel(p("Wards"),
                    selectInput(inputId = "myGgPlot2",
                                label = "Select crime type",
                                choices = sort(unique(mapPlot$PrimaryType))),
                    plotlyOutput("wardGgPlot"),
                   ),
           tabPanel(p("Crime Map"),
                    selectInput(inputId = "crimeMap",
                            label = "Select crime type",
                            choices = sort(unique(mapPlot$PrimaryType))),
                            leafletOutput("mymap")),
           tabPanel(p("About"),
                    includeMarkdown("info.md")
                    )
           )
        
    
)

