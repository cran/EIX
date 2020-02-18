## ---- echo=FALSE--------------------------------------------------------------
knitr::opts_chunk$set(fig.height = 6, fig.width = 6, fig.align = "center")


## -----------------------------------------------------------------------------
#devtools :: install_github("ModelOriented/EIX")
library("EIX")
set.seed(4)
knitr::kable(head(HR_data))

## ---- warning=FALSE, message=FALSE--------------------------------------------
library("Matrix")
sparse_matrix <- sparse.model.matrix(left ~ . - 1,  data = HR_data)
head(sparse_matrix)

## -----------------------------------------------------------------------------
library("xgboost")
param <- list(objective = "binary:logistic", max_depth = 2)
xgb_model <- xgboost(sparse_matrix, params = param, label = HR_data[, left] == 1, nrounds = 50, verbose = FALSE)
knitr::kable(head(xgboost::xgb.model.dt.tree(colnames(sparse_matrix),xgb_model)))

## -----------------------------------------------------------------------------
knitr::kable(head(xgboost::xgb.importance(colnames(sparse_matrix),xgb_model)))

## -----------------------------------------------------------------------------
lolli<-lollipop(xgb_model,sparse_matrix)
plot(lolli)
#plot(lolli, threshold=0.05)
#plot(lolli, labels="roots")
#plot(lolli, labels="interactions")
#plot(lolli, labels="roots", threshold=0.05)
#plot(lolli, labels="interactions",threshold=0.05)
#plot(lolli, log_scale = FALSE)

## -----------------------------------------------------------------------------
pairs<-interactions(xgb_model, sparse_matrix, option = "pairs")
head(pairs)
plot(pairs)

## ---- warning=FALSE, message=FALSE--------------------------------------------
interactions<-interactions(xgb_model, sparse_matrix, option = "interactions")
head(interactions)
plot(interactions)

## -----------------------------------------------------------------------------
importance<-importance(xgb_model, sparse_matrix, option = "both")
head(importance)
plot(importance, radar=FALSE)
#plot(importance,  xmeasure = "mean5Gain", ymeasure = "sumGain",  top = 15, radar=FALSE)

## -----------------------------------------------------------------------------
plot(importance)
#plot(importance, text_start_point = 0.3)
#plot(importance, text_size = 4)
#plot(importance, top=15)

## -----------------------------------------------------------------------------
data <- HR_data[9,]
new_observation <- sparse_matrix[9,]
wf<-waterfall(xgb_model, new_observation, data, option = "interactions")
wf
plot(wf)
#wf<-waterfall(xgb_model, new_observation, data, option = "interactions", baseline = "intercept")
#wf
#plot(wf)

