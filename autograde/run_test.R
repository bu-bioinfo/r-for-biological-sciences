#!/share/pkg.7/r/4.1.1/install/bin/Rscript

library(testthat)

args = commandArgs(trailingOnly=TRUE)

if (length(args)!=1) {
  stop("One and only one argument, the path to the test file, must be provided.")
}

testthat::test_file(args[1], report="minimal")

