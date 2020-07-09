###########################################################################
# LegoBatmanFan                                 8 November 2014
#
# this program calls "CreateTidyData.R", which downloads and manipulates
# data. a histogram plot of Global_active_power with timeDateData on the
# x-axis is created. timeDateData is a varibale that is a combination of 
# the columns Date and Time.
###########################################################################
plot1 <- function(){
        # download and manipuate the data
        source("createTidyData.R")
        downloadDataFromInternet()
        finalTable <- manipulateData()
        
        #plot the data
        png("plot1.png", width=480, height=480, units="px")
        hist(finalTable$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red")
        dev.off() 
}