
#' @title Initializes the \pkg{mscsweblm4r} package.
#'
#' @description This function initializes the Microsoft Cognitive Services Web
#' Language Model REST API key and URL by reading them either from a
#' configuration file or environment variables.
#'
#' This function \strong{MUST} be called right after package load and before calling
#' any \pkg{mscsweblm4r} core functions, or these functions will fail.
#'
#' The \code{\link{weblmInit}} configuration function will first check to see
#' if the variable \code{MSCS_WEBLANGUAGEMODEL_CONFIG_FILE} exists in the system
#' environment. If it does, the package will use that as the path to the
#' configuration file.
#'
#' If \code{MSCS_WEBLANGUAGEMODEL_CONFIG_FILE} doesn't exist, it will look for
#' the file \code{.mscskeys.json} in the current user's home directory (that's
#' \code{~/.mscskeys.json} on Linux, and something like \code{C:/Users/Phil/Documents/.mscskeys.json}
#' on Windows). If the file is found, the package will load the API key and URL
#' from it.
#'
#' If using a file, please make sure it has the following structure:
#'
#' \preformatted{
#' {
#'   "weblanguagemodelurl": "https://api.projectoxford.ai/text/weblm/v1.0/",
#'   "weblanguagemodelkey": "...MSCS Web Language Model API key goes here..."
#' }
#' }
#'
#' If no configuration file is found, \code{\link{weblmInit}} will attempt to
#' pick up its configuration information from two Sys env variables instead:
#'
#' \code{MSCS_WEBLANGUAGEMODEL_URL} - the URL for the Web LM REST API.
#'
#' \code{MSCS_WEBLANGUAGEMODEL_KEY} -  your personal Web LM REST API key.
#'
#' \code{\link{weblmInit}} needs to be called \emph{only once}, after package
#' load.
#'
#' @export
#'
#' @author Phil Ferriere \email{pferriere@hotmail.com}
#'
#' @examples \dontrun{
#'  weblmInit()
#' }
weblmInit <- function() {

  # Get config info from file
  configFile <- weblmGetConfigFile()

  if (file.exists(configFile)) {

    weblm <- jsonlite::fromJSON(configFile)

    if (is.null(weblm[["weblanguagemodelkey"]])) {
      assign("weblm", NULL, envir = .weblmpkgenv)
      stop(paste0("mscsweblm4r: Field 'weblanguagemodelkey' either empty or missing from ", configFile), call. = FALSE)
    } else if (is.null(weblm[["weblanguagemodelurl"]])) {
      assign("weblm", NULL, envir = .weblmpkgenv)
      stop(paste0("mscsweblm4r: Field 'weblanguagemodelurl' either empty or missing from ", configFile), call. = FALSE)
    } else {
      weblm[["weblanguagemodelconfig"]] <- configFile
      assign("weblm", weblm, envir = .weblmpkgenv)
    }

  } else {

    # Get config info from Sys env, if config file is missing
    weblm <- list(
      weblanguagemodelkey = Sys.getenv("MSCS_WEBLANGUAGEMODEL_KEY", ""),
      weblanguagemodelurl = Sys.getenv("MSCS_WEBLANGUAGEMODEL_URL", ""),
      weblanguagemodelconfig = ""
    )

    if (weblm[["weblanguagemodelkey"]] == "" || weblm[["weblanguagemodelurl"]] == "") {
      assign("weblm", NULL, envir = .weblmpkgenv)
      stop("mscsweblm4r: could not load config info from Sys env nor from file", call. = FALSE)
    } else {
      assign("weblm", weblm, envir = .weblmpkgenv)
    }

  }
}

## The next seven \pkg{mscsweblm4r} internal functions are used to facilitate
## configuration and assist with error handling:
##
## \itemize{
##  \item API URL configuration - \code{\link{weblmGetURL}}, \code{\link{weblmSetURL}} functions
##  \item API key configuration - \code{\link{weblmGetKey}}, \code{\link{weblmSetKey}} functions
##  \item Package configuration file - \code{\link{weblmGetConfigFile}}, \code{\link{weblmSetConfigFile}} functions
##  \item Httr assist - \code{\link{weblmHttr}} function
## }
##

