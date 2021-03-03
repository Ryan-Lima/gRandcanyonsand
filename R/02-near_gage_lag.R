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

