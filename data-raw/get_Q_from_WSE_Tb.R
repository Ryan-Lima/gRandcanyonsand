library(tibble)
get_Q_from_WSE <- read.csv(file = 'data-raw/GetQ_fromWSE.csv', header = T)
get_Q_from_WSE_Tb <- tibble::as_tibble(get_Q_from_WSE)

usethis::use_data(get_Q_from_WSE_Tb, overwrite = T)
