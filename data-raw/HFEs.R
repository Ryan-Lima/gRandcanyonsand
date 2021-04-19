# HFE dates

library(lubridate)


year_str <- c("2012","2013","2014","2016","2018")
year_num <- c(2012,2013,2014,2016,2018)

type <-c("HFE","HFE","HFE","HFE","HFE")

start_dt_str <- c("20121118_0600","20131111_0900","20141110_0900","20161107_0600","20181105_0600")

start_dt <- ymd_hm(start_dt_str,tz = 'MST')
start_dt

end_dt_str <- c("20121123_1900","20131116_1500","20141115_1400","20161112_1500","20181108_1500")
end_dt <- ymd_hm(end_dt_str, tz = 'MST')

maxQ <- c(43000,37000,37500,36500,38100)
max_upramp <- c(1500,4000,4000,4000,4000)
max_dnramp <-c(1500,1500,1500,1500,1500)
peak_dur_num <- c(24,96,96,96,60)
peak_dur_hrs <- duration(peak_dur_num, units = 'hours')
flood_dur_num <-c(91,125,125,120,82)
flood_dur_hrs <- duration(flood_dur_num, units = 'hours')

#hfes <- data.frame(YEAR_STR,YEAR_NUM,TYPE,START_DT,START,END_DT,END,MAXQ,MAX_UP_RAMP,MAX_DN_RAMP)

lead_days = days(5)
follow_days = days(5)
buff <- days(2)
start_dt + buff

pre_HFE_interval = interval(start_dt - lead_days,(start_dt + buff) ,tz = 'MST')
post_HFE_interval = interval((end_dt - buff),(end_dt + follow_days), tz = 'MST')
pre_HFE_labels = c('preHFE2012', 'preHFE2013', 'preHFE2014', 'preHFE2016', 'preHFE2018')
post_HFE_labels = c('pstHFE2012', 'pstHFE2013', 'pstHFE2014', 'pstHFE2016', 'pstHFE2018')

HFEs <- data.frame(year_str,
                   year_num,
                   start_dt,
                   start_dt_str,
                   end_dt,
                   end_dt_str,
                   maxQ,
                   max_upramp,
                   max_dnramp,
                   peak_dur_num,
                   peak_dur_hrs,
                   flood_dur_num,
                   flood_dur_hrs,
                   pre_HFE_interval,
                   pre_HFE_labels,
                   post_HFE_interval,
                   post_HFE_labels)

HFEs
usethis::use_data(HFEs,overwrite = T, interal = T)
