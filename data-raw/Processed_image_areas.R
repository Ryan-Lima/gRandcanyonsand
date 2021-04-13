# Process checked segmentation results

'''
This script is intended to take the mySQL database files
for each site which resulted from segmentation with pipeline 3
and subsequent removal of bad images from the manual check
and prime the data for further exploration.

The input data for these should be
nSITE_checked_seg tables in mySQL gcsandbarimagerydb
they have been exported to:
K:/Ryan/R_packages/Chapter_3/Image_data/

the resulting files are called SITE_checked_unprocessed.csv
'''
library(tidyverse)
library(lubridate) # library with important date functions
library(zoo) # imports yearmon objects
library(devtools) # allows use of load_all()
load_all() # loads gRandcanyonsand
library(wesanderson) # import fun color palettes

#### functions to process and clean data #######

convert_datetime_str_to_DTobj <-function(datetime_str, tz = 'MST'){
  # converts a str yyyymmdd_hhmm into a posixCT object
  date <- lubridate::ymd_hm(datetime_str, tz = tz)
  return(date)
}

get_site_from_name_or_id <- function(img_id){
  # get site name and id
  out <- unlist(strsplit(img_id, '_'))
  site <- substr(out[1],3,7)
  return(site)
}

d <- HFEs
d
get_flow_period <- function(dt_posix, hfe_data = d){
  period_lab = NULL
  for (i in 1:nrow(hfe_data)){
    if (dt_posix %within% hfe_data$pre_HFE_interval[i]){
      period_lab = hfe_data$pre_HFE_labels[i]
    }else if(dt_posix %within% hfe_data$post_HFE_interval[i]){
      period_lab = hfe_data$post_HFE_labels[i]
    }else if (dt_posix %within% lubridate::interval(hfe_data$start_dt[i], hfe_data$end_dt[i])){
      period_lab = paste0(hfe_data$year_str[i],"HFE")
    }else{}
  }
  if (is.null(period_lab)){
    month = month(dt_posix)
    year = year(dt_posix)
    period_lab = paste0(month,'-',year)
  }
  return(period_lab)
}

breaks <- c(0,8000,12000,16000,20000,25000,50000)
t <- c("<8k","8k - 12k","12k - 16k", "16k - 20k","20k - 25k", ">25k")
tags <- factor(t, order = T, levels = c("<8k","8k - 12k","12k - 16k", "16k - 20k","20k - 25k", ">25k"))

########################################################
######################## RC0220Ra ######################
########################################################
RC0220Ra_dat_path = 'data-raw/RC0220Ra_checked_unprocessed.csv'
RC0220Ra_chk_unp_df = as_tibble(read.csv(RC0220Ra_dat_path, header = T))

glimpse(RC0220Ra_chk_unp_df)



site_area = 4581.772871
df1 <- RC0220Ra_chk_unp_df %>%
  mutate(dt_posix_img = convert_datetime_str_to_DTobj(datetime_str))%>%
  mutate(site = get_site_from_name_or_id(image_id))%>%
  mutate(river_mile = as.integer(substr(site,1,4))/10)%>%
  mutate(dt_posix_lees = find_dt_4Q_at_Lees(river_mile,datetime_str))%>%
  mutate(year = year(dt_posix_lees))%>%
  mutate(month = month(dt_posix_lees))%>%
  mutate(month_str = month(dt_posix_lees, label = T))%>%
  mutate(yearmon = as.yearmon(paste0(month,'-',year), "%m-%Y"))%>%
  mutate(pr_ref_area = ref_area/site_area)%>%
  mutate(pr_clip_area = clip_area/site_area)


for (i in 1:length(df1$river_mile)){
  out <- find_Q(df1$river_mile[i], df1$datetime_str[i])
  df1$qcfs[i] <- out$Qcfs
  df1$qcms[i] <- out$Qcms
  df1$elevation[i]<-f_E_Q(df1$site[i],out$Qcfs)
  df1$flow_period[i]<- get_flow_period(df1$dt_posix_lees[i],d)
}

RC0220Ra_img_data <- df1%>%
  mutate(closest_bin_num = round(qcfs, -3)) %>%
  mutate(elevation_bin_1k = as.character(closest_bin_num))%>%
  mutate(elevation_bin_4k = case_when(
    qcfs < breaks[2]~ tags[1],
    qcfs >= breaks[2]& qcfs < breaks[3] ~ tags[2],
    qcfs >= breaks[3]& qcfs < breaks[4] ~ tags[3],
    qcfs >= breaks[4]& qcfs < breaks[5] ~ tags[4],
    qcfs >= breaks[5]& qcfs < breaks[6] ~ tags[5],
    qcfs >= breaks[6]& qcfs < breaks[7] ~ tags[6],
  ))

unique(RC0220Ra_img_data$flow_period)
usethis::use_data(RC0220Ra_img_data, overwrite = T)


