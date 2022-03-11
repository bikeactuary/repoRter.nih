## have to edit Syntax Highlighter code, comment out one instance of htmlspecialchars_decode()
## editing post in WP after drafting results in html tags in post

library(RWordPress)
library(knitr)

options(WordpressLogin = c(mike = rstudioapi::askForPassword("Login Password")),
        WordpressURL = 'https://bikeactuary.com/xmlrpc.php')

## gotta run this 2x each time, getting very jenky
knit2wp('~/personal/repoRter.nih/blog/release_post_20220310.Rmd',
        title ="repoRter.nih: a convenient R interface to the NIH RePORTER Project API",
        categories = c("Data Science"),
        tags = c("R", "API", "NIH"),
        shortcode = c(TRUE,TRUE),
        # action = "newPost",
        action = "editPost",
        postid = 754,
        publish = FALSE)
