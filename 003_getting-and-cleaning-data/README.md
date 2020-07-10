
# Getting And Cleaning Data
======================


From the assignment:

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


HOW I ANALYZED THE DATA
* function downloadDataFromInternet:
* The data was downloaded. The training sets were read into R and then merged. 


function mergeTrainingAndTestData (performs steps 1 and 3):
* The data from the features.txt file was used to create the columns for the merged x data.
* The subject, activity, and x data tables were combined into one data table (completeUntidyDataTable).


function modifyDataset (performs steps 4, 2, and 5):
* The columns were renamed.
* The columns that did not contain the names "subject", "activity", "StanDev" (standard deviation) and "Mean" were removed from the table.
* The average of each variable for each activity and each subject was created. This was the final tidy data set.


MODIFYING THE DATA -
After merging the test and training sets for activity, subject, and numerical values(x), following actions were performed:
* Columns that did not contain the characters "mean" or "std" were removed from the table.
* The characters "-" and "()" were removed from varibale names.
* "t" was replaced with "time"
* "f" was replaced with "frequency"
* "mean" was replaced with "Mean"
* "std" was replaced with "StanDev"
* The data was grouped by activity, then subect and the mean was calculated for each variable for each activity and each subject.
* Columns containing "angle" were removed.
* The dataset was written to a file.


WHY I USED TWO FILES INSTEAD OF ONE
* It was easier to debug the code (isolate errors) by creating functions and calling them from a different file.
runAnalysis.R sources and calls functions from runAnalysisfuncionCalls.R

