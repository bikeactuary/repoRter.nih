## Maintainer Notes:
- I've updated code examples calling external API to use /dontrun() in place
  of /donttest() - the latter does not prevent tests
- I've updated the vignette to check for external API availability at the top
  and exit knitting early if unavailable
- These changes together should resolve the past issues with external 
  resources not being available causing build checks to fail
- I've reviewed all warnings/notes from rhub::check_for_cran and they can be
  ignored - the WARNING is due to my forgetting to pass the CMD CHECK arg
  "--compact-vignettes=gs+qpdf" 
- thank you

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking sizes of PDF files under ‘inst/doc’ ... WARNING
    ‘gs+qpdf’ made some significant size reductions:
       compacted ‘repoRter_nih.pdf’ from 382Kb to 124Kb
    consider running tools::compactPDF(gs_quality = "ebook") on these files

❯ On ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘"Michael Barr, ACAS, MAAA, CPCU" <mike@bikeactuary.com>’
  
  New submission
  
  Package was archived on CRAN
  
  Possibly misspelled words in DESCRIPTION:
    JSON (10:67)
    RePORTER (11:66)
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2022-10-12 for repeated policy violation.

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... [6s/41s] NOTE
  Maintainer: ‘"Michael Barr, ACAS, MAAA, CPCU" <mike@bikeactuary.com>’
  
  New submission
  
  Package was archived on CRAN
  
  Possibly misspelled words in DESCRIPTION:
    JSON (10:67)
    RePORTER (11:66)
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2022-10-12 for repeated policy violation.

❯ On fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

0 errors ✔ | 1 warning ✖ | 3 notes ✖