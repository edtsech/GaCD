setwd('/Users/edtsech/code/coursera/GaCD/week 4/UCI HAR Dataset/')

# Preload data
xTrain = read.table('./train/X_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)

xTest <- read.table("./test/X_test.txt",header=FALSE)
yTest <- read.table("./test/y_test.txt",header=FALSE)
subjectTest <- read.table("./test/subject_test.txt",header=FALSE)

features <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
subjectData <- rbind(subjectTrain, subjectTest)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
meanAndStd <- grep("-(mean|std)\\(\\)", features[, 2])
xData <- xData[, meanAndStd]
# Use real column names
names(xData) <- features[meanAndStd, 2]

# 3. Use descriptive activity names to name the activities in the data set
yData[, 1] <- activityLabels[yData[, 1], 2]
names(yData) <- "activity"

# 4. Appropriately label the data set with descriptive variable names
names(subjectData) <- "subject"
data <- cbind(subjectData, yData, xData)

colNames = gsub("\\(|\\)|-|,", "", names(data))
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("std","StdDev",colNames[i])
  colNames[i] = gsub("mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
};
names(data) <- colNames

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
result = ddply(data, .(activity, subject), numcolwise(mean))

write.table(result, file="tidyData.txt", sep = "\t", append=F)
