
#' Create Package BibTeX file
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#'
#' @section Function version: 0.1.0
#'
#' @export
module_write_BibTeX <- function(){

##get version number and package name
temp <- readLines("DESCRIPTION", n = 1)

pkg_name <- trimws(unlist(strsplit(temp[1], split = "Package:", fixed = TRUE))[2])
pkg_version <- trimws(
  unlist(strsplit(temp[grepl(pattern = "Version:", x = temp, fixed = TRUE)], split = "Version:", fixed = TRUE))[2])

package.citation <- utils::toBibtex(citation(pkg_name))
write(package.citation, file=paste0(pkg_name,".BuildResults/",pkg_name,"_", pkg_version,"-bibliography.bib"))

return(TRUE)

}
