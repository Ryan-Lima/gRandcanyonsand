
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gRandcanyonsand

<!-- badges: start -->

<!-- badges: end -->

> The goals of gRandcanyonsand are to:

  - analyze and visualize flow patterns in Grand Canyon
  - estimate the discharge at any river mile in Grand Canyon at a given
    time
  - estimate water surface elevation at sandbar monitoring sites at a
    given time

## Installation

the development version from [GitHub](https://github.com/) with:

``` r
library(devtools)
```

    ## Loading required package: usethis

``` r
devtools::install_github("Ryan-Lima/gRandcanyonsand")
```

    ## Skipping install of 'gRandcanyonsand' from a github remote, the SHA1 (e59fa286) has not changed since last install.
    ##   Use `force = TRUE` to force installation

## Examples

Find discharge at any time and any rivermile in Grand Canyon 2010 - 2020

``` r
#rivermile = 30.7
#date_of_interest = '20140601_1200' # YYYYMMDD_hhmm 
#gRandcanyonsand::find_Q(rm = rivermile,datetime = date_of_interest,print = T)
```

At specific sites, you can find the estimated water surface elevation
given a discharge or you can get an estimated discharge based on a given
water surface elevation

``` r
#site_list_vec # a list of the available sandbar monitoring sites
# site_name = site_list_vec[28]
# print(site_name)
# 
# estimated_E <- find_E_from_Q(site_name,Qcfs = 8000)
# print(estimated_E)
# 
# estimated_Q <- find_Q_from_E(site_name,estimated_E$WSE )
# print(estimated_Q)
```

The estimated elevations and discharges are based on measured
stage-discharge relationships for each site, you can see these
relationships with the function: plot\_site\_sd()

``` r
# plot_site_sd(site_list_vec[4])
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!
