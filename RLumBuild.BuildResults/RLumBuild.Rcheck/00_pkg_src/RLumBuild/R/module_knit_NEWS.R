#' Module: Knit NEWS
#'
#'
#' @export
module_knit_NEWS <- function() {
  rmarkdown::render("NEWS.Rmd", output_format = "github_document")

}



