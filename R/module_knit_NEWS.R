#' Module: Knit NEWS
#'
#' @description Create NEWS.md from NEWS.Rmd
#'
#' @author Sebastian Kreutzer, Geography & Earth Sciences, Aberystwyth University (United Kingdom)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_knit_NEWS <- function() {
  rmarkdown::render("NEWS.Rmd", output_format = "github_document")

}



