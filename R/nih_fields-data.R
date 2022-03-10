#' NIH RePORTER Field Translation
#' 
#' A \code{tibble} containing name translations between payload criteria, column selection/sorting arguments, and the result set.
#' 
#' @docType data
#' 
#' @usage data("nih_fields")
#' 
#' @format A tibble with 43 rows and 5 columns:
#' \describe{
#' \item{\code{payload_name}}{the name for a data element when specified in the payload criteria of a request; 
#'       NA indicates that this is not available as payload criteria (can not search/filter on).}
#' \item{\code{response_name}}{the name of the field returned by RePORTER (and what you will see in all cases
#'       when \code{flatten_result = FALSE}.}
#' \item{\code{include_name}}{the name of the field when specified in \code{include_fields}, \code{exclude_fields},
#'       and \code{sort_field} argument.}
#' \item{\code{return_class}}{the class of the corresponding column in a tibble returned by \code{get_nih_data()}.
#'       The tibble contains nested data frames and lists of variable length vectors.} 
#' }
#' 
#' Note: when \code{flatten_result = TRUE}, the original field name will prefix the names of the new flattened columns.
#' See: \code{\link[jsonlite:flatten]{jsonlite:flatten}}.
#' 
#' @references \href{https://api.reporter.nih.gov/documents/Data\%20Elements\%20for\%20RePORTER\%20Project\%20API\%20v2.pdf}{NIH RePORTER API Documentation}
#' 
#' @keywords datasets
"nih_fields"
