##Codebook
####Instructions for project
####The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

####Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

####You should create one R script called run_analysis.R that does the following.

####1)Merges the training and the test sets to create one data set.
####2)Extracts only the measurements on the mean and standard deviation for each measurement.
####3)Uses descriptive activity names to name the activities in the data set
####4)Appropriately labels the data set with descriptive variable names.
####5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###STEPS and all details Variable, data,transformation,explanation of code and how onnected .
#### STEP1 : Getting Data
##### 1)Download the raw data file in the working directory and unzip the file.

#####2)For this project ,using the below files

##### test/subject_test.txt
##### test/X_test.txt
##### test/y_test.txt
##### train/subject_train.txt
##### train/X_train.txt
##### train/y_train.txt

#### STEP2 : Read the data
#####VARIABLES :
Values of Varible Activity consist of data from “Y_train.txt” and “Y_test.txt”
values of Varible Subject consist of data from “subject_train.txt” and subject_test.txt"
Values of Varibles Features consist of data from “X_train.txt” and “X_test.txt”
Names of Varibles Features come from “features.txt”
levels of Varible Activity come from “activity_labels.txt”
Activity, Subject and Features are used as part of descriptive variable names for data in data frame.

##### 1) Get indexes of columns which contain mean/stdev info

features <- read.table("./UCI HAR Dataset/features.txt", colClasses = c("NULL", "character"))
rawIndx <- sapply(features[[1]], function(x) grepl("mean()", x, fixed = TRUE), USE.NAMES = FALSE) | 
  sapply(features[[1]], function(x) grepl("std()" , x, fixed = TRUE), USE.NAMES = FALSE)

##### 2) Get main headers of mean/stdev info & format out "-" & "()"
features <- t(features[rawIndx,]) # headers
features <- sub("-", "_", features, fixed = TRUE)
features <- sub("-", "_", features, fixed = TRUE)
features <- sub("()", "", features, fixed = TRUE)

##### 3)Get main data of mean/stdev info
rawIndx <- ifelse(rawIndx, "numeric", "NULL") 
trainingSet <- read.table("./UCI HAR Dataset/train/X_train.txt", colClasses = rawIndx)
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt", colClasses = rawIndx)
data <- rbind(trainingSet, testSet)
names(data) <- features

##### 4) Get activity labels column 
trainingLabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                             colClasses = c("NULL", "character")) # factor map
activity <- rbind(trainingLabel, testLabel)
activity <- as.factor(activity[[1]])
levels(activity) <- activityLabels[[1]]

##### 5) Get subjects column
trainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(trainingSubject, testSubject)
subject <- as.factor(subject[[1]])

####STEP3:Merge activity labels with rest of data
data <- cbind("activity" = activity, "subject" = subject, data)

#### STEP4: Create a summarised version of data ,consists averaged values for each acitivty and subject
shortData <- aggregate(data[,-(1:2)], by=list("activity"=data$activity, "subject"=data$subject), mean)
write.table(shortData, file = "tidy_data.txt", row.names = FALSE)

