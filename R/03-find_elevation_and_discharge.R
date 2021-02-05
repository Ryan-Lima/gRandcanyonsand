##------ functions to find Q and E
library(ggplot2)


#figure out how to either include datasets as default variables or attach them so the functions work properly

#' `interp_Q` interpolate discharge
#'
#' This function interpolated discharge between 15-minute discharge measurments.
#' The discharge measurements before and after the chosen time datetime are used to solve
#' for the equation of a line, then that line is used to estimate discharge at the chosen datetime
#'
#'y1 <- Q_before
#'y2 <- Q_after
#'x1 <- time_before
#'x2 <- time_after
#'m <- (y2-y1)/(x2 - x1)
#'b <- y1- m*x1
#'x3 <- as.numeric(dt)
#'y3 <- m * x3 + b
#'
#' @param dt lubridate - datetime object
#' @param time_before - numeric datetime, 15-min discharge measurment before
#' @param Q_before - discharge (cfs) associated with time_before in gage_data
#' @param time_after  - numeric datetime, 15-min discharge measurment after
#' @param Q_after  - discharge (cfs) associated with time_after in gage_data
#'
#' @return y3 -- numeric value, interpolated discharge in cfs
#'
#' @export
#'
#' @examples
interp_Q <- function(dt, time_before, Q_before, time_after, Q_after){
  y1 <- Q_before
  y2 <- Q_after
  x1 <- time_before
  x2 <- time_after
  m <- (y2-y1)/(x2 - x1)
  b <- y1- m*x1
  x3 <- as.numeric(dt)
  y3 <- m * x3 + b
  return(y3)
}


#' find Q (discharge cfs)
#'
#' find discharge in cfs given the rm (rivermile) and datetime (a string 'YYYYMMDD_hhmm')
#'
#' @param rm <numeric> rivermile
#' @param datetime <chr> string in format YYYYMMMDD__hhmm (24-hr) timez = 'MST'
#' @param print print = FALSE by default, if print = TRUE useful print statement produced
#'
#' @return  out <- list("Qcfs" = Qcfs, "Qcms" = Qcms)
#' @export
#'
#' @examples
#' out <- find_Q(30.7,"20191002_0030")
#' out
find_Q <-function(rm, datetime, print = F){
  dt <- lubridate::ymd_hm(datetime, tz = 'MST')
  nr_gage_output <- find_nr_gage(rm)
  nr_gage_name <- nr_gage_output$gage_name
  lag <- find_lag_time(rm)
  lagtime <- lag$lagtime
  gage_data_df <- gage_data_list[[nr_gage_name]]
  gage_time <- dt - lagtime
  diff_duration <- gage_data_df$datetime - gage_time
  row_i <- which.min(base::abs(diff_duration))
  min_val <- as.numeric(diff_duration[row_i])
  #interpotlate
  if (min_val < 0){ # in this case the closest gage reading is after gage time
    row_b <- row_i
    row_a <- row_i + 1
  }else if (min_val > 0){
    row_b <- row_i - 1
    row_a <- row_i
  }else{
    row_b <- row_i - 1
    row_a <- row_i + 1
  }
  entry_before <- gage_data_df[row_b,]
  entry_after <-gage_data_df[row_a,]
  Qcfs <- interp_Q(gage_time,entry_before$datetime_num, entry_before$cfs, entry_after$datetime_num, entry_after$cfs)
  Qcms <- Qcfs*0.028316847
  if (print == T){
    print(paste0("Finding approx. Q at river mile:", rm, " at ", dt))
    print(paste0("Nearest gage is {",nr_gage_name,"} lagtime to this gage is {",lagtime,"} approx. gage time is {",gage_time,"}"))
    print(paste0("approx. Q is:", Qcfs,"-cfs & " ,Qcms, "-cms"))
  }else{}
  out <- list("Qcfs" = Qcfs, "Qcms" = Qcms)
  return(out)
}




