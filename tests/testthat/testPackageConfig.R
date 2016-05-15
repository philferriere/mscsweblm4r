context("testPackageConfig")

# From http://stackoverflow.com/questions/6979917/how-to-unload-a-package-without-restarting-r
# Usage: detachPackage(mscsweblm4r) or detachPackage("mscsweblm4r", TRUE)
detachPackage <- function(pkg, character.only = FALSE)
{
  if(!character.only)
  {
    pkg <- deparse(substitute(pkg))
  }
  search_item <- paste("package", pkg, sep = ":")
  while(search_item %in% search())
  {
    detach(search_item, unload = TRUE, character.only = TRUE)
  }
}

# Method 1: From file set with env var
test_that("configuring from env-specified file path works", {

  skip_on_cran()

  if (file.exists("~/.mscskeys.json.inaccessible"))
    file.rename("~/.mscskeys.json.inaccessible", "~/.mscskeys.json")

  detachPackage(mscsweblm4r)

  Sys.setenv(MSCS_WEBLANGUAGEMODEL_CONFIG_FILE = ".bogusmscskeys.json")
  Sys.getenv("MSCS_WEBLANGUAGEMODEL_CONFIG_FILE")

  library(mscsweblm4r)

  expect_that(mscsweblm4r:::weblmGetConfigFile(), equals(".bogusmscskeys.json"))
  expect_that(mscsweblm4r:::weblmGetURL(), equals("https://www.bogus.com/fromconfigfile/"))
  expect_that(mscsweblm4r:::weblmGetKey(), equals("abracadabrafromconfigfile"))

  Sys.unsetenv("MSCS_WEBLANGUAGEMODEL_CONFIG_FILE")
})

# Method 2: From sys env
test_that("configuring from env-specified file path works", {

  skip_on_cran()

  detachPackage(mscsweblm4r)

  if (file.exists("~/.mscskeys.json"))
    file.rename("~/.mscskeys.json", "~/.mscskeys.json.inaccessible")

  Sys.setenv(MSCS_WEBLANGUAGEMODEL_URL = "https://www.bogus.com/fromsysenv/")
  Sys.setenv(MSCS_WEBLANGUAGEMODEL_KEY = "abracadabrafromsysenv")

  library(mscsweblm4r)

  expect_that(mscsweblm4r:::weblmGetConfigFile(), equals(""))
  expect_that(mscsweblm4r:::weblmGetURL(), equals("https://www.bogus.com/fromsysenv/"))
  expect_that(mscsweblm4r:::weblmGetKey(), equals("abracadabrafromsysenv"))

  if (file.exists("~/.mscskeys.json.inaccessible"))
    file.rename("~/.mscskeys.json.inaccessible", "~/.mscskeys.json")
})

# Method 3: From default file
test_that("configuring from default file path works", {

  skip_on_cran()

  detachPackage(mscsweblm4r)

  library(mscsweblm4r)

  expect_that(mscsweblm4r:::weblmGetConfigFile(), equals("~/.mscskeys.json"))
  expect_that(mscsweblm4r:::weblmGetURL(), is_a("character"))
  expect_that(mscsweblm4r:::weblmGetKey(), is_a("character"))

  Sys.unsetenv("MSCS_WEBLANGUAGEMODEL_CONFIG_FILE")
})
