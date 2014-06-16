As required by the license in README.txt, I acknowledge these people and this journal:
 Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
 

There should be a file "getdata%@Fprojectfiles%2FUCI HAR Dataset.zip" in your working directory.
We un-compress this.
Load the data from each of test and train, and merge these into a single data frame.


extract only means and stds for each measurement
activity and subject are not measurements, so they stay.
The standard deviations are clearly identified by "std()"
The means are more troublesome. By my understanding of the description in features_info.txt,
both"mean()" and "meanFreq()" identify means, but the measurements containing "Mean" are are 
derived from means, but are not themselves means.
I therefore exclude them.
If this is not satisfactory, they can easily be included.
The file "features.txt" contains useful header information that we need


We need to some ad-hoc cleaning of the column names to ensure no
horrors occur with the "$" operator.
replace any number of punctuation symbols with dots


Lets assign some meaningful activity names
These are in the file "activity_labels.txt".

# Finally, Subject is probably best treated as a factor.

Create my tidy data.