#' find elevation from Discharge (cfs)
#'
#' find E (water surface elevation) with input of Qcfs, output is list, of Q-cfs, Q-cms, WSE-or-E
#'
#' @param site <chr> 5-letter site name, including 4-character RM and 1-character side of river,
#' ex. 'site = 0307R'
#' @param Qcfs <numeric> discharge in cubic feet per second
#' ex. Qcfs = 8000
#' @param print print = FALSE by default, if print = TRUE useful print statement produced
#'
#' @return out <- list('WSE' = WSE, 'Qcfs' = Qcfs, 'Qcms' = Qcms)
#' `WSE` <numeric> meters
#' `Qcfs` <numeric> cubic feet per second
#' `Qcms` <numeric> cubic meters per second
#'
#' @export
#'
#' @examples
#' out <- find_E_from_Q('0220R', 11200)
#' out
find_E_from_Q <- function(site, Qcfs, print = F){
  Qcfs <- as.numeric(Qcfs)
  # check to see if Qcfs is within range
  if(site %in% site_list_vec){
    site_i <- which(site_list_vec == site)
    site_eq <- get_WSE_from_Q_Tb[site_i,]
    if (Qcfs < site_eq$minQ | Qcfs > site_eq$maxQ){
      print(paste0("Discharge {",Qcfs,"} is out of range. Site discharge range is:"))
      print(paste0(site_eq$minQ,"--to--",site_eq$maxQ))
      out <- list('WSE' = NA, 'Qcfs' = NA, 'Qcms' = NA)
    }else{
      elevation <- site_eq$intercept + site_eq$term1 * Qcfs + site_eq$term2 * Qcfs^2
      WSE <- round(elevation, digits = 3)
      if (print == T){
        print(paste0("Estimating elevation from selected discharge {",Qcfs,"} at {",site,"}"))
        print(paste0("Estimated elevation = {",WSE,"} meters in AZ central state plane 0202"))
      }else{}
      Qcms = Qcfs*0.028316847
      out <- list('WSE' = WSE, 'Qcfs' = Qcfs, 'Qcms' = Qcms)
  }
    }else{
    print(paste0("Site {",site,"} not in site_list_vec, try again."))
    out <- list('WSE' = NA, 'Qcfs' = NA, 'Qcms' = NA)}
  return(out)
}



#' simple - find elevation from discharge (cfs)
#'
#'
#'find E with input of Q-cfs, E =(water surface elevation),  output is 'E' only
#'This function simply outputs elevation, not in a list
#'
#' @param site <chr> 5-letter site name, including 4-character RM and 1-character side of river,
#' ex. 'site = 0307R'
#' @param Qcfs <numeric> discharge in cubic feet per second
#'
#' @return E <numeric> elevation in meters
#' @export
#'
#' @examples
#' f_E_Q('0220R', 22000)
f_E_Q <- function(site,Qcfs){
  outE <- find_E_from_Q(site, Qcfs)
  out <- outE$WSE
  return(out)
}



#' find Elevation and discharge from datetime
#'
#' Given a datetime object and site
#' output estimated water surface elevation in meters and discharge in cfs and cms
#'
#' @param site <chr> 5-letter site name, including 4-character RM and 1-character side of river,
#' ex. 'site = 0307R'
#' @param datetime <chr> string in format YYYYMMMDD__hhmm (24-hr) timez = 'MST'
#' @param print print = FALSE by default, if print = TRUE useful print statement produced
#'
#' @return out <- list('Qcfs' = outQ$Qcfs , 'Qcms' = outQ$Qcms,'WSE' = WSE)
#' @export
#'
#' @examples
#' out <- find_EQ_from_dt('0307R', '20111201_1234')
#' out
find_EQ_from_dt <- function(site, datetime, print = F){
  dt <- lubridate::ymd_hm(datetime, tz = 'MST')
  site_i <- which(site_list_vec == site)
  rm <- as.numeric(substr(site,1,4))/10
  outQ <- find_Q(rm, datetime)
  outE <- find_E_from_Q(site,outQ$Qcfs)
  WSE <- outE$WSE
  if (print == T){
    print(paste0("Estimating elevation and discharge at {",site,"} at {",dt,"}"))
    print(paste0("Estimated discharge = {",outQ$Qcfs,"} cfs and {",outQ$Qcms,"}cms"))
    print(paste0("Estimated elevation = {",WSE,"} meters in AZ state plane"))
  }else{}
  out <- list('Qcfs' = outQ$Qcfs , 'Qcms' = outQ$Qcms,'WSE' = WSE)
  return(out)
}




