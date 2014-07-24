###Getting and Cleaning Data programming Assignment
##SJ Rigatti June 2014

#Check to see if a "data" directory exists, create one if not
if(!file.exists("./data")){dir.create("./data")}

#download and unzip the .zip archive from the web site
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="UCIData.zip")
unzip("UCIData.zip",exdir="./data")



##read the features file which contains the feature (variable) names
featurenames<-read.table("./data/UCI HAR Dataset/features.txt",sep=" ")

##read in the training data, firs the list of subjects, then the activity indices
## then the actual measurement data
trainsubjects<-read.table("./data/UCI HAR Dataset//train/subject_train.txt",sep=" ")
trainactivities<-read.table("./data/UCI HAR Dataset/train/y_train.txt",sep=" ")
traindata<-read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE, strip.white=TRUE)

## do the same for the test data
testsubjects<-read.table("./data/UCI HAR Dataset/test/subject_test.txt",sep=" ")
testactivities<-read.table("./data/UCI HAR Dataset/test/y_test.txt",sep=" ")
testdata<-read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE, strip.white=TRUE)

## bind the subject id's, activitiy indices and rest of the data
## for training and test sets
traindf<-cbind(trainsubjects,trainactivities,traindata)
testdf<-cbind(testsubjects,testactivities,testdata)

## combine the training and test sets
df<-rbind(traindf,testdf)

## name the id and activity variables directly then retrieve other
##  variable names from the 2nd column of the feature names data
varnames<-c("id","activity",as.character(featurenames[,2]))

## append these names to the data frame
names(df)<-varnames

## varaible names containting "-std()" or "-mean()" are selected 
##  note that this eliminates the gravityMean and other similar variables
## which are part of the "angle" measurements, this is intentional - see README
meansd<-c(1,2,sort(c(grep("-std()",varnames, fixed=TRUE),grep("-mean()",varnames, fixed=TRUE))))

## subset the dataframe to select only the mean and std variables
df.sub<-df[,meansd]


# split the data frame by id and activity variables
split.df<-split(df.sub,f=list(as.factor(df.sub$id),as.factor(df.sub$activity)))

# apply the columnMeans function to get the mean of each variable by
#  id and activity
splitmeans<-lapply(split.df,FUN=colMeans)

# collapse the list from lapply and create a data frame of the results
df.means<-data.frame(do.call("rbind",splitmeans))

# create a factor and re-name the levels for the activity variable
df.means[,2]<-factor(df.means[,2])
levels(df.means[,2])<-c("walking","upstairs","downstairs","sitting","standing","laying")

# clean up the variable names, using camelCaps, "time" or "freq" at the beginning and 
# X/Y/Z at the end, eliminate parenthesis, periods and hyphens, eliminate duplication of 
#  "Body"
y<-names(df.means)
y<-gsub("std","Std",y)
y<-gsub("mean","Mean",y)
y<-gsub("^t","time",y)
y<-gsub("^f","freq",y)
y<-gsub("\\.","",y)
y<-gsub("\\()","",y)
y<-gsub("-*","",y)
y<-gsub("BodyBody","Body",y)
names(df.means)<-y

tidydata<-df.means
rm(df.means)

## tidydata file is now ready for downstream analysis
