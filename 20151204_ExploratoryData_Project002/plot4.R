################################################################################################
# Lego BatmanFan                                                16 November 2014
# Exploratory Data Analysis                                     Course Project 2
#
# This program ddresses the following question from the assignemnt:
# Across the United States, how have emissions from coal combustion-related sources changed 
# from 1999-2008?
#
# This program creates two graphs: I was experimenting and wanted to show different ways of 
# displaying the data
###############################################################################################
plot4 <- function(){
        # download the data
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project002/plot4")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
        
        # read the data
        print("reading the data...")
        NEI_Data <- readRDS("summarySCC_PM25.rds")
        SCC_Data <- readRDS("Source_Classification_Code.rds")
        
        # Get the data for coal emission-related sources, sum the emissions and rename the column names
        print("perfomring some calculations...")
        CoalSourcesSCC_Data <- SCC_Data[grep("coal|Coal", SCC_Data$EI.Sector),]
        TotalCoalData <- NEI_Data[NEI_Data$SCC %in% CoalSourcesSCC_Data$SCC,]
        TotalCoal_PlotData <- aggregate(TotalCoalData$Emissions, by=list(TotalCoalData$year), sum)
        colnames(TotalCoal_PlotData) <- c("Year", "Emissions")
        
        # plot4 has 2 graphs
        print("plotting...")
        png("plot4.png", width=500, height=700, units="px")
        old.par <- par(mfrow=c(2, 1))
        # 1st graph
        plot(TotalCoal_PlotData, type = "l", ylab=(expression('Emissions PM'[2.5])), xlab = "Year")
        
        # 2nd graph
        barplot(TotalCoal_PlotData$Emissions, xlab = "Year", ylab = (expression('Emissions PM'[2.5])), ylim = c(0, 700000), names.arg = c("1999", "2002", "2005", "2008"))
        text(0.7, 650000, round(TotalCoal_PlotData$Emissions[1], 2), cex=0.8)
        text(1.9, 600000, round(TotalCoal_PlotData$Emissions[2], 2), cex=0.8)
        text(3.1, 600000, round(TotalCoal_PlotData$Emissions[3], 2), cex=0.8)
        text(4.3, 400000, round(TotalCoal_PlotData$Emissions[4], 2), cex=0.8)
        mtext("Emissions from Coal Combustion-related Sources (1999-2008)", side = 3, line = -2, outer = TRUE)
        par(old.par)
        dev.off() 
        
        print("plotting complete and graph saved...")
        
        # some cleanup. not necessary, but frees up memory 
        print("some cleanup...")
        NEI_Data <- NULL
        SCC_Data <- NULL
        TotalCoal_PlotData <- NULL
        CoalSourcesSCC_Data <- NULL
        TotalCoalData <- NULL
        
        print("analysis complete for plot4. please view your results/graph...")
}