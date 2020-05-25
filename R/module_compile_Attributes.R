#' Module: Compile attributes
#'
#' @description Compile C++ attributes if such code is part of the package
#'
#' @author Sebastian Kreutzer, Geography & Earth Sciences, Aberystwyth University (United Kingdom)
#'
#' @section Function version: 0.1.0
#'
#'
#' @md
#' @export
module_compile_Attributes <- function() {
  Rcpp::compileAttributes()

}
