This project is for Coursera class 'Getting and Cleaning Data'
===========
## Understanding of Source Files
There are three type of data files and two info files.
### Data Files 
- subject_train.txt, subject_test.txt : This file just includes person's unique id column as number.
- y_train.txt, y_test.txt : This file has one column what is activity id like 'SITTING', 'WALKING' etc. The columns is number type.
- X_train.txt, X_test.txt : This file has 561 columns. The features come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.

### Info Files
- activity_labels.txt : This file has two columns. First one is id and second one is behavior. This file's first id column matchs with y_train.txt
- features.txt : This file has also two columns. First one is id and second one is features name measured from the accelerometer and gyroscope. It matchs with X_train.txt

To create one big dataframe I have to merge three data files. But the variables names from data files are not human readable. So I use info files to replace column names. 

## How to merge three files into one big dataframe
It is simple. Just load three data files into each dataframe using read.csv function and merges those files into single big dataframe using cbind function. Repeat these action to make two dataframe each train and test.<br>
Also I add extra column called "group" to distinguish two data frame. To make final one big dataframe called "merge" use rbind.

## Convert activity id to human readable.
It is not easy what activity id means, so I create function "activity.id.to.strings" to convert id to some strings. That function uses dataframe "activity" made from activity_labels.txt file.

## Extract variables just needed.
The dataframe "merged" has 564 columns. This is too much. I need just variables which are features of std or mean but the "merge" dataframe columns names are like "V1", "V2", "V3" etc. <br/>
In "feature.txt" file there is features names like "tGravityAcc-mean()-Y", "tBodyAccJerk-mean()-Y". I create two vectors colname.mean, colname.std those has "mean" or "std" characters from "feature" dataframe. These vectors has values like "V1", "V251", "V243". <br/>
Finally I can subset "merged" dataframe only has "std" or "mean" columns using two vectors and names "tidy" dataframe.

## Convert features columns names to human readable.
This step is similar in converting activity id to strings. I use "features" dataframe as columns names source. The function "id.to.string" helps converting "V1" to "tGravityAcc-mean()-Y".<br/>
I also change varaibles name "subject" to "person" and "activity" to "motion". I think it is better name.

## Getting mean value of features columns.
I made a tidy dataframe so far. But this has many observation of activity. In example, person 1 did many "SITTING", many "WALKING" etc. To make a meaningful compact dataset I melted "tidy" to "tidy.melted". To calculate mean of (person, motion) I used dcast function. These two function act like "group by" in sql.<br/>
Finally I got little tidy dataframe. 




