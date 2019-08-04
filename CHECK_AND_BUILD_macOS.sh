#!/bin/bash
R -q -e "RLumBuild::build_package(
  exclude = c(
   'module_check_ReverseDependencies',
   'module_write_codemetar'
  ),
  as_cran = FALSE,
  write_Rbuildignore = TRUE
)"