#' Write Function List
#'
#' @description Create a HTML and markdown list of all major functions in the package
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#' @section Function version: 0.1.0
#'
#' @export
module_write_FunctionList <- function(){

##get package and version number
pkg_name <- .get_pkg_name()
pkg_version <- .get_pkg_version()

# Reading file ------------------------------------------------------------
file.list.man <- list.files("man/", include.dirs = FALSE, pattern = ".Rd")

##exclude package itself
file.list.man <- file.list.man[file.list.man != paste0(pkg_name,"-package.Rd")]

##set output file
output.file <- paste0(pkg_name,".BuildResults/",pkg_name,"_",pkg_version,"-Functions.html")

## run over files
for(i in 1:length(file.list.man)) {

  file <- paste0("man/",file.list.man[i])
  Rd <- tools::parse_Rd(file)
  tags <- vapply(Rd, function(x) {attr(x, "Rd_tag")}, FUN.VALUE = character(1))
  tag.name <- unlist(Rd[[which(tags == "\\name")]])

  ##AUTHOR
  if("\\author" %in% tags){
    tag.author <- gsub("\n","<br />",paste(unlist(Rd[[which(tags == "\\author")]]), collapse= " "))
    tag.author <- trimws(sub("<br />", "", tag.author))

  }else{
    tag.author <- NA

  }

  ##VERSION
  if(length(grep("Function version", unlist(Rd)))>0){

    tag.version <- unlist(Rd)[grep("Function version", unlist(Rd))+2]
    tag.mdate <- strsplit(tag.version, " ")[[1]][3]
    tag.mdate <-  gsub("\\(", "", tag.mdate)
    tag.mtime <- strsplit(tag.version, " ")[[1]][4]
    tag.mtime <-  gsub("\\)", "", tag.mtime)
    tag.version <- strsplit(tag.version, " ")[[1]][2]

  }else{

    tag.version <- NA
    tag.mtime <- NA
    tag.mdate <- NA

  }


  ##TITLE
  if("\\title" %in% tags){

    tag.title <- gsub("\n","<br />",paste(unlist(Rd[[which(tags == "\\title")]]),
                                          collapse= " "))

  }

  ##DESCRIPTION
  if("\\description" %in% tags){
    tag.description <- trimws(gsub("\n","",paste(unlist(Rd[[which(tags == "\\description")]]),
                                                collapse= " ")))

  }

  ##VERSION
  if(length(grep("How to cite", unlist(Rd)))>0){

    tag.citation <- unlist(Rd)[grep("How to cite", unlist(Rd))+2]

  } else {

    tag.citation <- NA

  }


  if(exists("output")==FALSE){

    output <- data.frame(Name=tag.name,
                         Title = tag.title,
                         Description = tag.description,
                         Version=tag.version,
                         m.Date = tag.mdate,
                         m.Time = tag.mtime,
                         Author = tag.author,
                         Citation = tag.citation)

  }else{

    temp.output <- data.frame(Name=tag.name,
                              Title = tag.title,
                              Description = tag.description,
                              Version=tag.version,
                              m.Date = tag.mdate,
                              m.Time = tag.mtime,
                              Author = tag.author,
                              Citation = tag.citation)

    output <- rbind(output,temp.output)

  }

}

# HTML Output -------------------------------------------------------------
R2HTML::HTML(paste("<h2 align=\"center\">Major functions in the R package 'Luminescence'</h2>
           <h4 align=\"center\"> [version:", pkg_version,"]</h4>
           <style type=\"text/css\">
           <!--

           h2 {font-family: Arial, Helvetica, sans-serif
           }

           h4 {font-family: Arial, Helvetica, sans-serif
           }

           table {text-align:left;
           vertical-align:top;
           border: 1px solid gray;
           }

           th, td {
           border: 1px solid gray;
           padding: 3px;
           font-family: 'Liberation Sans', Arial, Helvetica, sans-serif;
           font-size: 90%;
           text-align: left;
           vertical-align: top;
           }

           th {
           background-color: #DDD;
           font-weight: bold;
           }

           -->
           </style>


           "),
     file = output.file)

R2HTML::HTML(
  output,
  align = "center",
  Border = 0,
  innerBorder = 1,
  classtable = "style=caption-side:bottom",
  file = output.file
)

# CSV Output --------------------------------------------------------------
write.table(
  x = output,
  file =  paste0(
    pkg_name,".BuildResults/",pkg_name,"_",
    pkg_version,
    "-Functions.csv"
  ),
  sep = ",",
  row.names = FALSE
)


# LaTeX Output ------------------------------------------------------------
options(xtable.comment = FALSE)
latex.table <- xtable::xtable(output)
write(
  x = print(latex.table),
  file = paste0(
    pkg_name,
    ".BuildResults/",
    pkg_name,
    "_",
    pkg_version,
    "-Functions.tex"
  )
)

# Markdown Output ---------------------------------------------------------
pander::panderOptions("table.split.table", Inf)
pander::panderOptions("table.style", "rmarkdown")
pander::set.alignment("left")
markdown.table <- gsub("<br />", " - ", capture.output(pander::pander(output)))
write(markdown.table,
      file = paste0(pkg_name,".BuildResults/",pkg_name,"_",pkg_version,"-Functions_Markdown.md"))

##we keep this out here.
# for (i in 1:ncol(output)) {
#   output[, i] <- gsub("\\n", "", paste0("<sub>", output[, i], "</sub>"))
# }
#
# pander::panderOptions("table.split.table", Inf)
# pander::panderOptions("table.style", "rmarkdown")
# pander::set.alignment("left")
# markdown.table <- capture.output(pander::pander(output))
# write(markdown.table, file = paste0("R/README.md"))

return(TRUE)

}
