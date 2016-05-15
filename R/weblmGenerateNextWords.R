
#' @title Returns the words most likely to follow a sequence of words.
#'
#' @description This function returns the list of words (completions) most
#' likely to follow a given sequence of words. The input string must be in ASCII
#' format.
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
#' @param precedingWords (character) Character string to retrieve completions
#' for. Must be in ASCII format.
#'
#' @param modelToUse (character) Which language model to use, supported values:
#' "title", "anchor", "query", or "body" (optional, default: "body")
#'
#' @param orderOfNgram (integer) Which order of N-gram to use, supported values:
#' 1L, 2L, 3L, 4L, or 5L (optional, default: 5L)
#'
#' @param maxNumOfCandidatesReturned (integer) Maximum number of candidates to
#' return (optional, default: 5L)
#'
#' @return An S3 object of the class \code{\link{weblm}}. The results are stored in
#' the \code{results} dataframe inside this object. The dataframe contains the
#' candidate words and their log(probability).
#'
#' @author Phil Ferriere \email{mscs4rmaintainer@gmail.com}
#'
#' @examples \dontrun{
#'  tryCatch({
#'
#'    # Generate next words
#'    wordCandidates <- weblmGenerateNextWords(
#'      precedingWords = "how are you",  # ASCII only
#'      modelToUse = "title",            # "title"|"anchor"|"query"(default)|"body"
#'      orderOfNgram = 4L,               # 1L|2L|3L|4L|5L(default)
#'      maxNumOfCandidatesReturned = 5L  # Default: 5L
#'    )
#'
#'    # Class and structure of wordCandidates
#'    class(wordCandidates)
#'    #> [1] "weblm"
#'
#'    str(wordCandidates, max.level = 1)
#'    #> List of 3
#'    #>  $ results:'data.frame':  5 obs. of  2 variables:
#'    #>  $ json   : chr "{"candidates":[{"word":"doing","probability":-1.105}, __truncated__ ]}
#'    #>  $ request:List of 7
#'    #>   ..- attr(*, "class")= chr "request"
#'    #>  - attr(*, "class")= chr "weblm"
#'
#'    # Print results
#'    pandoc.table(wordCandidates$results)
#'    #> ---------------------
#'    #>   word    probability
#'    #> ------- -------------
#'    #>   doing     -1.105
#'    #>
#'    #>    in       -1.239
#'    #>
#'    #> feeling     -1.249
#'    #>
#'    #>   going     -1.378
#'    #>
#'    #>   today      -1.43
#'    #> ---------------------
#'
#'  }, error = function(err) {
#'
#'    # Print error
#'    geterrmessage()
#'
#'  })
#' }

weblmGenerateNextWords <- function(
  precedingWords,                  # ASCII only
  modelToUse = "body",             # "title"|"anchor"|"query"(default)|"body"
  orderOfNgram = 5L,               # 1L|2L|3L|4L|5L(default)
  maxNumOfCandidatesReturned = 5L  # Default: 5L
  ) {

  # Validate input params
  stopifnot(is.character(precedingWords), length(precedingWords) == 1)
  stopifnot(is.character(modelToUse), length(modelToUse) == 1)
  stopifnot(is.integer(orderOfNgram), orderOfNgram >= 1, orderOfNgram <= 5)
  stopifnot(is.integer(maxNumOfCandidatesReturned), maxNumOfCandidatesReturned >= 1)

  # Buid list of query parameters
  query <- list(model = modelToUse,
                words = precedingWords,
                order = orderOfNgram,
                maxNumOfCandidatesReturned = maxNumOfCandidatesReturned)

  # Call the MSCS Web Language Model REST API
  res <- weblmHttr("POST", "generateNextWords", Filter(Negate(is.null), query))

  # Extract response
  json <- httr::content(res, "text", encoding = "UTF-8")

  # Build df from JSON results
  candidates <- jsonlite::fromJSON(json)$candidates

  # Return results as S3 object of class "weblm"
  weblm(candidates, json, res$request)
}
