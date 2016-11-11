# NAME OF THE PROGRAM: run_analysis.R                                                                              #
# AIM OF THE PROGRAM: when you execute the program it generates a .csv file that contains the averages             #
#                     of some interesting variables in a directory called proyect. The info of this variables and  #
#                     the reasons why they has been selected are explained in the codebook and README files.       #  
#                     This averages are calculated for each type of activity and for each subject.                 #
#                     The number of activities and subjects are 6 and 30 respectively so the                       #
#                     averages.csv file will contain 180 rows. Finally, the interesting variables we have selected #
#                     are 18. If we add the subject and activity columns we find that our resultant file           #  
#                     has 20 columns.                                                                              #
####################################################################################################################

# We will need the dplyr and plyr packages in order to manipulate data.

library(dplyr)
library(plyr)

# We set the root of our directory. IMPORTANT!: in this step the person who is executing the program
# must modificate the wd (work directory) variable and set their own work directory root.

wd<-setwd('~/Escritorio/Datascience/Curso_Get_Clean_Data/Week4')

# We create, if it does not exist, a directory called 'proyect'

if(!file.exists('proyect')) {
  
  dir.create('proyect')
}

# In the following steps we download and unzip the files which contain the data

fileUrl<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
wd<-setwd('~/Escritorio/Datascience/Curso_Get_Clean_Data/Week4/proyect')

download.file(fileUrl,destfile = paste(wd,'/DataSet.zip',sep =''),mode = 'wb')
unzip(paste(wd,'/DataSet.zip',sep = ''),exdir = wd)

# We update our wd root because when we unzip the file it creates another directory called 'UCI HAR Dataset'

wd<-setwd(paste(wd,'/UCI HAR Dataset',sep=''))


# Now we are going to save the useful data. The data are divided in two groups Test and Training data.
# Each of them are stored in diferents folders called 'test' and 'training' respesctively.
# For both, we are interested in three diferent data sets.
#   1.- The subject id: which contains values from 1 to 30. 
#   2.- The value of the variables. In total are 561 diferent variables.
#   3.- The type of activity: contains values from 1 to 6, each of them correspond to a different activity.
#                             Its assigement is described in the codebook.


# I specify the dimensions of the objects to make the things clearer. Notice that each group has the same
# number of rows.

test_subject<-read.table(paste(wd,'/test/subject_test.txt',sep = ''))         # dim=(2947,1)
test_vals<-read.table(paste(wd,'/test/X_test.txt',sep = ''))                  # dim=(2947,561)
test_actv<-read.table(paste(wd,'/test/y_test.txt',sep = ''))                  # dim=(2947,1)


train_subject<-read.table(paste(wd,'/train/subject_train.txt',sep = ''))      # dim=(7352,1)
train_vals<-read.table(paste(wd,'/train/X_train.txt',sep = ''))               # dim=(7352,561)
train_actv<-read.table(paste(wd,'/train/y_train.txt',sep = ''))               # dim=(7352,1)

# Also we store the name of the features in a variable calles 'features' because is going to be
# useful when we filter the 561 variables and select  the 18 interesting ones.

features<-read.table(paste(wd,'/features.txt',sep = ''))

# We gather the subject, activity a values in the same data frame.

train<-cbind(train_subject,train_actv,train_vals)
test<-cbind(test_subject,test_actv,test_vals)

train=data.frame(id=train[,1],actv=train[,2],value=train[,1:ncol(train_vals)+2])
test=data.frame(id=test[,1],actv=test[,2],value=test[,1:ncol(test_vals)+2])

# As we want all the values in the same data frame, we are going to merge them by the subject variable.

all<-merge(train,test,by.x='id',by.y='id',all.x  = TRUE,all.y=TRUE)

# In this step we have duplicated the number of columns because when we merge them we gather both groups
# into one data frame, but the merge function fill the 'gap' values with NAs. 
# The reason of the duplication is because we have introducted all.x=T and all.y=T in the argument.
#
# But what we want its only one column for each variable, not two.
#
#    / sub variable.x variable.y \     /  sub   variable \
#    |  1   0.4           Na     |     |   1      0.4    |
#  A=|  1   0.1           Na     |   B=|   1      0.1    |
#    |  2   Na           0.2     |     |   2      0.2    |
#    |  2   Na           0.8     |     |   2      0.8    |
#    \                          /      \                / 
#
# In other words, we have the situation of the matrix A and we want to have the situation of the matrix B.
# In order to do that we enter the program in a loop from 1 to the ncol(all) -1 (because 
# we exclude the subject column) and in each iteration we use the function rowSums with na.rm=T 
# to avoid the Nas values.

