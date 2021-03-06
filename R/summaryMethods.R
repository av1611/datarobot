#' DataRobot S3 object methods for R's generic summary function
#'
#' These functions extend R's generic summary function to the
#' DataRobot S3 object classes dataRobotModel, dataRobotProject,
#' listOfBlueprints, listOfFeaturelists, listOfModels, and
#' projectSummaryList.
#'
#' @param object The S3 object to be summarized.
#' @param nList Integer: for the 'listOf' class objects, the first
#' nList elements of the list are summarized in the dataframe in
#' the second element of the list returned by the function.
#' @param \dots Not currently used.
#' @return An object-specific summary: for objects of class
#' dataRobotModel and dataRobotProject, this summary is a
#' character vector giving key characteristics of the model or
#' project, respectively; for the other object classes, the
#' value is a two-element list where the first element is a
#' brief summary character string and the second element
#' is a more detailed dataframe with nList elements.
#' @export
#'
summary.dataRobotModel <- function(object, ...) {
  #
  ##############################################################################
  #
  #  summary method for S3 objects of class 'dataRobotModel'
  #
  #  Returns a summary of object with only the following components:
  #  modelType, expandedModel (constructed from modelType and processes),
  #  modelId, blueprintId, and projectId
  #
  #############################################################################
  #
  components <- union(object$processes, object$modelType)
  expandedModel <- paste(components, collapse = "::")
  summaryList <- c(modelType = object$modelType, expandedModel = expandedModel,
                   modelId = object$modelId, blueprintId = object$blueprintId,
                   projectId = object$projectId)
  return(summaryList)
}

#' @rdname summary.dataRobotModel
#' @export
summary.dataRobotProject <- function(object, ...) {
  #
  #############################################################################
  #
  #  summary method for S3 objects of class 'dataRobotProject'
  #
  #  Returns a summary of object with only the following components:
  #  projectName, projectId, created, fileName, target, targetType, and metric
  #
  #############################################################################
  #
  summaryList <- c(projectName = object$projectName,
                   projectId = object$projectId,
                   created = object$created, fileName = object$fileName,
                   target = object$target, targetType = object$targetType,
                   metric = object$metric)
  return(summaryList)
}

#' @rdname summary.dataRobotModel
#' @export
summary.listOfBlueprints <- function(object, nList = 6, ...) {
  #
  ##############################################################################
  #
  #  summary method for S3 objects of class 'listOfBlueprints'
  #
  #  Returns a two-component list summarizing the first nList elements of object
  #
  ##############################################################################
  #
  #  Truncate nList if it is greater than the number of blueprints in object
  #
  nList <- min(nList, length(object))
  #
  #  Each element of a listOfBlueprints object has 4 components:
  #                             projectId, processes, blueprintId, and modelType
  #
  #  The first element of the summary list returned gives the total number of
  #  elements in object and, if projectId is constant, this value is also
  #  displayed; otherwise, an information message is displayed indicating
  #  that object includes blueprints from different projects
  #
  #  The format of the second summary list element also depends on whether
  #  projectId is unique: if so, the common value of projetId is included in
  #  the first summary list element and not repeated in the second list element;
  #  if not, projectId is included in the dataframe returned in the second
  #  summary list element.  To simplify the code, the required values of the
  #  non-projectId list elements that are always required are generated first
  #
  sumFrame <- NULL
  for (i in 1:nList) {
    modelType <- object[[i]]$modelType
    components <- union(modelType, object[[i]]$processes)
    expandedModel <- paste(components, collapse = "::")
    blueprintId <- object[[i]]$blueprintId
    projectId <- object[[i]]$projectId
    upFrame <- data.frame(projectId = projectId, modelType = modelType,
                          expandedModel = expandedModel,
                          blueprintId = blueprintId)
    sumFrame <- rbind.data.frame(sumFrame, upFrame)
  }
  nBlue <- length(object)
  projectId <- object[[1]]$projectId
  getProjectIdFunction <- function(xList) { xList$projectId }
  nProjectId <- length(unique(unlist(lapply(object, getProjectIdFunction))))
  if (nProjectId == 1) {
    firstElement <- paste("First", nList, "of", nBlue,
                          "blueprints for projectId", projectId)
    secondElement <- sumFrame[, 2:4]
  } else {
    firstElement <- paste("First", nList, "of", nBlue,
                          "blueprints from a mixed list of",
                          nProjectId, "projects")
    secondElement <- sumFrame
  }
  outList <- list(generalSummary = firstElement,
                  detailedSummary = secondElement)
  return(outList)
}

