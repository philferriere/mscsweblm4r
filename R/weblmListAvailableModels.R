
#' @title Retrieves the list of web language models available.
#'
#' @description This function retrieves the list of web language models
#' currently available.
#'
#' Internally, this function invokes the Microsoft Cognitive Services Web
#' Language Model REST API documented at \url{https://www.microsoft.com/cognitive-services/en-us/web-language-model-api/documentation}.
#'
#' You MUST have a valid Microsoft Cognitive Services account and an API key for
#' this function to work properly. See \url{https://www.microsoft.com/cognitive-services/en-us/pricing}
#' for details.
#'
#' @export
#'
#' @return An S3 object of the class \code{\link{weblm}}. The list of available
#' language models is stored in the \code{results} dataframe inside this object.
#' The dataframe includes a short description of the corpus used to build the
#' model, the name of the model, the max N-gram order supported, and a list of
#' Web Language Model REST API methods supported by each model.
#'
#' @author Phil Ferriere \email{mscs4rmaintainer@gmail.com}
#'
#' @examples \dontrun{
#'  tryCatch({
#'
#'    # Retrieve a list of supported web language models
#'    modelList <- weblmListAvailableModels()
#'
#'    # Class and structure of modelList
#'    class(modelList)          # weblm
#'    # [1] "weblm"
#'
#'    str(modelList, max.level = 1)
#'    # List of 3
#'    #  $ results:'data.frame':  4 obs. of  7 variables:
#'    #  $ json   : chr "{"models":[{"corpus":"bing webpage title text 2013-12", __truncated__ }]}
#'    #  $ request:List of 7
#'    #   ..- attr(*, "class")= chr "request"
#'    #  - attr(*, "class")= chr "weblm"
#'
#'    # Print partial results
#'    pandoc.table(modelList$results[1:3])
#'    #-------------------------------------------------
#'    #            corpus              model   maxOrder
#'    #------------------------------ ------- ----------
#'    #   bing webpage title text      title      5
#'    #           2013-12
#'    #
#'    #bing webpage body text 2013-12   body      5
#'    #
#'    # bing web query text 2013-12    query      5
#'    #
#'    #   bing webpage anchor text    anchor      5
#'    #           2013-12
#'    #-------------------------------------------------
#'
#'
#'  }, error = function(err) {
#'
#'    # Print error
#'    geterrmessage()
#'
#'  })
#' }

weblmListAvailableModels <- function() {

  # Call MSCS Web Language Model REST API
  res <- weblmHttr("GET", "models")

  # Extract response
  json <- httr::content(res, "text", encoding = "UTF-8")

  # Build df from JSON results
  models <- jsonlite::fromJSON(json)$models
  supportedOps <- c(unlist(unique(jsonlite::fromJSON(json)$models$supportedOperations)))
  for (supportedOp in supportedOps) {
    eval(parse(text = paste0(eval(supportedOp), " <- c()")))
    for (model in 1:nrow(models)) {
      eval(parse(text = paste0(eval(supportedOp), " <- c(", eval(supportedOp),
        ifelse(supportedOp %in% models$supportedOperations[[model]], ', "supported")', ', "unsupported")'))))
    }
    eval(parse(text = paste0('models <- cbind(models, ', eval(supportedOp), ' = factor(',
      eval(supportedOp), ', levels = c("unsupported", "supported")))')))
  }
  models$supportedOperations <- NULL

  # Return results as S3 object of class "weblm"
  weblm(models, json, res$request)
}
