#' Module: Knit README
#'
#' @description Create README.md from README.Rmd
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_knit_README <- function() {
  rmarkdown::render("README.Rmd", output_format = "github_document")

}



