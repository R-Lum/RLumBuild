% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/build_package.R
\name{build_package}
\alias{build_package}
\title{Check and Build Package}
\usage{
build_package(
  path = ".",
  exclude = NULL,
  write_Rbuildignore = TRUE,
  as_cran = FALSE
)
}
\arguments{
\item{path}{\link{character} (with default): set package path}

\item{exclude}{\link{character} (optional): names of build modules you want to exclude]}

\item{write_Rbuildignore}{\link{logical} (optional): writes are master build-ignore}

\item{as_cran}{\link{logical} (with default): enable/disable \code{--as-cran} check}
}
\description{
Central function to run the package build process.
}
\section{Function version}{
 0.1.0
}

\examples{

print("This is only to silence the CRAN check")

\dontrun{
build_package()

}

}
\author{
Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
, RLum Developer Team} 

\section{How to cite}{
Kreutzer, S., 2024. build_package(): Check and Build Package. Function version 0.1.0. In: Kreutzer, S., Burow, C., 2024. RLumBuild: RLum Universe Package Building. R package version 0.1.9. https://github.com/R-Lum/RLumBuild
}

