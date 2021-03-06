% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetProjectStatus.R
\name{GetProjectStatus}
\alias{GetProjectStatus}
\title{Request Autopilot status for a specified DataRobot project}
\usage{
GetProjectStatus(project)
}
\arguments{
\item{project}{Either (1) a character string giving the unique alphanumeric
identifier for the project, or (2) a list containing the element projectId with this identifier.}
}
\value{
List with the following three components:
\describe{
  \item{autopilotDone}{Logical flag indicating whether the Autopilot has completed}
  \item{stage}{Character string specifying the Autopilot stage}
  \item{stageDescription}{Character string interpreting the Autopilot stage value}
}
}
\description{
This function polls the DataRobot Autopilot for the status
of the project specified by the project parameter.
}
