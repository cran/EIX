## ---- echo=FALSE--------------------------------------------------------------
knitr::opts_chunk$set(fig.height = 6, fig.width = 6, fig.align = "center")


## -----------------------------------------------------------------------------
#devtools :: install_github("ModelOriented/EIX")
library("EIX")
library(data.table)
set.seed(4)
titanic_data<-data.table(na.omit(titanic_data))
knitr::kable(head(titanic_data))

library("Matrix")
sparse_matrix <- sparse.model.matrix(survived ~ . - 1,  data = titanic_data)

## ---- warning=FALSE, message=FALSE--------------------------------------------
library("xgboost")
param <- list(objective = "binary:logistic", max_depth = 2)
xgb_model <- xgboost(sparse_matrix, params = param, label = titanic_data[, "survived"] == "yes", nrounds = 50, verbose = FALSE)

## -----------------------------------------------------------------------------
lolli<-lollipop(xgb_model,sparse_matrix)
plot(lolli, threshold=0.02)

## -----------------------------------------------------------------------------
interactions<-interactions(xgb_model, sparse_matrix, option = "interactions")
head(interactions, 15)
plot(interactions)

## -----------------------------------------------------------------------------
importance<-importance(xgb_model, sparse_matrix, option = "both")
head(importance, 15)
plot(importance, radar=FALSE)

## -----------------------------------------------------------------------------
plot(importance)

## -----------------------------------------------------------------------------
data <- titanic_data[27,]
new_observation <- sparse_matrix[27,]
wf<-waterfall(xgb_model, new_observation, data, option = "interactions")
wf
plot(wf)

