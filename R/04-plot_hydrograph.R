# 03- plot_hydrograph




#' plot hydrograph
#'
#' @importFrom dplyr filter mutate
#' @importFrom lubridate ymd_hm interval %within% as.duration
#' @importFrom magrittr "%>%"
#' @importFrom ggplot2 ggplot aes  geom_point geom_line xlab ylab theme_bw geom_hline ggtitle
#' @param rm river mile downstream from lees ferry, numeric
#' @param start_dt_str string of start date and time YYYMMDD_hhmm (24hr)
#' @param end_dt_str string  of end date and time YYYMMDD_hhmm (24hr)
#' @param ylabloc numeric, specifies vertical location of Q labels,
#'  in cfs/cms above/below red/blue lines
#' @param xlabloc numeric, specifying horizontal location of Q-labels,
#'  1/(xlabloc = 2)put the label
#' in the middle of the plot, 1/xlabloc = 4 puts the label on the left,
#'  experiment
#' @param LoQ where (cfs/cms)to display a low Q line
#' @param HiQ where (cfs/cms)to display a hi Q line
#' @param unit_cfs default is T, displays in cubic feet per second,
#' if unit_cfs = F, displays in cubic meters per second
#'
#' @return hydrograph (figure)
#' @export
#'
plot_hydrograph <- function(rm, start_dt_str,
                            end_dt_str,
                            ylabloc = 300,
                            xlabloc = 1.5,
                            LoQ = 8000,
                            HiQ = 25000,
                            unit_cfs = T) {
  start_DT <- ymd_hm(start_dt_str, tz = 'MST')
  end_DT <- ymd_hm(end_dt_str, tz = 'MST')
  Hrange <- interval(start_DT,end_DT)
  quarter <- Hrange/xlabloc
  q <- as.duration(quarter)
  Xval <- start_DT + q
  ng <- find_nr_gage(rm)
  gi <- ng$index
  gdata = gage_data_list[[gi]]
  Drange = interval(gdata$datetime[1],gdata$datetime[nrow(gdata)])
  if (Hrange %within% Drange){
    #print("Chosen Date Range is within the available gage data range")
  }else{
    print("Chosen Date Range is not available. adjust start/end datetime")
    stop()
  }
  lag <- find_lag_time(rm)
  lag_dur <- lag$lagtime
  gage_time_s <- start_DT - lag_dur
  gage_time_e <- end_DT - lag_dur
  diff_dur_start <- gdata$datetime - gage_time_s
  diff_dur_end <- gdata$datetime - gage_time_e
  i_start <- which.min(base::abs(diff_dur_start))
  i_end <- which.min(base::abs(diff_dur_end))
  hydr_data <- gdata[i_start:i_end,]
  h_data <- hydr_data %>%
    mutate(DT_h = datetime - lag_dur) %>%
    mutate(DT_hnum = as.numeric(datetime_num - lag_dur))
  if (unit_cfs == T){
    labLow = paste0(LoQ," [ft^3/s^-1]")
    labHi = paste0(HiQ," [ft^3/s^-1]")
    title_txt <- paste0("Hydrograph for Colorado River at RM:",rm)
    subtitle_txt <- paste0("For dates: ",gage_time_s, " -to:", gage_time_e)
    h <- ggplot2::ggplot(h_data, aes(x = DT_h, y = cfs))+
      geom_line()+
      theme_bw()+
      ylab("Discharge [ft^3/s^-1]")+
      xlab("Date")+
      ggtitle(title_txt, subtitle = subtitle_txt)
    hydrograph <- h + geom_hline(yintercept = LoQ, linetype = "dashed", color = "red", size = 1) +
      annotate("text", x = Xval, y = LoQ-ylabloc, label = labLow, color = 'red')+
      geom_hline(yintercept = HiQ, linetype = "dashed", color = "blue", size = 1)+
      annotate("text", x = Xval, y = HiQ+ylabloc, label = labHi, color = 'blue')


  }else if (unit_cfs == F){
    if (LoQ == 8000 & HiQ == 25000) {
      LoQ = round(LoQ * 0.028316846592,0)
      HiQ = round(HiQ * 0.028316846592,0)
    }else{
      print('You should have changed the LoQ and HiQ to cms...')
      LoQ = LoQ
      HiQ = HiQ
    }
    labLow = paste0(LoQ," [m^3/s^-1]")
    labHi = paste0(HiQ," [m^3/s^-1]")
    title_txt <- paste0("Hydrograph for Colorado River at RM:",rm)
    subtitle_txt <- paste0("For dates: ",gage_time_s, " -to:", gage_time_e)
    h <- ggplot2::ggplot(h_data, aes(x = DT_h, y = cms))+
      geom_line()+
      theme_bw()+
      ylab("Discharge [m^3/s^-1")+
      xlab("Date")+
      ggtitle(title_txt, subtitle = subtitle_txt)
    hydrograph <- h + geom_hline(yintercept = LoQ, linetype = "dashed", color = "red", size = 1) +
      annotate("text", x = Xval, y = LoQ-ylabloc, label = labLow, color = 'red')+
      geom_hline(yintercept = HiQ, linetype = "dashed", color = "blue", size = 1)+
      annotate("text", x = Xval, y = HiQ+ylabloc, label = labHi, color = 'blue')
  }else{
    print('ERROR: unit_cfs invalid')
    stop()
  }

  return(hydrograph)
}



