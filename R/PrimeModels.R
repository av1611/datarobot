#' Retrieve information about all DataRobot Prime models for a DataRobot project
#'
#' This function requests the DataRobot Prime models information for the DataRobot
#' project specified by the project argument, described under Arguments.
#' The function returns data.frame containing informatione about each DataRobot Prime model in a project (one row per Prime model)
#'
#' @inheritParams DeleteProject
#' @return data.frame containing informatione about each DataRobot Prime model in a project (one row per Prime model)
#' @export
#'
ListPrimeModels <- function(project) {
  projectId <- ValidateProject(project)
  routeString <- UrlJoin("projects", projectId, "primeModels")
  primeInfo <- DataRobotGET(routeString, addUrl = TRUE)
  primeDetails <- primeInfo$data
  return(as.dataRobotPrimeModel(primeDetails))
}


#' Retrieve information about specified DataRobot Prime model
#'
#' This function requests the DataRobot Prime model information for the DataRobot
#' project specified by the project argument, and modelId
#' The function returns list containing informatione about specified DataRobot Prime model
#'
#' @inheritParams DeleteProject
#' @param modelId Unique alphanumeric identifier for the model of interest.
#' @return list containing informatione about specified DataRobot Prime model
#' @export
#'
GetPrimeModel <- function(project, modelId) {
  projectId <- ValidateProject(project)
  routeString <- UrlJoin("projects", projectId, "primeModels", modelId)
  primeInfo <- DataRobotGET(routeString, addUrl = TRUE)
  return(as.dataRobotPrimeModel(primeInfo))
}


#' Retrieve information about specified DataRobot Prime model using corresponding jobId
#'
#' @inheritParams DeleteProject
#' @param jobId Unique integer identifier (return for example by RequestPrimeModel)
#' @param maxWait maximum time to wait (in sec) before job completed
#' @return list containing informatione about specified DataRobot Prime model
#' @export
#'
GetPrimeModelFromJobId <- function(project, jobId, maxWait = 600) {
  projectId <- ValidateProject(project)
  routeString <- UrlJoin("projects", projectId, "jobs", jobId)
  response <- WaitForAsyncReturn(routeString, maxWait,
                                 failureStatuses = JobFailureStatuses)
  return(GetPrimeModel(project, response$id))
}


as.dataRobotPrimeModel <- function(inList){
  elements <- c("featurelistId",
                "processes",
                "featurelistName",
                "modelType",
                "projectId",
                "samplePct",
                "modelCategory",
                "metrics",
                "score",
                "parentModelId",
                "ruleCount",
                "isFrozen",
                "blueprintId",
                "rulesetId",
                "id")
  return(ApplySchema(inList, elements, "metrics"))
}
