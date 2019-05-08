#' Module: Knit NEWS
#'
#' @description Create NEWS.md from NEWS.Rmd
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_knit_NEWS <- function() {
  rmarkdown::render("NEWS.Rmd", output_format = "github_document")

}



