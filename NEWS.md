# repoRter.nih 0.1.4

* Changes to ensure calls to API are not tested on CRAN (\dontrun{} replaces \donttest{})
* Exit vignette knitting early if API not available, for CRAN
* reduce vignette build time for CRAN

# repoRter.nih 0.1.3

* Update get_nih_data() to return NA when API call returns non-200 response
* Modified vignette to render without error when API service is down

# repoRter.nih 0.1.2

* Update make_req() to incorporate RePORTER API schema change - eliminates "award" criteria and brings sub-elements up a level
* Update vignette large result set example to reflect schema change
* Update for TeX Live 2022, resolve build errors in vignette
* README.md documentation for github

# repoRter.nih 0.1.1

* Fixed LaTeX errors in vignette

# repoRter.nih 0.1.0

* Initial release