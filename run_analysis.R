#Check if files exists
setwd("UCI HAR Dataset")
if(!file.exists("features.txt"))
{
    stop("The features file doesn't exist")
}
if(!file.exists("train/y_train.txt"))
{
    stop("The train labels file doesn't exist")
}
if(!file.exists("train/X_train.txt"))
{
    stop("The train data file doesn't exist")
}

#Load the files fo features and train in R
features <- read.table("features.txt", header = F)
labels_train <- read.table("train/y_train.txt", header = F, col.names = c("activityLabel"))
train <- read.table("train/X_train.txt", header = F, col.names = features$V2)
train_df <- cbind(labels_train,train)
rm(labels_train, train)

#Check the same for the files of test
if(!file.exists("test/y_test.txt"))
{
    stop("The train labels file doesn't exist")
}
if(!file.exists("test/X_test.txt"))
{
    stop("The train data file doesn't exist")
}

#Load the test files on R
labels_test <- read.table("test/y_test.txt", header = F, col.names = c("activityLabel"))
test <- read.table("test/X_test.txt", header = F, col.names = features$V2)
test_df <- cbind(labels_test,test)
rm(labels_test, test, features)

#Merge test and train data, joining all the contents of both data frames
join_df <- merge(test_df,train_df, all = T)
#Extract the variables that contains mean or standard deviation
extracted_df <- join_df[,c(1,grep("mean|std",names(join_df), ignore.case = T))]

#Change the activity label, to be readable without the activity_labels.txt file
activityLabels <- read.table("activity_labels.txt", header = F)
for (i in activityLabels[,1])
{
    extracted_df$activityLabel <- gsub(i, activityLabels[activityLabels$V1==i,2], extracted_df$activityLabel)
}

#Rename the variables appropiately
names(extracted_df) <- sub("[.,]{3}","-",names(extracted_df))
names(extracted_df) <- sub("[.,]{2}","",names(extracted_df))
names(extracted_df) <- sub("BodyBody","Body",names(extracted_df))
names(extracted_df)[c(82,85,86,87)] <- c("angle.tBodyAccJerkMean.gravityMean","angle.gravityMean-X","angle.gravityMean-Y", "angle.gravityMean-Z")

primaryData <- extracted_df
rm(extracted_df,join_df,test_df,train_df)

#Tidy data set with activity and subject average
secondaryData <- aggregate(primaryData[,2:dim(primaryData)[2]], list(primaryData$activityLabel), mean)
names(secondaryData)[1] <- "activityLabel"
