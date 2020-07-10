# Created by: Lena Horsley
# Date: 3 March 2020 
# Developing Data Products
#
# mapPlot <- read.csv("./testData/cleanedCrimeDataComplete.csv")
# myCrimeTotalsFinal <- read.csv("./testData/crimeTotalsFinal.csv")

suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(data.table))
crimeStatsFrame<- read.csv("./testData/Crimes_-_2017.csv") 
dim(crimeStatsFrame)
head(crimeStatsFrame)
# Set empty cells to NA ad remove those cells
sum(is.na(crimeStatsFrame))
crimeStatsFrame <- replace(crimeStatsFrame, crimeStatsFrame == "", NA)
sum(is.na(crimeStatsFrame))
crimeStatsNoNaFrame <- crimeStatsFrame[complete.cases(crimeStatsFrame), ]
dim(crimeStatsNoNaFrame)

#write.csv(crimeStatsNoNaFrame, "./testData/001_crimeStatsNoNaFrame.csv", row.names = FALSE)
## Remove whitespace
crimeStatsNoNaFrame$Primary.Type <- gsub('\\s+', '_', crimeStatsNoNaFrame$Primary.Type)
## Change the data frame to a data table
crimeStatsNoNaDT <- data.table(crimeStatsNoNaFrame)
dim(crimeStatsNoNaDT)
sum(is.na(crimeStatsNoNaDT))
rm(crimeStatsNoNaFrame)
## Change columns (git rid of period)
names(crimeStatsNoNaDT)[names(crimeStatsNoNaDT) == 'Case.Number'] <- 'CaseNumber'
names(crimeStatsNoNaDT)[names(crimeStatsNoNaDT) == 'Primary.Type'] <- 'PrimaryType'
names(crimeStatsNoNaDT)[names(crimeStatsNoNaDT) == 'Location.Description'] <- 'LocationDescription'
names(crimeStatsNoNaDT)[names(crimeStatsNoNaDT) == 'Community.Area'] <- 'CommunityArea'
names(crimeStatsNoNaDT)[names(crimeStatsNoNaDT) == 'FBI.Code'] <- 'FBICode'
names(crimeStatsNoNaDT)
# Remove columns
colToRemove <- c(1,2, 16,17, 19, 22)
cleanedCrimeData <- subset(crimeStatsNoNaDT, select= -colToRemove)
#write.csv(cleanedCrimeData, "./testData/002_cleanedCrimeData.csv")
class(cleanedCrimeData$Date)
cleanedCrimeData$datetime <- ymd(as.POSIXct(strptime(as.character(cleanedCrimeData$Date),
                                                     format = "%m/%d/%Y")))
head(cleanedCrimeData)
dim(cleanedCrimeData)
#write.csv(cleanedCrimeData, "./testData/003_cleanedCrimeData001.csv", row.names = FALSE)
rm(crimeStatsNoNaDT)

class(cleanedCrimeData$PrimaryType)
class(cleanedCrimeData$datetime)
mapPlot <- cleanedCrimeData
myCrimeTotalsFinal <- cleanedCrimeData %>%
     group_by(datetime, PrimaryType) %>%
     summarise(count = dplyr::n()) %>%
     #spread(key = PrimaryType, value = count, fill = 0, drop = FALSE) %>%
     as.data.frame()

primaryTypeWardFrame <- cleanedCrimeData %>%
  group_by(PrimaryType, Ward) %>%
  summarise(count = dplyr::n()) %>%
  #spread(key = PrimaryType, value = count, fill = 0, drop = FALSE) %>%
  as.data.frame()
