#' Find the nearest upstream gage
#'
#' @param rm --numeric-- river mile, miles downstream from Lees Ferry
#' @param print print = FALSE by default, if print = TRUE, distance and closest gage statement printed
#'
#' @return out = list('gage_name'= "LeesFerry",'index'=1,'distance_to_gage'= -10)
#' @export
#'
#' @examples
#' out <- find_us_gage(30.7)
find_us_gage <- function(rm, print = F){
  if (is.numeric(rm)){
    if (rm < 226 & rm >= 0){
      diff <- rm - gage_lag_Tb$gage_mile_num
      ng_i <- which.max(1/diff)
      near_gage_up <- gage_lag_Tb$gage_mile_num[ng_i]
      near_gage_up_name <- gage_lag_Tb$gage_name[ng_i]
      if (print == T){
        print(paste0("The closest upstream gage is: ",near_gage_up_name, "; the distance to the upstream gage is: ", -diff[ng_i], " river miles"))
      }else{}
      out <- list("gage_name"= near_gage_up_name, "index" = ng_i, "distance_to_gage" = -diff[ng_i])
    }else{
      out <- list("gage_name"= NA, "index" = NA, "distance_to_gage" = NA)
    print("Rivermile (rm) out of range, must be between 0 and 225")}
  }else{
    out <- list("gage_name"= NA, "index" = NA, "distance_to_gage" = NA)
    print("Rivermile (rm) needs to be type numeric")}
  return(out)
}


#' Find the nearest downstream gage
#'
#' @param rm --numeric-- river mile, miles downstream from Lees Ferry
#' @param print print = FALSE by default, if print = TRUE, distance and closest gage statement printed
#'
#' @return out = list('gage_name'= "LeesFerry",'index'=1,'distance_to_gage'= -10)
#' @export
#'
#' @examples
#' out <- find_ds_gage(30.7)
find_ds_gage <- function(rm, print = F){
  if (is.numeric(rm)){
    if (rm < 166 & rm >= 0){
      diff <- rm - gage_lag_Tb$gage_mile_num
      # ng_i = near gage index
      ng_i <- which.max(1/-diff)
      near_gage_dn <- gage_lag_Tb$gage_mile_num[ng_i]
      near_gage_dn_name <- gage_lag_Tb$gage_name[ng_i]
      if (print == T){
        print(paste0("The closest downstream gage is: ", near_gage_dn_name,"; the distance to the downstream gage is: ", -diff[ng_i], " river miles"))
      }else{}
      out <- list("gage_name"= near_gage_dn_name, "index"= ng_i, "distance_to_gage" = -diff[ng_i])
    }else{
      out <- list("gage_name"= NA, "index"= NA, "distance_to_gage" = NA)
      print("Rivermile (rm) out of range, must be between 0 and 166")}
  }else{
    out <- list("gage_name"= NA, "index"= NA, "distance_to_gage" = NA)
    print("Rivermile (rm) needs to be type numeric")}
  return(out)
}

#' Find the nearest gage
#'
#' @param rm --numeric-- river mile, miles downstream from Lees Ferry
#' @param print print = FALSE by default, if print = TRUE, distance and closest gage statement printed
#'
#' @return out = list('gage_name'= "LeesFerry",'index'=1,'distance_to_gage'= -10)
#' @export
#'
#' @examples
#' out <- find_nr_gage(30.7)
find_nr_gage <- function(rm, print = F){
  if (is.numeric(rm)){
    if (rm < 226 & rm >= 0){
      diff <- rm - gage_lag_Tb$gage_mile_num
      ng_i <- which.min(base::abs(diff))
      near_gage <- gage_lag_Tb$gage_mile_num[ng_i]
      near_gage_name <- gage_lag_Tb$gage_name[ng_i]
      if (print == T){
        print(print(paste0("The nearest gage is: ", near_gage_name,"; the distance to the nearest gage is: ", -diff[ng_i], " river miles")))
      }else{}
      out <- list("gage_name" = near_gage_name, "index" = ng_i, "distance_to_gage" = -diff[ng_i])
    }else{
      out <- list("gage_name"= NA, "index" = NA, "distance_to_gage" = NA)
      print("Rivermile (rm) out of Range, must be between 0 and 225")
    }
  }else{
    out <- list("gage_name"= NA, "index" = NA, "distance_to_gage" = NA)
    print("Rivermile (rm) needs to be type Numeric")}
  return(out)
}



