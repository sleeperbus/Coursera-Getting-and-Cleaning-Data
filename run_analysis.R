library(plyr)
library(reshape2)
################################################################################
# load information files to dataframes
################################################################################
features <- read.table("features.txt", stringsAsFactors=FALSE)
names(features) <- c("id", "feature")
activities <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
names(activities) <- c("id", "activity")


################################################################################
# loading data from train files and make single dataframe
################################################################################
setwd("train")
train.data <- read.table("X_train.txt", stringsAsFactors=FALSE)

train.subject <- read.table("subject_train.txt", stringsAsFactors=FALSE)
# add extra column called "group"
train.subject <- cbind(1, train.subject)
names(train.subject) <- c("group", "subject")

train.activity <- read.table("y_train.txt", stringsAsFactors=FALSE)
names(train.activity) <- c("activity") 

# add extra columns to train
train <- cbind(train.subject, train.activity, train.data)

################################################################################
# loading data from test files and make single dataframe
################################################################################
setwd("../test")
test.data <- read.table("X_test.txt", stringsAsFactors=FALSE)

test.subject <- read.table("subject_test.txt", stringsAsFactors=FALSE)
# add extra column called "group"
test.subject <- cbind(2, test.subject)
names(test.subject) <- c("group", "subject")

test.activity <- read.table("y_test.txt", stringsAsFactors=FALSE)
names(test.activity) <- c("activity")

# add extra columns to training
test<- cbind(test.subject, test.activity, test.data)

# finally, make one dataframe
merged <- rbind(test, train)

# function to convert activity id to readable term.
activity.id.to.strings <- function(x) {
    with(activities, activities[id == x, "activity"])
}

# change activity id to readable code.
merged$activity <- sapply(merged$activity, activity.id.to.strings)

# extract mean(), std() columns from merged
colname.mean <- paste("V", grep("mean()", features$feature), sep="")
colname.std <- paste("V", grep("std()", features$feature), sep="")

# subset the merged contained mean and std columns
tidy <- merged[,c("subject", "activity",  colname.mean, colname.std)]

# convert column names(like V1, V2) to human readble column names
id.to.string <- function(x) {
	with(features, features[id == gsub("V", "", x), "feature"])
}
colname.mean <- sapply(colname.mean, id.to.string)
colname.std <- sapply(colname.std, id.to.string)
colname.mean <- gsub("(^t|^f|\\(|\\))", "", colname.mean)
colname.std <- gsub("(^t|^f|\\(|\\))", "", colname.std)

# rename columns of tiny data
names(tidy) <- c("person", "motion", colname.mean, colname.std)

# finally, make csv file
tidy.melted <- melt(tidy, id=c("person", "motion"))
tidy.mean <- dcast(tidy.melted, person + motion ~ variable, mean)
write.csv(tidy.mean, "../tidy.csv")
