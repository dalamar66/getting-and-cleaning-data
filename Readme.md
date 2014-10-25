Created a script called run_analysis.R which will merge the test and training sets together. Prerequisites for this script:

The UCI HAR Dataset must be extracted and the UCI HAR Dataset must be availble in a directory called "UCI HAR Dataset"
After merging testing and training, labels are added and only columns that have to do with mean and standard deviation are kept.

The script will create a tidy data set containing the means of all the columns per test subject and per activity. This tidy dataset will be written to a tab-delimited file called tidy_data.txt