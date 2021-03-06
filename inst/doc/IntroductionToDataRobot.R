## ---- echo=TRUE,message=FALSE--------------------------------------------
library(datarobot)

## ----echo=TRUE,eval=FALSE------------------------------------------------
#  ConnectToDataRobot(endpoint ='https://app.datarobot.com/api/v2', token='dqmtAG9B7pB7wIuxtmQ81s4BF0mWxZOi')

## ---- echo=FALSE, message=FALSE------------------------------------------
library(MASS)
data(Boston)

## ---- echo=TRUE, message=FALSE-------------------------------------------
str(Boston)

## ----echo=TRUE,eval=FALSE------------------------------------------------
#  projectObject <- SetupProject(dataSource = Boston, projectName = "BostonVignetteProject")

## ----echo=FALSE----------------------------------------------------------
projectObject <- readRDS("projectObject.rds")
projectObject

## ----echo=TRUE,eval=FALSE------------------------------------------------
#  SetTarget(project = projectObject, target = "medv")

## ---- echo=FALSE---------------------------------------------------------
listOfBostonModels <- readRDS("listOfBostonModels.rds")
fullFrame <- as.data.frame(listOfBostonModels, simple = FALSE)

## ---- echo=TRUE, eval=FALSE----------------------------------------------
#  WaitForAutopilot(project = projectObject)
#  listOfBostonModels <- GetAllModels(projectObject)

## ---- echo=TRUE----------------------------------------------------------
summary(listOfBostonModels)

## ---- echo=TRUE,fig.width=7,fig.height=6, fig.cap='Horizontal barplot of modelType and validation set RMSE values for all project models'----
plot(listOfBostonModels, orderDecreasing = TRUE)

## ---- echo=TRUE----------------------------------------------------------
modelFrame <- as.data.frame(listOfBostonModels)
modelType <- modelFrame$modelType
metric <- modelFrame$validationMetric
bestModelType <- modelType[which.min(metric)]
worstModelType <- modelType[which.max(metric)]

## ---- echo=FALSE---------------------------------------------------------
worstModelType

## ---- echo=FALSE---------------------------------------------------------
bestModelType

## ---- echo=TRUE----------------------------------------------------------
modelFrame$expandedModel

## ---- echo=TRUE,eval=FALSE-----------------------------------------------
#  bestIndex <- which.min(metric)
#  bestModel <- listOfBostonModels[[bestIndex]]
#  dataset <- UploadPredictionDataset(projectObject, Boston)
#  bestPredictJobId <- RequestPredictionsForDataset(projectObject, bestModel$modelId, dataset$id)
#  bestPredictions <- GetPredictions(projectObject, bestPredictJobId)

## ---- echo=FALSE, fig.width=7,fig.height=6-------------------------------
medv <- Boston$medv
bestPredictions <- readRDS("bestPredictions.rds")
plot(medv, bestPredictions, xlab="Observed medv value", ylab="Predicted medv value", ylim=c(0,50))
abline(a = 0, b=1, lty=2, lwd=3, col="red")
title("Best model")

