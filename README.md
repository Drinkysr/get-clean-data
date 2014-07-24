ReadMe for run_analysis
==============

Created in fulfillment of the Course Project for Getting and Cleaning Data course on Coursera, July 2014.

The objective of this assignment is to demonstrate the ability to collect, clean and process data in order to prepare it for downstream analysis. The data for this assignment comes from the UCI Machine Learning Repository - Human Activity
Recognition Using Smartphones Data Set.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


Researchers conducted an experiment wherein 30 subjects each performed 6 controlled activities while data was collected from the accelereometers and gryoscopes of a Samsung smartphone worn at the waist.

From the UCI Website description:
"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain." 

The purpose of this assignment was to "create one R script called run_analysis.R that does the following: 
1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement. 
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names. 
5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject."

Script description:
The script "run_analysis.R" in this repo first creates a folder named "data" in the user's working directory if one does not already exist.Then the .zip archive is downloaded from the url:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The archive is named "UCIData" and loaded in the the working directory. From there it is unzipped into a folder called "UCI HAR Dataset".This folder contains sub-directories for the test and training sets, as well as a README file, and a file containing the names of the feature variables ("features.txt"). Another file explained the activity labels (1=WALKING, etc.).Each of the subfolders contains 3 text files, one for subject ids (beginning with "subject"), one for activity indices (beginning with "y" and one for the actual measurement data (beginning with "X"). The Inertial Signals folder contains a large array of data which is not pertinent to this project.

First, the "features.txt" file was read into a variable called "featurenames" using read.table. Then, ach of the pertinent text files is read, using read_table, into a variable.Training and test sets were constructed using cbind. For example, for the training set, the following command was used: cbind(trainsubjects,trainactivities,traindata).
Once the training and test sets were constructed they were combined using rbind. This is appropriate because the 2 sets have identical column headings and contain samples on independent subjects. This accomplishes objective 1.

The script the attaches column names through the "names" attribute. The "id" and "subject" columns are named directly, while the other 561 names are obtained from column 2 of the featurenames table.

Next, variable selection was performed. A decision was made to only select those features with "-mean()" or "-std()" in their name. This was done because the other variables which mention mean, such as "GravityMean" are constructed from the angle measurement, and were therefore felt to represent a value calculation rather than a measurement. Since objective 2 states "only the measurements on the mean and standard deviation for each measurement" - the other variables were felt to be inappropriate. This accomplishes objective 2.

Next the data frame (at this point called "df.sub") is split by subject id and activity using the "split" function and treating id and subject indices as factors. This creates a 180 element list of data frames, one for each subject/activity combination. The lapply function is then used to appl the colMeans function to the list. The output is a 180-element list containing the means of the columns for each subject/activity combination (called "splitmeans").

The final step in collecting the data is to collapse the list into a data frame. This is done by calling the data.frame function on the matrix which results from applying do.call(rbind) to the splitmeans list. This data frame is called "df.means". This accomplishes objective 5.

The activity indices were changed from a numeric vector into a factor vector using "factor" and the levels were changed to the English-language activity descriptions using the "levels" attribute. This accomplishes objective 3.

Finally, variable names were trimmed and changed so that the correponded to a naming system as described in the Codebook. To do this, grep and gsub were used to eliminate unnecessary characters, expand "f" to "freq", expand "t" to "time", capitalize "mean" and "std" to conform with camel caps format in the final varialbe name and to remove redundant uses of "Body" in some names. This accomplishes objective 4.

The final tidy data frame was named "tidydata".










