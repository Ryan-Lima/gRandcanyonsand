## code to prepare `SandbarSitesTb` dataset goes here

library(usethis)
library(lubridate)
library(tidyverse)

infile <- "data-raw/sandbar_sites_df.csv"
sandbarSitesDf <- read.csv(infile,header = T)
sandbarSitesTb <- as_tibble(sandbarSitesDf)
sandbarSitesTb <- sandbarSitesTb %>%
  mutate(begin_date = as.character(begin_date))

sandbarSitesTb


usethis::use_data(sandbarSitesTb, overwrite = TRUE, internal = T)
