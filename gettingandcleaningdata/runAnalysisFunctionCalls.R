downloadDataFromInternet <- function() {
        print("downloading data...")
        setwd("~/Coursera/CleaningData/ProjectNotes")
        url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
        file <- "dataset.zip"
        download.file(url, file)
        unzip(file)
}


mergeTrainingAndTestData <- function() {  
        print("merging data...")
        print("reading and combining the training and test data sets for the subject...")
        # read and combine the training and test data sets for the subject
        subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
        subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
        completeSubject <- rbind(subjectTrain, subjectTest) 
        
        # create a column name "subject"
        names(completeSubject) <- "subject_init"
        
        
        print("reading and combining the training and test data sets for the activity...")
        # read and combine the training and test data sets for the activity
        activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
        activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
        trainAndTestActivity <- rbind(activityTrain, activityTest) 
        
        
        print("changing the values top activities...")
        #convert the table to factors and change the values to activities
        activityList <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
        trainAndTestActivity <- apply(trainAndTestActivity, 1, as.factor)
        activity_init <- activityList[trainAndTestActivity]
        
        
        print("reading and combining the training and test data sets for the numerical values (x)...")
        # read and combine the training and test data for x
        xTrain <- read.table("UCI HAR Dataset/train/x_train.txt", sep="", header=FALSE)
        xTest <- read.table("UCI HAR Dataset/test/x_test.txt", sep="", header=FALSE)
        completeXData <- rbind(xTrain, xTest) 
        
        # create the columns for the x data by reading in the second column from the features file
        featuresData <- read.table("UCI HAR Dataset/features.txt", sep="", header=FALSE) [,2]
        names(completeXData) <- featuresData
        
        
        print("combining the subject, activity and x data to form the complete untidy data...")
        # combine the subject, activity and x data to form the complete untidy data
        completeUntidyDataTable <- cbind(completeSubject, activity_init, completeXData)  
        
        return (completeUntidyDataTable)
}


modifyDataset <- function(untidyDataTable){
        print("modifying data...")
        print("renaming the columns...")
        # rename the columns
        names(untidyDataTable) <- gsub("^t", "time", names(untidyDataTable))
        names(untidyDataTable) <- gsub("^f", "freq", names(untidyDataTable))
        names(untidyDataTable) <- gsub("-", "", names(untidyDataTable))
        names(untidyDataTable) <- gsub('[()-]', '', names(untidyDataTable))
        names(untidyDataTable) <- gsub("mean", "Mean", names(untidyDataTable))
        names(untidyDataTable) <- gsub("std", "StanDev", names(untidyDataTable))
  
        print("getting the mean and standard deviation values...")
        # get all of the columns we want
        initialTidyDataTable <- untidyDataTable[, grep("subject_init|activity_init|*Mean*|*StanDev*", colnames(untidyDataTable))]
  
        print("grouping the data and performing some calculations...")
        # group the data by activity, then subject, and take the mean
        completeTidyDataTable <- aggregate(initialTidyDataTable, by=list(activity = initialTidyDataTable$activity_init, subject = initialTidyDataTable$subject_init), mean)
  
        # create a second table without the activity_init and subject_init columns
        secondDataTable <- completeTidyDataTable[, -grep("activity_init|subject_init|angle", colnames(completeTidyDataTable))]
  
        # store the activity and subject columns. then remove them from the table
        # Activity <- secondDataTable[, grep("activity", colnames(secondDataTable))]
        # Subject <- secondDataTable[, grep("subject", colnames(secondDataTable))]
        # thirdDataTable <- secondDataTable[, -grep("activity|subject", colnames(secondDataTable))]
  
        # create a new table with the subject column 1st, activiy column, and thirdDataTable next
        # finalTidyDataTable <- cbind(Subject, Activity, thirdDataTable)
  
        return (secondDataTable)
}


createDataFile <- function(finalDataTable) {
        print("writing the tidy data set to a file...")
        # write the table to a file
        write.table(finalDataTable, "tidyDataSet.txt", sep="\t")
}



