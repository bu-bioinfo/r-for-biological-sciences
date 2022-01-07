#!/usr/bin/Rscript
# if you change the name of your script, this line must be changed as well
source("main.R")
library(testthat)

test_that("This pass", {
  expect_true(TRUE)
})

test_that("This warn", {
  warning("Ouch")
})

test_that("This fail", {
  expect_true(1 / "a")
})

test_that("This skip", {
  skip("God bless us every one")
})
