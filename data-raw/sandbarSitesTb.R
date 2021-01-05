## code to prepare `SandbarSitesTb` dataset goes here

sandbarSitesDf <- read.csv("data-raw/sandbar_sites_df.csv", header = T)
sandbarSitesTb <- as_tibble(sandbarSitesDf)



usethis::use_data(sandbarSitesTb, overwrite = TRUE)
