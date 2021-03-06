library(tidyverse)
library(usethis)



site_list_vec = c('0034L','0081L','0089L','0166L','0220R','0236L','0307R',
                  '0333L','0414R','0434L','0445L','0450L','0476R','0501R','0515L',
                  '0566R','0629R','0651R','0688R','0701R','0817L','0846R','0876L',
                  '0917R','0938L','1044R','1194R','1227R','1233L','1377L','1396R',
                  '1459L','1726L','1833R','1946L','2023R','2133L','2201R','2255R')
usethis::use_data(site_list_vec, overwrite = TRUE, internal = TRUE)
