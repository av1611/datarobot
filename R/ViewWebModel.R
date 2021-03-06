#' Retrieve a DataRobot web page that displays detailed model information
#'
#' This function brings up a web page that displays detailed model
#' information like that available from the standard DataRobot user
#' interface (e.g., graphical representations of model structures).
#'
#' @inheritParams DeleteModel
#' @export
#'
ViewWebModel <- function(model) {
  #
  ########################################################################
  #
  #  Function to retrieve a web-page that contains information about model
  #
  ########################################################################
  #
  #  Validate model
  #
  validModel <- ValidateModel(model)
  #
  #  GET Datarobot endpoint URL
  #
  dataRobotUrl <- Sys.getenv("DataRobot_URL")
  #
  parsedUrl <- httr::parse_url(dataRobotUrl)
  #
  #  Specify route for web-browser
  #
  #    This statement gives an absolute_paths_linter false positive:
  #
  routeString <- paste0(parsedUrl['scheme'], '://',
                       parsedUrl['hostname'], '/',
                       "projects/", model$projectId, "/models/",  # nolint
                       model$modelId)
  #
  #  Invoke browser to open specified route
  #
  browseURL(routeString)
  #
  #  Display user message and return logical value
  #
  modelType <- validModel$modelType
  urlString <- paste0(parsedUrl['scheme'], '://',
                     parsedUrl['hostname'], '/')
  if (is.null(modelType)) {
    message(paste("Opened URL", urlString, "for selected model"))
  } else {
    message(paste("Opened URL", urlString, "for model:", modelType))
  }
}