#' find discharge given elevation
#'
#' @param site <chr> 5-letter site name, including 4-character RM and 1-character side of river,
#' ex. 'site = 0307R'
#' @param E <numeric> elevation in meters AZ central state plane
#' @param print print = FALSE by default, if print = TRUE useful print statement produced
#'
#' @return out <- list('WSE' = E, 'Qcfs' = Qcfs, 'Qcms' = Qcms)
#' @export
#'
#' @examples
#' out <- find_Q_from_E('0220R', 881.55)
#' out
find_Q_from_E <- function(site, E, print = F){
  if(site %in% site_list_vec){
    site_i <- which(site_list_vec == site)
    site_eq <- get_Q_from_WSE_Tb[site_i,]
    if (E < site_eq$minE | E > site_eq$maxE){
      print(paste0("Elevation {",E,"} is out of range. Site elevation range is:"))
      print(paste0(site_eq$minE,"--to--",site_eq$maxE))
      out <- list('WSE' = E, 'Qcfs' = NA, 'Qcms' = NA)
    }else{
      Qcfs <- site_eq$intercept + site_eq$term1 * E + site_eq$term2 * E^2
      Qcms <- Qcfs*0.028316847
      out <- list('WSE' = E, 'Qcfs' = Qcfs, 'Qcms' = Qcms)
      if (print == T){
        print(paste0("Estimating Discharge in cfs at site {",site,"} at elevation {",E,"} meters"))
        print(paste0("Estimated Q = {",Qcfs,"}cfs -- {",Qcms,"}cms"))
      }else{}
    }
  }else{
    print(paste0("Site {",site,"} not in site_list_vec, try again."))
    out <- list('WSE' = E, 'Qcfs' = NA, 'Qcms' = NA)}
  return(out)
}




#' plot stage-discharge observation and model for given site
#'
#' @param site <chr> 5-letter site name, including 4-character RM and 1-character side of river,
#' ex. 'site = 0307R'
#'
#' @return plot of stage discharge relationship at selected site
#' @export
#'
#' @examples
plot_site_sd <- function(site){
  if(site %in% site_list_vec){
    site_i <- which(site_list_vec == site)
    site_sd_df <- stage_discharge_data[[site_i]]
    fit <- lm(Q ~Elevation + I(Elevation^2), data = site_sd_df)
    prd <- data.frame(Elevation = seq(from = range(site_sd_df$Elevation)[1],
                                      to = range(site_sd_df$Elevation)[2],
                                      length.out = 100))
    err <- predict(fit, newdata = prd, se.fit = T)
    prd$lci <- err$fit - 2*1.96 * err$se.fit
    prd$fit <- err$fit
    prd$uci <- err$fit + 2*1.96 * err$se.fit
    title <- paste0("Modeled and observed stage-discharge relationship for ", site)
    adj_rsq <- signif(summary(fit)$adj.r.squared, 3)
    pval <- signif(summary(fit)$coef[2,4], 3)
    lab <-paste("adj.R^2 == ", adj_rsq,"; pvalue ==", pval)
    out <- ggplot2::ggplot(prd, aes(x = Elevation, y = fit)) +
      theme_light()+
      geom_line() +
      geom_smooth(aes(ymin = lci, ymax = uci), stat = 'identity') +
      geom_point(data = site_sd_df, aes(x = Elevation, y = Q), color = "red")+
      labs(y = expression( Discharge~ft^{"3"}/sec), x =expression( Elevation~(meters)))+
      ggtitle(title) +
      annotate('text', x = (max(site_sd_df$Elevation)-1.5), y = 10000,label = lab, parse = T)
  }else{
    print(paste0("Site {",site,"} not in site_list_vec, try again."))
    out <- NULL
  }
  return(out)
}





