#' @title make_req
#'
#' @description Easily generate a json request with correct schema to be passed to NIH RePORTER Project API
#'
#' @param criteria list(); the RePORTER Project API query criteria used to filter results (projects).
#'     \strong{See Details for schema and other spec rules.}
#' @param include_fields character(); optional; use to return only the specified fields from the result.
#'     \strong{See Details for valid return field names}
#' @param exclude_fields character(); optional; use to exclude specified fields from the result.
#' @param offset integer(1); optional; default: 0; usually not explicitly passed by user.
#'     Used to set the start index of the results to be retrieved (indexed from 0). \strong{See Details}.
#' @param limit integer(1); optional; default: 500; restrict the number of project records returned per page/request
#'     inside the calling function. Defaulted to the maximum allowed value of 500. Reducing this may help with
#'     bandwidth/timeout issues.
#' @param sort_field character(1); optional; use to sort the result by the specified field.
#'     May be useful in retrieving complete result sets above the API maximum of 10K (but below 2x the max = 20K)
#' @param sort_order character(1): optional; one of "asc" or "desc"; \code{sort_field} must be specified.
#' @param message logical(1); default: TRUE; print a message with the JSON to console/stdout. You may want to
#'     suppress this at times.
#' 
#' @return A standard json (\code{jsonlite} flavor) object containing the valid JSON request string which can
#'     be passed to \code{\link{get_nih_data}} or elsewhere
#' 
#' @details
#' 
#' The maximum number of records that can be returned from any result set is 10,000. Also, the maximum record index
#'     in the result set that can be returned is 9,999 - corresponding to the 10,000'th record in the set. These
#'     constraints from the NIH API defy any intuition that the \code{offset} argument would be useful to return records
#'     beyond this 10K limit. If you need to do this, you have two options:
#' \itemize{
#'     \item{You can break your request into several smaller requests to be retrieved individually. For example,
#'           requesting records for one fiscal year (see: \code{fiscal_years}) at a time. This should be your first path}
#'     \item{If you have a result set between 10,001 and 20,000 records, you might try passing essentially the same request
#'           twice, but
#'           varying them by the sort order on some field (and taking care to avoid or remove overlapping results).
#'           See the \code{sort_field} and \code{sort_order} arguments.}
#' }
#' \code{criteria} must be specified as a list and may include any of the following (all optional) top level elements:
#' \itemize{
#'   \item{\code{use_relevance}: logical(1); if TRUE (default), it will sort the most closely matching records per the search
#'         criteria to the top (i.e. the NHI sorts descending according to a calculated match score)}
#'   \item{\code{fiscal_years}: numeric(); one or more fiscal years to retrieve projects that correspond to (or started in)
#'         one of the fiscal years entered}
#'   \item{\code{include_active_projects}: logical(1); if TRUE (default), adds in active projects without regard for \code{policy_years}}
#'   \item{\code{pi_names}: list(); API will return records with Project Investigators (PIs) wildcard-matching any of the strings
#'         requested.\cr
#'         If provided, the list must contain three named character vector elements: \code{first_name},
#'         \code{last_name}, \code{any_name}. Each vector must contain at least one element - use a length-1
#'         vector with an empty string (\code{= ""} or \code{= character(1)}) for any name field you do not wish to search on.}
#'   \item{\code{multi_pi_only: logical(1)}; default: FALSE; when multiple \code{pi_names} are matched, setting this value to TRUE
#'         changes the logic from returning project records associated with ANY matched PI name to those associated with ALL names.}
#'   \item{\code{po_names}: list(); Project Officers (POs), otherwise same comments as for \code{pi_names}}
#'   \item{\code{org_names}: character(); one or more strings to filter organization names. The \strong{provided string is implicitly
#'         taken to include wildcards at head and tail} ends; "JOHN" and "HOP" will both match "JOHNS HOPKINS UNIVERSITY", etc.}
#'   \item{\code{org_names_exact_match}: character(); one or more strings to exactly match organization names}
#'   \item{\code{pi_profile_ids}: numeric(); one or more project investigator profile IDs; results will match projects associated with
#'         any of the IDs}
#'   \item{\code{org_cities}: character(); one or more cities in which associated organizations may be based.}
#'   \item{\code{org_states}: character(); one or more US States or Territories (note: requires the abbreviation codes: "NY", "PR", etc.)
#'         in which a project organization may be based.}
#'   \item{\code{project_nums}: character(); one or more project numbers (note: the alphanumeric variety of numbers); results will match
#'         any of the specified strings. You may include explicit wildcard operators ("*") in the strings, e.g. "5UG1HD078437-\*"}
#'   \item{\code{project_num_split}: list(6); the \code{project_nums} can be broken down to meaningful components which can be searched
#'         individually using this argument.
#'               These component codes are defined \href{https://api.reporter.nih.gov/documents/Data\%20Elements\%20for\%20RePORTER\%20Project\%20API\%20v2.pdf#page=31}{here}
#'               Your list must contain all of the following named elements:
#'               \itemize{
#'                   \item{\code{appl_type_code}: character();}
#'                   \item{\code{activity_code}: character();}
#'                   \item{\code{ic_code}: character();}
#'                   \item{\code{serial_num}: character();}
#'                   \item{\code{support_year}: character();}
#'                   \item{\code{suffix_code}: character();}
#'               }
#'               Provide a length-1 vector containing an empty string (\code{=""} or \code{=character(1)}) for any element you do not want to search on
#'       }
#'   \item{\code{spending_categories}: list(2); a list containing the following named elements:
#'                \itemize{
#'                    \item{\code{values}: numeric(): the NIH spending category code. These are congressionally defined and are
#'                          available \href{https://api.reporter.nih.gov/documents/Data\%20Elements\%20for\%20RePORTER\%20Project\%20API\%20v2.pdf#page=40}{here}
#'                         }
#'                    \item{\code{match_all}: logical(1); TRUE to return projects found in all categories; FALSE to return projects matching any one
#'                          of the categories.}
#'                }
#'        }
#'   \item{\code{funding_mechanism}: character(); one or more NIH funding mechanism codes used in the president's budget.
#'         Available \href{https://api.reporter.nih.gov/documents/Data\%20Elements\%20for\%20RePORTER\%20Project\%20API\%20v2.pdf#page=14}{here}}
#'   \item{\code{org_countries}: character(); one or more country names; e.g. "United States"}
#'   \item{\code{appl_ids}: numeric(); one or more application IDs (note: appl. IDs are natural numbers, unlike \code{project_nums})}
#'   \item{\code{agencies}: character(); one or more of the abbreviated NIH agency/institute/center names, available
#'        \href{https://grants.nih.gov/grants/acronym_list.htm#ao_two}{here}}
#'   \item{\code{is_agency_admin: logical(1)}; when specifying associated \code{agencies}, set this value to \code{TRUE} to further specify
#'         that these agencies are administering the grant/project.}
#'   \item{\code{is_agency_funding: logical(1)}; when specifying associated \code{agencies}, set this value to \code{TRUE} to further specify
#'         that these agencies are funding the grant/project. }
#'   \item{\code{activity_codes: character()}; a 3-character code identifying the grant, contract, or intramural activity through which a project is supported.
#'         This is a more detailed description within each funding mechanism. Codes are available
#'         \href{https://grants.nih.gov/grants/funding/ac_search_results.htm}{here}}
#'   \item{\code{award_types: character()}; (aka Type of Application) one or more grant/application type codes numbered 1-9.
#'         See types \href{https://grants.nih.gov/grants/how-to-apply-application-guide/prepare-to-apply-and-register/type-of-applications.htm}{here}}
#'   \item{\code{dept_types: character()}; one or more of NIH standardized department type names (e.g. "PEDIATRICS"). Valid names are provided
#'         \href{https://nexus.od.nih.gov/all/2021/04/09/how-are-schools-and-departments-assigned-to-nih-grants/}{here}}
#'   \item{\code{cong_dists: character()}; one or more US congressional districts (e.g. "NY-20") which the project can be associated with.
#'         See \href{https://en.wikipedia.org/wiki/List_of_United_States_congressional_districts}{here}}
#'   \item{\code{foa: character()}; one or more FOA (Funding Opportunity Announcements). Multiple projects may be tied to a single FOA.
#'   See \href{https://grants.nih.gov/grants/how-to-apply-application-guide/prepare-to-apply-and-register/understand-funding-opportunities.htm}{here}}
#'   \item{\code{project_start_date}: list(2); provide a range for the project start date. Must pass as list containing the following named elements:
#'                \itemize{
#'                    \item{\code{from_date}: character(1);}
#'                    \item{\code{to_date}: character(1);}
#'                }
#'        }
#'   \item{\code{project_end_date: list(2)}; provide a range for the project end date - similar to \code{project_start_date}.
#'                \itemize{
#'                    \item{\code{from_date}: character(1);}
#'                    \item{\code{to_date}: character(1);}
#'                }
#'   }
#'   \item{\code{organization_type: character()}; one or more types of applicant organizations (e.g. "SCHOOLS OF MEDICINE"). There does not appear to be a
#'         documented list of valid values, but you can obtain one by pulling all records in a recent year and extracting unique values.}
#'   \item{\code{award}: list(3): parameters related to the award. If you use this criteria, you must provide values for all sub-criteria
#'      \itemize{
#'        \item{\code{award_notice_date: character(1)}; the award notice date}
#'        \item{\code{award_notice_opr: character(1)}; wish I could tell you what this is - use an empty string}
#'        \item{\code{award_amount_range: list(2)}; a numeric range - if you don't want to filter by this sub-criteria (but are filtering on some other award criteria),
#'              enter 0 for min and 1e9 for max
#'          \itemize{
#'            \item{\code{min_amount: numeric(1)}; a real number between 0 and something very large}
#'            \item{\code{max_amount: numeric(1)}; a real number between 0 and something very large}
#'          }
#'        }
#'      }
#'    }
#'   \item{\code{exclude_subprojects: logical(1)}; default: FALSE; related to multiproject research awards, TRUE will limit results to just the parent project.}
#'   \item{\code{sub_project_only: logical(1)}; default: FALSE; similar to \code{exclude_subprojects}, this field will limit results to just the subprojects,
#'         excluding the parent.}
#'   \item{\code{newly_added_projects_only: logical(1)}; default: FALSE; return only those projects "newly added" (this is left undefined in the official
#'         documentation) to the system.}
#'   \item{\code{covid_response: character();} one or more special selector codes used to return projects awarded to study COVID-19 and related topics as funded
#'         and classified according to the below valid values/funding sources:
#'        \itemize{
#'           \item{\code{All}: all COVID-19 projects}
#'           \item{\code{Reg-CV}: those funded by regular NIH Appropriated funds}
#'           \item{\code{CV}: those funded by the Coronavirus Preparedness and Response Supplemental Appropriations Act, 2020}
#'           \item{\code{C3}: those funded by the CARES Act}
#'           \item{\code{C4}: those funded by the Paycheck Protection Program and Health Care Enhancement Act}
#'           \item{\code{C5}: those funded by the Coronavirus Response and Relief Supplemental Appropriations Act, 2021}
#'           \item{\code{C6}: those funded by the American Rescue Plan Act, 2021}
#'        } 
#'   }
#'   \item{\code{full_study_sections: list(6)}; (not documented in API notes) Review activities of the Center for Scientific Review (CSR) are organized into
#'         Integrated Review Groups (IRGs). Each IRG represents a cluster of study sections around a general scientific area. Applications generally are assigned
#'         first to an IRG, and then to a specific study section within that IRG for evaluation of scientific merit.\cr
#'         This gets a bit complicated so we provide \href{https://public.csr.nih.gov/StudySections}{this resource} for further reading.
#'         If providing this criteria, you must include each of the below named elements as character vectors:
#'        \itemize{
#'                   \item{\code{irg_code}: character(); Integrated Review Group}
#'                   \item{\code{sra_designator_code}: character(); Scientific Review Administrator }
#'                   \item{\code{sra_flex_code}: character(); }
#'                   \item{\code{group_code}: character(); }
#'                   \item{\code{name}: character(); }
#'                   \item{\code{url}: character(); }
#'               }
#'        }
#'   \item{\code{advanced_text_search}: list(3); used to perform string search in the Project Title ("projecttitle"),
#'         Abstract ("abstract"), and/or Project Terms ("terms") fields.
#'         If providing this criteria, you must include each of the below named elements:
#'         \itemize{
#'                \item{\code{operator: character(1)}; one of "and", "or", "advanced". "and", "or" will be the logical operator between all provided search terms.
#'                      "advanced" allows the user to pass a boolean search string directly.}
#'                \item{\code{search_field: character()}; can be one or multiple of "abstract", "terms", "projecttitle" passed as a vector of length 1 to 3.
#'                      To search all fields, the user can alternatively pass a length 1 character vector containing the string "all" or "".}
#'                \item{\code{search_text: character(1)}; pass one or multiple search terms separated by spaces, without any quotations. If searching in
#'                      "advanced" mode, provide a boolean search string - you may use parentheses, AND, OR, NOT, and *escaped* double quotes
#'                      (e.g. \code{search_text = "(brain AND damage) OR (\"insane in the membrane\") AND cure"})}
#'                }
#'       }
#' }
#' 
#' \subsection{Field Names}{
#'     Full listing of available field names which can be specified in \code{include_fields}, \code{exclude_fields}, and \code{sort_field}
#'     is located \href{https://api.reporter.nih.gov/documents/Data\%20Elements\%20for\%20RePORTER\%20Project\%20API\%20v2.pdf}{here}
#' }
#' 
#' @examples
#' library(repoRter.nih)
#' 
#' ## all projects funded in the current (fiscal) year
#' req <- make_req() 
#' 
#' ## projects funded in 2019 through 2021
#' req <- make_req(criteria = list(fiscal_years = 2019:2021))
#' 
#' ## projects funded in 2021 where the principal investigator first name is
#' ## "Michael" or begins with "Jo" 
#' req <- make_req(criteria = 
#'                     list(fiscal_years = 2021,
#'                          pi_names = 
#'                              list(first_name = c("Michael", "Jo*"),
#'                                   last_name = c(""), # must specify
#'                                   any_name = character(1) # same here
#'                                   )
#'                          )
#'                 )
#' 
#' ## all covid-related projects except those funded by American Rescue Plan
#' ## and specify the fields to return, sorting ascending on ApplId column
#' req <- make_req(criteria = 
#'                     list(covid_response = c("Reg-CV", "CV", "C3", "C4", "C5")
#'                     ),
#'                 include_fields = 
#'                     c("ApplId", "SubprojectId", "FiscalYear", "Organization",
#'                       "AwardAmount", "CongDist", "CovidResponse",
#'                       "ProjectDetailUrl"),
#'                 sort_field = "ApplId",
#'                 sort_order = "asc")
#'                 
#' ## using advanced_text_search with boolean search string
#' 
#' string <- "(head AND trauma) OR \"brain damage\" AND NOT \"psychological\""
#' req <- make_req(criteria = 
#'                     list(advanced_text_search =
#'                          list(operator = "advanced",
#'                               search_field = c("terms", "abstract"),
#'                               search_text = string
#'                               )
#'                          )
#'                 )
#' 
#' @import jsonlite
#' @import assertthat
#' @import crayon
#' @import magrittr
#' @importFrom purrr "discard"
#' @importFrom lubridate "year"
#' @export
make_req <- function(criteria = list(fiscal_years = lubridate::year(Sys.Date())),
                     include_fields = NULL,
                     exclude_fields = NULL,
                     offset = 0,
                     limit = 500,
                     sort_field = NULL,
                     sort_order = NULL,
                     message = TRUE) {
  
  if (is.null(criteria)) criteria <- list() 
  
  ## fill req w/ default values for these criteria to be explicit
  ## is_agency_admin --> this currently has no effect on results 
  ## is_agency_funding --> also no effect on result
  ## include_active_projects --> add in active projects (ignoring other criteria?)
  boolys <- c("use_relevance", "include_active_projects", "exclude_subprojects", "multi_pi_only",
              "newly_added_projects_only", "sub_project_only")
  
  for (i in 1:length(boolys)) {
    ## all of these values will be set to API defaults determined through testing result when unspecified
    if (!(boolys[i] %in% names(criteria))) {
      criteria[[boolys[i]]] <- FALSE
    }
  }
  
  if (!is.null(criteria$pi_names)) {
    ## assert three named character vectors in list
    assert_that(is.list(criteria$pi_names),
                has_name(criteria$pi_names, "any_name"),
                has_name(criteria$pi_names, "first_name"),
                has_name(criteria$pi_names, "last_name"),
                is.character(criteria$pi_names$any_name),
                is.character(criteria$pi_names$first_name),
                is.character(criteria$pi_names$last_name))
    
    pi_names_reformat <- list()
    
    for (i in 1:length(criteria$pi_names$any_name)) {
      pi_names_reformat[[i]] <- data.frame(any_name = criteria$pi_names$any_name[i]) %>%
        unbox()
    }
    
    start <- length(pi_names_reformat)
    for (j in 1:length(criteria$pi_names$first_name)) {
      pi_names_reformat[[start+j]] <- data.frame(first_name = criteria$pi_names$first_name[j]) %>%
        unbox()
    }
    
    start <- length(pi_names_reformat)
    for (k in 1:length(criteria$pi_names$last_name)) {
      pi_names_reformat[[start+k]] <- data.frame(last_name = criteria$pi_names$last_name[k]) %>%
        unbox()
    }
    
    criteria$pi_names <- pi_names_reformat
  }
  
  if (!is.null(criteria$po_names)) {
    ## asserrt three named character vectors in list
    assert_that(is.list(criteria$po_names),
                has_name(criteria$po_names, "any_name"),
                has_name(criteria$po_names, "first_name"),
                has_name(criteria$po_names, "last_name"),
                is.character(criteria$po_names$any_name),
                is.character(criteria$po_names$first_name),
                is.character(criteria$po_names$last_name))
    
    po_names_reformat <- list()
    
    for (i in 1:length(criteria$po_names$any_name)) {
      po_names_reformat[[i]] <- data.frame(any_name = criteria$po_names$any_name[i]) %>%
        unbox()
    }
    
    start <- length(po_names_reformat)
    for (j in 1:length(criteria$po_names$first_name)) {
      po_names_reformat[[start+j]] <- data.frame(first_name = criteria$po_names$first_name[j]) %>%
        unbox()
    }
    
    start <- length(po_names_reformat)
    for (k in 1:length(criteria$po_names$last_name)) {
      po_names_reformat[[start+k]] <- data.frame(last_name = criteria$po_names$last_name[k]) %>%
        unbox()
    }
    criteria$po_names <- po_names_reformat
  }
  
  if (!is.null(criteria$project_num_split)) {
    ## asserrt 6 named character vectors in list
    assert_that(is.list(criteria$project_num_split),
                has_name(criteria$project_num_split, "appl_type_code"),
                has_name(criteria$project_num_split, "activity_code"),
                has_name(criteria$project_num_split, "ic_code"),
                has_name(criteria$project_num_split, "serial_num"),
                has_name(criteria$project_num_split, "support_year"),
                has_name(criteria$project_num_split, "suffix_code"),
                is.character(criteria$project_num_split$appl_type_code),
                is.character(criteria$project_num_split$activity_code),
                is.character(criteria$project_num_split$ic_code),
                is.character(criteria$project_num_split$serial_num),
                is.character(criteria$project_num_split$support_year),
                is.character(criteria$project_num_split$suffix_code))
  }
  
  if (!is.null(criteria$spending_categories)) {
    ## asserrt two named vectors in list
    assert_that(is.list(criteria$spending_categories),
                length(criteria$spending_categories) == 2,
                has_name(criteria$spending_categories, "values"),
                has_name(criteria$spending_categories, "match_all"),
                is.numeric(criteria$spending_categories$values),
                is.logical(criteria$spending_categories$match_all),
                length(criteria$spending_categories$match_all) == 1 )
  }
  
  if (!is.null(criteria$project_start_date)) {
    ## asserrt two named vectors in list
    assert_that(is.list(criteria$project_start_date),
                length(criteria$project_start_date) == 2,
                has_name(criteria$project_start_date, "from_date"),
                has_name(criteria$project_start_date, "to_date"),
                is.character(criteria$project_start_date$from_date),
                is.character(criteria$project_start_date$to_date))
  }
  
  if (!is.null(criteria$project_end_date)) {
    ## asserrt two named dates in list
    assert_that(is.list(criteria$project_end_date),
                length(criteria$project_end_date) == 2,
                has_name(criteria$project_end_date, "from_date"),
                has_name(criteria$project_end_date, "to_date"),
                is.character(criteria$project_end_date$from_date),
                is.character(criteria$project_end_date$to_date),
                length(criteria$project_end_date$from_date) == 1,
                length(criteria$project_end_date$to_date) == 1 )
  }
  
  
  if (!is.null(criteria$full_study_sections)) {
    assert_that(is.list(criteria$full_study_sections),
                length(criteria$full_study_sections) == 6,
                has_name(criteria$full_study_sections, "irg_code"),
                has_name(criteria$full_study_sections, "sra_designator_code"),
                has_name(criteria$full_study_sections, "sra_flex_code"),
                has_name(criteria$full_study_sections, "group_code"),
                has_name(criteria$full_study_sections, "name"),
                has_name(criteria$full_study_sections, "url"),
                is.character(criteria$full_study_sections$irg_code),
                is.character(criteria$full_study_sections$sra_designator_code),
                is.character(criteria$full_study_sections$sra_flex_code),
                is.character(criteria$full_study_sections$group_code),
                is.character(criteria$full_study_sections$name),
                is.character(criteria$full_study_sections$url))
  }
  
  if (!is.null(criteria$award)) {
    
    assert_that(is.list(criteria$award),
                length(criteria$award) == 3,
                has_name(criteria$award, "award_notice_date"),
                has_name(criteria$award, "award_notice_opr"),
                has_name(criteria$award, "award_amount_range"),
                is.character(criteria$award$award_notice_date),
                is.character(criteria$award$award_notice_opr),
                is.list(criteria$award$award_amount_range),
                length(criteria$award$award_amount_range) == 2,
                has_name(criteria$award$award_amount_range, "min_amount"),
                has_name(criteria$award$award_amount_range, "max_amount"),
                is.numeric(criteria$award$award_amount_range$min_amount),
                is.number(criteria$award$award_amount_range$max_amount))
    
    criteria$award$award_notice_date <- unbox(criteria$award$award_notice_date)
    criteria$award$award_notice_opr <- unbox(criteria$award$award_notice_opr)
    criteria$award$award_amount_range$max_amount <- unbox(criteria$award$award_amount_range$max_amount)
    criteria$award$award_amount_range$min_amount <- unbox(criteria$award$award_amount_range$min_amount)
  }
  
  if (!is.null(criteria$advanced_text_search)) {
    # all(criteria$advanced_text_search$search_field %in% c("projecttitle", "abstract", "terms")) %>% print
    
    assert_that(is.list(criteria$advanced_text_search),
                length(criteria$advanced_text_search) == 3,
                has_name(criteria$advanced_text_search, "operator"),
                has_name(criteria$advanced_text_search, "search_field"),
                has_name(criteria$advanced_text_search, "search_text")
    )
    
    criteria$advanced_text_search$operator %<>% tolower()
    criteria$advanced_text_search$search_field %<>% tolower()
    
    assert_that(length(criteria$advanced_text_search$operator) == 1,
                criteria$advanced_text_search$operator %in% c("and", "or", "advanced"))
    
    assert_that((length(criteria$advanced_text_search$search_field == 1) &
                   all(criteria$advanced_text_search$search_field %in% c("projecttitle", "abstract", "terms"))) ||
                  (length(criteria$advanced_text_search$search_field > 1) &
                     criteria$advanced_text_search$search_field %in% c("all", ""))
                
    )
    
    criteria$advanced_text_search$search_field <- paste0(criteria$advanced_text_search$search_field, collapse = ",") %>% unbox
    criteria$advanced_text_search$operator <- criteria$advanced_text_search$operator %>% unbox
    criteria$advanced_text_search$search_text <- criteria$advanced_text_search$search_text %>% unbox
  }
  
  unbox_elements <- c("use_relevance", "include_active_projects", "is_agency_admin", "is_agency_funding",
                      "exclude_subprojects", "multi_pi_only", "newly_added_projects_only", "sub_project_only"
  )
  
  nms <- names(criteria)
  for (i in 1:length(nms)) {
    if (nms[i] %in% unbox_elements) criteria[[nms[i]]] <- unbox(criteria[[i]])
  }
  
  the_req <- list(
    criteria = criteria %>%
      discard(is.null),
    include_fields = include_fields,
    exclude_fields = exclude_fields,
    offset = unbox(offset), 
    limit = unbox(limit),
    sort_field = unbox(sort_field),
    sort_order = unbox(sort_order)
  ) %>% 
    discard(is.null)
  
  if (is.logical(message) & length(message) == 1 & message) {
    message(paste0("This is your JSON payload:", "\n", the_req %>% toJSON %>% prettify() %>% green(),
                   "\n", "If you receive a non-200 API response, compare this formatting (boxes, braces, quotes, etc.) to the 'Complete Payload' schema provided here:\n",
                   underline("https://api.reporter.nih.gov/?urls.primaryName=V2.0#/Search/post_v2_projects_search", "\n")))
  }
  
  toJSON(the_req) %>%
    return()
}
