###########################################################################
# LegoBatmanFan                                 8 November 2014
# 
# this program is called by plot1.R, plot2.R, plot3.R, and plot4.R
#
# function downloadDataFromInternet: downloads the data from the internet
#       and unzips the file
#
# function manipulateData: manipulates/tidies the data
#       1. reads in the data
#       2. combines the date and time columns, creates a new column,
#               and places the values created by the combination of
#               date and time columns into a new column called
#               "timeDataData"
#       3. the date for myDataFile$Date is formatted (changed to characters)
#       4. data for 1 feb 2007 and 2 feb 2007 are removed
#       5. the bad values are removed
#       6. some columns are changed to numeric values
###########################################################################
downloadDataFromInternet <- function() {
        print("downloading data...")
        setwd("~/Coursera/ExploratoryData/Project001")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
}

manipulateData <- function(){
        options(stringsAsFactor = FALSE)
        print("reading the file...")
        myDataFile <- read.table("household_power_consumption.txt", header=TRUE, sep=";", colClasses='character')
        print("manipulating the data...")
        tempDateTime <- paste(myDataFile$Date, myDataFile$Time)
        timeDateData <- strptime(tempDateTime, "%d/%m/%Y %H:%M:%S")
        myDataFile <- cbind(myDataFile, timeDateData)
        myDataFile$Date <- strptime(as.character(myDataFile$Date), "%d/%m/%Y")
        print("getting the data for two days..")
        myDataFile <- myDataFile[grep("2007-02-01|2007-02-02", myDataFile$Date),]
        myDataFile$Date <- format(myDataFile$Date, "%m/%d/%Y")
        
        goodData <- myDataFile[complete.cases(myDataFile),]
        print("changing some columns to numberic values")
        goodData$Global_active_power <- as.numeric(goodData$Global_active_power)
        goodData$Global_reactive_power <- as.numeric(goodData$Global_reactive_power)
        goodData$Voltage <- as.numeric(goodData$Voltage)
        goodData$Global_intensity <- as.numeric(goodData$Global_intensity)
        goodData$Sub_metering_1 <- as.numeric(goodData$Sub_metering_1)
        goodData$Sub_metering_2 <- as.numeric(goodData$Sub_metering_2)
        goodData$Sub_metering_3 <- as.numeric(goodData$Sub_metering_3)
        tempDateTime <- NULL
        timeDateData <- NULL
        myDataFile <- NULL
        return(goodData)
}