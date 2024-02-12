#' Create Package BibTeX file
#'
#' @description A BibTeX file to be used to cite the package is automatically created.
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#' @export
module_write_BibTeX <- function(){

##get version number and package name
pkg_name <- .get_pkg_name()
pkg_version <- .get_pkg_version()

package.citation <- utils::toBibtex(citation(pkg_name))
write(package.citation, file=paste0(pkg_name,".BuildResults/",pkg_name,"_", pkg_version,"-bibliography.bib"))

return(TRUE)

}
