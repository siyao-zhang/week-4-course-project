#download the data for the project to computer
#read in X_test.txt and X_train.txt trainfiles downloaded 
test<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/test/X_test.txt",stringsAsFactors=F)
train<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/train/X_train.txt",stringsAsFactors=F)
#read in features.txt file which contains column names
features<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/features.txt",stringsAsFactors=F)
#read in subject_test.txt and subject_train files
subjetest<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/test/subject_test.txt",stringsAsFactors=F)
subjetrain<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=F)
#read in activity files y_test and y_train
activtest<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/test/y_test.txt",stringsAsFactors=F)
activtrain<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/train/y_train.txt",stringsAsFactors=F)
#choose names from features file containing only the mean and standard deviation for each measurement. Store the data in a vector called col 
col<-grep("mean|std", features$V2)
#column bind subject and activity files to test and train data respectively
test<-cbind(test, activtest, subjetest)
train<-cbind(train, activtrain, subjetrain)
#merge the training and the test sets, and convert the data set to a data frame
test_train_df<-data.frame(rbind(train, test))
#extracts only the measurements on the mean and standard deviation for each measurements
library(dplyr)
sele_data<-select(test_train_df, ncol=c(col,562, 563))
#make activity names in the data set descriptive
  #store column names in vector called name
  name<-grep("mean|std", features$V2, value=TRUE)
  #remove hyphen 
  name<-gsub("-", "", name)
  #remove parenthesis
  name<-gsub("()", "", name, fixed=TRUE)
  #fix typo where Body repeats twice in name
  name<-gsub("BodyBody", "Body", name)
  #use lower case in name
  name<-tolower(name) 
#lable the data set with descriptive variable names
names(sele_data)<-c(name, "activity", "subject")
#Uses descriptive activity names to name the activities in the data set
activlabel<-read.table("/Users/Hank/Documents/siyao/couseraR/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)
activlabel<-data.frame(activlabel, stringsAsFactors=F)
sele_data1<-merge(sele_data, activlabel, by.x="activity", by.y="V1")
sele_data2<-select(sele_data1, -activity)
names(sele_data2)<-c(name,  "subject","activity")
#creates a second, independent tidy data set with the average of each variable for each activity and each subject
group<-group_by(sele_data2, subject, activity, add= TRUE)
final_data<-summarize_all(group, mean)
                 
