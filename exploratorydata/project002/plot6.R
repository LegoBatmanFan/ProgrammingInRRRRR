################################################################################################
# Lego BatmanFan                                                16 November 2014
# Exploratory Data Analysis                                     Course Project 2
#
# This program ddresses the following question from the assignemnt:
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen 
# greater changes over time in motor vehicle emissions?
#
# This program creates two graphs: I was experimenting and wanted to show different ways of 
# displaying the data
###############################################################################################
plot6 <- function(){
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project002/plot6")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
        
        # read the data
        print("reading the data...")
        NEI_Data <- readRDS("summarySCC_PM25.rds")
        SCC_Data <- readRDS("Source_Classification_Code.rds")
        
        # Get the data for motor emission sources, sum the emissions and rename the column names
        print("perfomring some calculations...")
        MotorSourcesSCC_Data <- SCC_Data[grep("*motor*|*Motor*", SCC_Data$Short.Name),]
        BaltimoreLACounty_NEI_Data <- NEI_Data[grep("24510|06037", NEI_Data$fips),]
        BaltimoreLACountyMotor_Data<- BaltimoreLACounty_NEI_Data[BaltimoreLACounty_NEI_Data$SCC %in% MotorSourcesSCC_Data$SCC,]
        TotalPlotData <- aggregate(BaltimoreLACountyMotor_Data$Emissions, by=list(BaltimoreLACountyMotor_Data$fips, BaltimoreLACountyMotor_Data$year), sum)
        colnames(TotalPlotData) <- c("City","Year", "Emissions")
        TotalPlotData$City <- gsub("06037", "LA County", TotalPlotData$City)
        TotalPlotData$City <- gsub("24510", "Baltimore City", TotalPlotData$City)
        TotalPlotData$Year <- factor(TotalPlotData$Year)
       
        print("getting the library ggplot2...")
        library(ggplot2) 
        
        # plot6 has two graphs
        print("plotting...")
        png("plot6.png", width=500, height=700, units="px")
        # 1st graph
        p1 <- ggplot(TotalPlotData, aes(Year, Emissions, group= City, color=City)) + geom_line() + geom_point() +
                labs(y=expression('Emissions PM'[2.5]))
        
        # 2nd graph
        p2 <- ggplot(TotalPlotData, aes(x=Year, y=Emissions, fill=City)) + geom_bar(stat="identity", position="dodge") +
                labs(y=expression('Emissions PM'[2.5])) +
                annotate("text", x = 0.7, y = 3, size = 3, label = (round(TotalPlotData$Emissions[2],2))) + 
                annotate("text", x = 1.25, y = 70, size = 3, label = (round(TotalPlotData$Emissions[1],2))) +
                annotate("text", x = 1.75, y = 12, size = 3, label = (round(TotalPlotData$Emissions[4],2))) +
                annotate("text", x = 2.23, y = 80, size = 3, label = (round(TotalPlotData$Emissions[3],2))) +
                annotate("text", x = 2.78, y = 12, size = 3, label = (round(TotalPlotData$Emissions[6],2))) +
                annotate("text", x = 3.25, y = 88, size = 3, label = (round(TotalPlotData$Emissions[5],2))) +
                annotate("text", x = 3.8, y = 3, size = 3, label = (round(TotalPlotData$Emissions[8],2))) +
                annotate("text", x = 4.2, y = 87, size = 3, label = (round(TotalPlotData$Emissions[7],2))) 
        library(grid)
        library(gridExtra)
        grid.arrange(p1, p2, nrow=2, main = "Comparison of Motor Vehicle Sources in Baltimore and LA County (1999-2008)")
        dev.off() 
        
        print("plotting complete and graph saved...")
        
        # some cleanup. not necessary, but frees up memory 
        print("some cleanup...")
        NEI_Data <- NULL
        SCC_Data <- NULL
        MotorSourcesSCC_Data <- NULL
        BaltimoreLACounty_NEI_Data <- NULL
        BaltimoreLACountyMotor_Data <- NULL
        TotalPlotData <- NULL
        
        print("analysis complete for plot6. please view your results/graph...")
}