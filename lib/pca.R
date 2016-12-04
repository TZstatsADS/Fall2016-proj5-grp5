##PCA
##all together
#pc<-prcomp(A)
#summary(pc)$importance[3,]
#90%
#a<-data.frame(loss=reduced_dat$loss,pc$x[,1:90],large_cat_matrix)

#b<-predict(pc,newdata=A_test)

#d<-data.frame(b[,1:90],large_test_cat_matrix)
#d<-d[-na_ind,]

##Separtely perform PCA on continuous and categorical variables to reduce varaibility
##14 continuous varaibles
pc1<-prcomp(A[,486:500])
##using 7 principal components from continuous varaible explains about 92% of the variability
summary(pc1)$importance[3,]

########
new_dat<-cbind(mat_train1[,-c(112:125)],pc1$x[,1:7])

new_test_dat<-cbind(mat_test1[,-c(112:125)],pc_test_cont[-na_ind,])
  
  
########
  
    
##PCA on dummy variables of 111 categorical varaibles without the cat varaibles with large
##categories
pc2<-prcomp(A[,1:485])
summary(pc2)$importance[3,]
##using 55 principal components explain about 81% of the variation

pc_cont<-pc1$x[,1:7]
##colnames(pc_cont)<-c("pc_cont1","pc_cont2","pc_cont3","pc_cont4","pc_cont5","pc_cont6","pc_cont7")
pc_cat<-pc2$x[,1:11]
##colnames(pc_cat)<-c("pc_cat1","pc_cat2","pc_cat3","pc_cat4","pc_cat5","pc_cat6","pc_cat7"
##                    ,"pc_cat8","pc_cat9","pc_cat10","pc_cat11")


pc_dat<-cbind(pc_cont,pc_cat)

pc_train_dat<-data.frame(loss=reduced_dat$loss,pc_dat,large_cat_matrix)

##transform test into PCA 
##seelcting 7 components from continuous and 11 from categorical
pc_test_cont<-predict(pc1,newdata=A_test[,486:500])
pc_test_cont<-pc_test_cont[,1:7]
#colnames(pc_test_cont)<-c("pc_cont1","pc_cont2","pc_cont3","pc_cont4","pc_cont5","pc_cont6","pc_cont7")

pc_test_cat<-predict(pc2,newdata=A_test[,1:485])
pc_test_cat<-pc_test_cat[,1:11]
#colnames(pc_test_cat)<-c("pc_cat1","pc_cat2","pc_cat3","pc_cat4","pc_cat5","pc_cat6","pc_cat7"
#                    ,"pc_cat8","pc_cat9","pc_cat10","pc_cat11")

##select 7 components from continuous and 11 components from categorical
pc_test_dat<-cbind(pc_test_cont,pc_test_cat)
pc_test_dat<-data.frame(pc_test_dat,large_test_cat_matrix)
pc_test_dat<-pc_test_dat[-na_ind,]

