
#' @title Calculates the conditional probability that a word follows a sequence
#' of words.
#'
#' @description This function calculates the conditional probability that a
#' particular word will follow a given sequence of words. The input string must
#' be in ASCII format.
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
#' @param precedingWords (character) Character string for which to calculate
#' continuation probabilities. Must be in ASCII format.
#'
#' @param continuations (character vector) Vector of words following
#' \code{precedingWords} for which to calculate conditional probabilities.
#'
#' @param modelToUse (character) Which language model to use, supported values:
#' "title", "anchor", "query", or "body" (optional, default: "body")
#'
#' @param orderOfNgram (integer) Which order of N-gram to use, supported values:
#' 1L, 2L, 3L, 4L, or 5L (optional, default: 5L)
#'
#' @return An S3 object of the class \code{\link{weblm}}. The results are stored in
#' the \code{results} dataframe inside this object. The dataframe contains the
#' continuation words and their log(probability).
#'
#' @author Phil Ferriere \email{pferriere@hotmail.com}
#'
#' @examples \dontrun{
#'  tryCatch({
#'
#'    # Calculate conditional probability a particular word will follow a given sequence of words
#'    conditionalProbabilities <- weblmCalculateConditionalProbability(
#'      precedingWords = "hello world wide",       # ASCII only
#'      continuations = c("web", "range", "open"), # ASCII only
#'      modelToUse = "title",                      # "title"|"anchor"|"query"(default)|"body"
#'      orderOfNgram = 4L                          # 1L|2L|3L|4L|5L(default)
#'    )
#'
#'    # Class and structure of conditionalProbabilities
#'    class(conditionalProbabilities)
#'    #> [1] "weblm"
#'
#'    str(conditionalProbabilities, max.level = 1)
#'    #> List of 3
#'    #>  $ results:'data.frame':  3 obs. of  3 variables:
#'    #>  $ json   : chr "{"results":[{"words":"hello world wide","word":"web", __truncated__ }]}
#'    #>  $ request:List of 7
#'    #>   ..- attr(*, "class")= chr "request"
#'    #>  - attr(*, "class")= chr "weblm"
#'
#'    # Print results
#'    pandoc.table(conditionalProbabilities$results)
#'    #> -------------------------------------
#'    #>      words        word   probability
#'    #> ---------------- ------ -------------
#'    #> hello world wide   web      -0.32
#'    #>
#'    #> hello world wide range     -2.403
#'    #>
#'    #> hello world wide  open      -2.97
#'    #> -------------------------------------
#'
#'  }, error = function(err) {
#'
#'    # Print error
#'    geterrmessage()
#'
#'  })
#' }

weblmCalculateConditionalProbability <- function(
  precedingWords,       # ASCII only
  continuations,        # ASCII only
  modelToUse = "body",  # "title"|"anchor"|"query"(default)|"body"
  orderOfNgram = 5L     # 1L|2L|3L|4L|5L(default)
  ) {

  # Validate input params
  stopifnot(is.character(precedingWords), length(precedingWords) == 1)
  stopifnot(is.character(continuations), length(continuations) >= 1)
  stopifnot(is.character(modelToUse), length(modelToUse) == 1)
  stopifnot(is.integer(orderOfNgram), orderOfNgram >= 1, orderOfNgram <= 5)

  # Buid list of query parameters
  query <- list(
    model = modelToUse,
    order = orderOfNgram
  )

  # Combine text inputs in df easy to JSON encode
  df <- data.frame(words = rep(precedingWords, length(continuations)), word = continuations)

  # Call the MSCS Web Language Model REST API
  res <- weblmHttr(
    "POST",
    "calculateConditionalProbability",
    Filter(Negate(is.null), query),
    jsonlite::toJSON(list(queries = df), auto_unbox = TRUE)
  )

  # Extract response
  json <- httr::content(res, "text", encoding = "UTF-8")

  # Build df from JSON results
  results <- jsonlite::fromJSON(json)$results

  # Return results as S3 object of class "weblm"
  weblm(results, json, res$request)
}
