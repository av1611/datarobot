% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DeletePredictJob.R
\name{DeletePredictJob}
\alias{DeletePredictJob}
\title{Function to delete one predict job from the DataRobot queue}
\usage{
DeletePredictJob(project, predictJobId)
}
\arguments{
\item{project}{Either (1) a character string giving the unique alphanumeric
identifier for the project, or (2) a list containing the element projectId with this identifier.}

\item{predictJobId}{Integer, identifying the prediction job
created by the call to RequestPredictions.}
}
\value{
Logical TRUE and displays a message to the user if the delete
request was successful; otherwise, execution halts and an error message
is displayed.
}
\description{
This function deletes the predict job specified by predictJobId from
the DataRobot queue.
}
