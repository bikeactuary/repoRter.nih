#' @title get_nih_data
#'
#' @description Easily send a pre-made JSON request to NIH RePORTER Project API, retrieve and process the results
#'
#' @param query A valid JSON request formatted for the RePORTER Project API, as returned by the \code{\link{make_req}} method
#' @param max_pages numeric(1); default: NULL; An integer specifying to only fetch (up to) the first \code{max_pages} number of pages from the result set.
#'     Useful for testing your query/obtaining schema information. Default behavior is to fetch all pages.
#' @param flatten_result (default: FALSE) If TRUE, flatten nested dataframes and collapse nested vectors to a single character column with elements delimited by a semi-colon
#' @param return_meta (default: FALSE) If TRUE, will return a \code{list} containing your result set as well as the meta data - this includes a count of total projects matching
#'     your query and can be useful for programming.
#' 
#' @return A \code{tibble} containing your result set (API max of 10,000 records); or if \code{include_meta = TRUE}, a list containing your \code{tibble} and your metadata from the response
#' 
#' @details A request to the RePORTER Project API requires retrieving paginated results, combining them, and often
#'     flattening the combined ragged data.frame to a familiar flat format which we can use in analyses. This
#'     method handles all of that for you.
#' 
#' @examples
#' 
#' \donttest{
#' library(repoRter.nih)
#' 
#' ## make the usual request
#' req <- make_req(criteria = 
#'                     list(advanced_text_search = 
#'                         list(operator = "Or",
#'                              search_field = "all",
#'                              search_text = "sarcoidosis lupus") ),
#'                  message = FALSE)
#' 
#' ## get the data ragged
#' res <- get_nih_data(req,
#'                     max_pages = 1)
#' 
#' ## get the data flattened
#' res_flattened <- get_nih_data(req,
#'                               flatten_result = TRUE,
#'                               max_pages = 1)
#' }
#' 
#' @rawNamespace import(tibble, except = "has_name")
#' @import dplyr
#' @import httr
#' @import jsonlite
#' @import crayon
#' @import magrittr
#' @importFrom janitor "clean_names"
#' @export
get_nih_data <- function(query, max_pages = NULL, flatten_result = FALSE, return_meta = FALSE) {
  
  assert_that(validate(query),
              is.numeric(max_pages) | is.null(max_pages),
              is.logical(flatten_result),
              is.logical(return_meta))
  
  endpoint <- "https://api.reporter.nih.gov/v2/projects/Search"
  query_lst <- fromJSON(query)
  
  pages <- list()
  offset <- as.numeric(query_lst$offset)
  limit <- as.numeric(query_lst$limit)
  
  message("Retrieving first page of results (up to ", limit, " records)")
  
  res <- tryCatch(
    {
      RETRY("POST",
            url = endpoint,
            accept("text/plain"),
            content_type_json(),
            body = query)
    },
    error = function(msg) {
      message(paste0("Failed unexpectedly on initial connect to API. Here is the error message from POST call:",
                     "\n", msg) %>% red() )
      stop("Exiting from get_nih_data()")
    }
  )
  
  if (res$status_code != 200) {
    stop("API Error: received non-200 response")
  }
  
  res %<>% content(as = "text") %>%
    fromJSON()
  meta <- res$meta
  
  if (meta$total == 0) {
    message(green("Done - 0 records returned. Try a different search criteria."))
    if(return_meta) {
      list(records = NA,
           meta = meta) %>%
        return()
    } else {
      return(NA)
    }
  }
  
  pages[[1]] <-  res %>%
    extract2("results")
  
  page_count <- ceiling(meta$total / limit)
  
  if (!is.null(max_pages)) {
    if (max_pages >= page_count) {
      message(paste0("max_pages set to ", max_pages, " by user, but result set only contains ", page_count, " pages.  Retrieving the full result set..."))
    } else if (max_pages < page_count) {
      message(paste0("max_pages set to ", max_pages, " by user. Result set contains ", page_count, " pages. Only partial results will be retrieved."))
    }
    iters <- min(page_count, max_pages)
  } else {
    iters <- page_count
  }
  
  if (iters > 1) {
    
    queries <- list()
    queries[[1]] <- query
    Sys.sleep(1)
    
    for (i in 2:iters) {
      new_offset <- (i-1)*limit
      
      queries[[i]] <- gsub(paste0("\"offset\":", new_offset-limit), paste0("\"offset\":", new_offset), queries[[i-1]])
      
      message("Retrieving results ", (i-1)*limit+1, " to ", min((i)*limit, meta$total), " of ", meta$total)
      res <- RETRY("POST",
                   url = endpoint,
                   accept("text/plain"),
                   content_type_json(),
                   body = queries[[i]])
      
      if (res$status_code != 200) {
        message(paste0("API request failed for page #", i, ". Skipping to next page.") %>% red() )
        next
      }
      
      res %<>% content(as = "text") %>%
        fromJSON()
      
      pages[[i]] <- res$results
      Sys.sleep(1)
    }
  }
  
  ## fails during devtools::check() with an error
  ## message about installing plyr
  # ret <- bind_rows(pages) %>%
  #   as_tibble()
  
  df <- bind_rows(pages)
  ret <- as_tibble(df)
  
  if (flatten_result) {
    # flatten nested data frames (not lists of data frames)
    ret %<>% 
      flatten() %>%
      clean_names() %>%
      as_tibble()
    
    # flatten lists of vectors
    ret %<>% 
      mutate(across(, function(x) {
        if (is.list(x) && is.vector(x[[1]]) && is.atomic(x[[1]])) {
          sapply(x, function(y) paste0(y, collapse = ";")) %>%
            return()
        } else { return(x) }
      }))
  }
  
  if (return_meta) {
    list(records = ret,
         meta = meta) %>%
      return()
  } else {
    ret %>%
      return()
  }
}
