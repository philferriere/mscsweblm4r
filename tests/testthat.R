# testthat testing instructions are at http://r-pkgs.had.co.nz/tests.html
# quick notes:
#   put all your tests in tests/testthat folder
#   each test file should start with test and end in .R
library("testthat")
library("mscsweblm4r")
test_check("mscsweblm4r")
