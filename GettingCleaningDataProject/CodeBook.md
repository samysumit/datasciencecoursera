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
    
Below you will find all the information per column level


```r
codebook(tidydataset)
```

```
## ===========================================================================
## 
##    tidydf.subject
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: integer
##    Measurement: interval
## 
##             Min:   1.000
##             Max:  30.000
##            Mean:  15.500
##        Std.Dev.:   8.655
##        Skewness:   0.000
##        Kurtosis:  -1.203
## 
## ===========================================================================
## 
##    tidydf.activity
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: integer
##    Measurement: nominal
## 
##           Values and labels    N    Percent 
##                                             
##    1   'LAYING'               30   16.7 16.7
##    2   'SITTING'              30   16.7 16.7
##    3   'STANDING'             30   16.7 16.7
##    4   'WALKING'              30   16.7 16.7
##    5   'WALKING_DOWNSTAIRS'   30   16.7 16.7
##    6   'WALKING_UPSTAIRS'     30   16.7 16.7
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometer.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:   0.222
##             Max:   0.301
##            Mean:   0.274
##        Std.Dev.:   0.012
##        Skewness:  -1.055
##        Kurtosis:   2.329
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometer.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.041
##             Max:  -0.001
##            Mean:  -0.018
##        Std.Dev.:   0.006
##        Skewness:  -0.537
##        Kurtosis:   1.612
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometer.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.153
##             Max:  -0.075
##            Mean:  -0.109
##        Std.Dev.:   0.010
##        Skewness:  -1.115
##        Kurtosis:   4.910
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometer.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.996
##             Max:   0.627
##            Mean:  -0.558
##        Std.Dev.:   0.450
##        Skewness:   0.438
##        Kurtosis:  -1.216
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometer.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.990
##             Max:   0.617
##            Mean:  -0.460
##        Std.Dev.:   0.495
##        Skewness:   0.235
##        Kurtosis:  -1.586
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometer.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.988
##             Max:   0.609
##            Mean:  -0.576
##        Std.Dev.:   0.394
##        Skewness:   0.451
##        Kurtosis:  -1.026
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometer.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.680
##             Max:   0.975
##            Mean:   0.697
##        Std.Dev.:   0.486
##        Skewness:  -1.811
##        Kurtosis:   1.452
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometer.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.480
##             Max:   0.957
##            Mean:  -0.016
##        Std.Dev.:   0.344
##        Skewness:   1.427
##        Kurtosis:   1.051
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometer.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.495
##             Max:   0.958
##            Mean:   0.074
##        Std.Dev.:   0.288
##        Skewness:   1.145
##        Kurtosis:   1.208
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometer.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.997
##             Max:  -0.830
##            Mean:  -0.964
##        Std.Dev.:   0.025
##        Skewness:   1.669
##        Kurtosis:   5.051
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometer.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:  -0.644
##            Mean:  -0.952
##        Std.Dev.:   0.033
##        Skewness:   4.817
##        Kurtosis:  42.501
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometer.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.991
##             Max:  -0.610
##            Mean:  -0.936
##        Std.Dev.:   0.040
##        Skewness:   3.248
##        Kurtosis:  22.288
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerk.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  0.043
##             Max:  0.130
##            Mean:  0.079
##        Std.Dev.:  0.013
##        Skewness:  0.821
##        Kurtosis:  2.560
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerk.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.039
##             Max:   0.057
##            Mean:   0.008
##        Std.Dev.:   0.014
##        Skewness:  -0.192
##        Kurtosis:   1.606
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerk.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.067
##             Max:   0.038
##            Mean:  -0.005
##        Std.Dev.:   0.013
##        Skewness:  -0.835
##        Kurtosis:   3.525
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerk.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.544
##            Mean:  -0.595
##        Std.Dev.:   0.416
##        Skewness:   0.424
##        Kurtosis:  -1.273
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerk.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.990
##             Max:   0.355
##            Mean:  -0.565
##        Std.Dev.:   0.432
##        Skewness:   0.362
##        Kurtosis:  -1.450
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerk.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.993
##             Max:   0.031
##            Mean:  -0.736
##        Std.Dev.:   0.276
##        Skewness:   0.679
##        Kurtosis:  -0.681
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscope.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.206
##             Max:   0.193
##            Mean:  -0.032
##        Std.Dev.:   0.054
##        Skewness:   0.341
##        Kurtosis:   2.391
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscope.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.204
##             Max:   0.027
##            Mean:  -0.074
##        Std.Dev.:   0.035
##        Skewness:  -0.286
##        Kurtosis:   2.070
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscope.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.072
##             Max:   0.179
##            Mean:   0.087
##        Std.Dev.:   0.036
##        Skewness:  -0.781
##        Kurtosis:   3.224
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscope.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:   0.268
##            Mean:  -0.692
##        Std.Dev.:   0.290
##        Skewness:   0.391
##        Kurtosis:  -1.073
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscope.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:   0.477
##            Mean:  -0.653
##        Std.Dev.:   0.351
##        Skewness:   0.731
##        Kurtosis:  -0.458
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscope.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.986
##             Max:   0.565
##            Mean:  -0.616
##        Std.Dev.:   0.372
##        Skewness:   0.531
##        Kurtosis:  -0.798
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerk.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.157
##             Max:  -0.022
##            Mean:  -0.096
##        Std.Dev.:   0.023
##        Skewness:   0.485
##        Kurtosis:   1.825
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerk.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.077
##             Max:  -0.013
##            Mean:  -0.043
##        Std.Dev.:   0.010
##        Skewness:  -0.814
##        Kurtosis:   2.785
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerk.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.092
##             Max:  -0.007
##            Mean:  -0.055
##        Std.Dev.:   0.012
##        Skewness:   0.258
##        Kurtosis:   1.867
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerk.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.997
##             Max:   0.179
##            Mean:  -0.704
##        Std.Dev.:   0.300
##        Skewness:   0.554
##        Kurtosis:  -0.916
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerk.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.997
##             Max:   0.296
##            Mean:  -0.764
##        Std.Dev.:   0.267
##        Skewness:   1.156
##        Kurtosis:   1.064
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerk.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.193
##            Mean:  -0.710
##        Std.Dev.:   0.304
##        Skewness:   0.649
##        Kurtosis:  -0.652
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometermagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.986
##             Max:   0.645
##            Mean:  -0.497
##        Std.Dev.:   0.472
##        Skewness:   0.231
##        Kurtosis:  -1.587
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometermagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.986
##             Max:   0.428
##            Mean:  -0.544
##        Std.Dev.:   0.430
##        Skewness:   0.464
##        Kurtosis:  -1.194
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometermagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.986
##             Max:   0.645
##            Mean:  -0.497
##        Std.Dev.:   0.472
##        Skewness:   0.231
##        Kurtosis:  -1.587
## 
## ===========================================================================
## 
##    tidydf.timeGravityaccelerometermagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.986
##             Max:   0.428
##            Mean:  -0.544
##        Std.Dev.:   0.430
##        Skewness:   0.464
##        Kurtosis:  -1.194
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerkmagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.993
##             Max:   0.434
##            Mean:  -0.608
##        Std.Dev.:   0.395
##        Skewness:   0.360
##        Kurtosis:  -1.388
## 
## ===========================================================================
## 
##    tidydf.timebodyaccelerometerJerkmagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.451
##            Mean:  -0.584
##        Std.Dev.:   0.422
##        Skewness:   0.425
##        Kurtosis:  -1.319
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopemagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.981
##             Max:   0.418
##            Mean:  -0.565
##        Std.Dev.:   0.397
##        Skewness:   0.313
##        Kurtosis:  -1.422
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopemagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.981
##             Max:   0.300
##            Mean:  -0.630
##        Std.Dev.:   0.336
##        Skewness:   0.482
##        Kurtosis:  -1.027
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerkmagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.997
##             Max:   0.088
##            Mean:  -0.736
##        Std.Dev.:   0.276
##        Skewness:   0.660
##        Kurtosis:  -0.646
## 
## ===========================================================================
## 
##    tidydf.timebodygyroscopeJerkmagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.998
##             Max:   0.250
##            Mean:  -0.755
##        Std.Dev.:   0.265
##        Skewness:   1.016
##        Kurtosis:   0.546
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometer.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.537
##            Mean:  -0.576
##        Std.Dev.:   0.429
##        Skewness:   0.391
##        Kurtosis:  -1.328
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometer.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.989
##             Max:   0.524
##            Mean:  -0.489
##        Std.Dev.:   0.479
##        Skewness:   0.259
##        Kurtosis:  -1.567
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometer.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.989
##             Max:   0.281
##            Mean:  -0.630
##        Std.Dev.:   0.355
##        Skewness:   0.470
##        Kurtosis:  -1.073
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometer.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.997
##             Max:   0.659
##            Mean:  -0.552
##        Std.Dev.:   0.459
##        Skewness:   0.469
##        Kurtosis:  -1.145
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometer.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.991
##             Max:   0.560
##            Mean:  -0.481
##        Std.Dev.:   0.473
##        Skewness:   0.244
##        Kurtosis:  -1.566
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometer.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.987
##             Max:   0.687
##            Mean:  -0.582
##        Std.Dev.:   0.387
##        Skewness:   0.518
##        Kurtosis:  -0.808
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometerJerk.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.474
##            Mean:  -0.614
##        Std.Dev.:   0.397
##        Skewness:   0.444
##        Kurtosis:  -1.222
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometerJerk.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.989
##             Max:   0.277
##            Mean:  -0.588
##        Std.Dev.:   0.407
##        Skewness:   0.347
##        Kurtosis:  -1.478
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometerJerk.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.992
##             Max:   0.158
##            Mean:  -0.714
##        Std.Dev.:   0.296
##        Skewness:   0.670
##        Kurtosis:  -0.677
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometerJerk.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.477
##            Mean:  -0.612
##        Std.Dev.:   0.399
##        Skewness:   0.413
##        Kurtosis:  -1.306
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometerJerk.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.990
##             Max:   0.350
##            Mean:  -0.571
##        Std.Dev.:   0.431
##        Skewness:   0.393
##        Kurtosis:  -1.386
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometerJerk.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.993
##             Max:  -0.006
##            Mean:  -0.756
##        Std.Dev.:   0.256
##        Skewness:   0.709
##        Kurtosis:  -0.606
## 
## ===========================================================================
## 
##    tidydf.frequencybodygyroscope.mean.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.993
##             Max:   0.475
##            Mean:  -0.637
##        Std.Dev.:   0.346
##        Skewness:   0.417
##        Kurtosis:  -1.040
## 
## ===========================================================================
## 
##    tidydf.frequencybodygyroscope.mean.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:   0.329
##            Mean:  -0.677
##        Std.Dev.:   0.331
##        Skewness:   0.738
##        Kurtosis:  -0.471
## 
## ===========================================================================
## 
##    tidydf.frequencybodygyroscope.mean.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.986
##             Max:   0.492
##            Mean:  -0.604
##        Std.Dev.:   0.383
##        Skewness:   0.445
##        Kurtosis:  -1.128
## 
## ===========================================================================
## 
##    tidydf.frequencybodygyroscope.std.X
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.995
##             Max:   0.197
##            Mean:  -0.711
##        Std.Dev.:   0.272
##        Skewness:   0.401
##        Kurtosis:  -1.052
## 
## ===========================================================================
## 
##    tidydf.frequencybodygyroscope.std.Y
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:   0.646
##            Mean:  -0.645
##        Std.Dev.:   0.362
##        Skewness:   0.830
##        Kurtosis:  -0.090
## 
## ===========================================================================
## 
##    tidydf.frequencybodygyroscope.std.Z
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.987
##             Max:   0.522
##            Mean:  -0.658
##        Std.Dev.:   0.335
##        Skewness:   0.631
##        Kurtosis:  -0.449
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometermagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.987
##             Max:   0.587
##            Mean:  -0.537
##        Std.Dev.:   0.450
##        Skewness:   0.464
##        Kurtosis:  -1.197
## 
## ===========================================================================
## 
##    tidydf.frequencybodyaccelerometermagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.988
##             Max:   0.179
##            Mean:  -0.621
##        Std.Dev.:   0.352
##        Skewness:   0.493
##        Kurtosis:  -1.134
## 
## ===========================================================================
## 
##    tidydf.frequencybodybodyaccelerometerJerkmagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:   0.538
##            Mean:  -0.576
##        Std.Dev.:   0.430
##        Skewness:   0.424
##        Kurtosis:  -1.293
## 
## ===========================================================================
## 
##    tidydf.frequencybodybodyaccelerometerJerkmagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.994
##             Max:   0.316
##            Mean:  -0.599
##        Std.Dev.:   0.408
##        Skewness:   0.453
##        Kurtosis:  -1.301
## 
## ===========================================================================
## 
##    tidydf.frequencybodybodygyroscopemagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.987
##             Max:   0.204
##            Mean:  -0.667
##        Std.Dev.:   0.317
##        Skewness:   0.582
##        Kurtosis:  -0.793
## 
## ===========================================================================
## 
##    tidydf.frequencybodybodygyroscopemagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.981
##             Max:   0.237
##            Mean:  -0.672
##        Std.Dev.:   0.292
##        Skewness:   0.493
##        Kurtosis:  -0.955
## 
## ===========================================================================
## 
##    tidydf.frequencybodybodygyroscopeJerkmagnitude.mean
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.998
##             Max:   0.147
##            Mean:  -0.756
##        Std.Dev.:   0.262
##        Skewness:   0.957
##        Kurtosis:   0.276
## 
## ===========================================================================
## 
##    tidydf.frequencybodybodygyroscopeJerkmagnitude.std
## 
## ---------------------------------------------------------------------------
## 
##    Storage mode: double
##    Measurement: interval
## 
##             Min:  -0.998
##             Max:   0.288
##            Mean:  -0.772
##        Std.Dev.:   0.250
##        Skewness:   1.137
##        Kurtosis:   1.122
```


