
## ----loaddata------------------------------------------------------------
unzip("getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")

base.dir = "UCI HAR Dataset"                # this is our dataset
# knitr does not play well with setwd(), so everything is relative file paths.
# Helper function to assemble file paths.
datafile = function(...){
    file.path(base.dir, ...)
}

# A helper function to load test or training data
get.data = function(directory, subject.file, activity.file, data.file){
    subjects = read.table(datafile(directory, subject.file))
    names(subjects)="Subject"

    activities = read.table(datafile(directory, activity.file))
    names(activities)="Activity"
    data = read.table(datafile(directory, data.file))
    full.data = data.frame(subjects, activities, data)
    full.data
    }

# load test directory
test.data = get.data("test", "subject_test.txt", "y_test.txt", "X_test.txt")

# load training directory
training.data = get.data("train", "subject_train.txt", "y_train.txt", "X_train.txt")

# merge data
all.data = rbind(test.data, training.data)


## ----extract.means-------------------------------------------------------
features = read.table(datafile("features.txt"), 
                      colClasses=c("integer",              # line number
                      "character"))[,2]                    # feature name
stds = grep("std\\(\\)", features)
angleMeans = grep("Mean", features)
means = grep("mean\\(\\)", features)
meanFreqs = grep("meanFreq\\(\\)", features)
# We must not forget that the first two columns are our subject and activity columns
# so everything else is offset by two.
selected.features = c(means,
                     meanFreqs,
                     #angleMeans,  # don't want this
                     stds)

chopped = all.data[c(1:2, selected.features+2)]    # don't forget offset for first two columns


## ----sanitize.names------------------------------------------------------
# replace any number of punctuation characters with a single dot.
sanitized.features = gsub("[[:punct:]]+",".",features)
# remove any remaining trailing dots
sanitized.features =  gsub("\\.$","", sanitized.features)

names(chopped) = c(names(chopped[1:2]), sanitized.features[selected.features])


## ----activiy.name--------------------------------------------------------
activity.df = read.table(datafile("activity_labels.txt"))
chopped$Activity = activity.df[chopped$Activity,2]


## ----factor.subject------------------------------------------------------
chopped$Subject = factor(chopped$Subject)


## ----create.tidy.data----------------------------------------------------
tidy.data = aggregate(chopped[-c(1,2)], 
                      by=list(Subject=chopped$Subject, 
                              Activity=chopped$Activity), 
                      FUN=mean)

write.csv(tidy.data, file="tidy_data.txt", row.names=FALSE)


## ----codebook------------------------------------------------------------
# Create a code book
# sink() does not work well with knitr, must isolate it in {}
{
    sink("Codebook.txt")
    cat("Code Book for tidy_data.txt\n")
    cat("\n\n")
    cat("Subject is a factor with the following levels:\n")
    str(tidy.data$Subject)
    cat("\n\n")
    cat("Activity is a factor with the following levels:\n")
    print(data.frame("Activity"=levels(tidy.data$Activity)))
    cat("\n\n")
    cat("The remaining columns contain means and standard deviations for various measurements\n")
    cat("All values are numeric.\n")
    cat("The original data names have had punctuation removed so the column names can be used safely.\n")
    cat("Please consult the README.txt for the original data for further clarification\n")
    print(data.frame("Original Names"=features[selected.features], 
                 row.names=sanitized.features[selected.features]))
    sink()
}


