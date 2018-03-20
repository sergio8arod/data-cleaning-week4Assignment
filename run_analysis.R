if(!file.exists("features.txt"))
{
    stop("The features file doesn't exist")
}
if(!file.exists(train/y_train.txt))
{
    stop("The train labels file doesn't exist")
}
if(!file.exists(train/X_train.txt))
{
    stop("The train data file doesn't exist")
}

features <- read.table("features.txt", header = F)
labels_train <- read.table("train/y_train.txt", header = F, col.names = c("activityLabel"))
train <- read.table("train/X_train.txt", header = F, col.names = features$V2)
train_df <- cbind(labels_train,train)
rm(labels_train, train)


if(!file.exists(test/y_tests.txt))
{
    stop("The train labels file doesn't exist")
}
if(!file.exists(test/X_test.txt))
{
    stop("The train data file doesn't exist")
}

labels_test <- read.table("test/y_test.txt", header = F, col.names = c("activityLabel"))
test <- read.table("test/X_test.txt", header = F, col.names = features$V2)
test_df <- cbind(labels_test,test)
rm(labels_test, test, features)

join_df <- merge(test_df,train_df, all = T)
dim(join_df)