#' @rdname summary.dataRobotModel
#' @export
summary.listOfFeaturelists <- function(object, nList = 6, ...) {
  #
  ##############################################################################
  #
  #  summary method for listOfFeaturelists objects
  #
  #  Returns a two-component list summarizing the first nList elements of object
  #
  ##############################################################################
  #
  #  Truncate nList if it is greater than the number of featurelists in object
  #
  nList <- min(nList, length(object))
  #
  #  Each element of a listOfFeaturelists object has 4 components:
  #                            featurelistId, projectId, features, and name
  #
  #  The first element of the summary list returned gives the total number of
  #  elements in object and, if projectId is constant, this value is also
  #  displayed; otherwise, an information message is displayed indicating
  #  that object includes featurelists from different projects
  #
  #  The format of the second summary list element also depends on whether
  #  projectId is unique: if so, the common value of projetId is included
  #  in the first summary list element and not repeated in the second list
  #  element; if not, projectId is included in the dataframe returned in
  #  the second summary list element.  To simplify the code, the required
  #  values of the non-projectId list elements that are always required
  #  are generated first
  #
  sumFrame <- NULL
  for (i in 1:nList) {
    upFrame <- as.data.frame(object[[i]])
    sumFrame <- rbind.data.frame(sumFrame, upFrame)
  }
  nf <- length(object)
  projectId <- object[[1]]$projectId
  getProjectIdFunction <- function(xList) { xList$projectId }
  nProjectId <- length(unique(unlist(lapply(object, getProjectIdFunction))))
  if (nProjectId == 1) {
    firstElement <- paste("First", nList, "of", nf,
                          "featurelists for projectId", projectId)
    allNames <- colnames(sumFrame)
    keepNames <- setdiff(allNames, "projectId")
    keepCols <- which(allNames %in% keepNames)
    secondElement <- sumFrame[, keepCols]
  } else {
    firstElement <- paste("First", nList, "of", nf,
                          "featurelists from a mixed list of",
                          nProjectId, "projects")
    secondElement <- sumFrame
  }
  outList <- list(generalSummary = firstElement,
                  detailedSummary = secondElement)
  return(outList)
}

#' @rdname summary.dataRobotModel
#' @export
summary.listOfModels <- function(object, nList = 6, ...) {
  #
  ##############################################################################
  #
  #  summary method for S3 objects of cass 'listOfModels'
  #
  #  Returns a two-component list summarizing the first nList elements of object
  #
  ##############################################################################
  #
  #  Truncate nList if it is greater than the number of models in object
  #
  nModels <- length(object)
  nList <- min(nList, nModels)
  sumFrame <- as.data.frame(object, simple = TRUE)
  #
  firstElement <- paste("First", nList, "of", nModels, "models from:",
                        deparse(substitute(object)),
                        "(S3 object of class listOfModels)")
  secondElement <- sumFrame[seq(1, nList, 1), ]
  #
  outList <- list(generalSummary = firstElement,
                  detailedSummary = secondElement)
  return(outList)
}

#' @rdname summary.dataRobotModel
#' @export
summary.projectSummaryList <- function(object, nList = 6, ...) {
  #
  ##############################################################################
  #
  #  summary method for S3 objects of class 'projectSummaryList'
  #
  #  Returns a two-component list summarizing the first nList elements of object
  #
  ##############################################################################
  #
  #  Truncate nList if it is greater than the number of projects in object
  #
  sumFrame <- as.data.frame(object, simple = TRUE)
  nProjects <- nrow(sumFrame)
  nList <- min(nList, nProjects)
  #
  firstElement <- paste("First", nList, "of", nProjects,
                        "projects from:", deparse(substitute(object)),
                        "(S3 object of class projectSummaryList)")
  secondElement <- sumFrame[seq(1, nList, 1), ]
  #
  outList <- list(generalSummary = firstElement,
                  detailedSummary = secondElement)
  return(outList)
}