#' summarize Q (discharge)
#' @importFrom dplyr filter mutate
#' @importFrom lubridate ymd_hm interval %within% as.duration
#' @importFrom magrittr "%>%"
#' @importFrom ggplot2 ggplot aes  geom_point geom_line xlab ylab theme_bw geom_hline ggtitle
#' @param rm river mile, numeric
#' @param start_dt string of start date and time YYYMMDD_hhmm (24hr)
#' @param end_dt string of end date and time YYYMMDD_hhmm (24hr)
#' @param unit_cfs True by default providing summary in cubic feet per second,
#'  if False, displays summary in cubic meters per second
#' @param plot False by default, if True hydrograph is stored as out$hydograph
#'
#' @return a list containing (meanQ, maxQ, minQ, rangeQ, medianQ, data, hydrograph)
#' @export
#'
Summarise_Q <- function(rm, start_dt, end_dt, unit_cfs = T, plot = F){
  start_DT <- ymd_hm(start_dt, tz = 'MST')
  end_DT <- ymd_hm(end_dt, tz = 'MST')
  Hrange <- interval(start_DT, end_DT)
  ng <- find_nr_gage(rm) # nearest gage = ng
  gi <- ng$index # gage index = gi, for ng
  gdata <- gage_data_list[[gi]] # gage data from nearest gage
  Drange <- interval(gdata$datetime[1], gdata$datetime[nrow(gdata)])
  if (Hrange %within% Drange){
    #print("Chosen Date Range is within the available gage data range")
  }else{
    print("Chosen Date Range is not available. adjust start/end datetime")
    stop()}
  lag <- find_lag_time(rm)
  lag_dur <- lag$lagtime
  gage_time_s <- start_DT - lag_dur
  gage_time_e <- end_DT - lag_dur
  diff_dur_start <- gdata$datetime - gage_time_s
  diff_dur_end <- gdata$datetime - gage_time_e
  i_start <- which.min(base::abs(diff_dur_start))
  i_end <- which.min(base::abs(diff_dur_end))
  hydr_data <- gdata[i_start:i_end,]
  maxQ <- max(hydr_data$cfs)
  minQ <- min(hydr_data$cfs)
  medianQ <- median(hydr_data$cfs)
  meanQ <- mean(hydr_data$cfs)
  rangeQ <- maxQ - minQ
  cov_const = 0.028316846592
  xcfs <- hydr_data$cfs
  if (plot == T){
    if (unit_cfs == T){
      plot <- plot_hydrograph(rm,
                              start_dt_str = start_dt,
                              end_dt_str = end_dt,
                              LoQ = minQ,
                              HiQ = maxQ,
                              unit_cfs = T)
    }else{
      plot <- plot_hydrograph(rm,
                              start_dt_str = start_dt,
                              end_dt_str = end_dt,
                              LoQ = minQ * cov_const,
                              HiQ =maxQ * cov_const,
                              unit_cfs = F)}
  }else{
    plot <- NA
  }
  cfs <- list('meanCFS' = meanQ,
              'maxCFS' = maxQ,
              'minCFS' =  minQ,
              'rangeCFS' = rangeQ,
              'medianCFS' = medianQ,
              'data' = hydr_data,
              'hydrograph' = plot)
  cms <-list('meanCMS' = meanQ* cov_const,
             'maxCMS' = maxQ* cov_const,
             'minCMS' =  minQ* cov_const,
             'rangeCMS' = rangeQ* cov_const,
             'medianCMS' = medianQ* cov_const,
             'data' = hydr_data,
             'hydograph' = plot)
  if (unit_cfs == T){
    print('summary statsitics in CFS')
    out <- cfs
    #fdc(xcfs*cov_const)
    }else{
    print('CFS = F, summary statsistics in Q[m3/s]')
    out <- cms
    #fdc_cms <- fdc(xcfs*cov_const, main = 'Flow Duration Curve at ')
    }
  print(out[1:5])
  return(out)
}




