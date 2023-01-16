# Generate plots for vignette in advance to reduce run-time during CRAN system checks

library(tibble)
library(repoRter.nih)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(scales)
library(tufte)

data("covid_response_codes")
data("nih_fields")

cov_req <- make_req(criteria =
                      list(covid_response = c("All")),
                    include_fields = nih_fields %>%
                      filter(payload_name %in% c("award_amount_range", "covid_response"))
                    %>% pull(include_name))

cov_res <- get_nih_data(cov_req,
                        flatten_result = TRUE)

if (class(cov_res)[1] == "tbl_df") {
  p <- cov_res %>%
    left_join(covid_response_codes, by = "covid_response") %>%
    mutate(covid_code_desc = case_when(!is.na(fund_src) ~ paste0(covid_response, ": ", fund_src),
                                       TRUE ~ paste0(covid_response, " (Multiple)"))) %>%
    group_by(covid_code_desc) %>%
    summarise(total_awards = sum(award_amount) / 1e6) %>%
    ungroup() %>%
    arrange(desc(covid_code_desc)) %>%
    mutate(prop = total_awards / sum(total_awards),
           csum = cumsum(prop),
           ypos = csum - prop/2 ) %>%
    ggplot(aes(x = "", y = prop, fill = covid_code_desc)) +
    geom_bar(stat="identity") +
    geom_text_repel(aes(label =
                          paste0(dollar(total_awards,
                                        accuracy = 1,
                                        suffix = "M"),
                                 "\n", percent(prop, accuracy = .01)),
                        y = ypos),
                    show.legend = FALSE,
                    nudge_x = .8,
                    size = 3, color = "grey25") +
    coord_polar(theta ="y") +
    theme_void() +
    theme(legend.position = "right",
          legend.title = element_text(colour = "grey25"),
          legend.text = element_text(colour="blue", size=6, 
                                     face="bold"),
          plot.title = element_text(color = "grey25"),
          plot.caption = element_text(size = 6)) +
    labs(caption = "Data Source: NIH RePORTER API v2") +
    ggtitle("Legislative Source for NIH Covid Response Project Funding")
}
detach("package:repoRter.nih", unload = TRUE)

# if (class(p)[1] == "gg") {
#   p
# }

ggsave("covid_plot.png", p)
saveRDS(cov_res, "cov_res.RDS")
