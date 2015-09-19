---
title: "Readme"
author: "Sumit Bhagchandani"
date: "September 18, 2015"
output: html_document
---

This document describes how run_analysis.R script works

More details are given in the CodeBook.md file.

- First set the working directory
- Check if file Datasets.zip exists in the directory, if not download the file from the URL as specified.
- Unzip the downloaded file into a seperate directory called Dataset
- Set the working directory to the new directory Dataset/UCI HAR Dataset
- Read all the appropriate files into data frames using read.table command
- Start merging test/train data frames
- Change some columns
- Creating final merged data frame from subject / activity / features data frames
- Extract means/std columns along with subject and activity
- Replace activity numbers with activity description in the data set
- Make column names lower case and more meaningful
- Finally create a new tidy data frame  that has the mean of all columns grouping by activity and subject columns.
- Exporting this final tidy data frame into a text file
- Finally setting the working directory to the old working directory

Script execution

- Open R Studio
- File-Open file run_analysis.R
- Select Run from Source
- An output file should be generated in the working directory (./Dataset/UCI HAR Dataset)
