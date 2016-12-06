

library(data.table)
library(Matrix)
library(xgboost)
library(Metrics)

ID = 'id'
TARGET = 'loss'
SEED = 0
SHIFT = 200

train.raw = "C:/Users/LEE/Desktop/project5/train.csv"
test.raw = "C:/Users/LEE/Desktop/project5/test.csv"
submission.f = "C:/Users/LEE/Desktop/project5/sample_submission.csv"


train = fread(train.raw, showProgress = TRUE)
test = fread(test.raw, showProgress = TRUE)

train.label = log(train[,TARGET, with = FALSE] + SHIFT)[[TARGET]]

train[, c(ID, TARGET) := NULL]
test[, c(ID) := NULL]

num.train = nrow(train)
train.test = rbind(train, test)

features = names(train)

for (f in features) {
  if (class(train.test[[f]])=="character") {
    #cat("VARIABLE : ",f,"\n")
    levels <- sort(unique(train.test[[f]]))
    train.test[[f]] <- as.integer(factor(train.test[[f]], levels=levels))
  }
}
# in order to speed up fit within Kaggle scripts 
remove.features <- c("cat67","cat21","cat60","cat65", "cat32", "cat30",
                      "cat24", "cat74", "cat85", "cat17", "cat14", "cat18",
                      "cat59", "cat22", "cat63", "cat56", "cat58", "cat55",
                      "cat33", "cat34", "cat46", "cat47", "cat48", "cat68",
                      "cat35", "cat20", "cat69", "cat70", "cat15", "cat62")

new.train = train.test[1:num.train,-remove.features, with = FALSE]
new.test = train.test[(num.train+1):nrow(train.test),-remove.features, with = FALSE]



dtrain = xgb.DMatrix(as.matrix(new.train), label=train.label)
dtest = xgb.DMatrix(as.matrix(new.test))


xgb_params = list(
  seed = 0,
  colsample_bytree = 0.5,
  subsample = 0.8,
  eta = 0.05, # replace this with 0.01 for local run to achieve 1113.93
  objective = 'reg:linear',
  max_depth = 12,
  alpha = 1,
  gamma = 2,
  min_child_weight = 1,
  base_score = 7.76
)


xg_eval_mae <- function (yhat, dtrain) {
  y = getinfo(dtrain, "label")
  err= mae(exp(y),exp(yhat) )
  return (list(metric = "error", value = err))
}

 
best_nrounds = 545 

gbdt = xgb.train(xgb_params, dtrain, nrounds=as.integer(best_nrounds/0.8))

submission = fread(submission.f, colClasses = c("integer", "numeric"))
submission$loss = exp(predict(gbdt,dtest)) - SHIFT
write.csv(submission,'sub.csv',row.names = FALSE)
