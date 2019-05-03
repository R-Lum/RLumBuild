#' Module: set_VersionNumber
#'
#' @description Register C/C++ entry points as required by CRAN
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#' @section Function version: 0.1.0
#'
#' @md
#' @export
module_register_EntryPoints<- function() {

  ##get pkg_name
  pkg_name <- .get_pkg_name()

  ##run registration
  init <- utils::capture.output(tools::package_native_routine_registration_skeleton(".", character_only = FALSE))

  if(length(init) != 0){
    ##add header text
    header <-  c(
      "/* DO NOT CHANGE MANUALLY! */",
      "/* This file was produced by RLumBuild::.module_register_EntryPoints< */")


    ##write file
    write(x = c(header, init), file = paste0("src/", pkg_name, "_init.c"))

  }else{
    invisible(NULL)

  }

  ##return what we have to return
  return(TRUE)
}
