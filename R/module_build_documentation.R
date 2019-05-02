#' @title Module: Build Documentation
#'
#' @md
#' @export
module_build_documentation <- function() {
   roxygen2::roxygenise(package.dir = ".", clean = TRUE)

}



