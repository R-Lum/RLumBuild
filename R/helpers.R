#'@title RLumBuild Helper Functions
#'
#'@description Helper functions which are used internally to visualise the console output.
#'Those functions are not in the overivew, but are, however, documented
#'
#'@author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#'@keywords internal
#'@md
#'@name helpers
NULL

#'@rdname helpers
#'
#'@param text [character] (with default): text to display in the terminal
#'@md
#'@export
.running <- function(text = ""){
  cat(crayon::yellow(cli::symbol$play), "\t", text, sep = "")

}

#'@rdname helpers
#'@md
#'@export
.success <- function(text = ""){
  cat("\r", crayon::green(cli::symbol$tick), "\t", text, sep = "")

}

#' @rdname helpers
#'
#'@md
#'@export
.failure <- function(text = ""){
  cat("\r", crayon::red(cli::symbol$cross), "\t", text, sep = "")

}

#' @rdname helpers
#'
#'@md
#'@export
.neutral <- function(text = ""){
  cat("\r", crayon::silver(cli::symbol$en_dash), "\t", text, sep = "")

}

#' @rdname helpers
#'
#' @param expr [expression] (**required**): R expression to be excecuted in silence, the results is piped
#' through and the output muted (messages, warnings and usual terminal prints). Errors are returned.
#'
#'@md
#'@export
.shut_up = function(expr) {
  #https://stackoverflow.com/questions/6177629/how-to-silence-the-output-from-this-r-package
  #+ own modifications
  #temp file
  f = file()

  #write output to that file
  sink(file = f)

  #evaluate expr in original environment
  y <- try(suppressWarnings(suppressMessages(eval(expr, envir = parent.frame()))), silent = TRUE)

  #close sink
  sink()

  #get rid of file
  close(f)

  invisible(y)
}


#'@rdname helpers
#'
#'@export f [function] (**required**): function to be run, the results are analysed and
#'summarised using the a one line terminal output
#'
#'@param shut_up [logical] (with default): enables/disables shut_up mode
#'
#'@md
#'@export
.run_module <- function(text = "", f = NULL, shut_up = TRUE){
  .running(text)

  ##run function
  if(shut_up){
    output <- .shut_up(f)

  }else{
    output <- try(eval(f, parent.frame()))

  }


  ##check output
  if(is.null(output) || length(output) == 0 || (class(output[[1]]) == "logical" && output[[1]] == FALSE)){
    .neutral(text)

  }else if(inherits(output, "try-error")){
    .failure(text)
    cat("\n\t", crayon::red(">>", output))

  }else{
    .success(text)

  }

  cat("\n")

  ##return
  invisible(output)

}

#'@rdname helpers
#'
#'@md
#'@export
.get_pkg_name <- function(){
  if(!file.exists("DESCRIPTION"))
    stop("[.get_pkg_name()] It does not look like a package. I could not find a DESCRIPTION!", call. = FALSE)

  strsplit(x = readLines("DESCRIPTION", n = 1, warn = FALSE), split = "Package: ", fixed = TRUE)[[1]][2]

}


#'@rdname helpers
#'
#'@md
#'@export
.get_pkg_version <- function(){
   temp <- readLines("DESCRIPTION", n = 10, warn = FALSE)
   strsplit(x = temp[grepl(pattern = "Version: ", x = temp, fixed = TRUE)], split = "Version: ", fixed = TRUE)[[1]][2]

}