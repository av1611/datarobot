% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SetupProject.R
\name{SetupProjectFromPostgreSQL}
\alias{SetupProjectFromPostgreSQL}
\title{Function to set up a new DataRobot project using data from PostgreSQL table}
\usage{
SetupProjectFromPostgreSQL(server, database, table, username, port = NULL,
  driver = NULL, fetch = NULL, useDeclareFetch = NULL,
  projectName = NULL, password = NULL, encryptedPassword = NULL,
  maxWait = 60 * 60)
}
\arguments{
\item{server}{Character string. The address of the MySQL server}

\item{database}{Character string. The name of the database to use}

\item{table}{Character string. The name of the table to fetch}

\item{username}{Character string. The username to use to access the database}

\item{port}{Optional integer. The port to reach the PostgreSQL server. 
If not specified, will use the default specified by DataRobot (5432).}

\item{driver}{Optional character string. Specify ODBC driver to use. If not specified - use DataRobot default.
See the values within datarobot.enums.POSTGRESQL_DRIVER}

\item{fetch}{Optional integer. If specified, specifies the number of rows 
to stream at a time from the database. If not specified, fetches all results at once. 
This is an optimization for reading from the database}

\item{useDeclareFetch}{Optional bool. On True, server will fetch result as available using DB cursor.
On False it will try to retrieve entire result set - not recommended for big tables.
If not specified - use the default specified by DataRobot.}

\item{projectName}{Optional character string specifying a project name.}

\item{password}{Optional character string. The plaintext password to be used to access MySQL database.
Will be first encrypted with DataRobot. Only use this or `encryptedPassword`, not both.}

\item{encryptedPassword}{Optional character string. The encrypted password to be used to access MySQL database. 
Only use this or `password`, not both.}

\item{maxWait}{The maximum time to wait for each of two steps: (1) The initial project creation
request, and (2) data processing that occurs after receiving the response to this initial
request.}
}
\value{
This function returns a list with the following four components:
\describe{
  \item{projectName}{The name assigned to the DataRobot project}
  \item{projectId}{The unique alphanumeric project identifier for this DataRobot project}
  \item{fileName}{The name of the CSV modeling file uploaded for this project}
  \item{created}{Character string containing the time and date of project creation}
}
}
\description{
This function returns the projectName specified in the
calling sequence, the unique alphanumeric identifier projectId for the new
project, the name of the modeling dataset uploaded to create this project,
and the project creation time and date.
}
