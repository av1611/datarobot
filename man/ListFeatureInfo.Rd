% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Features.R
\name{ListFeatureInfo}
\alias{ListFeatureInfo}
\title{Details about all features for this project}
\usage{
ListFeatureInfo(project)
}
\arguments{
\item{project}{Either (1) a character string giving the unique alphanumeric
identifier for the project, or (2) a list containing the element projectId with this identifier.}
}
\value{
A list of lists with one element for each feature The named list for
each feature contains:
\describe{
 \item{id}{feature id - note: Throughout the API, features are specified using their names,
 not this ID.}
 \item{name}{feature name}
 \item{featureType}{feature type: 'Numeric', 'Categorical', etc.}
 \item{importance}{numeric measure of the strength of relationship between the feature and
 target (independent of any model or other features).}
 \item{lowInformation}{whether feature has too few values to be informative}
 \item{uniqueCount}{number of unique values}
 \item{naCount}{number of missing values}
 \item{dateFormat}{format of the feature if it is date-time feature}
  \item{projectId}{Character id of the project the feature belonges to}
 }
}
\description{
Details about all features for this project
}
