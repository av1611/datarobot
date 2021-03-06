% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Models.R
\name{RequestFrozenModel}
\alias{RequestFrozenModel}
\title{Train a new frozen model with parameters from specified model}
\usage{
RequestFrozenModel(model, samplePct)
}
\arguments{
\item{model}{An S3 object of class dataRobotModel like that returned by
the function GetModelObject, or each element of the list returned by
the function GetAllModels.}

\item{samplePct}{Numeric, specifying the percentage of the training
dataset to be used in building the new model}
}
\value{
An integer value that can be used as the modelJobId parameter
in subsequent calls to the GetModelFromJobId function.
}
\description{
Frozen models use the same tuning parameters as their parent model 
instead of independently optimizing them to allow efficiently 
retraining models on larger amounts of the training data.
}
\details{
Note : For datetime partitioned projects, use ``RequestFrozenDatetimeModel` instead
}
