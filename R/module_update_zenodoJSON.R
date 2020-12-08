#' Module: Update .zenodo.json file
#'
#' @description Automatically update the .zenodo.json file
#'
#' @details A small helper to make sure that we have not to take care
#' update `version`, `title` and `description` in the `zenodo.json` file
#'
#' @author Sebastian Kreutzer, Geography & Earth Sciences, Aberystwyth University (United Kingdom)
#'
#' @section Function version: 0.1.0
#'
#'
#' @export
module_update_zenodoJSON<- function() {

  #check whether we have such a file, if not do nothing
  if(!file.exists(".zenodo.json"))
    return(NULL)

# Read DESCRIPTION --------------------------------------------------------
  ##read DESCRIPTION and deparse DECRIPTION
  temp <- readLines("DESCRIPTION")

  version <- .get_pkg_version()
  package <- .get_pkg_name()
  title <- regmatches(x = temp, regexpr("(?<=Title:\\s).*", temp, perl = TRUE))
  description <- paste0(
    "<p>",
    regmatches(x = temp, regexpr("(?<=Description:\\s).*", temp, perl = TRUE)),
    "</p>")

# Read JSON ---------------------------------------------------------------
  ##import
  json <- jsonlite::fromJSON(txt = ".zenodo.json", simplifyVector = FALSE)

  ##update
  json$title <- paste0(package,": ", title)
  json$description <- description
  json$version <- version

# Write JSON --------------------------------------------------------------
  jsonlite::write_json(x = json, path = ".zenodo.json", pretty = TRUE)

  return(TRUE)

}

