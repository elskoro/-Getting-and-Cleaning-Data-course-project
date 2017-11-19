setwd("/Users/ilya/Documents/R/Coursera/Elena/getting and cleaning data/UCI HAR Dataset")
dir()
install.packages('reshape2')
library(reshape2)

getwd()

########### 1. Load activity lables and features##############

activity_labels <- read.table('activity_labels.txt')
features <- read.table('features.txt')

## 1.2 select needed features (only mean and standard deviation)##
Numbers_of_features_Needed <- grep('.*mean.*|.*std.*', features[, 2])
Names_of_features_Needed <- features[Numbers_of_features_Needed, 2]


########### 2. merge train and test #################

setwd("/Users/ilya/Documents/R/Coursera/Elena/getting and cleaning data/UCI HAR Dataset/train")

subject_train <- read.table('subject_train.txt')
X_train <- read.table('X_train.txt')
y_train <- read.table('y_train.txt')
X_train <- X_train[, Numbers_of_features_Needed]

## 2.2 set the colnames of train tables ##
colnames(subject_train) <- 'subject'
colnames(X_train) <- Names_of_features_Needed
colnames(y_train) <- 'activity'
Train <- cbind(subject_train, y_train, X_train)

setwd("/Users/ilya/Documents/R/Coursera/Elena/getting and cleaning data/UCI HAR Dataset/test")

subject_test <- read.table('subject_test.txt')
X_test <- read.table('X_test.txt')
y_test <- read.table('y_test.txt')
X_test <- X_test[, Numbers_of_features_Needed]

## 2.3 set the colnames of tese tables ##
colnames(subject_test) <- 'subject'
colnames(X_test) <- Names_of_features_Needed
colnames(y_test) <- 'activity'
Test <- cbind(subject_test, y_test, X_test)

merged_data <- rbind(Train, Test)

################# 3.  descriptive activity names to name the activities in the data set #############

merged_data$activity <- factor(merged_data$activity, levels = activity_labels[, 1], labels = activity_labels[, 2])
merged_data$subject <- as.factor(merged_data$subject)
################# 4. second tidy data set with the average of each variable for each activity and each subject. ######

merged_data_melted <- melt(merged_data, id.vars = c('subject', 'activity'))
merged_data_mean <- dcast(merged_data_melted, subject + activity ~ variable, mean)

write.table(merged_data_mean, 'tidy_data.txt', col.names = T, quote = F)
 
tidydata <- read.table('tidy_data.txt')
