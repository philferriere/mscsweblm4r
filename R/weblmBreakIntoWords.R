
#' @title Breaks a string of concatenated words into individual words
#'
#' @description This function inserts spaces into a string of words lacking spaces,
#' like a hashtag or part of a URL. Punctuation or exotic characters can prevent
#' a string from being broken, so it's best to limit input strings to lower-case,
#' alpha-numeric characters. The input string must be in ASCII format.
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
#' @param textToBreak (character) Line of text to break into words. If spaces
#' are present, they will be interpreted as hard breaks and maintained, except
#' for leading or trailing spaces, which will be trimmed. Must be in ASCII format.
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
#' candidate breakdowns and their log(probability).
#'
#' @author Phil Ferriere \email{mscs4rmaintainer@gmail.com}
#'
#' @examples \dontrun{
#'  tryCatch({
#'
#'    # Break a sentence into words
#'    textWords <- weblmBreakIntoWords(
#'      textToBreak = "testforwordbreak", # ASCII only
#'      modelToUse = "body",              # "title"|"anchor"|"query"(default)|"body"
#'      orderOfNgram = 5L,                # 1L|2L|3L|4L|5L(default)
#'      maxNumOfCandidatesReturned = 5L   # Default: 5L
#'    )
#'
#'    # Class and structure of textWords
#'    class(textWords)
#'    #> [1] "weblm"
#'
#'    str(textWords, max.level = 1)
#'    #> List of 3
#'    #>  $ results:'data.frame':  5 obs. of  2 variables:
#'    #>  $ json   : chr "{"candidates":[{"words":"test for word break", __truncated__ }]}
#'    #>  $ request:List of 7
#'    #>   ..- attr(*, "class")= chr "request"
#'    #>  - attr(*, "class")= chr "weblm"
#'
#'    # Print results
#'    pandoc.table(textWords$results)
#'    #> ---------------------------------
#'    #>       words          probability
#'    #> ------------------- -------------
#'    #> test for word break    -13.83
#'    #>
#'    #>  test for wordbreak    -14.63
#'    #>
#'    #>  testfor word break    -15.94
#'    #>
#'    #>  test forword break    -16.72
#'    #>
#'    #>   testfor wordbreak    -17.41
#'    #> ---------------------------------
#'
#'  }, error = function(err) {
#'
#'    # Print error
#'    geterrmessage()
#'
#'  })
#' }

weblmBreakIntoWords <- function(
  textToBreak,                     # ASCII only
  modelToUse = "body",             # "title"|"anchor"|"query"(default)|"body"
  orderOfNgram = 5L,               # 1L|2L|3L|4L|5L(default)
  maxNumOfCandidatesReturned = 5L  # Default: 5
  ) {

  # Validate input params
  stopifnot(is.character(textToBreak), length(textToBreak) == 1)
  stopifnot(is.character(modelToUse), length(modelToUse) == 1)
  stopifnot(is.integer(orderOfNgram), orderOfNgram >= 1, orderOfNgram <= 5)
  stopifnot(is.integer(maxNumOfCandidatesReturned), maxNumOfCandidatesReturned >= 1)

  # Buid list of query parameters
  query <- list(model = modelToUse,
                text = textToBreak,
                order = orderOfNgram,
                maxNumOfCandidatesReturned = maxNumOfCandidatesReturned)

  # Call the MSCS Web Language Model REST API
  res <- weblmHttr("POST", "breakIntoWords", Filter(Negate(is.null), query))

  # Extract response
  json <- httr::content(res, "text", encoding = "UTF-8")

  # Build df from JSON results
  candidates <- jsonlite::fromJSON(json)$candidates

  # Return results as S3 object of class "weblm"
  weblm(candidates, json, res$request)
}
