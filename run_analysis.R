##Download file, add to "data" folder, unzip
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
UCIfiles<-list.files(path_rf, recursive=TRUE)
##Examine file names by printing "UCIfiles"
##Read data from files and create variables for test and training sets
##for Activity and Subject files
## Read subject files
dataSubjectTrain <- tbl_df(read.table(file.path(path_rf, "train", "subject_train.txt")))
dataSubjectTest  <- tbl_df(read.table(file.path(path_rf, "test" , "subject_test.txt" )))

## Read activity files
dataActivityTrain <- tbl_df(read.table(file.path(path_rf, "train", "Y_train.txt")))
dataActivityTest  <- tbl_df(read.table(file.path(path_rf, "test" , "Y_test.txt" )))
##Read data files.
dataTrain <- tbl_df(read.table(file.path(path_rf, "train", "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(path_rf, "test" , "X_test.txt" )))

##Can examine properties of each dataset by calling str() on these 6 variables
##All data sets should be data frames
##Activity and Subject test sets with 2947 observations of 1 variable
##Activity and Subject training sets with 7352 observations of 1 variable

## Step 1 Merging the Data
##for both Activity and Subject files this will merge the training and the test sets 
##by row binding and rename variables "subject" and "activityNum"
alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")

##combine the DATA training and test files
dataTable <- rbind(dataTrain, dataTest)

##Read in Features data and name variables according to feature 
##e.g.(V1 = "tBodyAcc-mean()-X")
dataFeatures <- tbl_df(read.table(file.path(path_rf, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

##column names for activity labels
activityLabels<- tbl_df(read.table(file.path(path_rf, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

## Merge columns
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
dataTable <- cbind(alldataSubjAct, dataTable)

##Step2 Extract only measurements for mean and standard deviation
## Reading "features.txt" and extracting only the mean and standard deviation
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,
                            value=TRUE) #var name

## Taking only measurements for the mean and standard deviation 
## and add "subject","activityNum"

dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd)

##Step3 Use Descriptive Activity Names to name activities in data set
##enter name of activity into dataTable
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

##Label Data set with Descriptive Variable Names
##check variable names before
head(str(dataTable),2)
##Use gsub to rename variables
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))
##check variable names after
head(str(dataTable),6)

##Step 5 Write to new Text File for Tidy Data
write.table(dataTable, "TidyData.txt", row.name=FALSE)