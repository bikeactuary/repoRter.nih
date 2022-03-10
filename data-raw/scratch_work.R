## some scratch work for datasets
## nih_fields was manual and should be improved in future

nih_fields <- tibble(payload_name = colnames(res),
                     response_name = payload_name,
                     filter_name = response_name %>% janitor::make_clean_names(case = "big_camel"),
                     return_object_class = unlist(lapply(res, class), use.names = FALSE))

## used this as starting point, gone through api doc to make mods
## upload work from csv
nih_fields <- read.csv("data/names.csv") %>%
  as_tibble()
nih_fields[nih_fields == ""] <- NA

## I notice some payload terms return multiple fields - need to restructure this mapping 1-to-many

save(nih_fields, file = "data/nih_fields.rda")
# load("data/nih_fields.RData")
covid_response_codes <- tibble(covid_response = c("Reg-CV", "CV", "C3", "C4", "C5", "C6"),
                               funding_source = c("NIH regular appropriations funding", 
                                                  "Coronavirus Preparedness and Response Supplemental Appropriations Act, 2020",
                                                  "CARES Act (Coronavirus Aid, Relief, and Economic Security Act), 2020",
                                                  "Paycheck Protection Program and Health Care Enhancement Act, 2020",
                                                  "Coronavirus Response and Relief Supplemental Appropriations Act, 2021",
                                                  "American Rescue Plan Act of 2021" ),
                               fund_src = c("NIH Reg Appropriations",
                                            "Coronav Prep & Reponse Act", 
                                            "CARES Act",
                                            "PPP & Health Care Enhance Act",
                                            "Coronav Response & Relief Act",
                                            "American Rescue Plan"))
save(covid_response_codes, file = "data/covid_response_codes.rda")
# load("data/covid_response_codes.RData")
