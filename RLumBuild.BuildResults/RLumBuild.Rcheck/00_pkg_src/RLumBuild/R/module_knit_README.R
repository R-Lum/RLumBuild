#' Module: Knit README
#'
#' @export
module_knit_README <- function() {
  rmarkdown::render("README.Rmd", output_format = "github_document")

}



