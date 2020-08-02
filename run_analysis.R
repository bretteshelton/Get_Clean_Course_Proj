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

## adding the correct column names to the datasets
dataNames <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(trainRaw) <- dataNames[,2]; colnames(testRaw) <- dataNames[,2]
colnames(trainSubjects) <- "participant_id"; colnames(testSubjects) <- "participant_id"
colnames(trainLabels) <- "training_label"; colnames(testLabels) <- "training_label"


#-----------------------------------------------------------------------------------
## Merging the test set using cbind
combineTestLabelRaw <- cbind(testLabels,testRaw)
combineTestAll<- cbind(testSubjects,combineTestLabelRaw)

## Merging the training set using cbind
combineTrainLabelRaw <- cbind(trainLabels,trainRaw)
combineTrainAll<- cbind(trainSubjects,combineTrainLabelRaw)

## Merging the training set and the test set using rbind
allData <- rbind(combineTrainAll,combineTestAll)

#-----------------------------------------------------------------------------------
## Tidying the data
      
      #-----------------------------------------------------------
##    First limit the dataset to only the columns that we want for 
##    measurements on the mean and standard deviation for each measurement.

## This grabs the "mean" data and puts it in a new dataframe, 46 variables
meanData <- allData[,grep("mean",names(allData))]

## This grabs the "std" data and puts it in a new dataframe, 33 variables
stdData <- allData[,grep("std",names(allData))]

## This takes the first 2 columns we added, "participant_id" and "training_label"
## and puts them in a new data frame with the "mean" data and "std" data
## for a dataframe of dim 10299x81
mean_std_data <- cbind("participant_id"=allData$participant_id,
                       "training_label"=allData$training_label,
                       meanData,stdData)

      #-----------------------------------------------------------
##    Then provide appropriate names for the test labels, in effect,
##    substituting the activity character string for the numerical one.
##    The labels are in the file "activity_labels.txt" accompanying the dataset
mean_std_data$training_label <- sub(5,"standing",mean_std_data$training_label)
mean_std_data$training_label <- sub(1,"walking",mean_std_data$training_label)
mean_std_data$training_label <- sub(2,"walking_upstairs",mean_std_data$training_label)
mean_std_data$training_label <- sub(3,"walking_downstairs",mean_std_data$training_label)
mean_std_data$training_label <- sub(4,"sitting",mean_std_data$training_label)
mean_std_data$training_label <- sub(6,"laying",mean_std_data$training_label)


      #-----------------------------------------------------------
##    Then make sure variable names follow proper protocol, so renaming them
##    to be descriptive and meaningful. *** Note that we already started this
##    process when adding column names to the read data prior to merging them.

## Here I just wanted to use some of the features of dplyr
tbl_df(mean_std_data)

## Take out the "()" in each of the variable names
names(mean_std_data) <- gsub("\\(+\\)","",names(mean_std_data))

## The prefix "t" means a time based variable, "f" means a frequency based variable
## Let's replace those indicators with more descriptive names
names(mean_std_data) <- gsub("^t","time_",names(mean_std_data))
names(mean_std_data) <- gsub("^f","frequency_",names(mean_std_data))
## Also replace the remaining "-" dash characters with underscores as per the lesson recommends
names(mean_std_data) <- gsub("-","_",names(mean_std_data))
## Finally make sure the "training_label" gets put back to what we want
mean_std_data <- rename(mean_std_data, training_label = time_raining_label)

      #-----------------------------------------------------------
## Finally we create a second, independent tidy data 
#         set with the average of each variable for each activity and each 
#         subject. I could have piped this, but I like following the incremental
#         checks in the console when building it.

mean_std_data <- arrange(mean_std_data, participant_id)
mean_std_data <- group_by(mean_std_data, participant_id, training_label)
mean_std_data_final <- summarize_all(mean_std_data, mean)


write.table(mean_std_data_final,"mean_std_data_final.txt")


#to view the output file in R, use the following:
# data <- read.table("mean_std_data_final.txt", header = TRUE);
# View(data)