########################################################
######################## RC0307Rf ######################
########################################################
RC0307Rf_dat_path = 'data-raw/RC0307Rf_checked_unprocessed.csv'
RC0307Rf_chk_unp_df = as_tibble(read.csv(RC0307Rf_dat_path, header = T))

glimpse(RC0307Rf_chk_unp_df)



site_area = 8438.09539
df1 <- RC0307Rf_chk_unp_df %>%
  mutate(dt_posix_img = convert_datetime_str_to_DTobj(datetime_str))%>%
  mutate(site = get_site_from_name_or_id(image_id))%>%
  mutate(river_mile = as.integer(substr(site,1,4))/10)%>%
  mutate(dt_posix_lees = find_dt_4Q_at_Lees(river_mile,datetime_str))%>%
  mutate(year = year(dt_posix_lees))%>%
  mutate(month = month(dt_posix_lees))%>%
  mutate(month_str = month(dt_posix_lees, label = T))%>%
  mutate(yearmon = as.yearmon(paste0(month,'-',year), "%m-%Y"))%>%
  mutate(pr_ref_area = ref_area/site_area)%>%
  mutate(pr_clip_area = clip_area/site_area)

for (i in 1:length(df1$river_mile)){
  out <- find_Q(df1$river_mile[i], df1$datetime_str[i])
  df1$qcfs[i] <- out$Qcfs
  df1$qcms[i] <- out$Qcms
  df1$elevation[i]<-f_E_Q(df1$site[i],out$Qcfs)
  df1$flow_period[i]<- get_flow_period(df1$dt_posix_lees[i],d)
}

RC0307Rf_img_data <- df1%>%
  mutate(closest_bin_num = round(qcfs, -3)) %>%
  mutate(elevation_bin_1k = as.character(closest_bin_num))%>%
  mutate(elevation_bin_4k = case_when(
    qcfs < breaks[2]~ tags[1],
    qcfs >= breaks[2]& qcfs < breaks[3] ~ tags[2],
    qcfs >= breaks[3]& qcfs < breaks[4] ~ tags[3],
    qcfs >= breaks[4]& qcfs < breaks[5] ~ tags[4],
    qcfs >= breaks[5]& qcfs < breaks[6] ~ tags[5],
    qcfs >= breaks[6]& qcfs < breaks[7] ~ tags[6],
  ))

unique(RC0307Rf_img_data$flow_period)
usethis::use_data(RC0307Rf_img_data, overwrite = T)


########################################################
######################## RC1459L ######################
########################################################

RC1459L_dat_path = 'data-raw/RC1459L_checked_unprocessed.csv'
RC1459L_chk_unp_df = as_tibble(read.csv(RC1459L_dat_path, header = T))

glimpse(RC1459L_chk_unp_df)



site_area = 1275.836201
df1 <- RC1459L_chk_unp_df %>%
  mutate(dt_posix_img = convert_datetime_str_to_DTobj(datetime_str))%>%
  mutate(site = get_site_from_name_or_id(image_id))%>%
  mutate(river_mile = as.integer(substr(site,1,4))/10)%>%
  mutate(dt_posix_lees = find_dt_4Q_at_Lees(river_mile,datetime_str))%>%
  mutate(year = year(dt_posix_lees))%>%
  mutate(month = month(dt_posix_lees))%>%
  mutate(month_str = month(dt_posix_lees, label = T))%>%
  mutate(yearmon = as.yearmon(paste0(month,'-',year), "%m-%Y"))%>%
  mutate(pr_ref_area = ref_area/site_area)%>%
  mutate(pr_clip_area = clip_area/site_area)


for (i in 1:length(df1$river_mile)){
  out <- find_Q(df1$river_mile[i], df1$datetime_str[i])
  df1$qcfs[i] <- out$Qcfs
  df1$qcms[i] <- out$Qcms
  df1$elevation[i]<-f_E_Q(df1$site[i],out$Qcfs)
  df1$flow_period[i]<- get_flow_period(df1$dt_posix_lees[i],d)
}

RC1459L_img_data <- df1%>%
  mutate(closest_bin_num = round(qcfs, -3)) %>%
  mutate(elevation_bin_1k = as.character(closest_bin_num))%>%
  mutate(elevation_bin_4k = case_when(
    qcfs < breaks[2]~ tags[1],
    qcfs >= breaks[2]& qcfs < breaks[3] ~ tags[2],
    qcfs >= breaks[3]& qcfs < breaks[4] ~ tags[3],
    qcfs >= breaks[4]& qcfs < breaks[5] ~ tags[4],
    qcfs >= breaks[5]& qcfs < breaks[6] ~ tags[5],
    qcfs >= breaks[6]& qcfs < breaks[7] ~ tags[6],
  ))


unique(RC1459L_img_data$flow_period)
usethis::use_data(RC1459L_img_data, overwrite = T)



