#' Create Codemetar JSON-LD file
#'
#' @description Add JSON-LD file file to make the package more tracable
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#' @seealso [codemetar::create_codemeta]
#'
#' @export
module_write_codemetar <- function(){
  codemetar::write_codemeta(verbose = FALSE, use_filesize = FALSE)

return(TRUE)

}
