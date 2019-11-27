#' @title Add How to Cite Section
#'
#' @description Adds a function tailored section 'How to Cite' to each manual page as long as
#' author names and a section 'Function version' exists.
#'
#' @details
#'
#' **Output example**
#'
#' Burow, C., Kreutzer, S. (2019). module_add_HowToCite(): Add How to Cite Section. Function version 0.1.0.
#' In: Kreutzer, S., Burow, C. (2019). RLumBuild: RLum Universe Package BuildingR
#' package version 0.1.1.9000-5. https://github.com/R-Lum/RLumBuild
#'
#' @section Function version: 0.3.0
#'
#' @author Christoph Burow (Germany), Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (Frange)
#'
#' @md
#' @export
module_add_HowToCite <- function(){
  ## -------------------------------------------------------------------------- ##
  ## FIND AUTHORS ----
  ## -------------------------------------------------------------------------- ##
  DESC <- readLines("DESCRIPTION")

  DESC_PACKAGE <- unlist(
    strsplit(x = DESC[grepl(pattern = "Package:", x = DESC, fixed = TRUE)], split = "Package: ", fixed = TRUE))[2]

  DESC_TITLE <- unlist(
    strsplit(x = DESC[grepl(pattern = "Title:", x = DESC, fixed = TRUE)], split = "Title: ", fixed = TRUE))[2]

  DESC_VERSION <- unlist(
    strsplit(x = DESC[grepl(pattern = "Version:", x = DESC, fixed = TRUE)], split = "Version: ", fixed = TRUE))[2]

  DESC_URL <- unlist(
    strsplit(x = DESC[grepl(pattern = "URL:", x = DESC, fixed = TRUE)], split = "URL: ", fixed = TRUE))[2]

  ##test URL and account for NULL case
  if(!is.null(DESC_URL)){
    if(attr(curlGetHeaders(DESC_URL), "status") == "404")
      DESC_URL <- NULL

  }

  authors <- DESC[grep("author", DESC, ignore.case = TRUE)[1]:
                  c(grep("author", DESC, ignore.case = TRUE)[2] - 1)]

  ##remove [ths] ... means authors which have [ths] only
  if(any(grepl(authors, pattern = "[ths]", fixed = TRUE)))
    authors <- authors[-grep(authors, pattern = "[ths]", fixed = TRUE)]

  author.list <- do.call(rbind, lapply(authors, function(str) {

    # check if person is author
    is.auth <- grepl("aut", str)

    # remove "Author: "
    str <- stringi::stri_replace_all_coll(str, pattern = "Author: ", replacement = "")
    # remove all role contributions given in square brackets
    str <- strtrim(str, min(unlist(gregexpr("\\[|<", str))) - 2)
    # remove all leading whitespaces
    str <- stringi::stri_trim(str, "left")

    # get surname
    strsplit <- strsplit(str, " ")[[1]]
    surname <- strsplit[length(strsplit)]

    # get name
    name <- character()
    for (i in 1:c(length(strsplit)-1))
      name <- paste0(name, strtrim(strsplit[i], 1), ".")

    # bind as data.frame and return
    df <- data.frame(name = name, surname = surname, author = is.auth)
    return(df)
  }))


  ## -------------------------------------------------------------------------- ##
  ## ADD CITATION ----
  ## -------------------------------------------------------------------------- ##

  ##add citation section
  file.list.man <- list.files("man/", recursive = TRUE, include.dirs = FALSE, pattern = "\\.Rd")

  # build package citation
  pkg.authors <- character()
  author.list.authorsOnly <- author.list[which(author.list$author),]
  for (i in 1:nrow(author.list.authorsOnly)) {
    if (author.list.authorsOnly$author[i])
      pkg.authors <- paste0(pkg.authors,
                            author.list.authorsOnly$surname[i],", ",
                            author.list.authorsOnly$name[i],
                            ifelse(i == nrow(author.list.authorsOnly),"", ", "))
  }
  pkg.citation <- paste0(pkg.authors, ", ", format(Sys.time(), "%Y"), ". ",
                         paste0(DESC_PACKAGE, ": ",DESC_TITLE, ". "),
                         paste0("R package version ", DESC_VERSION, ". "),
                         DESC_URL)

  for (i in 1:length(file.list.man)) {
    temp.file.man <-  readLines(paste0("man/", file.list.man[i]), warn = FALSE)

    # determine function and title
    fun <-
      temp.file.man[grep("\\\\name", temp.file.man, ignore.case = TRUE)]
    fun <- stringi::stri_replace_all_regex(fun, "\\\\name|\\{|\\}", "")

    title.start <-
      grep("\\\\title", temp.file.man, ignore.case = TRUE)
    title.end <- grep("\\\\usage", temp.file.man, ignore.case = TRUE)

    if (length(title.end) != 0) {
      title <-
        paste(temp.file.man[title.start:c(title.end - 1)], collapse = " ")
      title <- stringi::stri_replace_all_regex(title, "\\\\title|\\{|\\}", "")
      title <-
        stringi::stri_replace_all_regex(title, "\\\\code", "", ignore.case  = TRUE)
      title <-
        stringi::stri_replace_all_regex(title, '"', "'", ignore.case  = TRUE)

      ##search for start and end author field
      author.start <- which(grepl("\\\\author", temp.file.man))

      ##search for Reference start field
      reference.start <- which(grepl("\\\\references", temp.file.man))

      if (length(author.start) > 0) {
        author.end <- which(grepl("\\}", temp.file.man)) - author.start
        author.end <- min(author.end[author.end > 0]) + author.start

        ##account for missing reference section
        if(length(reference.start) == 0){
          reference.start <- author.end + 1
        }


        relevant.authors <- do.call(rbind, sapply(as.character(author.list$surname), function(x) {
          str <- paste(temp.file.man[author.start:author.end], collapse = " ")
          str <- stringi::stri_replace_all_regex(str, ",|\\.", " ")
          included <- grepl(paste0(" ", x, " "), str, ignore.case = TRUE)
          if (included)
            pos <- regexpr(x, str)[[1]]
          else
            pos <- NA
          return(data.frame(included = included, position = pos))
        }, simplify = FALSE))

        # retain order of occurence, assuming that the name first mentioned is
        # also the main author of the function
        included.authors <- author.list[relevant.authors$included, ]
        included.authors <- included.authors[order(na.omit(relevant.authors$position)), ]

        fun.authors <- character()
        for (j in 1:nrow(included.authors)) {
          fun.authors <- paste0(
            fun.authors,
            included.authors$surname[j],
            ", ",
            included.authors$name[j],
            ifelse(j == nrow(included.authors), "", ", ")
          )
        }

        ##search for function version
        fun.version <-
          which(grepl("\\\\section\\{Function version\\}", temp.file.man))

        if (length(fun.version) != 0) {
          fun.version <- stringr::str_trim(strsplit(
            x = temp.file.man[fun.version + 1],
            split = "(",
            fixed = TRUE
          )[[1]][1])

        } else{
          fun.version <- ""
        }

        ##assemble citation text
        citation.text <- paste0(
          "\n\n\\section{How to cite}{\n",
          fun.authors,
          ", ",
          format(Sys.time(), "%Y"),
          ". ",
          fun,
          "(): ",
          title,
          ifelse(fun.version != "", ". Function version ", ""),
          fun.version,
          ". In: ",
          pkg.citation,
          "\n}\n"
        )

        temp.file.man[reference.start - 1] <-
          paste(temp.file.man[reference.start - 1],
                citation.text)

        ##generate R bibentry
        bib_entry <- utils::bibentry(
          bibtype = "InCollection",
          title = paste0(fun, "(): ", title),
          volume = paste0("version: ", fun.version),
          author = gsub(pattern = "[.,]", replacement = "",
                        x = gsub(pattern = ".,", replacement = " and", x =fun.authors, fixed = TRUE),
                        useBytes = TRUE),
          booktitle = if(is.null(DESC_URL)){
             pkg.citation
            }else{
              trimws(sub(pattern = DESC_URL, replacement = "", x = pkg.citation, fixed = TRUE))
             },
          publisher = DESC_PACKAGE,
          year = format(Sys.time(), "%Y"),
          url = DESC_URL)

        ##write file back to the disc and append BibTeX file
        if (length(author.start) > 0){
          write(temp.file.man, paste0("man/", file.list.man[i]))

          ##write BibTeX file
          bib_file <- paste0(DESC_PACKAGE,".BuildResults/", DESC_PACKAGE,"_",DESC_VERSION,"-fun_bibliography.bib")

          ##check if exsits or not
          if(!file.exists(bib_file))
            write(x = character(), file = bib_file)

          ##write to disc
          write(x = toBibtex(bib_entry), file = bib_file, append = TRUE)

        }
      }
    }
  }

  return(TRUE)
}
