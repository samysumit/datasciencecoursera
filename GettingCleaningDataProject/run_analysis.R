## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of 
##  each variable for each activity and each subject.

## Setup and checking for existing files ,directory etc.

## getting current working directory
wrkdir <- getwd()
## setting current working directory
setwd(wrkdir)

## checking if dataset.zip file exists in the working directory or not if not then download begins
if(!file.exists("Dataset.zip")) 
  {
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileurl,destfile="Dataset.zip",method="curl")
  }

## unzipping Dataset.zip into a newly created directory called Dataset
unzip(zipfile="Dataset.zip",exdir = "Dataset")

## construcing file path for newly created Dataset and its sub directory
wd <- file.path(wrkdir,"Dataset/UCI HAR Dataset")
## setting working directory with the new path
setwd(wd)

## Reading essential files 
## such as the activities train/test (Y), features train/test (X),
## subject train/text,featuers & activity label files.
dfacttest <- read.table("test/y_test.txt",header=FALSE)
dfacttrain <- read.table("train/y_train.txt",header=FALSE)

dfsubjtest <- read.table("test/subject_test.txt",header=FALSE)
dfsubjtrain <- read.table("train/subject_train.txt",header=FALSE)

dffeattest <- read.table("test/X_test.txt",header=FALSE)
dffeattrain <- read.table("train/X_train.txt",header=FALSE)

dffeatnames <- read.table("features.txt",head=FALSE)

dfactlabel <- read.table("activity_labels.txt",head=FALSE)

## Merging the training and the test sets to create one data set

## merging activity train with test data
dfact <- rbind(dfacttrain,dfacttest)
## merging subject train with test data
dfsubj <- rbind(dfsubjtrain,dfsubjtest)
##merging features train with test data
dffeat <- rbind(dffeattrain,dffeattest)

## changing colnames 
colnames(dfact) <- "activity"
colnames(dfsubj) <- "subject"
colnames(dffeat) <- dffeatnames$V2

## merging columns of subject and activity
dfsubjact <- cbind(dfsubj,dfact)
## merging to create final data set
dffsa <- cbind(dffeat,dfsubjact)

## Extracts only the measurements on the mean and standard deviation for each measurement. 

## extracting all features tha only have mean/std values
dfsubfeat <- dffeatnames$V2[grep("mean\\(\\)|std\\(\\)",dffeatnames$V2)]
dfsubfeat <- as.character(dfsubfeat)
## merging subject/activity data columns as well.
dfsubfeat <- c(dfsubfeat,"subject","activity")
## final merged data set 
dffsa <- subset(dffsa,select = dfsubfeat)

## setting descriptive activity names to name the activities in the data set
## matching activity label with activity description and setting the same.
dffsa$activity <- dfactlabel[match(dffsa$activity,dfactlabel$V1),2]

## Appropriately labelelling the data set with descriptive variable names. 
## setting  up the colnames to be meaningful
colnames(dffsa) <- gsub("\\(\\)","",names(dffsa))
colnames(dffsa) <- gsub("^t","time",names(dffsa))
colnames(dffsa) <- gsub("^f","frequency",names(dffsa))
colnames(dffsa) <- gsub("Acc","accelerometer",names(dffsa))
colnames(dffsa) <- gsub("Gyro","gyroscope",names(dffsa))
colnames(dffsa) <- gsub("Body","body",names(dffsa))
colnames(dffsa) <- gsub("BodyBody","body",names(dffsa)) 
colnames(dffsa) <- gsub("Mag","magnitude",names(dffsa)) 

##creating a second, independent tidy data set with the average of 
##each variable for each activity and each subject.
## calculating mean on each variable in the data set by subject by activity.
library(dplyr)
tidydf <- dffsa %>% group_by(subject,activity) %>% summarise_each(funs(mean))
tidydf <- as.data.frame(tidydf)

##Exporting the tidy data set in the txt file.
write.table(tidydf,file="tidydata.txt",row.name=FALSE)

## setting directory back to the original directory.
setwd(wrkdir)

