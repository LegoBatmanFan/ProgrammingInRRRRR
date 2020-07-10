################################################################################################
# Lego BatmanFan                                                16 November 2014
# Exploratory Data Analysis                                     Course Project 2
#
# This program ddresses the following question from the assignemnt:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.
#
# This program creates two graphs: I was experimenting and wanted to show different ways of 
# displaying the data
###############################################################################################
plot2 <- function(){
        # download the data
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project002/plot2")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
        
        # read the data
        print("reading the data...")
        NEI_Data <- readRDS("summarySCC_PM25.rds")
        SCC_Data <- readRDS("Source_Classification_Code.rds")
        
        # Get the data for Baltimore, sum the emissions and rename the column names
        print("perfomring some calculations...")
        BaltimoreNEI_Data <- NEI_Data[grep("24510", NEI_Data$fips),]
        BaltimoreNEI_PlotData <- aggregate(BaltimoreNEI_Data$Emissions, by=list(BaltimoreNEI_Data$year), sum)
        colnames(BaltimoreNEI_PlotData) <- c("Year", "Emissions")
        
        # plot2 has 2 graphs
        print("plotting...")
        png("plot2.png", width=500, height=700, units="px")
        old.par <- par(mfrow=c(2, 1))
        # 1st graph
        plot(BaltimoreNEI_PlotData, type = "l", ylab = expression('Emissions PM'[2.5]), xlab = "Year")
        
        # 2nd graph
        barplot(BaltimoreNEI_PlotData$Emissions, xlab = "Year", ylab = expression('Emissions PM'[2.5]), ylim = c(0, 4000), names.arg = c("1999", "2002", "2005", "2008"))
        text(0.7, 3500, round(BaltimoreNEI_PlotData$Emissions[1], 2), cex=0.8)
        text(1.9, 2700, round(BaltimoreNEI_PlotData$Emissions[2], 2), cex=0.8)
        text(3.1, 3300, round(BaltimoreNEI_PlotData$Emissions[3], 2), cex=0.8)
        text(4.3, 2100, round(BaltimoreNEI_PlotData$Emissions[4], 2), cex=0.8)
        mtext("Total Emissions in Baltimore City (1999-2008)", side = 3, line = -2, outer = TRUE)
        par(old.par)
        dev.off() 
        
        print("plotting complete and graph saved...")
        
        # some cleanup. not necessary, but frees up memory 
        print("some cleanup...")
        NEI_Data <- NULL
        SCC_Data <- NULL
        BaltimoreNEI_Data <- NULL
        BaltimoreNEI_PlotData <- NULL
        
        print("analysis complete for plot2. please view your results/graph...")
}