## ----echo=FALSE----------------------------------------------------------
# Build with devtools::install(build_vignettes = TRUE)
library("knitr")
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)

## ----eval=FALSE----------------------------------------------------------
#  if ("mscsweblm4r" %in% installed.packages()[,"Package"] == FALSE) {
#    install.packages("mscsweblm4r", repos = "http://cran.us.r-project.org")
#  }

## ----eval=FALSE----------------------------------------------------------
#  if ("mscsweblm4r" %in% installed.packages()[,"Package"] == FALSE) {
#    if ("devtools" %in% installed.packages()[,"Package"] == FALSE) {
#      install.packages("devtools", repos = "http://cran.us.r-project.org")
#    }
#    devtools::install_github("philferriere/mscsweblm4r")
#  }

## ------------------------------------------------------------------------
tryCatch({

  library('mscsweblm4r')

}, error = function(err) {

  geterrmessage()

})

## ----eval=FALSE----------------------------------------------------------
#  Error : .onAttach failed in attachNamespace() for 'mscsweblm4r', details:
#    call: NULL
#    error: mscsweblm4r: could not find MSCS_WEBLANGUAGEMODEL_KEY or MSCS_WEBLANGUAGEMODEL_URL in Sys env nor locate ~/.mscskeys.json
#  [1] "package or namespace load failed for 'mscsweblm4r'"

## ----eval = FALSE--------------------------------------------------------
#    # Retrieve a list of supported web language models
#    weblmListAvailableModels()

## ----eval = FALSE--------------------------------------------------------
#    # Break a string of concatenated words into individual words
#    weblmBreakIntoWords(
#      textToBreak,                      # ASCII only
#      modelToUse = "body",              # "title"|"anchor"|"query"(default)|"body"
#      orderOfNgram = 5L,                # 1L|2L|3L|4L|5L(default)
#      maxNumOfCandidatesReturned = 5L   # Default: 5L
#    )

## ----eval = FALSE--------------------------------------------------------
#    # Get the words most likely to follow a sequence of words
#    weblmGenerateNextWords(
#      precedingWords,                  # ASCII only
#      modelToUse = "title",            # "title"|"anchor"|"query"(default)|"body"
#      orderOfNgram = 4L,               # 1L|2L|3L|4L|5L(default)
#      maxNumOfCandidatesReturned = 5L  # Default: 5L
#    )

## ----eval = FALSE--------------------------------------------------------
#    # Calculate joint probability a particular sequence of words will appear together
#    weblmCalculateJointProbability(
#      inputWords =,                    # ASCII only
#      modelToUse = "query",            # "title"|"anchor"|"query"(default)|"body"
#      orderOfNgram = 4L                # 1L|2L|3L|4L|5L(default)
#    )

## ----eval = FALSE--------------------------------------------------------
#    # Calculate conditional probability a particular word will follow a given sequence of words
#    weblmCalculateConditionalProbability(
#      precedingWords,                  # ASCII only
#      continuations,                   # ASCII only
#      modelToUse = "title",            # "title"|"anchor"|"query"(default)|"body"
#      orderOfNgram = 4L                # 1L|2L|3L|4L|5L(default)
#    )

## ------------------------------------------------------------------------
tryCatch({

  # Retrieve a list of supported web language models
  weblmListAvailableModels()

}, error = function(err) {

 # Print error
 geterrmessage()

})

## ------------------------------------------------------------------------
tryCatch({

  # Break a sentence into words
  weblmBreakIntoWords(
    textToBreak = "testforwordbreak", # ASCII only
    modelToUse = "body",              # "title"|"anchor"|"query"(default)|"body"
    orderOfNgram = 5L,                # 1L|2L|3L|4L|5L(default)
    maxNumOfCandidatesReturned = 5L   # Default: 5L
  )

}, error = function(err) {

  # Print error
  geterrmessage()

})

## ------------------------------------------------------------------------
tryCatch({

  # Generate next words
  weblmGenerateNextWords(
    precedingWords = "how are you",  # ASCII only
    modelToUse = "title",            # "title"|"anchor"|"query"(default)|"body"
    orderOfNgram = 4L,               # 1L|2L|3L|4L|5L(default)
    maxNumOfCandidatesReturned = 5L  # Default: 5L
  )

}, error = function(err) {

  # Print error
  geterrmessage()

})

## ------------------------------------------------------------------------
tryCatch({

  # Calculate joint probability a particular sequence of words will appear together
  weblmCalculateJointProbability(
    inputWords = c("where", "is", "San", "Francisco", "where is",
                   "San Francisco", "where is San Francisco"),  # ASCII only
    modelToUse = "query",                     # "title"|"anchor"|"query"(default)|"body"
    orderOfNgram = 4L                         # 1L|2L|3L|4L|5L(default)
  )

}, error = function(err) {

  # Print error
  geterrmessage()

})

## ------------------------------------------------------------------------
tryCatch({

  # Calculate conditional probability a particular word will follow a given sequence of words
  weblmCalculateConditionalProbability(
    precedingWords = "hello world wide",       # ASCII only
    continuations = c("web", "range", "open"), # ASCII only
    modelToUse = "title",                      # "title"|"anchor"|"query"(default)|"body"
    orderOfNgram = 4L                          # 1L|2L|3L|4L|5L(default)
  )

}, error = function(err) {

  # Print error
  geterrmessage()

})

