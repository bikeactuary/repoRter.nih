## SUBMISSION NOTES

* This is a re-submission
* Changes since last submission:
  - API name, 'tibble' in single quotes in DESCRIPTION
  - API web reference added in angle brackets in DESCRIPTION
  - remove change of options() in make_req()
  - reset options to original settings in vignette
* This is a new package submission
* There were no ERRORs or WARNINGs.
* There is one note on spelling which is a false positive and should be ignored
  - the term 'RePORTER' is the format of the official API name; 'JSON' and 'tibble' are not misspelled
* There is a NOTE that is only found on Windows (x86_64-devel r-devel):

    > Found the following files/directories:
      'lastMiKTeXException'

  As noted in R-hub issue #503, this could be due to a bug/crash in MiKTeX and can likely be ignored.
  See <https://github.com/r-hub/rhub/issues/503>

* There is another NOTE, again only on windows, which I believe can be ignored based on seeing other packages with similar notes

    > Unable to find GhostScript executable to run checks on size reduction

  The largest PDF is the vignette at 375 KB, well below the CRAN limit. I believe this NOTE is due to an issue on the build agent.

## R CMD CHECK RESULTS (via rhub::check_for_cran)

For a CRAN submission we recommend that you fix all NOTEs, WARNINGs and ERRORs.
## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
> On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: '"Michael Barr, ACAS, MAAA, CPCU" <mike@bikeactuary.com>'
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    JSON (10:67)
    RePORTER (11:66)
    tibble (13:75)

> On windows-x86_64-devel (r-devel)
  checking sizes of PDF files under 'inst/doc' ... NOTE
  Unable to find GhostScript executable to run checks on size reduction

> On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✓ | 0 warnings ✓ | 3 notes x
