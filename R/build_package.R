#' @title Check and Build Package
#'
#' @description Central function to run the package build process.
#'
#' @param path [character] (with default): set package path
#'
#' @param exclude [character] (optional): names of build modules you want to exclude]
#'
#' @param write_Rbuildignore [logical] (optional): writes are master build-ignore
#'
#' @param as_cran [logical] (with default): enable/disable `--as-cran` check
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#'
#' @section Function version: 0.1.0
#'
#' @examples
#'
#' print("This is only to silence the CRAN check")
#'
#' \dontrun{
#' build_package()
#'
#' }
#'
#' @md
#' @export
build_package <- function(
  path = ".",
  exclude = NULL,
  write_Rbuildignore = TRUE,
  as_cran = FALSE

){

  ##set path
  setwd(path)

  ##get pkg_name
  pkg_name <- .get_pkg_name()

  # Retrive information -------------------------------------------------------------------------
  cli::cat_rule("Environmental information")
  cat(crayon::blue(cli::symbol$arrow_right, "Using 'RLumBuild' version:", packageVersion("RLumBuild"), "\n"),sep = "")
  cat(crayon::blue(cli::symbol$arrow_right, "Working directory: ", getwd(), "\n"),sep = "")
  cat(crayon::blue(cli::symbol$arrow_right, "Package name: ", pkg_name,"\n\n"), sep = "")

  # Prebuild scripts ----------------------------------------------------------------------------
  cli::cat_rule("Pre-build housekeeping")

  ##overwrite or create .Rbuildignore and add package stuff
  ##TODO might become part of an own module
  if(write_Rbuildignore){
    .run_module(text = "Create/overwrite .Rbuildignore with standard ... ",
                f = file.copy(
                  from = system.file("extdata", "temp_Rbuildignore", package="RLumBuild"),
                  to = ".Rbuildignore", overwrite = TRUE))

    ##add folders that start with the pkg_name
    cat(paste0("\n\n# -- Package '",pkg_name,"' stuff -- \n^",pkg_name,"\\..*$"), file=".Rbuildignore", append = TRUE)

  }

  ##check whether we have to create folders
  if(!dir.exists(pkg_name))
    dir.create(paste0(pkg_name, ".BuildResults"), showWarnings = FALSE)

  ##clean-up all files in folder
  ##>> .BuildResults
  .run_module(text = paste0("Clean .BuildResults folder ..."),
              f = file.remove(list.files(
                paste0(pkg_name, ".BuildResults/"),
                full.names = TRUE,
                recursive = TRUE
              )))

  ##>> Various files
  .run_module(text = "Remove .DS_Store ...", f = file.remove(".DS_Store"))
  .run_module(text = "Remove .Rhistory ...", f = file.remove(".Rhistory"))
  .run_module(text = "Remove .RData ...", f = file.remove(".RData"))
  .run_module(text = "Remove .RcppExports.cpp ...", f = file.remove("src/RcppExports.cpp"))
  .run_module(text = "Remove .RcppExports.R ...", f = file.remove("R/RcppExports.R"))
  .run_module(text = "Remove src/*.o ... ", f = file.remove(
    list.files("src/", pattern = "\\.o", recursive = TRUE, full.names = TRUE)))
  .run_module(text = "Remove src/*.so ... ", f = file.remove(
    list.files("src/", pattern = "\\.so", recursive = TRUE, full.names = TRUE)))

  cat("\n")
  cli::cat_rule("Pre-build modules")

  ##>> Update datalist
  if(!"module_update_datalist" %in% exclude)
    .run_module(text = "Update data/datalist ...", f = module_update_datalist())

  ##>> Attributes
  if(!"module_compile_Attributes" %in% exclude)
    .run_module(text = "Compile C/C++ attributes ...",f = module_compile_Attributes())

  #>> build documentation
  if(!"module_build_documentation" %in% exclude)
    .run_module(text = "Build documentation using roxygen2 ...", f = module_build_documentation())

  #>> Update version number
  if(!"module_set_VersionNumber" %in% exclude)
    .run_module(text = "Update DESCRIPTION: date and version number ...", f = module_set_VersionNumber())

  ##>> Add RLum Team
  if(!"module_add_RLumTeam" %in% exclude)
    .run_module(text = "Add RLum Developer Team ...", f = module_add_RLumTeam())

  ##>> Add How to Cite
  if(!"module_add_HowToCite" %in% exclude)
    .run_module(text = "Add 'How to cite' section in manual ...", f = module_add_HowToCite())

  ##>> Knit NEWS
  if(!"module_knit_NEWS" %in% exclude)
    .run_module(text = "Create NEWS.md file ...", f = module_knit_NEWS())

  ##>> Knit README
  if(!"module_knit_README" %in% exclude)
    .run_module(text = "Create README.md file ...", f = module_knit_README())


  # # Build source package ------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Building package")
  devtools::build(pkg = ".", path = paste0(pkg_name,".BuildResults/"))

  # # check package -------------------------------------------------------------------------------
  cat("\n")
  print(devtools::check_built(
    path = list.files(paste0(pkg_name,".BuildResults"), pattern = ".tar.gz", full.names = TRUE, ),
    cran = as_cran,
    incoming = as_cran,
    remote = as_cran,
    force_suggests = TRUE,
    check_dir = paste0(pkg_name,".BuildResults")))

  ##>> Verify example timing
  cat("\n")
  if(!"module_verify_ExampleTimings" %in% exclude)
    .run_module(text = "Verify example timings ...", f = module_verify_ExampleTimings())


  # # Build PDF manual ------------------------------------------------------------------------
  .run_module(text = "Build PDF manual ...", f = devtools::build_manual(pkg = ".", path = paste0(pkg_name,".BuildResults/")))

  ## Outro  -------------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Outro")

  if(!"module_write_BibTeX" %in% exclude)
    .run_module(text = "Create package BibTeX file ...", f = module_write_BibTeX())

  if(!"module_write_FunctionList" %in% exclude)
    .run_module(text = "Create function list (*.html/*.csv/*.md) ...", f = module_write_FunctionList())

  if(!"module_module_write_FunctionList" %in% exclude)
    .run_module(text = "Write function argument table (*.csv) ...", f = module_write_FunctionList())

  if(!"module_write_codemetar" %in% exclude)
      .run_module(text = "Create codemeta ...", f = module_write_codemetar())


  # Install -------------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Install package")
  install.packages(
    pkgs = list.files(paste0(pkg_name,".BuildResults"), pattern = ".tar.gz", full.names = TRUE),
    repos = NULL,
    type = "source",
    clean = TRUE)

  ## Clean-up  -------------------------------------------------------------------------------
  cat("\n")
  cli::cat_rule("Clean-up")

  ##delete check folder
  .run_module(
    text = "Delete .Rcheck folder ...",
    f = unlink(paste0(pkg_name,".BuildResults/",pkg_name,".Rcheck"), recursive = TRUE, force = TRUE))

  ##remove weired files in the src folder
  .run_module(text = "Remove src/*.o ... ", f = file.remove(list.files("src/", pattern = "\\.o", recursive = TRUE, full.names = TRUE)))
  .run_module(text = "Remove src/*.so ... ", f = file.remove(list.files("src/", pattern = "\\.so", recursive = TRUE, full.names = TRUE)))
  .run_module(text = "Remove src/*.rds ... ", f = file.remove(list.files("src/", pattern = "\\.rds", recursive = TRUE, full.names = TRUE)))

  cat("\n")
  cli::cat_rule("[FINE PACKAGE CHECKING AND BUILDING]")

  ## Revers dependency check --------------------------------------------------------------
  if(!"module_check_ReverseDependencies" %in% exclude){
    cat("\n")
    cli::cat_rule("Reverse dependency check")
    .run_module(text = "Reverse dependency check ... ", module_check_ReverseDependencies(), shut_up = FALSE)

  }

}