## Getting and Cleaning Data
## This will take the URL provided in the assignment and download the zip file.
## It then loads and merges the two datasets, Train and Test into one dataset

##install.packages("dplyr")
##library(plyr)
##library(dplyr)

## URL of the dataset
sourceDataURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

## File names for test data, train data and labels
fileList <- c('UCI HAR Dataset/test/subject_test.txt')
fileList <- append(fileList, c('UCI HAR Dataset/test/X_test.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/test/y_test.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/train/subject_train.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/train/X_train.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/train/y_train.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/activity_labels.txt'))
fileList <- append(fileList, c('UCI HAR Dataset/features.txt'))

## Temporary File for storing the downloaded zip then extract the files we want into R
temp <- tempfile()
download.file(sourceDataURL, temp, method = "libcurl")
test.subjects   <- read.table(unz(temp, fileList[1]))
test.x          <- read.table(unz(temp, fileList[2]))
test.y          <- read.table(unz(temp, fileList[3]))
train.subjects  <- read.table(unz(temp, fileList[4]))
train.x         <- read.table(unz(temp, fileList[5]))
train.y         <- read.table(unz(temp, fileList[6]))
acivities       <- read.table(unz(temp, fileList[7]))
features        <- read.table(unz(temp, fileList[8]))
unlink(temp)

## Merge testSubjects and trainSubjects into one vector, give descriptive column name
subjects              <- rbind(test.subjects, train.subjects)
subjects.x            <- rbind(test.x, train.x)
subjects.y            <- rbind(test.y, train.y)

## Rename Columns in subjects, subjects.x and subjects.y
colnames(subjects)    <- "Subject"
colnames(subjects.y)  <- "Activity"
colnames(subjects.x) <- features[, 2]

## Loop through columns in features and keep only the columns we want
## Rename columns based on features.txt column names

x <- 0
trim.subjects.x <- data.frame()
for (i in features[, 2])
{
   if (length(grep('mean()', i) > 0))
   {
       ##trim.subjects.x <- cbind(trim.subjects.x, subjects.x[, x])
       if (length(trim.subjects.x) == 0)
       {
           trim.subjects.x <- data.frame(subjects.x[, x])
           print("make new dataframe mean")
       }
       else
       {
           trim.subjects.x[[i]] <- subjects.x[, x]
           print("add to dataframe mean")
       }
   }
   else if (length(grep('std()', i) > 0))
   {
       ##trim.subjects.x <- cbind(trim.subjects.x, subjects.x[, x])
       if (length(trim.subjects.x) == 0)
       {
           trim.subjects.x <- data.frame(subjects.x[, x])
           print("make new dataframe std")
       }
       else
       {
           trim.subjects.x[[i]] <- subjects.x[, x]
           print("add to dataframe std")
       }
   }

   x <- x + 1
}


## Make one big data frame
subjects.full         <- cbind(subjects, subjects.y, subjects.x)




