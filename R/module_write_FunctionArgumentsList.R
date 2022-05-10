#' Write Function Argument List
#'
#' @description Create a spread-sheet table with all function arguments
#'
#' @details Pevious versions were written by Michael Dietze and Sebastian Kreutzer.
#' This version programmatically fetches all functions and arguments and does
#' not rely on parsing the .Rd files with regular expressions.
#'
#' @author Christoph Burow, Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#' @export
module_write_FunctionList <- function() {
  ##get basic information
  pkg_name <- .get_pkg_name()
  pkg_version <- .get_pkg_version()
  do.call(library, list(pkg_name))

  ##get package arguments
  args <- sapply(lsf.str(paste0("package:", pkg_name)), formalArgs)

  ##replace functions with no argument (NULL) with NA
  args[sapply(args, is.null)] <- NA

  ##set matrix
  M <-
    matrix(NA, ncol = length(args), nrow = max(sapply(args, length)))

  for (i in 1:ncol(M)) {
    M[1:length(args[[i]]), i] <- args[[i]]
  }

  ##set column names
  colnames(M) <- names(args)

  ##write table
  write.table(
    x = M,
    row.names = FALSE,
    file = paste0(
      pkg_name,
      ".BuildResults/",
      pkg_name,
      "_",
      pkg_version,
      "-Function_Arguments.csv"
    ),
    sep = ","
  )

  return(TRUE)

}

