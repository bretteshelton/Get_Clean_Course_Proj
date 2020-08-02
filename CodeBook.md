---
title: "CodeBook.md"
author: "Brett E Shelton"
date: "8/2/2020"
output: html_document
---

The data from which this script "run_analysis.R" uses is from a wearable computing project.

A full description of the original data and labels is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the original data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


The following explains the original data labels and values:

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

## 1. Merging the training and test sets

Merges the training and the test sets to create one data set.
First, reading the "test" and "train" data are read into these files
testRaw  from the X_test.txt file
testLabels from the y_test.txt file
testSubjects from the test_subjects.txt file
trainRaw (same as test file data but train in the filenames)
trainLabels 
trainSubjects 

***Note here that I added correct column names and row names prior to the merge, see below
Second I merged the test and train dataframes using cbind into dataframes:
combineTestAll
combineTrainAll

Third I merged the test and train data using rbind into the dataframe:
allData

Adding the correct column names to the datasets:
The variable names were also read from the "features.txt" files for test and train, and
the vector of the "dataNames"" was put into column names for the two files.
I also took the participant names and added the column names, and
took the training labels and added it to the column name. This was done prior 
to the merging of the test and train data noted above. So, it was a bit out of order from the tasks that were given to us for the assignment, but to me, it made more sense to do it in this order described here.

## 2. Extracting mean and standard deviation for each measurement

Extracts only the measurements on the mean and standard deviation for each measurement.
So, I took a dataframe meanData and stdData in two separate grep searches which
gave us a smaller dataset with only the means and standard deviation variables. The
new dataframe is named "mean_std_data"

## 3. Use descriptive activity names

Uses descriptive activity names to name the activities in the data set, here I just
used a "sub" command to rename the activities into their respective character-based
descriptors as provided in the "activity_labels.txt" file

## 4. Labels with descriptive variable names

Appropriately labels the data set with descriptive variable names. Here I used additional
sub functions to remove the "()" that appeared in many filenames. In addition, the "t" and
"f" characters representing time and frequency were not descriptive, so I replaced them
with "time" and "frequency" at the outset of each variable.
I also replaced all remaining "-" with "_" as was suggested by naming convention lessons.
The remaining variable names I think were pretty descriptive, and needed to be present to distinguish their individual value. The followed pretty closely the capitalization and underscore convention.

## 5. Creating indepdendent dataset with average of @ variable for activity and subject

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Here I use the arrange, group_by and summarize_all (by mean) to complete the new dataset.
mean_std_data <- arrange(mean_std_data, participant_id)
mean_std_data <- group_by(mean_std_data, participant_id, training_label)
mean_std_data_final <- summarize_all(mean_std_data, mean)

Then finally we write out the final tibble to the text file:
write.table(mean_std_data_final,"mean_std_data_final.txt")

Remember to view the output file in R, use the following:
data <- read.table("mean_std_data_final.txt", header = TRUE);
View(data)
