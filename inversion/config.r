# customizable configuration file for bayesian inversion

# ~~~~~~~~~~~~~~ Necessary paths ~~~~~~~~~~~~~~#

# paths to inversion directories
src_path <- "src/"
out_path <- "out/"

# footprint directory
foot_dir <- "../footprints/"

# Names of observational sites (correspond to directory names in the footprint
# dir)
sites <- c("WBB", "DBK", "RPK", "SUG", "MSA", "SUN")
nsites <- length(sites)

# include path
include_dir <- "../include/"

# Do we want to clear footprints?  re-running Hsplit.r can take time, so opt not
# to clear footprints when possible
clear_H <- F

# Do we want to run the reduced chi-square test of fit?  this can also take time,
# so set to TRUE only if desired
compute_chi_sq <- F

# Do we want to include estimated far-field contributions from an outer-domain
# emission estimate in the background? (Need gridded outer-domain emission file)
include_outer <- F

# Do we want to include estimated biological flux contributions in the background?
# (Need gridded biogenic flux file)
include_bio <- F

# ~~~~~~~~~~~~~~ Info files ~~~~~~~~~~~~~~#

# lonlat_domain file - lists all lon/lat pairs in domain as look up table
lonlat_domain_file <- paste0(include_dir, "lonlat_domain.rds")

# lonlat_outer file - lists all lon/lat pairs in outer domain as look up table
lonlat_outer_file <- NA#paste0(include_dir, "lonlat_outer.rds")

# Prior emissions file
prior_file <- paste0(include_dir, "prior_emiss.nc")

# outer-domain emissions inventory file
truth_file <- paste0(include_dir, "true_emiss.nc")

# Prior uncertainty file
sigma_file <- paste0(include_dir, "prior_uncert.nc")

# obs file should contain data for all sites used in the inversion, with
# nomenclature:
# SITECODE  OBS TIME (seconds since 1970-01-01 00:00:00)  OBS VALUE
# 'site1'          '[t1 number of seconds]'                 'X.XXX'
# 'site1'          '[t2 number of seconds]'                 'X.XXX'
#   ...                       ...                             ...
# 'site2'          '[t1 number of seconds]'                 'X.XXX'

obs_file <- paste0(include_dir, "obs.rds")

# bg filepath (follows same convention as obs, but without column 1)
bg_file <- paste0(include_dir, "background.rds")


# ~~~~~~~~~~~~~~ Model params ~~~~~~~~~~~~~~#

#spatial grid resolution
lon_res <- 0.01
lat_res <- 0.01
round_digs <- 1 + max(nchar(strsplit(as.character(lon_res), ".", fixed = TRUE)[[1]][[2]]),
                  nchar(strsplit(as.character(lat_res), ".", fixed = TRUE)[[1]][[2]]))

# footprint grid dimensions (T if dims are lon x lat, F if dims are lat x lon)
foot_dim_lonxlat <- T

# flux time range
flux_year_start <- 2015
flux_month_start <- 9
flux_day_start <- 1
flux_hour_start <- 18
flux_min_start <- 0

# flux bins reflect [start -> end) i.e. flux end time marks the end of last bin,
# not start of last bin (unlike obs)
flux_year_end <- 2015
flux_month_end <- 9
flux_day_end <- 30
flux_hour_end <- 6
flux_min_end <- 0

flux_t_res <- 6 * 3600  #flux time resolution, in seconds

# obs/receptor time range
obs_year_start <- 2015
obs_month_start <- 9
obs_day_start <- 2  #note that because footprints run 24 back, it is wise to start obs 24hrs after start of flux time domain start
obs_hour_start <- 0
obs_min_start <- 0

# obs bins reflect [start -> end] i.e. obs end time marks beginning of last bin.
obs_year_end <- 2015
obs_month_end <- 9
obs_day_end <- 29
obs_hour_end <- 23
obs_min_end <- 0

obs_t_res <- 3600  #observation time resolution, in seconds


# if observations are only desired from a subset of time, declare here otherwise,
# set to 0:23 (i.e. all hours of day)
subset_hours_utc <- 18:23

# boolean var: do you wish to aggregate your obs daily within the subsetted
# hours?
aggregate_obs <- T

# if so, what is the required minimum number of observations within the subsetted time per day?
min_agg_obs <- 2

# Define POSIX times for flux/obs start/end
flux_start_POSIX <- ISOdatetime(flux_year_start, flux_month_start, flux_day_start,
    flux_hour_start, flux_min_start, 0, tz = "UTC")

flux_end_POSIX <- ISOdatetime(flux_year_end, flux_month_end, flux_day_end,
     flux_hour_end, flux_min_end, 0, tz = "UTC")

obs_start_POSIX <- ISOdatetime(obs_year_start, obs_month_start, obs_day_start,
    obs_hour_start, obs_min_start, 0, tz = "UTC")

obs_end_POSIX <- ISOdatetime(obs_year_end, obs_month_end, obs_day_end,
     obs_hour_end, obs_min_end, 0, tz = "UTC")

# get the number of days
ndays <- length(seq(from = obs_start_POSIX, to = obs_end_POSIX, by = 24 * 3600))

# horizontal lengthscale parameter, in km
ls <- 6

# temporal lengthscale parameter, in days
lt <- 2

# Compute the number of time steps
ntimes <- length(seq(from = flux_start_POSIX, to = flux_end_POSIX,
            by = flux_t_res)) - 1

filename_width <- nchar(ntimes) #will be an integer

# time steps for posterior covariance V_shat, the timesteps to aggregate over
tstart <- 1
tstop <- ntimes

# define string for flux units
flux_units <- "umol/(m2 s)"

random_seed <- 5
