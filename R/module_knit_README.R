#' Module: Knit README
#'
#' @description Create README.md from README.Rmd
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_knit_README <- function() {
  rmarkdown::render("README.Rmd", output_format = "github_document")

}



