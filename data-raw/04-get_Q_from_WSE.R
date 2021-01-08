# import and clean GetQ_from_WSE.csv and GetWSE_fromQ.csv


get_Q_from_WSE <- read.csv(file = 'data-raw/GetQ_fromWSE.csv', header = T)
get_Q_from_WSE_Tb <- tibble::as_tibble(get_Q_from_WSE)


get_WSE_from_Q <- read.csv(file = 'data-raw/GetWSE_fromQ.csv', header = T)
get_WSE_from_Q_Tb <- tibble::as_tibble(get_WSE_from_Q)


usethis::use_data(get_Q_from_WSE_Tb, overwrite = T)
usethis::use_data(get_WSE_from_Q_Tb, overwrite = T)
