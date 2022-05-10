#' @title Module: Build Documentation
#'
#' @description Create documentation using roxygen2
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#'
#' @md
#' @export
module_build_documentation <- function() {

   ##this is a workaroung and might not be necessary in the future
   pkgbuild::compile_dll()

   ##create documentation
   roxygen2::roxygenise(package.dir = ".", clean = TRUE)

}



