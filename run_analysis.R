## This is the run_analysis.R file for a course assignment project, authored by 
## Brett E. Shelton
## "Getting and Cleaning Data" Offereed by Johns Hopkins as a certificate through
## coursera.
## This R script called run_analysis.R does the following.
#     1. Merges the training and the test sets to create one data set.
#     2. Extracts only the measurements on the mean and standard deviation for 
#         each measurement.
#     3. Uses descriptive activity names to name the activities in the data set
#     4. Appropriately labels the data set with descriptive variable names.
#     5. From the data set in step 4, creates a second, independent tidy data 
#         set with the average of each variable for each activity and each 
#         subject.

# Initial librarys
library(dplyr); 

#----------------------------------------------------------------------------
# Reading the data from the source. 
# You will want to retrieve the dataset from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# and extract the files into a local folder. I have placed it into a folder in the
# current working directory UCI_HAR_Dataset. The files to be read are in subfolders
# "test" and "train".
# 
# downloads the zip file from the archive location and unzips it into the 
# current working directory
temp <- tempfile()  
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp)

#-----------------------------------------------------------------------------
## reads the corresponding data files into data frames, keeping
## character strings and numerical data as non-factors
## note that nothing in the "Inertial Signals" folders were required, and thus
## were not read in, see 
## https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
testRaw <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, stringsAsFactors = FALSE)
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, stringsAsFactors = FALSE)
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, stringsAsFactors = FALSE)

trainRaw <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, stringsAsFactors = FALSE)
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, stringsAsFactors = FALSE)
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, stringsAsFactors = FALSE)

#-----------------------------------------------------------------------------------
## Merging the test set using cbind
combineTestLabelRaw <- cbind(testLabels,testRaw)
combineTestAll<- cbind(testSubjects,combineTestLabelRaw)

## Merging the training set using cbind
combineTrainLabelRaw <- cbind(trainLabels,trainRaw)
combineTrainAll<- cbind(trainSubjects,combineTrainLabelRaw)

## Merging the training set and the test set using rbind
allData <- rbind(combineTrainAll,combineTestAll)




