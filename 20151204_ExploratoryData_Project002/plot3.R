################################################################################################
# Lego BatmanFan                                                16 November 2014
# Exploratory Data Analysis                                     Course Project 2
#
# This program ddresses the following question from the assignemnt:
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 for 
# Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 
# plotting system to make a plot answer this question.
#
# This program creates three graphs: I was experimenting and wanted to show different ways of 
# displaying the data
###############################################################################################
plot3 <- function(){
        # download the data
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project002/plot3")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
        
        # read the data
        print("reading the data...")
        NEI_Data <- readRDS("summarySCC_PM25.rds")
        SCC_Data <- readRDS("Source_Classification_Code.rds")
        
        # get/call the necessary libraries
        print("getting the libraries plyr and ggplot2...")
        library(plyr)
        library(ggplot2) 
        
        # Get the data for Baltimore, sum the emissions and rename the column names
        print("perfomring some calculations...")
        BaltimoreNEI_Data <- NEI_Data[grep("24510", NEI_Data$fips),]
        BaltimoreNEI_PlotData001 <- aggregate(BaltimoreNEI_Data$Emissions, by=list(BaltimoreNEI_Data$type, BaltimoreNEI_Data$year), sum)
        colnames(BaltimoreNEI_PlotData001) <- c("Type","Year", "Emissions")
        BaltimoreNEI_PlotData001$Year <- factor(BaltimoreNEI_PlotData001$Year)
        
        # this piece of code allows you to plot the values on the bars. it came from stackoverflow.com and was modified for use 
        # in this assignment
        barMidpoints = function(BaltimoreNEI_PlotData001) {
                cumsums = c(0, cumsum(BaltimoreNEI_PlotData001$Emissions))
                diffs = diff(cumsums)
                pos = head(cumsums, -1) + (0.5 * diffs)
                return(data.frame(Type=BaltimoreNEI_PlotData001$Type, pos=pos, Emissions=BaltimoreNEI_PlotData001$Emissions))
        }
        midpointData = ddply(BaltimoreNEI_PlotData001, .(Year), barMidpoints)
        
        # plot3 has 3 graphs
        print("plotting...")
        png("plot3.png", width=500, height=1500, units="px")
        # 1st graph
        p1 <- ggplot(BaltimoreNEI_PlotData001, aes(Year, Emissions, group=Type, color=Type)) + geom_line() + geom_point() +
                labs(y=expression('Emissions PM'[2.5])) 
        
        # 2nd graph        
        p2 <- ggplot(BaltimoreNEI_PlotData001, aes(x=Year, y=Emissions, fill=Type)) + 
                geom_bar(stat="identity", position=position_dodge(width = 0.9)) +
                coord_flip() +
                geom_text(stat="identity", aes(y = Emissions, x = Year, label = round(Emissions,0) ),  position = position_dodge(width = 0.9), size=3) +
                labs(y=expression('Emissions PM'[2.5]))
        
        # 3rd graph
        p3 <- ggplot(midpointData, aes(x = Year, fill = Type)) +
                geom_bar(aes(weight=Emissions), position="stack") +
                geom_text(position = "identity", aes(x = Year, y = pos, ymax = 4000, label = round(Emissions,2)), size=4) + 
                labs(y=expression('Emissions PM'[2.5]))
        library(grid)
        library(gridExtra)
        grid.arrange(p1, p2, p3, nrow=3, main="Emissions by Source for Baltimore City (1999-2008")
        dev.off()
        
        print("plotting complete and graph saved...")
        
        # some cleanup. not necessary, but frees up memory 
        print("some cleanup...")
        NEI_Data <- NULL
        SCC_Data <- NULL
        BaltimoreNEI_PlotData001 <- NULL
        BaltimoreNEI_Data <- NULL
        midpointData <- NULL
        barMidpoints <- NULL
        
        print("analysis complete for plot3. please view your results/graph...")
}