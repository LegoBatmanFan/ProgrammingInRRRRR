###########################################################################
# LegoBatmanFan                                 8 November 2014
#
# this program calls "CreateTidyData.R", which downloads and manipulates
# data. a line plot of energy sub metering vs. timeDateData  is created.
# there are three sub metering variables: Sub_metering_1, Sub_netering_2,
# and Sub_metering_3. a plot with three lines is created. timeDateData is 
# a varibale that is a combination of the columns Date and Time.
###########################################################################
plot3 <- function(){
        # download and manipuate the data
        source("createTidyData.R")
        downloadDataFromInternet()
        finalTable <- manipulateData()
        
        #plot the data
        png("plot3.png", width=480, height=480, units="px")
        plot(finalTable$timeDateData, finalTable$Sub_metering_1, type = "l",ylab = "Energy sub metering",xlab = "", col="black")
        lines(finalTable$timeDateData, finalTable$Sub_metering_2, col="red")
        lines(finalTable$timeDateData, finalTable$Sub_metering_3, col="blue")
        legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lty=c(1,1,1), lwd=c(1,1,1),col=c("black","red","blue"))
        dev.off() 
}
        
        
