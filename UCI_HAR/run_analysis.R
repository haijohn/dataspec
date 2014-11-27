setwd('data')

## read test data
X_test <- read.table("test/X_test.txt", header=F)
y_test <- read.table("test/y_test.txt", header=F)
subject_test <- read.table("test/subject_test.txt", header=F)

## bind 3 dataset
df_test = cbind(subject_test, y_test, X_test)

## read train data
X_train = read.table("train/X_train.txt", header=F)
y_train = read.table("train/y_train.txt", header=F)
subject_train <- read.table("train/subject_train.txt", header=F)

## bind 3 dataset
df_train = cbind(subject_train, y_train, X_train)

## bind test data and train data
df_combine = rbind(df_test, df_train)

## read labels
labels = read.table('activity_labels.txt',header=F)

## replace activity integer with actual name
labels = as.character(labels[,2])
# lapply saves the day
df_combine[,2] = unlist(lapply(df_combine[,2], function(x) labels[x]))

## this is really slow
#num_row = nrow(df_combine)
#for(i in 1:num_row){
#    index <- integers[i] # get the integer in the second column
#    label <- labels[index] # get the label from the label data set
#    df_combine[i,2] <- label # replace the integer with activity name
#    if(i %% 500 == 0){
#        print(i)
#    } 
#}

## read feature 
features = read.table("features.txt", header=F)

## get colnames contains mean and std
index = grep("mean\\(|std\\(", features[,2])
filtered_features = features[index, ]

## remove '()' in names 
filtered_features = gsub("\\(\\)", "", filtered_features[,2])

## get column data based on the index before
df_filtered = df_combine[, index+2]

## add first and second column back
df_filtered = cbind(df_combine[,c(1,2)], df_filtered)

## label varible names
colnames(df_filtered) = c(c('subject','activity'),filtered_features)

#write.table(df_filtered,file="df_filtered.txt",row.names=F)

## caculate avg of each varible for each activity and each subject use ddply
library(plyr)
dim_col = length(colnames(df_filtered))
df_tide = ddply(df_filtered, .(subject,activity), function(df) colMeans(df[,3:dim_col]))
write.table(df_tide,file="df_tide.txt",row.names=F)



