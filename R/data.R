#'@title Tibble of sandbar monitoring sites
#'
#'@description A tibble with the various names that sandbar sites are called by
#'
#'@format A tibble 39 X 6:
#'\describe{
#'  \item{site_code_5}{<chr> 5 character site code ex. '0307R'}
#'  \item{site_name_7}{<chr> 7 character name of the camera without (a-f) deployment modifier ex. 'RC0307R'}
#'  \item{camera}{ <chr> 7 - 8 character name of the camera with (a-f) deployment modifier ex. 'RC0307Rf' }
#'  \item{begin_date}{ <chr> YYYYMMDD when imagery collection started at that site}
#'  \item{end_date}{ <chr> YYYYMMDD when imagery collection eneded at that site}
#'  \item{river_mile}{ <dbl> rivermile down stream from Lees Ferry where the sandbar site is located}
#'
#'}
"sandbarSitesTb"


