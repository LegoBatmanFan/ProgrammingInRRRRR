###########################################################################
# LegoBatmanFan                                 8 November 2014
#
# this program calls "CreateTidyData.R", which downloads and manipulates
# data. a line plot of Global_active_power vs. timeDateData  is created.
# timeDateData is a varibale that is a combination of the columns Date and 
# Time.
###########################################################################
plot2 <- function(){
        # download and manipuate the data
        source("createTidyData.R")
        downloadDataFromInternet()
        finalTable <- manipulateData()
        
        #plot the data
        png("plot2.png", width=480, height=480, units="px")
        plot(finalTable$timeDateData, finalTable$Global_active_power, type = "l",ylab = "Global Active Power (kilowatts)",xlab = "")
        dev.off()
}

 