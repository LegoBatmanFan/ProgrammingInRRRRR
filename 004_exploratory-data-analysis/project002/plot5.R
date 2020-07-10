################################################################################################
# Lego BatmanFan                                                16 November 2014
# Exploratory Data Analysis                                     Course Project 2
#
# This program ddresses the following question from the assignemnt:
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 
#
# This program creates two graphs: I was experimenting and wanted to show different ways of 
# displaying the data
###############################################################################################
plot5 <- function(){
        # download the data
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project002/plot5")
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
        BaltimoreNEI_Data <- NEI_Data[grep("24510", NEI_Data$fips),]
        BaltimoreMotor_Data<- BaltimoreNEI_Data[BaltimoreNEI_Data$SCC %in% MotorSourcesSCC_Data$SCC,]
        BaltimoreMotor_PlotData <- aggregate(BaltimoreMotor_Data$Emissions, by=list(BaltimoreMotor_Data$year), sum)
        colnames(BaltimoreMotor_PlotData) <- c("Year", "Emissions")
        
        # plot5 has 2 graphs
        print("plotting...")
        png("plot5.png", width=500, height=700, units="px")
        old.par <- par(mfrow=c(2, 1))
        # 1st graph
        plot(BaltimoreMotor_PlotData, type = "l",ylab = "Emissions (P.M 2.5)",xlab = "Year")
        
        # 2nd graph
        barplot(BaltimoreMotor_PlotData$Emissions, xlab = "Year", ylab = "Emissions", ylim = c(0, 15), names.arg = c("1999", "2002", "2005", "2008"))
        text(0.7, 1.3, round(BaltimoreMotor_PlotData$Emissions[1], 2), cex=0.8)
        text(1.9, 11.3, round(BaltimoreMotor_PlotData$Emissions[2], 2), cex=0.8)
        text(3.1, 11, round(BaltimoreMotor_PlotData$Emissions[3], 2), cex=0.8)
        text(4.3, 1.3, round(BaltimoreMotor_PlotData$Emissions[4], 2), cex=0.8)
        mtext("Emissions from Motor Vehicle Sources in Baltimore City (1999-2008)", side = 3, line = -2, outer = TRUE)
        par(old.par)
        dev.off() 
        
        print("plotting complete and graph saved...")
        
        # some cleanup. not necessary, but frees up memory 
        print("some cleanup...")
        NEI_Data <- NULL
        SCC_Data <- NULL
        BaltimoreMotor_PlotData <- NULL
        BaltimoreNEI_Data <- NULL
        MotorSourcesSCC_Data <- NULL
        BaltimoreMotor_Data <- NULL
        
        print("analysis complete for plot5. please view your results/graph...")
}