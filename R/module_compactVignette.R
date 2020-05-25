#' Module: compact_Vignette
#'
#' @description Try to further downsize the vignette, so far available
#'
#' @author Sebastian Kreutzer, Geography & Earth Sciences, Aberystwyth University (United Kingdom)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_compactVignette <- function() {
  if(dir.exists("vignettes")){
    files <-
      list.files(
        path = "vignettes/",
        pattern = ".pdf",
        full.names = TRUE,
        recursive = FALSE
      )
    tools::compactPDF(files, gs_quality = "screen")
    return(TRUE)

  } else {
    return(FALSE)
  }

}



