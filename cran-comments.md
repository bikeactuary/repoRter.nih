## Maintainer Notes:
- I've updated get_nih_data() to no longer use stop() and instead return(NA) when
  the underlying API service is unavailable or otherwise returns a non-200 response
- I've updated the vignette to handle such cases without throwing exception or 
  failing to render
- Incremented version to 0.1.3
- Spelling NOTE is false-positive (these are contained in quotes), other 2 
  NOTEs can by ignored
- Still no WARNINGs/ERRORs in r-hub or win-devel tests
- I've re-used one chunk output to reduce run-time in the vignette build and 
  eliminated /cache use which could add some time for disk I/O. That said, this
  takes 25 seconds to build locally.

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: '"Michael Barr, ACAS, MAAA, CPCU" <mike@bikeactuary.com>'
  
  New submission
  
  Package was archived on CRAN
  
  Possibly misspelled words in DESCRIPTION:
    JSON (10:67)
    RePORTER (11:66)

❯ On windows-x86_64-devel (r-devel)
  checking sizes of PDF files under 'inst/doc' ... NOTE
  Unable to find GhostScript executable to run checks on size reduction

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 3 notes ✖