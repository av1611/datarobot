% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Models.R
\name{RequestNewDatetimeModel}
\alias{RequestNewDatetimeModel}
\title{Adds a new datetime model of the type specified by the blueprint to a DataRobot project}
\usage{
RequestNewDatetimeModel(project, blueprint, featurelist = NULL,
  trainingRowCount = NULL, trainingDuration = NULL)
}
\arguments{
\item{project}{Either (1) a character string giving the unique alphanumeric
identifier for the project, or (2) a list containing the element projectId with this identifier.}

\item{blueprint}{A list with at least the following two elements:
blueprintId and projectId.  Note that the individual elements of the
list returned by GetRecommendedBlueprints are admissible values for
this parameter.}

\item{featurelist}{A list that contains the element featurelistId that
specifies the featurelist to be used in building the model; if not
specified (i.e., for the default value NULL), the project default
(Informative Features) is used.}

\item{trainingRowCount}{Integer (optional) the number of rows of data 
that should be used to train the model. If specified, trainingDuration may not be specified.}

\item{trainingDuration}{Character string (optional) a duration string specifying what 
time range the data used to train the model should span.
If specified, trainingRowCount may not be specified.}
}
\value{
An integer value that can be used as the modelJobId parameter
in subsequent calls to the GetDatetimeModelFromJobId function.
}
\description{
This function requests the creation of a new datetime model in the DataRobot
modeling project defined by the project parameter.  The function also
allows the user to specify alternatives to the project default for
featurelist, samplePct, and scoringType.  This function returns an
integer modelJobId value, which can be used by the GetDatetimeModelFromJobId
function to return the full model object.
}
\details{
Motivation for this function is the fact that some models - e.g., very
complex machine learning models fit to large datasets - may take a long
time to complete.  Splitting the model creation request from model
retrieval in these cases allows the user to perform other interactive R
session tasks between the time the model creation/update request is made
and the time the final model is available.
}
