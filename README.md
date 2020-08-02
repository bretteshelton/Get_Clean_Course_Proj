Get_Clean_Course_Proj

This is the README.md file for a course assignment project, authored by
Brett E. Shelton
"Getting and Cleaning Data" Offereed by Johns Hopkins as a certificate through
coursera.

For the assignment, we are charged with acquiring data regarding wearable
computing from the UCI HAR data repository.

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. We are charged with creating one R script called run_analysis.R that does the following.
     1. Merges the training and the test sets to create one data set.
     2. Extracts only the measurements on the mean and standard deviation for each measurement.
     3. Uses descriptive activity names to name the activities in the data set
     4. Appropriately labels the data set with descriptive variable names.
     5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---------------------------------------------------------------------------
Reading the Data:
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



***See the CodeBook.md file accompanying this project for descriptions of
the names of the datafiles at each step of data merging and tidying
---------------------------------------------------------------------------
1. Merging the data

Follows the steps of downloading, unzipping, and reading the files
using read.table for each. Specifically it reads the files X_test, y_test
for each of the training and test sets. It uses subject_test to get the 
participant IDs, the features file to get the variables (column names),
and finally the activity_labels file to identify which of the 6 activites
are associated with each row of data.

---------------------------------------------------------------------------
2. Extracting only the measurements on the mean and std deviation for
each measurement.


Follows the steps of searching for "mean" and "std" for the different 
variables, extracts those variable columns, and adds them to a new dataset
that also retains the participant ID and activity columns. I used grep to
search for and extract the data from the column names.

---------------------------------------------------------------------------
3. Using descriptive activity names to name the activities in the data set

Follows the steps to substitute the activity name for its corresponding
numerical code, that is, "walking" was coded as "1", and so on for each
of the 6 activites.

---------------------------------------------------------------------------
4. Appropriately Labeling the data set with descriptive variable names

Follows the steps to substitute out inappropriate characters in the variable
names. I substituted the "t" and "f" for time and frequency, I took out dashes and replaced them with underscores, and took out the meaningless "()" parenthesis in the variable names. Starting with the features.txt file, the variables names didn't need that much tweaking to be both meaningful and follow naming convention, so just a few steps were required.


---------------------------------------------------------------------------
5. Creating a second, tidy data set with average of each variable for each
activity and each subject

Here I used the arrange, group_by and summarize_all (by mean) to complete the new dataset.
I grouped it by participant ID and activity as per the directions. Then used summary_all
to capture all the variables and used the "mean" as the summary function.
I used write.table to write the final, tidy data set to the file "mean_std_data_final.txt"

Because we use write.table to create the output data file, "mean_std_data_final.txt", use the following code in R to read in and view the final table:

data <- read.table("mean_std_data_final.txt", header = TRUE)
View(data)

