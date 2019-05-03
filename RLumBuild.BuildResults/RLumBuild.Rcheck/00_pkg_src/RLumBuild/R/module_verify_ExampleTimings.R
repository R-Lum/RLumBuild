#' @title  Verify Example Timings
#'
#' @description Check and display the timing results of the example checks to avoid too long
#' example runs.
#'
#' @author Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060, CNRS - Université Bordeaux Montaigne (France)
#'
#' @section Function version: 0.1.0
#'
#'@md
#'@export
module_verify_ExampleTimings <- function(){

##get version number
temp <- readLines("DESCRIPTION")

pkg_name <- trimws(unlist(strsplit(temp[1], split = "Package:", fixed = TRUE))[2])
temp <- temp[grep("Version", temp)]
temp.version <- sub(" ","",unlist(strsplit(temp,":"))[2])

# CHECK EXAMPLE TIMING ----------------------------------------------------
timing.threshold <- 3

if(!file.exists(paste0(pkg_name,".BuildResults/",pkg_name,".Rcheck/",pkg_name,"-Ex.timings")) &&
   !file.exists(paste0(pkg_name,".BuildResults/",pkg_name,".Rcheck/examples_x64/",pkg_name,"-Ex.timings")))
  stop("[module_very_ExampleTimings()] Nothing to verify, the package does not run examples!", call. = FALSE)

if (Sys.info()[["sysname"]] == "Windows") {
  temp <- read.table(paste0(pkg_name,".BuildResults/",pkg_name,".Rcheck/examples_x64/",pkg_name,"-Ex.timings"), header=TRUE)

} else {
  temp <- read.table(paste0(pkg_name,".BuildResults/",pkg_name,".Rcheck/",pkg_name,"-Ex.timings"), header=TRUE)
}

##plot values for the functions
pdf(file=paste0(pkg_name,".BuildResults/", pkg_name,"-TimingExamples.",temp.version,".pdf"), paper="special")

values <- barplot(rev(temp$elapsed), horiz=TRUE, xlim=c(0,10), cex.names=0.7,
                  beside=TRUE, names.arg=c(length(temp$name):1), las=1,
                  xlab="elapsed test time [s]", ylab="function number",
                  main="run time for function examples")

abline(v=timing.threshold, col="red")

for (i in 1:length(temp$name)){

  if(temp$elapsed[i] > timing.threshold){
    text(temp$elapsed[i],values[length(values)+1-i],temp$name[i], pos=4, cex=.7)
  }

}
dev.off()

temp.threshold <- temp[temp$elapsed > timing.threshold, ]

write.table(
  x = temp.threshold[, c(1, 4)],
  file = paste0(
    pkg_name,
    ".BuildResults/",pkg_name,"-Ex.timings.",
    temp.version,
    ".WARNING"
  ),
  row.names = FALSE,
  quote = FALSE,
  col.names = FALSE,
  sep = " >> "
)

  if(nrow(temp.threshold) == 0){
    return(TRUE)

  }else{
    stop()
}
}
