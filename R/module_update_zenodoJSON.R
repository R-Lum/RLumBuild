#' Module: Update .zenodo.json file
#'
#' @description Automatically update the .zenodo.json file
#'
#' @details
#' A small helper to keep the `zenodo.json` file up to date. This takes care
#' of the `version`, `title` and `description` fields. It the pacakge uses the
#' `Authors@R` field, the funcion will warn if the author list needs to be
#' updated manually (it cannot be done automatically because we do not record
#' the affiliation in the DESCRIPTION file).
#'
#' @author
#' Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)\cr
#' Marco Colombo, Institute of Geography, Heidelberg University (Germany)
#'
#' @section Function version: 0.1.1
#'
#' @export
module_update_zenodoJSON <- function() {

  #check whether we have such a file, if not do nothing
  if(!file.exists(".zenodo.json"))
    return(NULL)

# Read DESCRIPTION --------------------------------------------------------
  ##read DESCRIPTION and deparse DECRIPTION
  desc <- read.dcf("DESCRIPTION", c("Package", "Version", "Date", "Title",
                                    "Description", "Authors@R"))

# Read JSON ---------------------------------------------------------------
  ##import
  json <- jsonlite::fromJSON(txt = ".zenodo.json", simplifyVector = TRUE, flatten = TRUE)

  ##update
  json$title <- paste0(desc[, "Package"],": ", desc[, "Title"])
  json$description <- paste0("<p>", gsub("\\n.*", "", desc[, "Description"]), "</p>")
  json$version <- desc[, "Version"]
  json$publication_date <- desc[, "Date"]

  ## check if the author list is up to date
  authors <- desc[, "Authors@R"]
  if (!is.na(authors)) {
    ## parse Authors@R
    authors <- eval(str2expression(authors))
    aut.desc <- do.call(rbind, lapply(authors, function(entry) {
      ## skip thesis supervisor
      if ("ths" %in% entry$role)
        return(NULL)
      name <- sprintf("%s, %s", entry$family, entry$given)
      orcid <- unname(entry$comment["ORCID"]) %||% NA
      data.frame(name, orcid)
    }))
    aut.json <- json$creators[, c("name", "orcid")]

    ## compare the content of the two author lists and report differences
    if (!identical(aut.desc, aut.json)) {
      vals.desc <- unname(apply(aut.desc, 1, paste, collapse = " "))
      vals.json <- unname(apply(aut.json, 1, paste, collapse = " "))
      only.in.desc <- vals.desc[!vals.desc %in% vals.json]
      only.in.json <- vals.json[!vals.json %in% vals.desc]
      if (length(only.in.desc) > 0) {
        cat("\nOnly in DESCRIPTION:\n")
        cat("\t", only.in.desc, sep = "\n\t")
      }
      if (length(only.in.json) > 0) {
        cat("\nOnly in .zenodo.json:\n")
        cat("\t", only.in.json, sep = "\n\t")
      }
      warning("Authors list in '.zenodo.json' may need to be updated")
    }
  }

# Write JSON --------------------------------------------------------------
  jsonlite::write_json(
    x = json,
    path = ".zenodo.json",
    pretty = TRUE,
    auto_unbox = TRUE
  )

  return(TRUE)
}
