#' Check Reverse Dependencies
#'
#' @description Check the reverse dependencies of the package
#'
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#' @export
module_check_ReverseDependencies <- function(){

##set local CRAN mirror, otherwise it does not really work!
local({r <- getOption("repos"); r["CRAN"] <- "https://cran.rstudio.com/"; options(repos = r)})

cat("\n")

##get package name
pkg_name <- .get_pkg_name()

##devtools looks nice but had a lot of problems, so we
##do it the old fashion way
results <-
  tools::check_packages_in_dir(
    dir = paste0(getwd(), "/", pkg_name, ".BuildResults/"),
    reverse = list(
      repos = getOption("repos")["CRAN"],
      which = "most"),
    clean = TRUE
  )

##show results
return(summary(results))

}