## @title Retrieves the Microsoft Cognitive Services Web Language Model REST API key.
##
## Do not call this internal function outside this package.
##
## @return A character string with the value of the API key.
##
## @author Phil Ferriere \email{pferriere@hotmail.com}
##
## @examples \dontrun{
##  weblmGetKey()
## }
weblmGetKey <- function() {

  if (!is.null(.weblmpkgenv$weblm))
    .weblmpkgenv$weblm[["weblanguagemodelkey"]]
  else
    stop("mscsweblm4r: REST API key not found in package environment.", call. = FALSE)

}

## @title Retrieves the Microsoft Cognitive Services Web Language Model REST API base URL.
##
## @return A character string with the value of the REST API base URL.
##
## Do not call this internal function outside this package.
##
## @author Phil Ferriere \email{pferriere@hotmail.com}
##
## @examples \dontrun{
##  weblmGetURL()
## }
weblmGetURL <- function() {

  if (!is.null(.weblmpkgenv$weblm))
    .weblmpkgenv$weblm[["weblanguagemodelurl"]]
  else
    stop("mscsweblm4r: REST API URL not found in package environment.", call. = FALSE)

}

## @title Retrieves the path to the configuration file.
##
## @return A character string with the path to the configuration file. This path
## may be empty if the package was configured using environment variables.'
##
## Do not call this internal function outside this package.
##
## @author Phil Ferriere \email{pferriere@hotmail.com}
##
## @examples \dontrun{
##  weblmGetConfigFile()
## }
weblmGetConfigFile <- function() {

  if (!is.null(.weblmpkgenv$weblm))
    .weblmpkgenv$weblm[["weblanguagemodelconfig"]]
  else {
    weblanguagemodelconfig = Sys.getenv("MSCS_WEBLANGUAGEMODEL_CONFIG_FILE", "")
    if (weblanguagemodelconfig == "") {
      if (file.exists("~/.mscskeys.json"))
        weblanguagemodelconfig = "~/.mscskeys.json"
    }
    weblanguagemodelconfig
  }

}

## @title Sets the Microsoft Cognitive Services Web Language Model REST API key.
##
## @description This function sets the Microsoft Cognitive Services Web Language
## Model REST API key. It is only used for testing purposes, to make sure that
## the package fails gracefully when using an invalid key.
##
## Do not call this internal function outside this package.
##
## @param key (character) REST API key to use
##
## @author Phil Ferriere \email{pferriere@hotmail.com}
##
## @examples \dontrun{
##  mscsweblm4r:::weblmSetKey("invalid-key")
## }
weblmSetKey <- function(key) {

  if (!is.null(.weblmpkgenv$weblm)) {
    .weblmpkgenv$weblm[["weblanguagemodelkey"]] <- key
  }
  else
    stop("mscsweblm4r: The package wasn't initialized properly.", call. = FALSE)

}

## @title Sets the Microsoft Cognitive Services Web Language Model REST API URL.
##
## @description This function sets the Microsoft Cognitive Services Web Language
## Model REST API URL. It is only used for testing purposes, to make sure that
## the package fails gracefully when the URL is misconfigured.
##
## Do not call this internal function outside this package.
##
## @param url (character) REST API URL to use
##
## @author Phil Ferriere \email{pferriere@hotmail.com}
##
## @examples \dontrun{
##  mscsweblm4r:::weblmSetURL("invalid-URL")
## }
weblmSetURL <- function(url) {

  if (!is.null(.weblmpkgenv$weblm))
    .weblmpkgenv$weblm[["weblanguagemodelurl"]] <- url
  else
    stop("mscsweblm4r: The package wasn't initialized properly.", call. = FALSE)

}

## @title Sets the file path for the configuration file.
##
## @description This function sets the file path for the configuration file. It
## is only used for testing purposes, to make sure that the package fails
## gracefully when the the configuration file is missing/compromised.
##
## Do not call this internal function outside this package.
##
## @param path (character) File path for the configuration file
##
## @author Phil Ferriere \email{pferriere@hotmail.com}
##
## @examples \dontrun{
##  weblmSetConfigFile("invalid-path")
## }
weblmSetConfigFile <- function(path) {

  if (!is.null(.weblmpkgenv$weblm))
    .weblmpkgenv$weblm[["weblanguagemodelconfig"]] <- path
  else
    stop("mscsweblm4r: The package wasn't initialized properly.", call. = FALSE)

}
