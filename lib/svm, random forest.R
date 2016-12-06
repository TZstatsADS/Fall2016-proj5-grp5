##support vector machines
##tuning using 5fold-cv
#takes long time to run
svm_tune<-tune(svm,loss~.,data=pc_train_dat,
               ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)),cross=5)

print(svm_tune)
plot(svm_tune)

model6<-svm(loss~.,data=pc_train_dat)

fit.model6<-predict(model6,pc_test_dat)

mae6<-mean(abs(fit.model6-mat_test1$loss))


##rf_tune<-tune(randomForest,loss~.,data=pc_train_dat,ranges=list(ntree=c(100,200,300)),cross=5)
##print(rf_tune)

##Random Foest
model4<-randomForest(loss~.,data=pc_train_dat,ntree=100)

fit.model4<-predict(model4,newdata=pc_test_dat)
mae4<-mean(abs(fit.model4-mat_test1$loss))