#' Generate summary statistics for a data frame containing 24 hour discharge
#'
#' @param flow_data the data output of the Summarise_Q function... out$data
#'
#' @return a list containing the following:
#' meanCFS = mean daily discharge in CFS
#' maxCFS = max daily discharge in CFS
#' minCFS =  min daily discharge in CFS
#' rangeCFS = range in daily discharge in CFS
#' medianCFS = median daily discharge in CFS
#' sdCFS = standard devation of daily discharge in CFS
#' DailyStdDelta = Daily Standardized delta rangeCFS/meanCFS from Bevelhimer et al., 2014
#' DailyCoV' = Daily coefficient of variation sdCFS/meanCFS from Bevelhimer et al., 2014
#' RiseFallCount' = Rise and Fall Count, hours of rise vs fall in discharge between -24 and 24
#' R-Bflashiness' = Richards-Baker Flashiness index modified for daily flows, Baker et al., 2004
#' @export
#'
Summarise_Daily_Q <- function(flow_data){
  # provide dataframe with 24-hours of 15-minute flow data
  # column names must be: cfs,  datetime, datetime_num
  minq <- range(flow_data$cfs)[1]
  maxq <- range(flow_data$cfs)[2]
  rangeq <- maxq - minq
  meanq <- mean(flow_data$cfs)
  medianq <- median(flow_data$cfs)
  sdq <- sd(flow_data$cfs)
  # daily standardized delta = DSD
  DSD <- rangeq/meanq
  # daily coefficient of variation = DCOV
  DCOV <- sdq / meanq
  # Daily rise and fall counts = RFC
  fd <- flow_data %>%
    mutate(hour = hour(datetime))%>%
    group_by(hour)%>%
    summarise(mean_hrly = mean(cfs))
  delta_Q = rep(NA, nrow(fd))
  for (i in 1:nrow(fd)){
    if (i == 1){
      delta_Q[i] = 0
    }else{
      delta_Q_hr = fd$mean_hrly[i] - fd$mean_hrly[i-1]
      if (delta_Q_hr > 1){
        delta_Q[i] = 1
      }else if (delta_Q_hr < 1){
        delta_Q[i] = -1
      }else{
        delta_Q[i] = 0
      }
    }
  }
  RFC <- sum(delta_Q)
  # daily Richards-Baker flashiness index  = DRBFI
  DRBFI = sum(abs(diff(flow_data$cfs)))/sum(flow_data$cfs)
  out <- list('meanCFS' = meanq,
             'maxCFS' = maxq,
             'minCFS' =  minq ,
             'rangeCFS' = rangeq,
             'medianCFS' = medianq,
             'sdCFS' = sdq,
             'DailyStdDelta' = DSD,
             'DailyCoV' = DCOV,
             'RiseFallCount' = RFC,
             'R_Bflashiness' = DRBFI)
  return(out)
}


