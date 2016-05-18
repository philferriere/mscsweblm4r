
#' @title The \code{weblm} object
#'
#' @description The \code{weblm} object exposes formatted results, the REST API JSON
#' response, and the HTTP request:
#'
#' \itemize{
#'   \item \code{result} the results in \code{data.frame} format
#'   \item \code{json} the REST API JSON response
#'   \item \code{request} the HTTP request
#' }
#'
#' @name weblm
#'
#' @family weblm methods
#'
#' @author Phil Ferriere \email{pferriere@hotmail.com}
NULL

weblm <- function(results = NULL, json = NULL, request = NULL) {

  # Validate input params
  if (!is.null(results))
    stopifnot(is.data.frame(results))
  if (!is.null(json))
    stopifnot(is.character(json), length(json) == 1)
  if (!is.null(request))
    stopifnot(class(request) == "request")

  # Return results as S3 object of class "weblm"
  structure(list(results = results, json = json, request = request), class = "weblm")
}

is.weblm <- function(x) {
  inherits(x, "weblm")
}

#' @export
print.weblm <- function(x, ...) {

  cat("weblm [", x$request$url, "]\n", sep = "")
  aintNoVT100NoMo <- panderOptions("table.split.table")
  panderOptions("table.split.table", getOption("width"))
  pandoc.table(x$results)
  panderOptions("table.split.table", aintNoVT100NoMo)

}
