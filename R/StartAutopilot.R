1#' Set the target variable (and by default, start the DataRobot Autopilot)
#'
#' This function sets the target variable for the project defined by
#' project, starting the process of building models to predict the response
#' variable target.  Both of these parameters - project and target - are
#' required and they are sufficient to start a modeling project with
#' DataRobot default specifications for the other 10 optional parameters.
#'
#' @inheritParams DeleteProject
#' @inheritParams GetValidMetrics
#' @param metric Optional character string specifying the model fitting metric
#' to be optimized; a list of valid options for this parameter, which depends on
#' both project and target, may be obtained with the function GetValidMetrics.
#' @param weights Optional character string specifying the name of the column
#' from the modeling dataset to be used as weights in model fitting.
#' @param partition Optional S3 object of class 'partition' whose elements specify
#' a valid partitioning scheme.  See help for functions
#' CreateGroupPartition, CreateRandomPartition, CreateStratifiedPartition, CreateUserPartition 
#' and CreateDatetimePartitionSpecification
#' @param mode Optional, specifies the autopilot mode used to start the
#' modeling project; valid options are 'auto' (fully automatic,
#' the current DataRobot default, obtained when mode = NULL), 'semi' 
#' (semi is deprecated in 2.3, will be removed in 3.0), 'manual' and 'quick'
#' @param seed Optional integer seed for the random number generator used in
#' creating random partitions for model fitting.
#' @param positiveClass Optional target variable value corresponding to a positive
#' response in binary classification problems.
#' @param blueprintThreshold Optional integer specifying the maximum time
#' (in hours) that any modeling blueprint is allowed to run before being
#' terminated.
#' @param responseCap Optional floating point value, between 0.5 and 1.0,
#' specifying a capping limit for the response variable. The default value
#' NULL corresponds to an uncapped response, equivalent to responseCap = 1.0.
#' @param quickrun Optional logcial variable; if TRUE then DR will perform
#' a quickrun, limiting the number of models evaluated during autopilot. (quickrun flag is deprecated in 2.4, will be removed in 3.0)
#' @param featurelistId Specifies which feature list to use. If NULL (default),
#' a default featurelist is used.
#' @param smartDownsampled Optional logcial variable. Whether to use smart downsampling to throw away excess rows of the majority class.
#' Only applicable to classification and zero-boosted regression projects.
#' @param majorityDownsamplingRate Optional floating point value, between 0.0 and 100.0. 
#' The percentage of the majority rows that should be kept.  Specify only if using smart downsampling.  
#' May not cause the majority class to become smaller than the minority class.
#' @param maxWait Specifies how many seconds to wait for the server to finish
#' analyzing the target and begin the modeling process. If the process takes
#' longer than this parameter specifies, execution will stop (but the server
#' will continue to process the request).
#' @export
#'
SetTarget <- function(project, target, metric = NULL, weights = NULL,
                      partition = NULL, mode = NULL, seed = NULL,
                      positiveClass = NULL, blueprintThreshold = NULL,
                      responseCap = NULL, quickrun = NULL, featurelistId = NULL,
                      smartDownsampled = NULL, majorityDownsamplingRate = NULL,
                      maxWait = 600) {

  if (is.null(target)) {
    stop("No target variable specified - cannot start Autopilot")
  } else {
    if (!is.null(mode) && mode == AutopilotMode$SemiAuto){
      Deprecated("semi mode (use auto or manual mode instead)", "2.3", "3.0")
    }
    if (!is.null(quickrun)){
      Deprecated("quickrun flag (use quick autopilot mode instead)", "2.4", "3.0")
    }

    if (!is.null(mode) && mode == AutopilotMode$Quick){
      mode <- AutopilotMode$FullAuto
      quickrun <- TRUE
    }

    projectId <- ValidateProject(project)
    routeString <- UrlJoin("projects", projectId, "aim")
    #
    #  Validate the project status
    #
    pStat <- GetProjectStatus(projectId)
    stage <- as.character(pStat[which(names(pStat) == "stage")])
    if (stage != "aim") {
      errorMsg <- paste("Autopilot stage is", stage,
                        "but it must be 'aim' to set the target and start a new project")
      stop(strwrap(errorMsg))
    }

    bodyList <- list(target = target)
    bodyList$metric <- metric
    bodyList$weights <- weights
    if (is.numeric(mode)) {
      Deprecated("Numeric modes (use e.g. AutopilotMode$FullAuto instead)", "2.1", "3.0")
    }
    bodyList$mode <- mode
    bodyList$seed <- seed
    bodyList$positiveClass <- positiveClass
    bodyList$blueprintThreshold <- blueprintThreshold
    bodyList$responseCap <- responseCap
    bodyList$quickrun <- quickrun
    bodyList$featurelistId <- featurelistId
    bodyList$smartDownsampled <- smartDownsampled
    bodyList$majorityDownsamplingRate <- majorityDownsamplingRate
    if (!is.null(partition)) {
      if (partition$cvMethod == cvMethods$DATETIME){
        partition <- as.dataRobotDatetimePartitionSpecification(partition)
      }
      bodyList <- append(bodyList, partition)
    }
    #
    #  Note that partitionKeyCols element, if present, must be passed as a
    #  list instead of a character string. Test for this case and apply the
    #  messy special handling required if this element is present
    #
    if (length(bodyList$partitionKeyCols) == 0) {
      if (exists('cvMethod', where = bodyList) && bodyList$cvMethod == cvMethods$DATETIME
          && !is.null(bodyList$backtests)){
        body <- FormatMixedList(bodyList, specialCase = 'backtests')
      } else {
        body <- jsonlite::unbox(as.data.frame(bodyList))
      }
    } else {
      body <- FormatMixedList(bodyList, specialCase = 'partitionKeyCols')
    }
    response <- DataRobotPATCH(routeString, addUrl = TRUE, body = body, returnRawResponse = TRUE,
                               encode = 'json')
    WaitForAsyncReturn(httr::headers(response)$location,
                       addUrl = FALSE,
                       maxWait = maxWait,
                       failureStatuses = "ERROR")
    message("Autopilot started")
  }
}

#' Starts autopilot on provided featurelist.
#
#' Only one autopilot can be running at the time.
#' That's why any ongoing autopilot on different featurelist will
#' be halted - modelling jobs in queue would not
#' be affected but new jobs would not be added to queue by
#' halted autopilot.
#'
#' There is an error if autopilot is currently running on or has already
#' finished running on the provided featurelist and also if project's target was not selected
#' (via SetTarget).
#'
#' @inheritParams DeleteProject
#' @param featurelistId Specifies which feature list to use. 
#' @param mode The desired autopilot mode: either AutopilotMode$FullAuto (default) or
#' AutopilotMode$SemiAuto (SemiAuto is deprecated in 2.3, will be removed in 3.0)
#'
#' @export
#'
StartNewAutoPilot <- function(project, featurelistId, mode = AutopilotMode$FullAuto) {
  if (mode == AutopilotMode$SemiAuto){
    Deprecated("semi mode (use auto or manual mode instead)", "2.3", "3.0")
  }
  projectId <- ValidateProject(project)
  routeString <- UrlJoin("projects", projectId, "autopilots")
  payload <- list(featurelistId = featurelistId, mode = mode)
  return(invisible(DataRobotPOST(routeString, addUrl = TRUE, body = payload)))
}
