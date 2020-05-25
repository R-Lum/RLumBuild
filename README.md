




<!-- README.md was auto-generated by README.Rmd. Please DO NOT edit by hand!-->

# RLumBuild <img width=120px src="man/figures/RLumBuild-logo.svg" align="right" />

**Build packages from the RLum-universe. A collection of tools and
scripts to unify the building of packages.**

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
![GitHub
release](https://img.shields.io/github/release/R-Lum/RLumBuild.svg)
![GitHub Release
Date](https://img.shields.io/github/release-date/R-Lum/RLumBuild.svg)

[![Build
Status](https://travis-ci.org/R-Lum/RLumBuild.svg?branch=master)](https://travis-ci.org/R-Lum/RLumBuild)

Over the years our RLum-package universe expanded. At the same time
building and maintaining the various packages became more and more
complex. While at the beginning we used tools, such as the `'devtools'`
package, bugs and changes of the [CRAN](https://r-project.org)
requirements forced us to develop custom-tailored scripts. Those scripts
where simple R-scripts loaded via `R CMD BATCH` from the terminal,
however, it was tedious to handle them across different packages. On the
top, we needed separate shell-scripts for all the three major OS
platforms. Now ’RLumBuild\` provides a unified environment to check and
build our **R** packages.

The package is more than just the collection of the scripts we had
developed so far. The central function is called `build_package()` and
is called without further arguments. The function calls the usual check
and build functions from `'devtools'` but also runs further custom
modules (functions in the package ‘RLumBuild’), to, e.g., add a new
section ‘How to cite’ to add function related citation information.

*Note: ‘RLumBuild’ is no CRAN package and it will not be submitted to
CRAN, since the number of potential users is very small. However, as for
all other packages we develop, we apply the same quality standards.*

## Installation

``` r
if(!require("devtools"))
  install.packages("devtools")
devtools::install_github("R-Lum/RLumBuild@master")
```

## Examples and how to use the package

A packages builds by simply calling

``` r
RLumBuild::build_package()
```

In conjunction with
[RStudio](https://www.rstudio.com/products/rstudio/download/) a short
bash script allowing a full integration is more useful.

    #!/bin/bash
    
    R -q -e "RLumBuild::build_package()"

This script is stored in the package directory and connected with
*RStudio* via *Project Options \>\> Build Tools \>\> Project Build Tools
\>\> \[Custom\]*

The function itself does not require arguments to run, however, it has
arguments that can be used to control the build process:

#### `write_Rbuildignore`

If set to `TRUE` (the default) every `.Ruildignore` is overwritten by a
template shipped with the package. Please note that this file is highly
customised to serve package building in the RLum-universe.

#### `exclude`

The package is mainly organised in modules (basically single, documented
package functions staring with `modul_`). Every module serves a
different process and is not essential to build the package but provide
some additional features (e.g., automated version numbering). To prevent
that a particular module is called, it can be excluded using the
argument `exclude`, e.g, the subsequent call prevents the `NEWS.md` file
from being created.

``` r
RLumBuild::build_package(exclude = c("module_knit_NEWS"))
```

#### `as_cran`

This argument allows to enable/disable the `--as-cran` check.

``` r
RLumBuild::build_package(as_cran = TRUE)
```

## License

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later
version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU
General Public
License](https://github.com/R-Lum/RLumBuild/blob/master/LICENSE) for
more details.

## Projects using RLumBuild

  - [BayLum](https://github.com/R-Lum/BayLum)
  - [Luminescence](https://github.com/R-Lum/Luminescence)
  - [RCarb](https://github.com/R-Lum/RCarb)
  - [RLumModel](https://github.com/R-Lum/RLumModel)
  - [rxylib](https://github.com/R-Lum/rxylib)

## <span class="glyphicon glyphicon-euro"></span> Funding

In 2019, the work of Sebastian Kreutzer as maintainer of the package was
supported by LabEx LaScArBxSK (ANR - n. ANR-10-LABX-52).
