### Getting and Cleaning Data 
### Course Project 1
### Create Tidy data from a raw dataset

# Download & unzip raw data file
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataURL, "UCI HAR Dataset.zip", quiet = TRUE)
unzip("UCI HAR Dataset.zip")

# Get indexes of columns which contain mean/stdev info
features <- read.table("./UCI HAR Dataset/features.txt", colClasses = c("NULL", "character"))
rawIndx <- sapply(features[[1]], function(x) grepl("mean()", x, fixed = TRUE), USE.NAMES = FALSE) | 
  sapply(features[[1]], function(x) grepl("std()" , x, fixed = TRUE), USE.NAMES = FALSE)

# Get main headers of mean/stdev info & format out "-" & "()"
features <- t(features[rawIndx,]) # headers
features <- sub("-", "_", features, fixed = TRUE)
features <- sub("-", "_", features, fixed = TRUE)
features <- sub("()", "", features, fixed = TRUE)

# Get main data of mean/stdev info
rawIndx <- ifelse(rawIndx, "numeric", "NULL") 
trainingSet <- read.table("./UCI HAR Dataset/train/X_train.txt", colClasses = rawIndx)
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt", colClasses = rawIndx)
data <- rbind(trainingSet, testSet)
names(data) <- features

# Get activity labels column 
trainingLabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                             colClasses = c("NULL", "character")) # factor map
activity <- rbind(trainingLabel, testLabel)
activity <- as.factor(activity[[1]])
levels(activity) <- activityLabels[[1]]

# Get subjects column
trainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(trainingSubject, testSubject)
subject <- as.factor(subject[[1]])

# Merge activity labels with rest of data
data <- cbind("activity" = activity, "subject" = subject, data)


# Create a summarised version of data for coursera submission
# consists averaged values for each acitivty and subject
shortData <- aggregate(data[,-(1:2)], by=list("activity"=data$activity, "subject"=data$subject), mean)
write.table(shortData, file = "tidy_data.txt", row.names = FALSE)