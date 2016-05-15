
#' @title Calculates the joint probability that a sequence of words will appear together.
#'
#' @description This function calculates the joint probability that a particular sequence of
#' words will appear together. The input string must be in ASCII format.
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
#' @param inputWords (character vector) Vector of character strings for which
#' to calculate the joint probability. Must be in ASCII format.
#'
#' @param modelToUse (character) Which language model to use, supported values:
#' "title", "anchor", "query", or "body" (optional, default: "body")
#'
#' @param orderOfNgram (integer) Which order of N-gram to use, supported values:
#' 1L, 2L, 3L, 4L, or 5L (optional, default: 5L)
#'
#' @return An S3 object of the class \code{\link{weblm}}. The results are stored in
#' the \code{results} dataframe inside this object. The dataframe contains the
#' word sequences and their log(probability).
#'
#' @author Phil Ferriere \email{mscs4rmaintainer@gmail.com}
#'
#' @examples \dontrun{
#'  tryCatch({
#'
#'    # Calculate joint probability a particular sequence of words will appear together
#'    jointProbabilities <- weblmCalculateJointProbability(
#'      inputWords = c("where", "is", "San", "Francisco", "where is",
#'                     "San Francisco", "where is San Francisco"),  # ASCII only
#'      modelToUse = "query",                     # "title"|"anchor"|"query"(default)|"body"
#'      orderOfNgram = 4L                         # 1L|2L|3L|4L|5L(default)
#'    )
#'
#'    # Class and structure of jointProbabilities
#'    class(jointProbabilities)
#'    #> [1] "weblm"
#'
#'    str(jointProbabilities, max.level = 1)
#'    #> List of 3
#'    #>  $ results:'data.frame':  7 obs. of  2 variables:
#'    #>  $ json   : chr "{"results":[{"words":"where","probability":-3.378}, __truncated__ ]}
#'    #>  $ request:List of 7
#'    #>   ..- attr(*, "class")= chr "request"
#'    #>  - attr(*, "class")= chr "weblm"
#'
#'    # Print results
#'    pandoc.table(jointProbabilities$results)
#'    #> ------------------------------------
#'    #>         words           probability
#'    #> ---------------------- -------------
#'    #>         where             -3.378
#'    #>
#'    #>           is              -2.607
#'    #>
#'    #>          san              -3.292
#'    #>
#'    #>       francisco           -4.051
#'    #>
#'    #>        where is           -3.961
#'    #>
#'    #>     san francisco         -4.086
#'    #>
#'    #> where is san francisco    -7.998
#'    #> ------------------------------------
#'
#'  }, error = function(err) {
#'
#'    # Print error
#'    geterrmessage()
#'
#'  })
#' }

weblmCalculateJointProbability <- function(
  inputWords,           # ASCII only
  modelToUse = "body",  # "title"|"anchor"|"query"(default)|"body"
  orderOfNgram = 5L     # 1L|2L|3L|4L|5L(default)
  ) {

  # Validate input params
  stopifnot(is.character(inputWords), length(inputWords) >= 1)
  stopifnot(is.character(modelToUse), length(modelToUse) == 1)
  stopifnot(is.integer(orderOfNgram), orderOfNgram >= 1, orderOfNgram <= 5)

  # Buid list of query parameters
  query <- list(
    model = modelToUse,
    order = orderOfNgram
  )

  # Call the MSCS Web Language Model REST API
  res <- weblmHttr(
    "POST",
    "calculateJointProbability",
    Filter(Negate(is.null), query),
    jsonlite::toJSON(list(queries = inputWords), auto_unbox = TRUE)
  )

  # Extract response
  json <- httr::content(res, "text", encoding = "UTF-8")

  # Build df from JSON results
  results <- jsonlite::fromJSON(json)$results

  # Return results as S3 object of class "weblm"
  weblm(results, json, res$request)
}
