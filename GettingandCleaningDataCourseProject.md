# Getting and Cleaning Data Course Project

### Description

This project uses the run_analysis.R script to transform the UCI HAR dataset into a tidy dataset. This function first checks the current working directory for a directory named 'UCI HAR Dataset'. If that does not exist, it checks for 'UCI HAR Dataset.zip', and finally if that does not exist, it downloads the zip file from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The zip files, as applicable, are extracted into the current working directory. The function then reads the relevant files from the dataset and does a number of different things before combining them. First, it converts the numerical activity labels contained in the original dataset's y_test.txt and y_train.txt files and converts them into textual activity labels using the table contained in the activity_labels.txt file. Then it extracts the column numbers (as well as their names) for those features in the features.txt file that are on the mean or standard deviation. The extracted column numbers are used to read in the appropriate columns from X_test.txt and X_train.txt. Next, the transformed activity labels, feature values and subject values extracted from subject_test.txt and subject_train.txt are merged together for the test and train datasets individually before those are merged as well. Finally, the resulting table is grouped by activity and subject and aggregated using the mean for each column. This final table is tidy, per Hadley Wickham's definition in "Tidy Data," (found [here](http://vita.had.co.nz/papers/tidy-data.pdf))which is:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

In tidy.csv, each column contains a single variable as per (1), each unique combination of subject and activity label is contained in a single row per (2), and all of the data is contained in a single table, per (3).

The project includes the following files:

=========================================

- README.md
- CODEBOOK.md
- run_analysis.R
- tidy.csv

### Running

The run_analysis() function can be executed by sourcing the run_analysis.R into the environment and running:

	source('run_analysis.R') # or whatever the appropriate path is
	tidy <- run_analysis()

No user inputs are required. The output is a table. The table can be saved using:

	fwrite(tidy, 'tidy.csv')
    
The csv file can be easily read and viewed using:

	tidy <- read.csv('tidy.csv') # or whatever the appropriate path is
    View(tidy)
    