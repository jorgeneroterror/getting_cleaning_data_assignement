#**CODE BOOK**




##**Intro: background**

The department of Non Linear Complex Systems in Genova University has carried out a research with 30 subjects.Each person performs 6 
activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.
With the accelerometer and the gyrocope inside the phoe the research group obtained meassurements about cinematic variables concerning the acceleration and angular speed of these 30 subjects.  

##**How data is shown?**
	
The 30 % of the data (test data) is in a folder called **test** and the remaining 70% (training data) in a folder called **training**. Inside each of these folders we find three interesting files

###**1- subject_training(or test).txt** this file contains the identification number of each training or test subject. 
Thus, it contains  values from 1 through 30. Notice that in the _subject_test.txt_ file we will find the 30 % of the numbers between 1 and 30 and in subject_trainingmthe remaining 70 %. Also notice that each number is repeated as many times as one variable is measured. We will talk about variables in the next point.
###**2.- X_training(or test).txt**
This file contains all the measurements taken by the Samsung Galaxy S II for each variable that is considered important in the study. In total there are 561 variables or features (you can find the names in features.txt and their information in features_info.txt)
###**3.- Y_training(or test).txt** this files describes which activity the subject is carring out.
 Each acitivity is a number between 1 and 6: 
* 1 WALKING
* 2 WALKING_UPSTAIRS
* 3 WALKING_DOWNSTAIRS 
* 4 SITTING 
* 5 STANDING 
* 6 LAYING

But outside training and test folder we find, as well, useful cross curricular information to both data sets: features_info.txt which give us information about the variables meassured and features.txt which give us their names. The last one will be crucial in order to filter the 561 features and take only which we considered more important according to our judgement.


##**The aim of this program**

The aim of this assignement is as simple as take an untidy dataset and tidy it. What we mean as tidy and untidy? That is what I will try to answer through the next 4 steps.

**First step: Gather and merge data**
We have the 30 % of the data in a folder and 70 % in another and also in each folder we have 3 different files. Hence, our first step is to gather this 3 files (subject, activity and variable values files) datasets into one single data frame. Once we have done that, we have to merge test dataset and training dataset into
one single data frame.
**Second step: filter the variables by mean and standard deviation and give them descriptive names**
Now we have one single data frame but it contains 563 (561 variables + 1 for the subjects + 1 the activites) columns! Thus our next step is filter the variables by mean and standard deviation (further explanation is explained in ..... section). Because we are tiding these datasets to make them clearer to a person who does not know nothing about the Genova's study, we have to give the variables a descriptive name which make that person understand it better.
**Third step: Change the activity numbers by descriptive names**
Here we only change 1 by WALKING, 2 by WALKING_UPSTAIRS and so on, in the activity column.

**Fourth: Calculate the average of each variable for each activity and each subject**
Finally we are interested in calculate the mean of each variable for each activity and each subject. This final step is what we understand as tidy dataset, a dataset which give us information about a specific topic, in this case a University study about the cinematics features of a bunch of subjects carring out differents activities.

##**Our judzgment followed to filter the variables**

There is a total of 561 features, so it obvious that we need to narrow them down. Although the assignement sais us to select only the meassurements on the mean and the standard deviation, there is still a problem: we would have 46 and 33 variables respectively, that is 79 in total.


###**A brief description of the variables**

We can classify our mean and standard deviation features according to the cinematic meassurements. These are

* The acceleration of the body
* The acceleration of the gravity
* The acceleration of the body when it jerks
* The angular speed of the body
* The angular speed of the body when it jerks

Because of the fact that the acceleration and the angular speed are vectors, these 5 cinematic variables have 3 directions (XYZ) and 1 magnitude value. Beside both are meassured in the time domain and in the frecuency domain.


###**Narrowing down the variables: the Magnitude of the vector**

We have data from 6 different activities in which some vector directions are more important than others. For example, if a person is walking up or downstairs the relevant body acceleration component is Z, whereas the X and Y do not play any rolle. However, if we are walking through the street it will happen the oposite effect, X and Y components are important while Z component is irrelevant. But this is not all the stuff, the acceleration of the gravity only have sense in the Z direction, and the angular speed of the body will be distinct of zero when it happens in the XY plane, unless the subject is doing a handstand.
Thus, it is difficult to select one direction and rule out the rest. For this reason it seem reasonable to filter all the directions and select the magnitude value.
Besides, with the magnitued we are taking into account all the 3 directions, so is more interesting in order to compare the average of differents features.

###***The name of the variables**

