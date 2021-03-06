% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ReasonCodes.R
\name{GetReasonCodesMetadataFromJobId}
\alias{GetReasonCodesMetadataFromJobId}
\title{Retrieve the reason codes metadata for a model using jobId}
\usage{
GetReasonCodesMetadataFromJobId(project, jobId, maxWait = 600)
}
\arguments{
\item{project}{Either (1) a character string giving the unique alphanumeric
identifier for the project, or (2) a list containing the element projectId with this identifier.}

\item{jobId}{Unique integer identifier (return for example by RequestReasonCodes)}

\item{maxWait}{Integer, The maximum time (in seconds) to wait for the model job to complete}
}
\value{
A named list which contains reason code metadata. For more information see GetReasonCodesMetadata
}
\description{
Retrieve the reason codes metadata for a model using jobId
}
