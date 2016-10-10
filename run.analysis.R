#Define fuctions to get data
gettraindata<-function(){
        setwd("./UCI HAR Dataset/train")
        trainname<-dir(pattern=".txt")
        trainlist<-lapply(trainname,read.table)
        return(trainlist)
}
gettestdata<-function(){
        setwd("./UCI HAR Dataset/test")
        testname<-dir(pattern=".txt")
        testlist<-lapply(testname,read.table)
        return(testlist)
}

#Get data

trainlist<-gettraindata()

testlist<-gettestdata()

#Bind rows of X/Y/subject components
subject<-rbind(trainlist[[1]], testlist[[1]])
names(subject)<-"subject"
X<-rbind(trainlist[[2]], testlist[[2]])
Y<-rbind(trainlist[[3]], testlist[[3]])


SelectedMeasurements <- function() {
        features <- read.table("features.txt", header=FALSE, col.names=c('id', 'name'))
        selected_columns <- grep('mean\\(\\)|std\\(\\)', features$name)
        filtered_dataset <- X[, selected_columns]
        names(filtered_dataset) <- features[features$id %in% selected_columns, 2]
        filtered_dataset
}

XDataset<-SelectedMeasurements ()

activity_labels <- read.table('activity_labels.txt', header=FALSE, col.names=c('id', 'name'))
Y[, 1] = activity_labels[Y[, 1], 2]
names(Y) <- "activity"

whole_dataset <- cbind(subject, Y, XDataset)

#Creating another file(the final one)
vari <- whole_dataset[, 3:66]
tidy_dataset <- aggregate(vari, list(whole_dataset$subject, whole_dataset$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
#library(dplyr)
#tbl_df(tidy_dataset)
write.csv(tidy_dataset, "~/Desktop/R/coursera/tidying data/UCI HAR Dataset/final_tidy_dataset.csv")
