setwd("C:/Users/YounHyuk/Desktop/train.csv")
library(randomForest)
library(MASS)
library(e1071)
library(stats)
library(rpart)
dat<-read.csv("train.csv",header=T)

set.seed(1)
ind<-sample(1:188318,16000)

reduced_dat<-dat[ind,]
reduced_dat<-reduced_dat[,-1]
##Treat this reduced data set as our training data set.
a<-c(1:116)
reduced_cat<-reduced_dat[,a]
reduced_cont<-reduced_dat[,-a]

##Data preparation
##how many categories in each variable
n_vec<-vector()
for(i in 1:116) {
  n_vec[i]<-length(unique(reduced_dat[,i]))
}

##creating dummy variables using model.matrix
large_cat<-which(n_vec>=32)
n_large_cat<-length(which(n_vec>=32))

reduced<-reduced_dat[,-large_cat]
A<-model.matrix(loss~0+.,data=reduced,contrasts.arg=lapply(reduced[,1:111],contrasts,contrasts=F))

##Response Average
large_cat_matrix<-matrix(NA,nrow(reduced_dat),length(large_cat))
for (i in 1:length(large_cat)) {
  n<-length(unique(reduced_dat[,large_cat[i]]))
  for (j in 1:n) {
    ind_cat<-which(reduced_dat[,large_cat[i]]==unique(reduced_dat[,large_cat[i]])[j])
    large_cat_matrix[ind_cat,i]<-mean(reduced_dat$loss[ind_cat])
  }
  }

colnames(large_cat_matrix)<-c("newCat109","newCat110","newCat112","newCat113","newCat116")


##matrix with only large category variables transformed
mat_train1<-cbind(reduced_dat[,-large_cat],large_cat_matrix)
##matrix to perform pca all variables combined





###########################################3
##Need to make test data into same format
##same as training model reducing our testing data set to 10,000 for computational purposes
test_dat<-dat[-ind,]

set.seed(1)
ind_test<-sample(1:nrow(test_dat),4000)

reduced_test_dat<-test_dat[ind_test,]
reduced_test_dat<-reduced_test_dat[,-1]

##PCA Data preparation
reduced_test<-reduced_test_dat[,-large_cat]
A_test<-model.matrix(loss~0+.,data=reduced_test,contrasts.arg=lapply(reduced_test[,1:111],contrasts,contrasts=F))

##Response Average
large_test_cat_matrix<-matrix(NA,nrow(reduced_test_dat),length(large_cat))
for (i in 1:length(large_cat)) {
  n<-length(unique(reduced_test_dat[,large_cat[i]]))
  for (j in 1:n) {
    ind_cat<-which(reduced_dat[,large_cat[i]]==unique(reduced_dat[,large_cat[i]])[j])
    ind_cat1<-which(reduced_test_dat[,large_cat[i]]==unique(reduced_dat[,large_cat[i]])[j])
    large_test_cat_matrix[ind_cat1,i]<-mean(reduced_dat$loss[ind_cat])
  }
}

colnames(large_test_cat_matrix)<-c("newCat109","newCat110","newCat112","newCat113","newCat116")

##removing NAs because there is no information on the training dataset about those values
na_ind<-which(is.na(large_test_cat_matrix),arr.ind=TRUE)[,1]

new_reduced_test_dat<-cbind(A_test,large_test_cat_matrix)

mat_test1<-cbind(reduced_test_dat[,-large_cat],large_test_cat_matrix)

mat_test1<-mat_test1[-na_ind,]



