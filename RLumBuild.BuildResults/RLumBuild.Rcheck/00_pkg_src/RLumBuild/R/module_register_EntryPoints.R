#' Module: set_VersionNumber
#'
#' @param pkg_name [character] the name of the package
#'
#' @md
#' @export
module_register_EntryPoints<- function(pkg_name) {
  ##run registration
  init <- utils::capture.output(tools::package_native_routine_registration_skeleton(".", character_only = FALSE))

  if(length(init) != 0){
  ##add header text
  header <-  c(
    "/* DO NOT CHANGE MANUALLY! */",
    "/* This file was produced by RLumBuild::.module_register_EntryPoints< */")

  ##write file
  write(x = c(header, init), file = "src/", pkg_name, "_init.c")
  }else{
    invisible(NULL)

  }

}
