#' @title Check and Build Package
#'
#' @param exclude [character] (optional): names of build modules you want to exclude
#'
#' @param as_cran [logical] (with default): enable/disable `--as-cran` check
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#' @md
#' @export
build_package <- function(
  exclude = NULL,
  as_cran = FALSE

){

  ##check package name, which should be the folder name
  pkg_name <- basename(getwd())

  # Prebuild scripts ----------------------------------------------------------------------------
  cli::cat_rule("Pre-build clean-up")

  ##check whether we have to create folders
  if(!dir.exists(pkg_name))
    dir.create(paste0(pkg_name, ".BuildResults"), showWarnings = FALSE)

  ##clean-up all files in folder
  ##>> .BuildResults
  .run_module(text = paste0("Clean .BuildResults folder"),
              f = file.remove(list.files(
                paste0(pkg_name, ".BuildResults/"),
                full.names = TRUE,
                recursive = TRUE
              )))

  ##>> Various files
  .run_module(text = "Remove .DS_Store", f = file.remove(".DS_Store"))
  .run_module(text = "Remove .Rhistory", f = file.remove(".Rhistory"))
  .run_module(text = "Remove .Rhistory", f = file.remove(".Rhistory"))
  .run_module(text = "Remove .RData", f = file.remove(".RData"))
  .run_module(text = "Remove .RcppExports.cpp", f = file.remove("src/RcppExports.cpp"))
  .run_module(text = "Remove .RcppExports.R", f = file.remove("R/RcppExports.R"))

  cat("\n")
  cli::cat_rule("Pre-build modules")

  ##>> Knit NEWS
  if(!"module_knit_NEWS" %in% exclude)
    .run_module(text = "Create NEWS.md file", f = module_knit_NEWS())

  ##>> Knit README
  if(!"module_knit_README" %in% exclude)
    .run_module(text = "Create README.md file", f = module_knit_README())

  ##>> Attributes
  if(!"module_compile_Attributes" %in% exclude)
    .run_module(text = "Compile C/C++ attributes ",f = module_compile_Attributes())

  #>> build documentation
  if(!"module_build_documentation" %in% exclude)
    .run_module(text = "Build documentation using roxygen2", f = module_build_documentation())

  #>> Update version number
  if(!"module_set_VersionNumber" %in% exclude)
    .run_module(text = "Update DESCRIPTION: date and version number", f = module_set_VersionNumber())

  ##>> Register Entry points
  if(!"module_register_EntryPoints" %in% exclude)
    .run_module(text = "Register C/C++ entry points", f = module_register_EntryPoints())

  ##>> Add RLum-Team
  if(!"module_add_HowToCite" %in% exclude)
    .run_module(text = "Add 'How to cite' section in manual ", f = module_add_HowToCite())


  # # Build source package ------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Building package")
  devtools::build(pkg = ".", path = paste0(pkg_name,".BuildResults/"))

  # # check package -------------------------------------------------------------------------------
  cat("\n")
  devtools::check_built(
    path = list.files(paste0(pkg_name,".BuildResults"), pattern = ".tar.gz", full.names = TRUE, ),
    cran = as_cran,
    force_suggests = TRUE,
    check_dir = paste0(pkg_name,".BuildResults"))

  ##>> Verify example timing
  cat("\n")
  if(!"module_verify_ExampleTimings" %in% exclude)
    .run_module(text = "Verify example timings ...", f = module_verify_ExampleTimings())


  # # Build PDF manual ------------------------------------------------------------------------
  .run_module(text = "Build PDF manual ...", f = devtools::build_manual(pkg = ".", path = paste0(pkg_name,".BuildResults/")))

  # Install -------------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Install package")
  install.packages(
    pkgs = list.files(paste0(pkg_name,".BuildResults"), pattern = ".tar.gz", full.names = TRUE),
    repos = NULL,
    type = "source",
    clean = TRUE)

  ## Install -------------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Outro")



}