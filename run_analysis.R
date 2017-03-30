
#Getting and Cleaning Data Course Projectless 
#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
#The goal is to prepare tidy data that can be used for later analysis. 
#You will be graded by your peers on a series of yes/no questions related to the project. 
#You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository 
#with your script for performing the analysis, and 3) a code book that describes the variables, the data, 
#and any transformations or work that you performed to clean up the data called CodeBook.md. 
#You should also include a README.md in the repo with your scripts. 
#This repo explains how all of the scripts work and how they are connected.


# set working directory where the UCI HAR Dataset is downloaded
setwd("C:/Users/anita/Desktop/DataScience/ProgrammingAssignment4/UCI HAR Dataset")

#Read activity label file
activity_labels <- read.table("activity_labels.txt")

#Read feature.txt fil'e
featureNames <- read.table("features.txt")

# read test data files
feature_test <- read.table("./test/X_test.txt")
activity_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

#read training data files
feature_train <- read.table("./train/X_train.txt")
activity_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

#merge training and test data 
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
feature <- rbind(feature_train, feature_test)

# adding header column
colnames(feature) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"

# complete merge data
CompleteMergeData <- cbind(feature,activity,subject)

#Extracts only the measurements on the mean and standard deviation for each measurement.
meanStdData <- grep(".*Mean.*|.*Std.*", names(CompleteMergeData), ignore.case = TRUE)
x <- c(meanStdData, 562, 563)
dim(CompleteMergeData)

dt <- CompleteMergeData[, x]
dim(dt)
#Uses descriptive activity names to name the activities in the data set
dt$Activity <- as.character(dt$Activity)
for (i in 1:6){
        dt$Activity[dt$Activity == i] <- as.character(activity_labels[i,2])
}

dt$Activity <- as.factor(dt$Activity)
#Appropriately labels the data set with descriptive variable names.
names(dt)

dt$Subject <- as.factor(dt$Subject)
dt <- data.table(dt)

# write tidy dataset
tidyData <- aggregate(. ~Subject + Activity, dt, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidy_data_output.txt", row.names = FALSE)
