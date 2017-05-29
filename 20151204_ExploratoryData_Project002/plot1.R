################################################################################################
# Lego BatmanFan                                                16 November 2014
# Exploratory Data Analysis                                     Course Project 2
#
# This program ddresses the following question from the assignemnt:
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the 
# base plotting system, make a plot showing the total PM2.5 emission from all sources for each 
# of the years 1999, 2002, 2005, and 2008.
#
# This program creates two graphs: I was experimenting and wanted to show different ways of 
# displaying the data
###############################################################################################
plot1 <- function(){
        # download the data
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project002/plot1")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
        
        # read the data
        print("reading the data...")
        NEI_Data <- readRDS("summarySCC_PM25.rds")
        SCC_Data <- readRDS("Source_Classification_Code.rds")
        
        # Sum the emissions and rename the column names
        print("perfomring some calculations...")
        NEI_PlotData <- aggregate(NEI_Data$Emissions, by=list(NEI_Data$year), sum)
        colnames(NEI_PlotData) <- c("Year", "Emissions")
        
        
        # plot1 has 2 graphs
        print("plotting...")
        png("plot1.png", width=500, height=700, units="px")
        old.par <- par(mfrow=c(2, 1))
        # 1st graph
        plot(NEI_PlotData, type = "l",ylab =expression('Emissions PM'[2.5]),xlab = "Year")
        
        # 2nd graph
        barplot(NEI_PlotData$Emissions, xlab = "Year", ylab=expression('Emissions PM'[2.5]), ylim = c(0, 8500000), names.arg = c("1999", "2002", "2005", "2008"))
        text(0.7, 7700000, round(NEI_PlotData$Emissions[1], 2), cex=0.8)
        text(1.9, 6000000, round(NEI_PlotData$Emissions[2], 2), cex=0.8)
        text(3.1, 5800000, round(NEI_PlotData$Emissions[3], 2), cex=0.8)
        text(4.3, 3800000, round(NEI_PlotData$Emissions[4], 2), cex=0.8)
        mtext("Total Emissions from all sources (1999-2008)", side = 3, line = -2, outer = TRUE)
        par(old.par)
        dev.off() 
        
        print("plotting complete and graph saved...")
        
        # some cleanup. not necessary, but frees up memory 
        print("some cleanup...")
        NEI_Data <- NULL
        SCC_Data <- NULL
        NEI_PlotData <- NULL
        
        print("analysis complete for plot1. please view your results/graph...")
}