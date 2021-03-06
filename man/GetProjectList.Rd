% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetProjectList.R
\name{GetProjectList}
\alias{GetProjectList}
\title{Retrieve a list of all DataRobot projects}
\usage{
GetProjectList()
}
\value{
An S3 object of class 'projectSummaryList', consisting
of the following 15 elements:
\describe{
  \item{projectId}{List of character strings giving the unique DataRobot identifier for each project}
  \item{projectName}{List of character strings giving the user-supplied project names}
  \item{fileName}{List of character strings giving the name of the modeling dataset for each project}
  \item{stage}{List of character strings specifying each project's Autopilot stage (e.g., 'aim' is necessary to set target)}
  \item{autopilotMode}{List of integers specifying the Autopilot mode (0 = fully automatic, 1 = semi-automatic, 2 = manual)}
  \item{created}{List of character strings giving the project creation time and date}
  \item{target}{List of character strings giving the name of the target variable for each project}
  \item{metric}{List of character strings identifying the fitting metric optimized for each project}
  \item{partition}{Dataframe with one row for each project and 12 columns specifying partitioning details}
  \item{recommender}{Dataframe with one row for each project and 3 columns characterizing recommender projects}
  \item{advancedOptions}{Dataframe with one row for each project and 4 columns specifying values for advanced option parameters}
  \item{positiveClass}{Character string identifying the positive target class for binary classification projects}
  \item{maxTrainPct}{List of integers specifying the maximum training set percentage possible for each project}
  \item{holdoutUnlocked}{Logical flag indicating whether holdout subset results have been computed}
  \item{targetType}{Character string giving the type of modeling project (e.g., regression or binary classification)}
}
}
\description{
This function returns an S3 object of class projectSummaryList
that describes all DataRobot modeling projects available to the user.
This list may be converted into a dataframe with the as.data.frame
method for this class of S3 objects.
}
