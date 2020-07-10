#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# Created by: Lena Horsley
# Date: 3 March 2020 
# Developing Data Products

library(shiny)
library(tidyr)
library(plotly)
library(ggplot2)
library(lubridate)
library(data.table)
source("fileLoad.R")
require(rCharts)
library(leaflet)
library(DT)
options(RCHART_WIDTH = 800)

shinyServer(function(input, output) {
    output$chart2 <- renderChart({
        chartCrimeList = input$myCrimes
        # print(paste0("class(chartCrimeList): ", class(chartCrimeList)))
        # print(paste0("class(length(chartCrimeList)): ", class(length(chartCrimeList))))
        # print(paste0("length(chartCrimeList): ", length(chartCrimeList)))
        # myLength <- length(chartCrimeList)
        # if (myLength > 0) {
        #     for(i in 1: length(chartCrimeList)){
        #         print(paste0("my crimestats: ", chartCrimeList[i]))
        #     }
        # }
        
        #print(paste0("Here are the values: ",head(myCrimeTotalsFinal)))
        myCrimes <- subset(myCrimeTotalsFinal, PrimaryType == chartCrimeList)
        crimePlot <- rPlot(count ~ datetime, color = 'PrimaryType', type = 'line', data = myCrimes)
        crimePlot$guides(x = list(title = "Date"))
        crimePlot$guides(y = list(title = "# of Crimes"))
        crimePlot$addParams(height = 400, dom = 'chart2')
        return(crimePlot)
    })

    output$mymap <- renderLeaflet({
        mapCrimeList <- input$crimeMap
        # print(paste0("class(mapCrimeList): ", class(mapCrimeList)))
        # print(paste0("class(length(mapCrimeList)): ", class(length(mapCrimeList))))
        # print(paste0("length(mapCrimeList): ", length(mapCrimeList)))
        # myLength <- length(mapCrimeList)
        # if (myLength > 0) {
        #     for(i in 1: length(mapCrimeList)){
        #         print(paste0("my crimestats: ", mapCrimeList[i]))
        #     }
        # }

        myCrimeMap <- subset(mapPlot, PrimaryType == mapCrimeList)
        mymap <- leaflet(myCrimeMap) %>% 
            clearMarkers() %>%
            setView(lng = -87.6298, lat = 41.8781, zoom = 10)  %>% 
            addTiles() %>% 
            addCircleMarkers(clusterOptions = markerClusterOptions(),
                       lng=~Longitude, 
                       lat=~Latitude,
                       popup = paste("<b>Date and Time: </b>",myCrimeMap$Date, "<br>",
                                    " <b>Block: </b>",myCrimeMap$Block, "<br>",
                                     " <b>Description: </b>",myCrimeMap$Description, "<br>",
                                     " <b>Individual(s) Arrested: </b>",myCrimeMap$Arrest, "<br>",
                                     " <b>GPS Coordinates: </b>",myCrimeMap$Latitude, myCrimeMap$Longitude))
        return(mymap)
    })
    
    output$plot1 <- renderPlotly({
        chartCrimeList = input$myCrimes
        #print(paste0("chartCrimeList: ", chartCrimeList))
        myCrimes <- subset(myCrimeTotalsFinal, PrimaryType == chartCrimeList)
        #print(paste0("PrimaryType: ", PrimaryType))
        #print(paste0("HEAD: ",head(myCrimes)))
        scatterCrimePlot <- plot_ly(myCrimes, x = ~datetime, y = ~count, color = ~PrimaryType, type="scatter", mode="markers") %>%
            layout(
                xaxis = list(title = "Date"),
                yaxis = list(title = "# of Crimes"))
       
        return(scatterCrimePlot)
    })
    
    output$wardGgPlot <- renderPlotly({
        chartCrimeList = input$myGgPlot2
        myWardCrimes <- subset(primaryTypeWardFrame, PrimaryType == chartCrimeList)
        myWardGgPlot <- ggplot(myWardCrimes, aes(x=Ward, y = count, fill=Ward)) + geom_bar(stat="identity") +
             theme(legend.position="none", axis.text.x = element_text(angle = 45, hjust = 1)) + xlab("Ward Number") + ylab("# of Crimes") + labs(title = "Number of Crimes per Ward")
        return(myWardGgPlot)
    })
})
