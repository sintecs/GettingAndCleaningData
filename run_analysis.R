## Getting and Cleaning Data
## This will take the URL provided in the assignment and download the zip file.
## It then loads and merges the two datasets, Train and Test into one dataset

install.packages("dplyr")
library(plyr)
library(dplyr)

## URL of the dataset
sourceDataURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

## File names for test data, train data and labels
fileList <- c('UCI HAR Dataset/test/subject_test.txt', 'UCI HAR Dataset/test/X_test.txt', 'UCI HAR Dataset/test/y_test.txt')
fileList <- append(fileList, c('UCI HAR Dataset/train/subject_train.txt', 'UCI HAR Dataset/train/X_train.txt', 'UCI HAR Dataset/train/y_train.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/activity_labels.txt', 'UCI HAR Dataset/features.txt'))


## Temporary File for storing the downloaded zip then extract the files we want into R
temp <- tempfile()
download.file(sourceDataURL, temp, method = "libcurl")
testSubjects   <- read.table(unz(temp, fileList[1]))
testX          <- read.table(unz(temp, fileList[2]))
testY          <- read.table(unz(temp, fileList[3]))
trainSubjects  <- read.table(unz(temp, fileList[4]))
trainX         <- read.table(unz(temp, fileList[5]))
trainY         <- read.table(unz(temp, fileList[6]))
acivities      <- read.table(unz(temp, fileList[7]))
features       <- read.table(unz(temp, fileList[8]))
unlink(temp)

## Merge testSubjects and trainSubjects into one vector, give descriptive column name
Subjects             <- rbind(testSubjects, trainSubjects)
SubjectsX            <- rbind(testX, trainX)
SubjectsY            <- rbind(testY, trainY)

colnames(Subjects)   <- "Subject"
colnames(SubjectsY)  <- "Activity"

## Rename columns based on features.txt
colnames(SubjectsX) <- features[, 2]

## Make one big data frame
SubjectsFull         <- cbind(Subjects, SubjectsY, SubjectsX)




