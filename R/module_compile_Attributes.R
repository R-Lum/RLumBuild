#' Module: Compile attributes
#'
#' @description Compile C++ attributes if such code is part of the package
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#'
#' @md
#' @export
module_compile_Attributes <- function() {
  Rcpp::compileAttributes()

}
