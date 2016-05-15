
.pkgenv <- new.env(parent = emptyenv())

.onAttach <- function(libname, pkgname) {

  weblmConfigure()

}