numcol<-ncol(all)

aux<-matrix(ncol = ncol(all)-1, nrow = nrow(all))

for(i in 1:ncol(all)-1){
  
  aux[,i]<-rowSums(all[,c(1+i,563+i)],na.rm = T)

}

# We 'rescue' the subject column and we select only the first 561 columns of aux. (Remember that when we
# merge the data we duplicate the number of columns)

all<-cbind(all$id,aux[,1:562])


# Now we are going to filter the number of variable. Since we are interested only in the variables which
# refer to the mean and the standard deviation we use the function grep applied to the variable 
# 'features' to select those elements that contains the string 'mean' and 'std' respectively.

mean<-grep('mean',features$V2,value = TRUE)
std<-grep('std',features$V2,value = TRUE)

# Among them, we are interested only those which refers to a Magnitude value. So we look for a 'Mag' 
# string.

mean<-grep('Mag',mean)
std<-grep('Mag',std)

# This variables above give us the position of the columns. So, with this information we subset the 
# columns we are interested in.

all_mean<-all[,mean]
all_std<-all[,std]

# In the next step we give descriptive names to our variales.


all<-data.frame(cbind(subject=all[,1],activity=all[,2],
                           'Mean of the body acceleration magnitude(Time Domain)'=all_mean[,1],
                           'Mean of the gravity acceleration magnitude(Time Domain)'=all_mean[,2],
                           'Mean of the body acceleration magnitude when it jerks(Time Domain)'=all_mean[,3],
                           'Mean of the body angular speed magnitude(Time Domain)'=all_mean[,4], 
                           'Mean of the body angular speed magnitude when it jerks(Time Domain)'=all_mean[,5],
                           'Mean of the body acceleration magnitude (Frequency Domain)'=all_mean[,6],
                           'Mean of the body acceleration magnitude when it jerks(Frequency Domain)'=all_mean[,8],
                           'Mean of the body angular speed magnitude(Frequency Domain)'=all_mean[,10],
                           'Mean of the body angular speed magnitude when it jerks(Frequency Domain)'=all_mean[,12],
                           'Standard deviation of the body acceleration magnitude(Time Domain)'=all_std[,1],
                           'Standard deviation of the gravity acceleration magnitude(Time Domain)'=all_std[,2],
                           'Standard deviation of the body acceleration magnitude when it jerks(Time Domain)'=all_std[,3],
                           'Standard deviation of the body angular speed magnitude(Time Domain)'=all_std[,4],
                           'Standard deviation of the body angular speed magnitude when it jerks(Time Domain)'=all_std[,5],
                           'Standard deviation of the body acceleration magnitude(Frequency Domain)'=all_std[,6],
                           'Standard deviation of the body acceleration magnitude when it jerks(Frequency Domain)'=all_std[,7],
                           'Standard deviation of the body angular speed magnitude(Time Domain)'=all_std[,8],
                           'Standard deviation of the body angular speed magnitude when it jerks(Time Domain)'=all_std[,9]
                      
                      
                                                                                                 ))

# Now want to substitute the labels 1 through 6 in the activiy variable for names which describe 
# the activity itself. In order to do that, we are going to use the sub() function to (literally)
# substitute '1','2'... for 'WALKING','WALKING_UPSTAIRS',...

all[,2]<-sub('1','WALKING',as.character(all[,2]))
all[,2]<-sub('2','WALKING_UPSTAIRS',as.character(all[,2]))
all[,2]<-sub('3','WALKING_DOWNSTAIRS',as.character(all[,2]))
all[,2]<-sub('4','SITTING',as.character(all[,2]))
all[,2]<-sub('5','STANDING',as.character(all[,2]))
all[,2]<-sub('6','LAYING',as.character(all[,2]))

all[,1]<-as.factor(all[,1])
all[,2]<-as.factor(all[,2])

# Finally, we want to create a tidy set which contain the averages of each variable for each activity 
# and each subject. In order to do that we are going to use functions of the dplyr package.

# First off all we GROUP our data set BY subject and activity. (that is why in the lines above we have
# transformed our subject and activity columns into factors)

result<-all %>% group_by(subject,activity) %>%
  
# Secondly, we calculate the mean in each group
  
  summarise_each(funs(mean))

# So, the only thing that remains to be done is to store the result in a data frame and write it
# in a .csv file 

result<-data.frame(result)
write.csv(result,'averages.csv')