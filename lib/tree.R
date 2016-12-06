##tree
##Using all the varaibles
mycontrol = rpart.control(minsplit=20,cp = 0, xval = 5) ##5-fold cv
model1<-rpart(loss~.,data=data.frame(mat_train1),method="anova",control = mycontrol)

##pruning tree to avoid overfitting
##minimum error
pruned_fit1<-prune(model1,cp=model1$cptable[which.min(model1$cptable[,"xerror"]),"CP"])

fit.model1<-predict(pruned_fit1,newdata=data.frame(mat_test1))

mae1<-mean(abs(fit.model1-mat_test1$loss))
##about 1504

##Using PCA components and 5 large categories variables
model2<-rpart(loss~.,data=pc_train_dat,method="anova",control=mycontrol)

pruned_fit2<-prune(model2,cp=model2$cptable[which.min(model2$cptable[,"xerror"]),"CP"])

fit.model2<-predict(pruned_fit2,newdata=pc_test_dat)

mae2<-mean(abs(fit.model2-mat_test1$loss))
