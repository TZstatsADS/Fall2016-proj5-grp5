##xgboost
##with cross-validation to tune parameters
##tuning maximum depth and shrinkage rate
depth<-c(1,5,9,10,15) ##5 choices
eta<-c(0.001,0.003,0.01,0.03,0.05) ##5 choices

##fixing number of rounds to 50
err_cv<-matrix(0,50,25)
for (i in 1:length(depth)) {
  for (j in 1:length(eta)) {
    fit_cv<-xgb.cv(data=as.matrix(pc_train_dat[,-1]),label=pc_train_dat$loss,nrounds=50,max.depth=depth[i],eta=eta[j],nfold=5,objective="reg:linear")
    err_cv[,(i-1)*length(eta)+j]<-fit_cv$test.rmse.mean
  }
}

which(err_cv==min(err_cv),arr.ind=T)
##15th is when depth=9 and eta=0.05

model5<-xgboost(as.matrix(pc_train_dat[,-1]),pc_train_dat$loss,objective="reg:linear",nrounds=50,max.depth=9,eta=0.05)

fit.model5<-predict(model5,as.matrix(pc_test_dat))

mae5<-mean(abs(fit.model5-mat_test1$loss))
