# Load required Packages
library(reshape2)

# Load activity labels
Labels <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/activity_labels.txt")
# mark activity labels as characters
Labels[,2] <- as.character(Labels[,2])
# Load features
features <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/Features.txt")
# mark features as characters
features[,2] <- as.character(features[,2])

# Find featurenames to extract only the data on mean and standard deviation
featuresrequired <- grep(".*mean.*|.*std.*", features[,2])
featuresrequired.names <- features[featuresrequired,2]
featuresrequired.names <-  gsub('-mean', 'Mean', featuresrequired.names)
featuresrequired.names <- gsub('-std', 'Std', featuresrequired.names)
featuresrequired.names <- gsub('[-()]', '', featuresrequired.names)


# Load the training data
train <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/train/X_train.txt")[featuresrequired]
train_Activities <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/train/y_train.txt")
train_Subjects <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_Subjects, train_Activities, train)

# Load the test Data
test <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/test/X_test.txt")[featuresrequired]
test_Activities <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/test/y_test.txt")
test_Subjects <- read.table("C:/Users/browntape/Documents/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_Subjects, test_Activities, test)

# merge datasets and add labels
all <- rbind(train, test)
colnames(all) <- c("subject", "activity", featuresrequired.names)

# convert activities & subjects into factors
all$activity <- factor(all$activity, levels = Labels[,1], labels = Labels[,2])
all$subject <- as.factor(all$subject)

# Melt & cast data table 
Data.melted <- melt(all, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

#write the results in a txt file
write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)