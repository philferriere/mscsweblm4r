I have read and agree to the CRAN policies at
http://cran.r-project.org/web/packages/policies.html

## R CMD check test environments
* local Windows 10 install, R version 3.3.0 (2016-05-03)
* on travis-ci: ubuntu (R:release and R:devel)
* on travis-ci: osx (R:release and R:devel)
* on win-builder: (R-devel and R-release)

## R CMD check test results on all environments but win-builder
R CMD check results
0 errors | 0 warnings | 0 notes

## R CMD check test results on win-builder
R CMD check results
0 errors | 0 warnings | 0 notes

* Possibly mis-spelled words in DESCRIPTION:
  API (4:14, 10:10, 14:33, 14:53)
  
Per [Wikipedia](https://en.wikipedia.org/wiki/Application_programming_interface), we believe this spelling to be correct.

* checking CRAN incoming feasibility ... WARNING
Maintainer: 'Phil Ferriere <pferriere@hotmail.com>'

Insufficient package version (submitted: 0.1.0, existing: 0.1.0)

* Uwe Ligges request 1: increase the version number

-> Version was bumped from 0.1.0 to 0.1.1

* Uwe Ligges request 2: enclose the URL in <> rather than ()

-> We replaced (https://www.microsoft.com/cognitive-services/) with <https://www.microsoft.com/cognitive-services/> in DESCRIPTION

* Finally, we had to replace: 

Author: person("Phil", "Ferriere", email="pferriere@hotmail.com", role = c("aut", "cre"))

with:

Authors@R: person("Phil", "Ferriere", email="pferriere@hotmail.com", role = c("aut", "cre"))
    
for it to display correctly.

R CMD check tests were rerun in all test environments listed at the top of this note.

Thank you for your help and patience.

Regards,
Phil Ferriere <pferriere@hotmail.com>
