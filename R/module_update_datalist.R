#' Update datalist
#'
#' @description Updates the file `data/datalist` if available. The standard CRAN functionality
#' only works for data > 1 MB. For whatever reason.
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_update_datalist <- function() {
  ## if nothing exits, nothing needs to be done
  if(!dir.exists("data"))
    return()

  ## get list of files, except datalist
  file_list <- list.files("data", pattern = "[^datalist$]", full.names = TRUE)

  ## extract names and format them
  datalist <- vapply(file_list, function(f){
    name <- tools::file_path_sans_ext(basename(f))
    paste0(name, ": ", paste(load(f), collapse = " "))


  }, character(1), USE.NAMES = FALSE)


  ## write to file
  writeLines(text = datalist, con = "data/datalist")
  return(TRUE)
}
