#' Module: add RLum-Team and update version timestamp
#'
#' @description If the package was supported by the RLumTeam (the standard) the RLum-Team is added
#' as author to all functions.
#'
#' @author Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.0
#'
#' @md
#' @export
module_add_RLumTeam <- function() {

  # Reading file ------------------------------------------------------------
  file.list.man <- list.files("man/", recursive = TRUE, include.dirs = FALSE, pattern = "\\.Rd",
                              full.names = TRUE)

    ## remove -package from the list
    file.list.man <-  file.list.man[!grepl("-package", file.list.man, fixed = TRUE)]

  # Adding additional information ---------------------------------------------------------------

  ##Adding change time time stamp and the R Luminescence team to as package author
  for (i in file.list.man) {
    temp.file.man <-  readLines(i, warn = FALSE)

    ##search for start field
    author.start <- which(grepl("\\author{",temp.file.man, fixed = TRUE))

    ##add luminescence team as author
    ##to avoid that the field was not found
    if (length(author.start)) {

      ##search for the next curly braces
      temp_id <- grep(pattern = "}", x = temp.file.man, fixed = TRUE)
      author.end <- min(temp_id[temp_id > author.start])

      ##replace this entry
      temp.file.man[author.end] <- ", RLum Developer Team}"

    }

    ##write file
    writeLines(temp.file.man, con = i)

  }


  return(TRUE)

}
