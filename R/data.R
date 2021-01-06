#'@title 'sandbarSitesTb' Tibble of sandbar monitoring sites
#'
#'@description A tibble with the various names that sandbar sites are called by
#'
#'@format A tibble 39 X 6
#'- `site_code_5` <chr> 5 character site code ex. "0307R"
#'- `site_name_7` <chr> 7 character name of the camera without (a-f) deployment modifier ex. "RC0307R"
#'- `camera`<chr> 7-8 character name of the camera with (a-f) deployment modifier ex. "RC0307Rf"
#'- `begin_date` <chr> YYYYMMDD when imagery collection began at that site/deployment
#'- `end_date` <chr> YYYYMMDD when imagery collection ended at that site
#'- `river_mile` <dbl> river mile downstream from Lees Ferry where the sandbar site is located
#'
"sandbarSitesTb"

#'@title 'gage_lag_Tb' tibble of gages and lag coefficients
#'
#'@description A tibble containing information about Grand Canyon gages including lag coefficients
#'
#'@format A tibble 5 x 8
#'-  `gage_number` <chr> USGS gage identification number
#'-  `gage_name` <chr> colloquial names for GC gages
#'-  `gage_mile_char` <chr> 4 digit river mile as character
#'-  `gage_mile_num` <dbl> gage river mile
#'-  `lag_slope` <dbl> slope for the line to predict lag from each gage
#'-  `lag_intercept` <dbl> inrecept for the line to predict lag for each gage
#'-  `begin_date` <date> beginning date for the gage data inside this package for the gage in question
#'-  `end_date` <date> end date for the gage data inside this package for the gage in question
#'
"gage_lag_Tb"


#'@title 'gage_data_list' list of data frames of GC gages
#'
#'
#'@description A list of data frames containing 15-minute discharge data for 5 gages in Grand Canyon
#'
#'@format A list containing 5 data frames
#'-  `gage_data_list` - "LeesFerry" df of datetime, discharge for  0-mile
#'-  `gage_data_list` - "ThirtyMile" df of datetime, discharge for  30-mile
#'-  `gage_data_list` - "LCR" df of datetime, discharge for  61-mile
#'-  `gage_data_list` - "PhantomRanch" df of datetime, discharge for  87-mile
#'-  `gage_data_list` - "NationalCanyon" df of datetime, discharge for  166-mile
#'
"gage_data_list"

