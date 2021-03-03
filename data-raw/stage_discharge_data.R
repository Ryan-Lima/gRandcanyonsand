# 03-stage_discharge_data

library(tidyverse)
library(usethis)



site_list_vec = c('0034L','0081L','0089L','0166L','0220R','0236L','0307R',
              '0333L','0414R','0434L','0445L','0450L','0476R','0501R','0515L',
              '0566R','0629R','0651R','0688R','0701R','0817L','0846R','0876L',
              '0917R','0938L','1044R','1194R','1227R','1233L','1377L','1396R',
              '1459L','1726L','1833R','1946L','2023R','2133L','2201R','2255R')



sitename = '0034L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0034Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0034Lsd, overwrite = TRUE)

sitename = '0081L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0081Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0081Lsd, overwrite = TRUE)

sitename = '0089L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0089Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0089Lsd, overwrite = TRUE)

sitename = '0166L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0166Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0166Lsd, overwrite = TRUE)

sitename = '0220R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0220Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0220Rsd, overwrite = TRUE)

sitename = '0236L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0236Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0236Lsd, overwrite = TRUE)

sitename = '0307R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0307Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0307Rsd, overwrite = TRUE)

sitename = '0333L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0333Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0333Lsd, overwrite = TRUE)

sitename = '0414R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0414Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0414Rsd, overwrite = TRUE)

sitename = '0434L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0434Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0434Lsd, overwrite = TRUE)

sitename = '0445L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0445Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0445Lsd, overwrite = TRUE)

sitename = '0450L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0450Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0450Lsd, overwrite = TRUE)

sitename = '0476R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0476Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0476Rsd, overwrite = TRUE)

sitename = '0501R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0501Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0501Rsd, overwrite = TRUE)

sitename = '0515L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0515Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0515Lsd, overwrite = TRUE)

sitename = '0566R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0566Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0566Rsd, overwrite = TRUE)

sitename = '0629R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0629Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0629Rsd, overwrite = TRUE)

sitename = '0651R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0651Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0651Rsd, overwrite = TRUE)

sitename = '0688R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0688Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0688Rsd, overwrite = TRUE)

sitename = '0701R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0701Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0701Rsd, overwrite = TRUE)

sitename = '0817L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0817Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0817Lsd, overwrite = TRUE)

sitename = '0846R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0846Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0846Rsd, overwrite = TRUE)

sitename = '0876L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0876Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0876Lsd, overwrite = TRUE)

sitename = '0917R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0917Rsd = read.csv(filename, header = T)
#usethis::use_data(RC0917Rsd, overwrite = TRUE)

sitename = '0938L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC0938Lsd = read.csv(filename, header = T)
#usethis::use_data(RC0938Lsd, overwrite = TRUE)

sitename = '1044R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1044Rsd = read.csv(filename, header = T)
#usethis::use_data(RC1044Rsd, overwrite = TRUE)

sitename = '1194R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1194Rsd = read.csv(filename, header = T)
#usethis::use_data(RC1194Rsd, overwrite = TRUE)

sitename = '1227R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1227Rsd = read.csv(filename, header = T)
#usethis::use_data(RC1227Rsd, overwrite = TRUE)

sitename = '1233L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1233Lsd = read.csv(filename, header = T)
#usethis::use_data(RC1233Lsd, overwrite = TRUE)

sitename = '1377L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1377Lsd = read.csv(filename, header = T)
#usethis::use_data(RC1377Lsd, overwrite = TRUE)

sitename = '1396R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1396Rsd = read.csv(filename, header = T)
#usethis::use_data(RC1396Rsd, overwrite = TRUE)

sitename = '1459L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1459Lsd = read.csv(filename, header = T)
#usethis::use_data(RC1459Lsd, overwrite = TRUE)

sitename = '1726L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1726Lsd = read.csv(filename, header = T)
#usethis::use_data(RC1726Lsd, overwrite = TRUE)

sitename = '1833R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1833Rsd = read.csv(filename, header = T)
#usethis::use_data(RC1833Rsd, overwrite = TRUE)

sitename = '1946L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC1946Lsd = read.csv(filename, header = T)
#usethis::use_data(RC1946Lsd, overwrite = TRUE)

sitename = '2023R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC2023Rsd = read.csv(filename, header = T)
#usethis::use_data(RC2023Rsd, overwrite = TRUE)

sitename = '2133L'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC2133Lsd = read.csv(filename, header = T)
#usethis::use_data(RC2133Lsd, overwrite = TRUE)

sitename = '2201R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC2201Rsd = read.csv(filename, header = T)
#usethis::use_data(RC2201Rsd, overwrite = TRUE)

sitename = '2255R'
filename = paste0('data-raw/',sitename,"sd.csv")
df_name = paste0('RC',sitename,'sd')
df_name
RC2255Rsd = read.csv(filename, header = T)
#usethis::use_data(RC2255Rsd, overwrite = TRUE)


stage_discharge_data = list(RC0034Lsd,RC0081Lsd,RC0089Lsd,RC0166Lsd,RC0220Rsd,RC0236Lsd,RC0307Rsd,RC0333Lsd,
                            RC0414Rsd,RC0434Lsd,RC0445Lsd,RC0476Rsd,RC0501Rsd,RC0515Lsd,RC0566Rsd,RC0629Rsd,
                            RC0651Rsd,RC0688Rsd,RC0701Rsd,RC0817Lsd,RC0846Rsd,RC0876Lsd,RC0917Rsd,RC0938Lsd,
                            RC1044Rsd,RC1194Rsd,RC1227Rsd,RC1233Lsd,RC1377Lsd,RC1459Lsd,RC1726Lsd,RC1833Rsd,
                            RC1946Lsd,RC2023Rsd,RC2133Lsd,RC2201Rsd,RC2255Rsd)



usethis::use_data(stage_discharge_data, overwrite = TRUE, internal = TRUE)
