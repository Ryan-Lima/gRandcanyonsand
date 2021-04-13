# sandbar survey data by site 8k - 40k

library(devtools)
library(tidyverse)
load_all()
library(lubridate)
library(zoo)


##################################################
all_survey_path = 'data-raw/results_incremental2018.csv'
all_survey_data = read.csv(all_survey_path, header = T)
RC0307Rf_survey_data = all_survey_data %>%
  filter(sitecode == "0030R")


survey_date <- unique(RC0307Rf_survey_data$surveydate)
survey_date  <- ymd(survey_date, tz = 'MST')
survey_years = as.integer(year(survey_date))
surveyid = unique(RC0307Rf_survey_data$surveyid)

date_year = data.frame(survey_years,survey_date,surveyid )


glimpse(date_year)
#############################################


RC0220Ra_surv_data_path = 'data-raw/RC0220Ra_res_incremental_8k_40k.csv'

RC0220Ra_surv_data <- as_tibble(read.csv(RC0220Ra_surv_data_path, header = T))



RC0220Ra_surv_data <- RC0220Ra_surv_data %>%
  mutate(yearmon_str = paste0(year,"-",month))%>%
  mutate(yearmon = as.yearmon(yearmon_str, "%Y-%m"))


glimpse(RC0220Ra_surv_data)
usethis::use_data(RC0220Ra_surv_data ,overwrite = T)
##########################################################
RC0307Rf_surv_data_path = 'data-raw/RC0307Rf_res_incremental_8k_40k.csv'

RC0307Rf_surv_data <- as_tibble(read.csv(RC0307Rf_surv_data_path, header = T))



RC0307Rf_surv_data <- RC0307Rf_surv_data %>%
  mutate(yearmon_str = paste0(year,"-",month))%>%
  mutate(yearmon = as.yearmon(yearmon_str, "%Y-%m"))

df <- left_join(RC0307Rf_surv_data,date_year, by = "surveyid")


RC0307Rf_surv_data <- df
usethis::use_data(RC0307Rf_surv_data ,overwrite = T)
##########################################################
RC1459L_surv_data_path = 'data-raw/RC1459L_res_incremental_8k_40k.csv'

RC1459L_surv_data <- as_tibble(read.csv(RC1459L_surv_data_path, header = T))

glimpse(RC1459L_surv_data)

RC1459L_surv_data <- RC1459L_surv_data %>%
  mutate(yearmon_str = paste0(year,"-",month))%>%
  mutate(yearmon = as.yearmon(yearmon_str, "%Y-%m"))


usethis::use_data(RC1459L_surv_data ,overwrite = T)

