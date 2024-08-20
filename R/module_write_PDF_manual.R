#' Create PDF Manual
#'
#' @description Build PDF Manual tar.gz is available
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#' @seealso [devtools::build_manual]
#'
#' @export
module_write_PDF_manual <- function(){
  devtools::build_manual(pkg = ".", path = paste0(.get_pkg_name(),".BuildResults/"))

  return(TRUE)

}
