# 03- plot_hydrograph
library(lubridate)
library(gridExtra)

summarize_Q <- function(rm, start_dt_str, end_dt_str){
  start_DT <- ymd_hm(start_dt_str, tz = 'MST')
  print(start_DT)
  end_DT <- ymd_hm(end_dt_str, tz = 'MST')
  print(end_DT)
  Hrange <- interval(start_DT,end_DT)
  Xval <- start_DT + q
  ng <- find_nr_gage(rm)
  gi <- ng$index
  gdata = gage_data_list[[gi]]
  Drange = interval(gdata$datetime[1],gdata$datetime[nrow(gdata)])
  if (Hrange %within% Drange){
    print("Chosen Date Range is within the available gage data range")
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
  maxQ <- max(hydr_data$cfs)
  minQ <- min(hydr_data$cfs)
  out <- list('maxQcfs' = maxQ, 'minQcfs' =  minQ)
  return(out)
}

res <- summarize_Q(30.7, '20100101_1200', '20110102_1200')
res

# plot_hydrograph <- function(rm, start_dt_str,
#                             end_dt_str,
#                             ylabloc = 300,
#                             xlabloc = 2,
#                             LoQ = 8000,
#                             HiQ = 20000) {
#   start_DT <- ymd_hm(start_dt_str, tz = 'MST')
#   end_DT <- ymd_hm(end_dt_str, tz = 'MST')
#   Hrange <- interval(start_DT,end_DT)
#   quarter <- Hrange/xlabloc
#   q <- as.duration(quarter)
#   Xval <- start_DT + q
#   ng <- find_nr_gage(rm)
#   gi <- ng$index
#   gdata = gage_data_list[[gi]]
#   Drange = interval(gdata$datetime[1],gdata$datetime[nrow(gdata)])
#   if (Hrange %within% Drange){
#     print("Chosen Date Range is within the available gage data range")
#   }else{
#     print("Chosen Date Range is not available. adjust start/end datetime")
#     stop()
#   }
#   lag <- find_lag_time(rm)
#   lag_dur <- lag$lagtime
#   gage_time_s <- start_DT - lag_dur
#   gage_time_e <- end_DT - lag_dur
#   diff_dur_start <- gdata$datetime - gage_time_s
#   diff_dur_end <- gdata$datetime - gage_time_e
#   i_start <- which.min(base::abs(diff_dur_start))
#   i_end <- which.min(base::abs(diff_dur_end))
#   hydr_data <- gdata[i_start:i_end,]
#   h_data <- hydr_data %>%
#     mutate(DT_h = datetime - lag_dur) %>%
#     mutate(DT_hnum = as.numeric(datetime_num - lag_dur))
#   labLow = paste0(LoQ," CFS")
#   labHi = paste0(HiQ," CFS")
#   title_txt <- paste0("Hydrograph for Colorado River at RM:",rm)
#   subtitle_txt <- paste0("For dates: ",gage_time_s, " -to:", gage_time_e)
#   h <- ggplot(h_data, aes(x = DT_h, y = cfs))+
#     geom_line()+
#     theme_bw()+
#     ylab("Discharge (CFS)")+
#     xlab("Date")+
#     ggtitle(title_txt, subtitle = subtitle_txt)
#   hydrograph <- h + geom_hline(yintercept = LoQ, linetype = "dashed", color = "red", size = 1) +
#     annotate("text", x = Xval, y = LoQ-ylabloc, label = labLow, color = 'red')+
#     geom_hline(yintercept = HiQ, linetype = "dashed", color = "blue", size = 1)+
#     annotate("text", x = Xval, y = HiQ+ylabloc, label = labHi, color = 'blue')
#   return(hydrograph)
#   }
#
# plot_hydrograph(22, '20100101_1200', '20110101_1200')


