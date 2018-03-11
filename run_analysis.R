library(RCurl)
library(data.table)
library(dplyr)

run_analysis <- function() {
  # Check if there is already a directory named 'UCI HAR Dataset', 
  # then for a zip file, and finally if neither of those are present
  # download it.
  if(!file.exists('./UCI HAR Dataset')) {
    if(!file.exists('./UCI_HAR_Dataset.zip')) {
      download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                    './UCI_HAR_Dataset.zip')
      unzip('./UCI_HAR_Dataset.zip')
    }
  }
  
  # Read in the activity labels file
  activity_labels <- fread('./UCI HAR Dataset/activity_labels.txt', select = 2)
  
  # Read in the features file and pull out the desired features - both
  # the column indices and their names. A '-mean()' suffix is added here as
  # it is easier than later.
  features <- fread('./UCI HAR Dataset/features.txt', select = 2)
  desired_features <- grep('mean\\(\\)|std\\(\\)', features$V2)
  desired_features_names <- sub('(?<=\\(\\))', 
                                '-mean()',
                                unlist(features[desired_features], use.names = FALSE),
                                perl = TRUE)
  
  # Helper function to reduce repetition.
  helper <- function(category) {
    # Read in the subject file.
    subject <- fread(paste('./UCI HAR Dataset/', category, '/subject_', category, '.txt', sep=''),
                     col.names = 'subject')
    
    # Read in the y file, then convert values to appropriate activity labels.
    y <- fread(paste('./UCI HAR Dataset/', category, '/y_', category, '.txt', sep=''))
    y_labels <- mapvalues(y$V1, 
                          from = rownames(activity_labels), 
                          to = activity_labels$V2)
    
    # Read in the X file, specifically only the columns in desired_features,
    # and name them using desired_features_names.
    X <- fread(paste('./UCI HAR Dataset/', category, '/X_', category, '.txt', sep=''), 
               select = desired_features, 
               col.names = desired_features_names)
    
    # Merge subject, X, and y columns
    merged <- cbind(subject, X)
    merged[, 'activity'] <- y_labels
    
    return(merged)
  }
  
  # Run the helper function on the test and train data
  merged_test <- helper('test')
  merged_train <- helper('train')
  
  # Merge test and train together
  merged <- rbind(merged_test, merged_train)
  
  # Sort by subject and activity
  merged <- arrange(merged, subject, activity)
  
  grouped <- group_by(merged, subject, activity) %>% summarise_all(funs(mean))
  
  return(grouped)
}