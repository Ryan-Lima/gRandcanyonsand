# load and process gage data

library(usethis)
library(lubridate)
library(tidyverse)

raw_gage_lag <- read.csv("data-raw/gage_lag.csv", colClasses = c("gage_number" = "character",
                                                                 "gage_name" = "character",
                                                                 "gage_mile_char" = "character",
                                                                 "gage_mile_num" = "numeric",
                                                                 "lag_slope" = "numeric",
                                                                 "lag_intercept" = "numeric"),header = T)

gage_lag_Tb <- tibble::as_tibble(raw_gage_lag)
gage_lag_Tb <- gage_lag_Tb[0:5,] # remove diamond creek for now

raw_gage_data_0000_mile <-read.delim("data-raw/gage_09380000_20100101_20210105.tsv", header = T)
gage_data_0000_mile <- raw_gage_data_0000_mile %>%
  mutate(datetime = lubridate::ymd_hms(time..MST., tz = "MST"))%>%
  mutate(datetime_num = as.numeric(datetime))%>%
  mutate(cfs = as.numeric(Discharge.cfs..09380000 ))%>%
  mutate(cms = as.numeric(Discharge.cfs..09380000*0.028316847))%>%
  select('datetime','datetime_num', 'cfs','cms')%>%
  na.omit(.)


raw_gage_data_0030_mile <-read.delim("data-raw/gage_09383050_20100101_20201028.tsv", header = T)
gage_data_0030_mile <- raw_gage_data_0030_mile %>%
  mutate(datetime = lubridate::ymd_hms(time..MST., tz = "MST"))%>%
  mutate(datetime_num = as.numeric(datetime))%>%
  mutate(cfs = as.numeric(Discharge.cfs..09383050 ))%>%
  mutate(cms = as.numeric(Discharge.cfs..09383050*0.028316847))%>%
  select('datetime','datetime_num', 'cfs','cms')%>%
  na.omit(.)

raw_gage_data_0061_mile <-read.delim("data-raw/gage_09383100_20100101_20201130.tsv", header = T)
gage_data_0061_mile <- raw_gage_data_0061_mile %>%
  mutate(datetime = lubridate::ymd_hms(time..MST., tz = "MST"))%>%
  mutate(datetime_num = as.numeric(datetime))%>%
  mutate(cfs = as.numeric(Discharge.cfs..09383100 ))%>%
  mutate(cms = as.numeric(Discharge.cfs..09383100*0.028316847))%>%
  select('datetime','datetime_num', 'cfs','cms')%>%
  na.omit(.)


raw_gage_data_0087_mile <-read.delim("data-raw/gage_09402500_20100101_20210105.tsv", header = T)
gage_data_0087_mile <- raw_gage_data_0087_mile %>%
  mutate(datetime = lubridate::ymd_hms(time..MST., tz = "MST"))%>%
  mutate(datetime_num = as.numeric(datetime))%>%
  mutate(cfs = as.numeric(Discharge.cfs..09402500 ))%>%
  mutate(cms = as.numeric(Discharge.cfs..09402500*0.028316847))%>%
  select('datetime','datetime_num', 'cfs','cms')%>%
  na.omit(.)


raw_gage_data_0166_mile <-read.delim("data-raw/gage_09404120_20100101_20200825.tsv", header = T)
gage_data_0166_mile <- raw_gage_data_0166_mile %>%
  mutate(datetime = lubridate::ymd_hms(time..MST., tz = "MST"))%>%
  mutate(datetime_num = as.numeric(datetime))%>%
  mutate(cfs = as.numeric(Discharge.cfs..09404120 ))%>%
  mutate(cms = as.numeric(Discharge.cfs..09404120*0.028316847))%>%
  select('datetime','datetime_num', 'cfs','cms')%>%
  na.omit(.)

#raw_gage_data_0225_mile <-read.delim("data-raw/gage_09404200_20100101_20210105.tsv", header = T) # remove diamond creek for now

gage_data_list <- list("LeesFerry" = gage_data_0000_mile,
                       "ThirtyMile" = gage_data_0030_mile,
                       "LCR"  = gage_data_0061_mile,
                       "PhantomRanch" = gage_data_0087_mile,
                       "NationalCanyon" = gage_data_0166_mile)

## how to call single gage data
#LCR = gage_data_list[['LCR']]


begin_date_0000 <- gage_data_0000_mile$datetime[1] # first date in record
begin_date_0030 <- gage_data_0030_mile$datetime[1]
begin_date_0061 <- gage_data_0061_mile$datetime[1]
begin_date_0166 <- gage_data_0166_mile$datetime[1]

begin_date <- vector(length = nrow(gage_lag_Tb))
class(begin_date)<-"Date"
end_date <- vector(length = nrow(gage_lag_Tb))
class(end_date)<-"Date"

for (i in 1:length(gage_lag_Tb$gage_name)){
  name <- gage_lag_Tb$gage_name[i]
  begin <- gage_data_list[[name]]$datetime[1]
  n <- length(gage_data_list[[name]]$datetime)
  end <- gage_data_list[[name]]$datetime[n]
  begin_date[i]<-begin
  end_date[i]<- end
}


gage_lag_Tb <- gage_lag_Tb %>%
  add_column(begin_date)%>%
  add_column(end_date)

#gage_lag_Tb
usethis::use_data(gage_lag_Tb, overwrite = T, internal = T)
usethis::use_data(gage_data_list, overwrite = T, internal = T)

