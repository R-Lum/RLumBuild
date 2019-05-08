#' Module: Compile attributes
#'
#' @description Compile C++ attributes if such code is part of the package
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (Frange)
#'
#' @section Function version: 0.1.0
#'
#'
#' @md
#' @export
module_compile_Attributes <- function() {
  Rcpp::compileAttributes()

}
