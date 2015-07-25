## Getting and Cleaning Data
## This will take the URL provided in the assignment and download the zip file.
## It then loads and merges the two datasets, Train and Test into one dataset

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
activities      <- read.table(unz(temp, fileList[7]))
features        <- read.table(unz(temp, fileList[8]))
unlink(temp)

## Merge testSubjects and trainSubjects into one vector, give descriptive column name
subjects              <- rbind(test.subjects, train.subjects)
subjects.x            <- rbind(test.x, train.x)
subjects.y            <- rbind(test.y, train.y)

## Rename Columns in subjects, subjects.x, subjects.y and activities
colnames(subjects)    <- 'Subject'
colnames(subjects.y)  <- 'ActivityID'
colnames(subjects.x)  <- features[, 2]
colnames(activities)  <- c('ActivityID', 'Activity')

## Get the columns with mean() or std() in their name and make one vector of them
mean.cols             <- grep('mean\\(\\)', colnames(subjects.x), ignore.case = TRUE)
std.cols              <- grep('Std\\(\\)', colnames(subjects.x), ignore.case = TRUE)
mean.std.cols         <- c(mean.cols, std.cols)

## Subset the data with the mean.std.cols vector
trim.subjects.x   <- subjects.x[, mean.std.cols]

## Name columns based on their column names from subjects.x
colnames(trim.subjects.x) <- colnames(subjects.x)[mean.std.cols]

## Merge subjects.y and activities by ActivityID, make sure to not sort the data
## or we will have the wrong activities with the wrong subjects!!!  
## To do this we add an id column temporarily
subjects.y$id         <- 1:nrow(subjects.y)
tidy.subjects.y       <- merge(subjects.y, activities, by = 'ActivityID', sort = FALSE)
tidy.subjects.y       <- tidy.subjects.y[order(tidy.subjects.y$id), ]
tidy.subjects.y       <- data.frame(tidy.subjects.y[, 3])
colnames(tidy.subjects.y)[1] <- 'Activity'

## Make one big data frame
subjects.full         <- cbind(subjects, tidy.subjects.y, trim.subjects.x)

## Get the average of each datapoint for each subject and activity pair
grouping              <- list(
                               Subject = subjects.full$Subject
                              ,Activity = subjects.full$Activity
                             )
column.count          <- length(colnames(subjects.full))
tidy.full             <- aggregate(subjects.full[, 3:column.count], grouping, mean, na.rm = TRUE)

## Give tidy column names
old.column.names      <- colnames(tidy.full)[3:length(colnames(tidy.full))]
prefix.name           <- 'Average by Subject and Activity'
new.column.names      <- paste(rep(prefix.name, length(old.column.names)), old.column.names)
colnames(tidy.full)[3:column.count] <- new.column.names

write.table(tidy.full, 'tidydata.txt', row.name = FALSE)