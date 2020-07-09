###########################################################################
# LegoBatmanFan                                 8 November 2014
#
# this program calls "CreateTidyData.R", which downloads and manipulates
# data. multiple plots are created in one graphic.
# plot 1: Global_active_power vs timeDateData
# plot 2: Voltage  vs timeDateData
# plot 3: energy sub metering vs. timeDateData
# plot 4: Global_reactive_power vs timeDateData
###########################################################################
plot4 <- function(){
        # download and manipuate the data
        source("createTidyData.R")
        downloadDataFromInternet()
        finalTable <- manipulateData()
        
        #plot the data
        png("plot4.png", width=480, height=480, units="px")
        old.par <- par(mfrow=c(2, 2))
        # plot 1
        plot(finalTable$timeDateData, finalTable$Global_active_power, type = "l",ylab = "Global Active Power (kilowatts)",xlab = "")
        
        #plot 2
        plot(finalTable$timeDateData, finalTable$Voltage, type = "l",ylab = "Voltage",xlab = "datetime")
        
        # plot 3
        plot(finalTable$timeDateData, finalTable$Sub_metering_1, type = "l",ylab = "Energy sub metering",xlab = "", col="black")
        lines(finalTable$timeDateData, finalTable$Sub_metering_2, col="red")
        lines(finalTable$timeDateData, finalTable$Sub_metering_3, col="blue")
        legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lty=c(1,1,1), lwd=c(1,1,1),col=c("black","red","blue"))
        
        # plot 4
        plot(finalTable$timeDateData, finalTable$Global_reactive_power, type = "l",ylab = "Global_reactive_power",xlab = "datetime")
        par(old.par)
        dev.off() 
}
