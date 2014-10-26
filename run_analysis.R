##1.1. read datasets
wd<-getwd()
varnames<-read.table(paste(wd, "/UCI HAR Dataset/features.txt", sep=""))
subject_train<-read.table(paste(wd, "/UCI HAR Dataset/train/subject_train.txt", sep=""))
label_train<-read.table(paste(wd, "/UCI HAR Dataset/train/y_train.txt", sep=""))
train<-read.table(paste(wd, "/UCI HAR Dataset/train/X_train.txt", sep=""))
subject_test<-read.table(paste(wd, "/UCI HAR Dataset/test/subject_test.txt", sep=""))
label_test<-read.table(paste(wd, "/UCI HAR Dataset/test/y_test.txt", sep=""))
test<-read.table(paste(wd, "/UCI HAR Dataset/test/X_test.txt", sep=""))
##1.2. merge datasets
merge_train<-cbind(subject_train, label_train, train); merge_test<-cbind(subject_test, label_test, test)
all<-rbind(merge_train, merge_test)
##2.1 search variable names containing "-mean()" and "-std()"
varnames2<-as.character(varnames[,2])
extract<-c(grep("-mean()", varnames2), grep("-std()", varnames2))
extract_index<-sort(extract)+2
##2.2 extract
mydata<-all[,c(1,2,extract_index)]
##3. replace class labels with activity names
activity<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")  
mydata[,2]<-factor(mydata[,2], levels=1:6, labels=activity)
##4. assign column names
names<-varnames2[sort(extract)]
colnames(mydata)<-c("subject", "activity", names)
##5. make tidy data displaying the average
library(dplyr)
mydata_groups<-group_by(mydata, subject, activity)
tidydata<-summarise_each(mydata_groups, funs(mean))
