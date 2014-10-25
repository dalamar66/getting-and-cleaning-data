require(plyr)

# Load files
uci_hard_dir <- "UCI\ HAR\ Dataset"
feature_file <- paste(uci_hard_dir, "/features.txt", sep = "")
activity_labels_file <- paste(uci_hard_dir, "/activity_labels.txt", sep = "")
x_train_file <- paste(uci_hard_dir, "/train/X_train.txt", sep = "")
y_train_file <- paste(uci_hard_dir, "/train/y_train.txt", sep = "")
subject_train_file <- paste(uci_hard_dir, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(uci_hard_dir, "/test/X_test.txt", sep = "")
y_test_file  <- paste(uci_hard_dir, "/test/y_test.txt", sep = "")
subject_test_file <- paste(uci_hard_dir, "/test/subject_test.txt", sep = "")

# Load Raw data
features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity"))
x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subject_train_file)
x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subject_test_file)

# Merge the training and the test sets to create one data set.
training_sensor_data <- cbind(cbind(x_train, subject_train), y_train)
test_sensor_data <- cbind(cbind(x_test, subject_test), y_test)
sensor_data <- rbind(training_sensor_data, test_sensor_data)

# Label columns
sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sensor_data) <- sensor_labels

# Extracts only the measurements on the mean and standard deviation for each measurement.
sensor_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

# Descriptive activity names to name the activities in the data set
sensor_mean_std <- join(sensor_mean_std, activity_labels, by = "ActivityId", match = "first")
sensor_mean_std <- sensor_mean_std[,-1]

# Labels the data set with descriptive names.

# Remove parentheses
names(sensor_mean_std) <- gsub('\\(|\\)',"",names(sensor_mean_std), perl = TRUE)

# Make syntactically valid names
names(sensor_mean_std) <- make.names(names(sensor_mean_std))

# Clean names
names(sensor_mean_std) <- gsub('Acc',"Acceleration",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('GyroJerk',"Angular.Acceleration",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Gyro',"Angular.Speed",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Mag',"Magnitude",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('^t',"Time.Domain.",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('^f',"Frequency.Domain.",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('\\.mean',".Mean",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('\\.std',".Standard.Deviation",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Freq\\.',"Frequency.",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Freq$',"Frequency",names(sensor_mean_std))

# Second tidy data set with the average of each variable for each activity and each subject.

tidy_data = ddply(sensor_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(tidy_data, file = "tidy_data.txt", , sep="\t")