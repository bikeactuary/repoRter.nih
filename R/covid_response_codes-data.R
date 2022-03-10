#' \code{covid_response_code} translation
#' 
#' A \code{tibble} containing name translations between \code{covid_response_code} and the funding source(s)
#' 
#' @docType data
#' 
#' @usage data("covid_response_codes")
#' 
#' @format A \code{tibble} with 6 rows and 3 columns:
#' \describe{
#' \item{\code{covid_response_code}}{the name for a data element when specified in the payload criteria of a request; NA indicates that this is not available as payload criteria (can not search/filter on)}
#' \item{\code{funding_source}}{the name of the funding source, often some federal legislation}
#' \item{\code{fund_src}}{a short name for the funding source}
#' }
#' 
#' @references \href{https://api.reporter.nih.gov/documents/Data\%20Elements\%20for\%20RePORTER\%20Project\%20API\%20v2.pdf}{NIH RePORTER API Documentation}
#' 
#' @keywords datasets
"covid_response_codes"
