  ---
title: "TidyData.md"
author: "Sumit Bhagchandani"
date: "September 17, 2015"
output: html_document
---

This document describes run_analysis.R file. The code has detailed comment's at every major step as highlighted :

- Setup and checking for existing files ,directory etc. (line 8).
- Reading essential files (line 30).
- Merging the training and the test sets to create one data set (line 46).
- Extracts only the measurements on the mean and standard deviation for each measurement (line 65).
- setting descriptive activity names to name the activities in the data set (line 75).
- Appropriately labelelling the data set with descriptive variable names (line 79).
- creating a second, independent tidy data set with the average of each variable for each activity and   each subject (line 90).
- Exporting data set into a text file (line 97).

### Setup and checking for existing files/directory etc.

This section of code sets up working directory, checks for the dataset.zip file if already downloaded, unzip the file into a new directory and finally updates the working directory to the newly created one. Some functions used are getwd()/setwd() (getting/setting work directory), download.file() (downloads the file and also creates the directory if not exists), unzip() (unzips the file and creates a new directory where it places the unzipped data), file.path() (to concatenate and create a new file path) etc. Variables used are wrkdir-- current working directory, wd -- variable to have new path value, fileurl to store the url where the actual data is downloaded from.

### Reading essential files.

This section of code uses read.table() function for reading all the essential files and creating 8 data frames. This function reads the file present in the changed working directory for example

- read.table("test/y_test.txt",header=FALSE)
- read.table("test/subject_test.txt",header=FALSE)
- read.table("train/X_train.txt",header=FALSE)

Variables used are all data frames as described below

dfacttest - This data frame contains all the y_test.txt data also called activity test data.
dfacttrain - This data frame contains all the y_train.txt data also called activity train data.

dfsubjtest - This data frame contains all the subject_test.txt data also called subject test data.
dfsubjtrain - This data frame contains all the subject_train.txt data also called subject train data.

dffeattest - This data frame contains all the X_test.txt data also called features test data.
dffeattrain - This data frame contains all the X_train.txt data also called features train data.

dffeatnames - This data frame contains features name from the features.txt data.
dfactlabel - This data frame contains activity description data from the activity_labels.txt data.


### Merging the training and the test sets to create one data set
Three categories of new data frames are created by merging data(using rbind) from using the activity, features & subject train/test data frames created in the previous steps and creates 3 distinct new data frames. This step also changes colnames for the 3 distinct df created. Finally a final data frame is created by using cbind function first to bind activity and subject and creating a new df and then combining the 4th df to the existing features data frame to get the final df.The functions used are rbind(), colnames(), cbind(). 

Functions used are 

- rbind()--concatenates rows from one df to another df.

    - ex: dfact <- rbind(dfacttrain,dfacttest)
    
- colnames--changes column names in a df.

    - ex: colnames(dfsubj) <- "subject"
    
- cbind--concatenates columns form one df to another df.

    - ex: dffsa <- cbind(dffeat,dfsubjact)

Variables used are 

dfact - A data frame that holds merged records of activity (test/train) data from the earlier data frames dfacttrain & dfacttest.
dfsubj - A data frame that holds merged records of subject (test/train) data from the earlier data frames dfsubjtrain & dfsubjtest.
dffeat - This data frame holds merged data records of features (test/train) data from the earlier data frames dffeattrain & dffeattest.

dfsubjact - This data frame contains the merged columns-data of  activity data and subject data.
dffsa - This data frame is the final data frame which contains the merged record of dfsubjact (subject & activity) & dffeat (features) data.

### Extracts only the measurements on the mean and standard deviation for each measurement
This step creates a character vector that contain's of only columns that have mean and std calculations. This character vector then gets appended with activity and subject names. The final df that was created in the previous step is now used in a subset function for extracting only column data that are mentioned in the character vector. Functions used are grep() and subset.

- grep()--functions is used for finding patterns of characters etc.

    - ex: dfsubfeat <- dffeatnames$V2[grep("mean\\(\\)|std\\(\\)",dffeatnames$V2)]
    
- subset()--function is used for extracting subset of data from a data frame by giving any conditions,   selected columns etc.

    - ex: dffsa <- subset(dffsa,select = dfsubfeat)

Variables used are 

dfsubfeat - A character vector consisting of only columns that have mean and std in the column heading. This same character vector also contains subject and activity column data as well. Once the subset is applied dffsa data frame is hte final data frame with all the required mean/std columns.


### setting descriptive activity names to name the activities in the data set
This step replaces the activity numbers with activity descriptions in the final data set. The function used is match().

- match()--this function returns a vector of the positions of matches of its first argumetn in the 
  second
  
    - ex: dffsa$activity <- dfactlabel[match(dffsa$activity,dfactlabel$V1),2]

### Appropriately labelelling the data set with descriptive variable names
This step replaces few characters on all the features column names to make it more meaningful. In this step we are using the gsub function which finds the name/character and replaces with the given name/charcter.

- gsub()--pattern matching and replacement

    - ex: colnames(dffsa) <- gsub("\\(\\)","",names(dffsa))
    - ex: colnames(dffsa) <- gsub("^t","time",names(dffsa))
    - ex: colnames(dffsa) <- gsub("^f","frequency",names(dffsa))
    - ex: colnames(dffsa) <- gsub("Acc","accelerometer",names(dffsa))


### Creating a second, independent tidy data set with the average of each variable for each activity and   each subject
This step we create tidy data by getting the average of all variables by subject and activity columns. The functions groupby() and %>% used is from the dplyr package 

- group_by()--generating summary statistics grouping by different columns.
- %>%--using special grammar to have all the operations in one statement.
  - ex: tidydf <- dffsa %>% group_by(subject,activity) %>% summarise_each(funs(mean))

Variable tidydf is a data frame containing mean of each column grouping by subject and activity columns.

The tidy data set now looks like as follows

```r
head(tidydf[,1:5])
```

```
##   subject           activity timebodyaccelerometer-mean-X
## 1       1             LAYING                    0.2215982
## 2       1            SITTING                    0.2612376
## 3       1           STANDING                    0.2789176
## 4       1            WALKING                    0.2773308
## 5       1 WALKING_DOWNSTAIRS                    0.2891883
## 6       1   WALKING_UPSTAIRS                    0.2554617
##   timebodyaccelerometer-mean-Y timebodyaccelerometer-mean-Z
## 1                 -0.040513953                   -0.1132036
## 2                 -0.001308288                   -0.1045442
## 3                 -0.016137590                   -0.1106018
## 4                 -0.017383819                   -0.1111481
## 5                 -0.009918505                   -0.1075662
## 6                 -0.023953149                   -0.0973020
```

### Exporting data set into a text file
The last step is to expor the tidydf to a text file. The function used is write.table()

- write.table()--exports the object to file.

    - ex: write.table(tidydf,file="tidydata.txt",row.name=FALSE)
    
    
