library(tibble)

get_WSE_from_Q <- read.csv(file = 'data-raw/GetWSE_fromQ.csv', header = T)
get_WSE_from_Q_Tb <- tibble::as_tibble(get_WSE_from_Q)

usethis::use_data(get_WSE_from_Q_Tb, overwrite = T)