We have almost answerd it in 'A brief description of the variables' section. Taking into account the descriptive name of the 5 cinematic variable, plus there are two domains (time and frecuency) and plus our judzgement when we filter the data, the name of our variable are:

* Mean of the gravity acceleration magnitude (Time Domain)
* Mean of the body acceleration magnitude when it jerks (Time Domain)
* Mean of the body angular speed magnitude(Time Domain) 
* Mean of the body angular speed magnitude when it jerks (Time Domain)
* Mean of the body acceleration magnitude (Frequency Domain)
* Mean of the body acceleration magnitude when it jerks (Frequency Domain)
* Mean of the body angular speed magnitude (Frequency Domain)
* Mean of the body angular speed magnitude when it jerks (Frequency Domain)

* Standard deviation of the body acceleration magnitude (Time Domain)
* Standard deviation of the gravity acceleration magnitude (Time Domain)
* Standard deviation of the body acceleration magnitude when it jerks (Time Domain)
* Standard deviation of the body angular speed magnitude (Time Domain)
* Standard deviation of the body angular speed magnitude when it jerks (Time Domain)
* Standard deviation of the body acceleration magnitude (Frequency Domain)
* Standard deviation of the body acceleration magnitude when it jerks (Frequency Domain)
* Standard deviation of the body angular speed magnitude (Time Domain)
* Standard deviation of the body angular speed magnitude when it jerks (Time Domain)
	

##**Data transformations**

###**Reading the data**

The first step is to read the data. We use the following variables

* train_subject: for the suject identification in the train dataset
* train_activity: for the type of activity in the train dataset
* train_vals: for the meassurements of the variables in the train dataset.

And analogously for the test train.

We put this three variables in one single dataset called train and test respectively.

###**Merging the data**

We merge the data using merge(train,test,by.x='id',by.y='id',all.x  = TRUE,all.y=TRUE). The result of this operation is, on one hand, a data frame with one single subject column with the numbers 1 through 30 ordered in ascending order (that is how we want it). And on the other hand, 
the columns of activity and features are duplicated, filled with NAs where there is not an asigned value. What we want is to  eliminate half of this columns and put all the values in the other half. In other words 


    / sub variable.x variable.y \     /  sub   variable \
    |  1   0.4           Na     |     |   1      0.4    |
  A=|  1   0.1           Na     |   B=|   1      0.1    |
    |  2   Na           0.2     |     |   2      0.2    |
    |  2   Na           0.8     |     |   2      0.8    |
    \                          /      \                / 


We have the situation of the matrix A and want the situation of the matrix B. In order to resolve the problem we use the following for loop:

_aux<-matrix(ncol = ncol(all)-1, nrow = nrow(all))_

_for(i in 1:ncol(all)-1){_
  
  _aux[,i]<-rowSums(all[,c(1+i,563+i)],na.rm = T)_

_}_


_all<-cbind(all$id,aux[,1:562])_

with the function rowSums we sum all the pair of rows, and with the argument na.rm=TRUE we omit the NA values. Finally, we built our data frame with the id column (all$id) and the first 561 columns of our aux vector.

###**Filtering the data**

Now we can filter the data. Our strategy is use the vector features, that contains all the names of the variables, in order to select the features we want. We use the function grep to select those features which contains the string 'mean' and 'std' respectively:

_mean<-grep('mean',features$V2,value = TRUE)_
_std<-grep('std',features$V2,value = TRUE)_

we assign value=TRUE because we do not want the position of the vector where appears the 'mean' or 'std' string, we want the value. Why? because we are going to make a second selection:

_mean<-grep('Mag',mean)_
_std<-grep('Mag',std)_

Now we have the magnitude value of the mean and standard deviation meassurements. What we wanted. Beside the mean and std vectors contains the posistions where 'Mag' string appears, so what we have to do is subset our data frame:

_all___mean<-all[,mean]_

_all___std<-all[,std]_


###**Giving descriptive names to the features**

We use the data.frame() function to give the variables the names we have described in **The name of the variables** section.


###**Substituting activity numbers for acitivity names**

In order to do that we use the sub() function:

_all[,2]<-sub('1','WALKING',as.character(all[,2]))_

and analogously for the rest of activities.

###**Averaging the meassurements of each variable for each activity and suject**

We use functions of the dplyr package for this task. We convert subject and activity columns into factors and them we use group___by function. And finally I average the rest of the columns using 

_summarise___each(funs(mean))_


###**Writing the result in a csv file**

Simply 

_write.csv(result,'averages.csv')_


