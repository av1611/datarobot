#' Request predictions for model from newdata
#'
#' This function uploads the data source defined by newdata and
#' requests the predictions generated from this data source by
#' model.  The data source is specified in the same way as for
#' the function SetupProject and can be either a CSV file or a
#' dataframe containing the features on which model was built.
#' Note that this function only requests the predictions be
#' generated and returns a prediction job identifier to be used
#' by the GetPredictions function to retrieve the predictions
#' once they have been generated.
#'
#' The DataRobot modeling engine requires a CSV file containing the data to be
#' used in generating predictions, and this has been implemented here in two ways.
#' The first and simpler is to specify dataSource as the name of this CSV file,
#' but for the convenience of those who wish to work with dataframes, this
#' function also provides the option of specifying a dataframe, which is then
#' written to a CSV file and uploaded to the DataRobot server. In this case, the
#' file name is either specified directly by the user through the saveFile
#' parameter, or indirectly from the name of the dataSource dataframe if
#' saveFile = NULL (the default).  In this second case, the file name consists
#' of the name of the dataSource dataframe with the string csvExtension appended.
#'
#' @inheritParams DeleteModel
#' @param newdata Either (a) the name of a CSV file or (b) a dataframe;
#' in either case, this parameter identifies the source of the data from which
#' all model predictions will be generated.  See Details.
#' @inheritParams SetupProject
#' @inheritParams SetupProject
#' @return Integer predictJobId to be used by GetPredictions function to retrieve
#' the model predictions.
#' @export
#'
RequestPredictions <- function(model, newdata, saveFile = NULL,
                               csvExtension = "_autoSavedDF.csv") {
  if ("cvsExtension" %in% names(match.call())) {
    Deprecated("csvExtension argument", "2.1", "2.3")
  }
  if ("saveFile" %in% names(match.call())) {
    Deprecated("saveFile argument", "2.1", "2.3")
  }
  newDataPath <- DataPathFromDataArg(newdata, saveFile, csvExtension)

  validModel <- ValidateModel(model)
  projectId <- validModel$projectId
  modelId <- validModel$modelId

  routeString <- UrlJoin("projects", projectId, "predictions")
  dataList <- list(modelId = modelId, file = httr::upload_file(newDataPath))
  rawReturn <- DataRobotPOST(routeString, addUrl = TRUE, body = dataList,
                             returnRawResponse = TRUE)
  message(paste("Prediction data file uploaded for model", modelId,
                "predictions"))
  rawHeaders <- httr::headers(rawReturn)
  predictJobPath <- rawHeaders$location
  pathSplit <- unlist(strsplit(predictJobPath, "predictJobs/"))
  predictJobId <- gsub("/", "", pathSplit[2])
  return(predictJobId)
}