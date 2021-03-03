# 05-plot_elevation_graph
library(lubridate)
library(gridExtra)
library(tidyverse)


#' plot_elevation_graph
#'
#' This function plots a hydrograph-type figure but instead of showing discharge
#' over time, it shows water-surface elevation based on estimated Q and the
#' observed stage discharge relationship for any given site.
#'
#' @param site  5 character site code ex.'0307R'
#' @param start_dt string of start date_time 'YYYYMMDD_hhmm' ex. '20100101_2200'
#' @param end_dt string of end date_time 'YYYYMMDD_hhmm' ex. '20100101_2200'
#' @param ylabloc numeric, a parameter to adjust labels are, play with this
#' @param xlabloc numeric, a parameter to adjust labels in the x direction
#' @param LowE the discharge in CFS for the low elevation line shown on plot
#' @param HiE the discharge in CFS for the high elevation line shown on the plot
#'
#' @return A plot, showing graph of water surface elevation
#' @export
#'
#' @examples
#' plot_elevation_graph("0220R", "20150528_1200", "20150603_1200")
plot_elevation_graph <- function(site,
                                 start_dt,
                                 end_dt,
                                 ylabloc = .05,
                                 xlabloc = 2,
                                 LowE = 8000,
                                 HiE = 20000) {
  start_DT <- ymd_hm(start_dt, tz = "MST")
  end_DT <- ymd_hm(end_dt, tz = "MST")
  rm <- as.numeric(substr(site, 1, 4)) / 10
  Hrange <- interval(start_DT, end_DT)
  quarter <- Hrange / xlabloc
  q <- as.duration(quarter)
  Xval <- start_DT + q
  ng <- find_nr_gage(rm)
  gi <- ng$index
  gdata <- gage_data_list[[gi]]
  Drange <- interval(gdata$datetime[1], gdata$datetime[nrow(gdata)])
  if (Hrange %within% Drange) {
    # print("Chosen Date Range is within the available gage data range")
  } else {
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
  hydr_data <- gdata[i_start:i_end, ]
  h_data <- hydr_data %>%
    mutate(DT_h = datetime - lag_dur) %>%
    mutate(DT_hnum = as.numeric(datetime_num - lag_dur)) %>%
    mutate(WSE = f_E_Q(site, cfs))
  Eightk <- f_E_Q(site, LowE)
  labLow <- paste0(LowE, " [ft3/s] elevation")
  twentyk <- f_E_Q(site, HiE)
  labHi <- paste0(HiE, " [ft3/s] elevation")
  title_txt <- paste0("Water Surface Elevation for Colorado River at site:", rm)
  subtitle_txt <- paste0("For dates: ", gage_time_s, " -to: ", gage_time_e)
  E <- ggplot(h_data, aes(x = DT_h, y = WSE)) +
    geom_line() +
    theme_bw() +
    ylab("Water Surface Elevation [Meters]") +
    xlab("Date") +
    ggtitle(title_txt, subtitle = subtitle_txt)
  E_graph <- E + geom_hline(yintercept = Eightk, linetype = "dashed", color = "red", size = 1) +
    annotate("text", x = Xval, y = Eightk - ylabloc, label = labLow, color = "red") +
    geom_hline(yintercept = twentyk, linetype = "dashed", color = "blue", size = 1) +
    annotate("text", x = Xval, y = twentyk + ylabloc, label = labHi, color = "blue")
  return(E_graph)
}



#' Summarize E (water surface elevation)
#'
#' provides summary statistics of the water surface elevation during
#' the chosen time period at the selected site
#'
#' @param site  5 character site code ex.'0307R'
#' @param start_dt string of start date_time 'YYYYMMDD_hhmm' ex. '20100101_2200'
#' @param end_dt string of end date_time 'YYYYMMDD_hhmm' ex. '20100101_2200'
#' @param plot = F (default), if plot = T, plot the water surface elevation graph
#'
#' @return list('meanWSE' = meanE,'maxWSE' = maxE,'minWSE' =  minE,'rangeWSE' = rangeE,'medianWSE' = medianE,'data' = h_data,'Elevation_graph' = plot)
#' @export
#'
#' @examples
#' out <- Summarize_E("0220R", "20150528_1200", "20150605_1200", plot = T)
#' out$Elevation_graph
Summarize_E <- function(site, start_dt, end_dt, plot = F) {
  rm <- as.numeric(substr(site, 1, 4)) / 10
  start_DT <- ymd_hm(start_dt, tz = "MST")
  end_DT <- ymd_hm(end_dt, tz = "MST")
  Hrange <- interval(start_DT, end_DT)
  ng <- find_nr_gage(rm) # nearest gage = ng
  gi <- ng$index # gage index = gi, for ng
  gdata <- gage_data_list[[gi]] # gage data from nearest gage
  Drange <- interval(gdata$datetime[1], gdata$datetime[nrow(gdata)])
  if (Hrange %within% Drange) {
    # print("Chosen Date Range is within the available gage data range")
  } else {
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
  hydr_data <- gdata[i_start:i_end, ]
  h_data <- hydr_data %>%
    mutate(WSE = f_E_Q(site, cfs))
  maxE <- max(h_data$WSE)
  minE <- min(h_data$WSE)
  medianE <- median(h_data$WSE)
  meanE <- mean(h_data$WSE)
  rangeE <- maxE - minE
  if (plot == T) {
    plot <- plot_elevation_graph(
      site,
      start_dt,
      end_dt
    )
  } else {
    plot <- NA
  }
  out <- list(
    "meanWSE" = meanE,
    "maxWSE" = maxE,
    "minWSE" = minE,
    "rangeWSE" = rangeE,
    "medianWSE" = medianE,
    "data" = h_data,
    "Elevation_graph" = plot
  )
  print(out[1:5])
  return(out)
}


