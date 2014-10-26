The script "run_analysis.R" does the following 5 things:
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Here is the step-by-step description for this script:
###1.1. Read.This step enable reading of all useful data sets as long as the "UCI HAR Dataset" folder is in your working directory.
wd<-getwd()

varnames<-read.table(paste(wd, "/UCI HAR Dataset/features.txt", sep=""))

subject_train<-read.table(paste(wd, "/UCI HAR Dataset/train/subject_train.txt", sep=""))

label_train<-read.table(paste(wd, "/UCI HAR Dataset/train/y_train.txt", sep=""))

train<-read.table(paste(wd, "/UCI HAR Dataset/train/X_train.txt", sep=""))

subject_test<-read.table(paste(wd, "/UCI HAR Dataset/test/subject_test.txt", sep=""))

label_test<-read.table(paste(wd, "/UCI HAR Dataset/test/y_test.txt", sep=""))

test<-read.table(paste(wd, "/UCI HAR Dataset/test/X_test.txt", sep=""))
###1.2. Merge data sets. This step combines x_files, y_files, sujects and train vs test together.
merge_train<-cbind(subject_train, label_train, train)

merge_test<-cbind(subject_test, label_test, test)

all<-rbind(merge_train, merge_test)
###2.1 Search variable names containing "-mean()" and "-std()" and get their index numbers. The info of all the variable names has been read into "varnames" from the file "feature.txt" (see step 1.1).
varnames2<-as.character(varnames[,2])

extract<-c(grep("-mean()", varnames2), grep("-std()", varnames2))

extract_index<-sort(extract)+2
###2.2 Extract out the variables about the mean or std.
mydata<-all[,c(1,2,extract_index)]
###3. Replace class labels with activity names
activity<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING") 
mydata[,2]<-factor(mydata[,2], levels=1:6, labels=activity)
###4. Assign column names. (also see step 2.1)
names<-varnames2[sort(extract)

colnames(mydata)<-c("subject", "activity", names)
###5. Make a new tidy data set called "tidydata" displaying the average for each activity and each subject.
library(dplyr)

mydata_groups<-group_by(mydata, subject, activity)

tidydata<-summarise_each(mydata_groups, funs(mean))