#' Find lag time to the nearest gage
#' @importFrom lubridate duration
#' @param rm --numeric-- river mile, miles downstream from Lees Ferry
#' @param print print = FALSE by default, if print = TRUE, lag time and nearest gage printed out
#'
#' @return out = list('lagtime' = --lubridate duration object--, 'nearest_gage' = "LCR" , 'nearest_gage_index' = 3)
#' @export
#'
#' @examples
#' out <- find_lag_time(220)
find_lag_time <- function(rm, print = F){
  nr_gage <- find_nr_gage(rm)
  i <- nr_gage$index
  gage_name <- gage_lag_Tb$gage_name[i]
  lag_slope <- gage_lag_Tb$lag_slope[i]
  lag_intercept <- gage_lag_Tb$lag_intercept[i]
  lag_hours <- lag_slope*rm + lag_intercept
  lagtime_hours <- lubridate::duration(lag_hours, units = 'hours')
  if (print == T){
    print(paste0("Selected river mile = ",rm,
                 " ;nearest gage = ",gage_name,
                 " ;distance in rivermiles = ",nr_gage$distance_to_gage,
                 ";lag hours = ",lag_hours))
  }else{}
  out <- list('lagtime' = lagtime_hours,'nearest_gage'= gage_name, 'nearest_gage_index'= i)
  return(out)
}





#' find datetime for Q at Lees Ferry
#'
#' @param rm -- numeric --
#' @param datetime_str -- string of datetime in format "YYYYMMDD_hhmm" - 24hr
#' @param print == F by default, if true, it prints a statement
#'
#' @return POSIXct, format: "YYYY-mm-dd hh:mm:ss"
#' @export
#'
find_dt_4Q_at_Lees <- function(rm, datetime_str, print = F){
  # Estimated DT when image discharge was at Lees Ferry
  gage_i = 1
  image_dt = lubridate::ymd_hm(datetime_str, tz = 'MST')
  gage_name <- gage_name<- gage_lag_Tb$gage_name[gage_i]
  lag_slope <- gage_lag_Tb$lag_slope[gage_i]
  lag_intercept <- gage_lag_Tb$lag_intercept[gage_i]
  lag_hours <- lag_slope*rm + lag_intercept
  lagtime_hours <- lubridate::duration(lag_hours, units = 'hours')
  correction <- 0.02878684 * rm
  hr_corr <- lubridate::duration(correction, units = 'hours')
  Lees_dt <- image_dt - (lagtime_hours - hr_corr)
  Lees_dt<- lubridate::as_datetime(Lees_dt, tz = "MST")
  if (print == T){
    print(paste0(" The dischage at river mile: ",rm))
    print(paste0(" at --", image_dt))
    print(paste0(" was at Lees Ferry at about --",Lees_dt))
    print(paste0(" A time difference of : ",lagtime_hours - hr_corr ))
  }
  return(Lees_dt)
}


#' Find the datetime when a flow will reach a given rivermile and datetime at Lees Ferry
#'
#' @param rm -- numeric --
#' @param Lees_datetime_str -- string of datetime in format "YYYYMMDD_hhmm" - 24hr
#' @param print == F by default, if true, it prints a statement
#'
#' @return
#' @export
#'
find_ds_traveltime_dt <- function(rm, Lees_datetime_str, print = F){
  # estimated datetime when flow at Lees reaches given rm
  gage_i = 1
  Lees_dt = lubridate::ymd_hm(Lees_datetime_str, tz = 'MST')
  gage_name <- gage_name<- gage_lag_Tb$gage_name[gage_i]
  lag_slope <- gage_lag_Tb$lag_slope[gage_i]
  lag_intercept <- gage_lag_Tb$lag_intercept[gage_i]
  lag_hours <- lag_slope*rm + lag_intercept
  lagtime_hours <- lubridate::duration(lag_hours, units = 'hours')
  print(lagtime_hours)
  correction <- 0.02878684 * rm
  hr_corr <- lubridate::duration(correction, units = 'hours')
  downstream_dt <- Lees_dt + (lagtime_hours - hr_corr)
  if (print == T){
    print(paste0(" The dischage at Lees Ferry at: ", Lees_dt ))
    print(paste0("Should arrive at river mile-- ",rm))
    print(paste0("at approximatly: ",downstream_dt))
    print(paste0(" A time difference of : ",lagtime_hours - hr_corr ))
  }
  return(downstream_dt)
}


#' convert cubic feet per second into cubic meters per second
#'
#' @param cfs cubic feet per second
#'
#' @return cms cubic meters per second
#' @export
#'
#' @examples
#' cfs_to_cms(8000)
cfs_to_cms <- function(cfs){
  cms <- (cfs * 0.028316846592)
  return(cms)
}


#' convert cubic meters per second to cubic feet per second
#'
#' @param cms cubic meters per second
#'
#' @return cfs cubic feet per second
#' @export
#'
#' @examples
#' cms_to_cfs(227)
cms_to_cfs <- function(cms){
  cfs <- (cms/0.028316846592)
  return(cfs)
}


#' estimate flow volume from vector of 15-minute stage discharges in cfs
#'
#' @param vec_cfs a vector of 15-minute discharge readings in cfs
#'
#' @return acre_feet the volume of water during that time in acre-feet
#' @export
#'
#' @examples
cfs15min_to_acrefeet<- function(vec_cfs){
  # vector of 15-minute discharges
  # multiplies 15-minute cfs by 900 seconds to get volume over 15-minutes
  # sum all of those 15-minute volumes
  # divide by constant 43560 to get acre feet of water
  acre_feet = sum(vec_cfs*900)/43560
  return(acre_feet)
}
