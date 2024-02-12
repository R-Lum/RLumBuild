#' Create Dependency Graph
#'
#' @description Create package dependency graph
#'
#' @details The script based on:
## https://cran.r-project.org/web/packages/miniCRAN/vignettes/miniCRAN-dependency-graph.html
#'
#'
#' @param Rversion [character] (with default): R version for which the graph is created
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @note Module currently not acctivated
#'
#' @section Function version: 0.1.0
#'
#' @export
module_create_DependencyGraph <- function(
 Rversion = paste(R.version[c("major", "minor")], collapse = ".")

){

##get package name
pkg_name <- .get_pkg_name()

##get graph
graph <- miniCRAN::makeDepGraph(
  pkg = pkg_name,
  availPkgs = miniCRAN::pkgAvail(
    repos = getOption("repos"),
    type = "source",
    Rversion = Rversion
  ),
  enhances = TRUE,
  suggests = TRUE,
  includeBasePkgs = FALSE
)

plot(graph, legendPosition = c(-1, 1), cex = 0.7,  vertex.size=10)

}
