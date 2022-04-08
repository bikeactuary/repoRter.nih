# repoRter.nih — R Interface to the 'NIH RePORTER Project' API

repoRter.nih is an R package that allows users to request project award data from the U.S. National Institute of Health (NIH)'s Application Programming Interface (API).
The RePORTER API provides the public with access to project and grantee information for all projects funded through NIH grants (around $42 billion annually as of 2021).
This package provides methods enabling a user to easily build requests in the non-standard JSON schema required by the RePORTER API as well as to retrieve and process results.

## Quick Tour 

### Installation  
repoRter.nih can be installed easily through [CRAN](https://cran.r-project.org/package=repoRter.nih) or [GitHub](https://github.com/bikeactuary/repoRter.nih).    

### CRAN

```r
install.packages('repoRter.nih')
```

### Github

The latest stable release (consistent with CRAN version) can be installed with
```r
devtools::install_github('bikeactuary/repoRter.nih)
```

A development version of this package will also be available and may contain bugfixes and/or new functionality not yet pushed to CRAN. For the latest dev version, you must specify
to install from the 'dev' branch:
```r
devtools::install_github('bikeactuary/repoRter.nih@dev')
```

### API Basics
The blsAPI package supports v2 of the RePORTER API. This API does not require registration or authorization of any kind. There are some limit around
request rates and result set size to be aware of, detailed below:

| Item                                     |           Value            |
|:-----------------------------------------|:--------------------------:|
| Daily query limit                        |            None            |
| Series per query limit                   |             50             |
| Years per query limit                    |             20             |
| Net/Percent Changes                      |            Yes             |
| Optional annual averages                 |            Yes             |
| Series description information (catalog) |            Yes             |

### Sample Code

#### Example 1
The following example will retrieve the civilian unadjusted Employment Cost Index (ECI) via the API and process the request into a data frame.

```r

```

#### Example 2
This example pulls monthly unemployment and labor force estimates for Manhattan (New York County, NY) using the version 2.0 API.  We graph a calculated unemployment rate including shading for the Great Recession.  According the [National Bureau of Economic Research (NBER)](http://www.nber.org/cycles.html) the Great Recession ran from December 2007 to June 2009.

```r

```

![](https://github.com/mikeasilva/blsAPI/blob/master/figure/unnamed-chunk-8-1.png) 


## Learning More
With the basics described above you can get started with the BLS API right away. To learn more see:  


<https://api.reporter.nih.gov/#/Search/post_v2_projects_search>
* [BLS API Home](http://www.bls.gov/developers/)
* [BLS API FAQ](http://www.bls.gov/developers/api_faqs.htm) 
* [BLS Help & Tutorials: Series ID Formats](http://www.bls.gov/help/hlpforma.htm)  
* [Register for BLS API v 2.0](http://data.bls.gov/registrationEngine/)  