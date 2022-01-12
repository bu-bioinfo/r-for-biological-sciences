library(testthat)
test_that("add() correctly adds things", {
  expect_equal(add(1,2),3)  
  expect_equal(add(5,6),11)  
}
)
