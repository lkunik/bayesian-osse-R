# script to generate synthetic observations placed into the 'z' vector last
# modified September 2018 by Lewis Kunik, University of Utah

## prerequisite scripts: make_Hs_hourly.r make_R.r output files: z.rds - file
## containing a vector (length = # of obs) of synthetic anthropogenic CO2
## enhancements [in ppm]

# run dependent scripts
source("config.r")

# get number of obs
nsites <- length(sites)

# load model-data mismatch errors
R_file <- paste(out_path, "R.rds", sep = "")
R <- readRDS(R_file)
nobs <- nrow(R)

# load synthetic data from Hstruth.rds
Hstruth_file <- paste(out_path, "Hstruth.rds", sep = "")
Hstruth <- readRDS(Hstruth_file)

# ~~~~~~~ apply random perturbations based on errors defined in R ~~~~~~~~~#

R_sqrt_diag <- sqrt(diag(R))  #R is expressed as variance, so we need to take the sqrt to get std error
rand_errs <- rnorm(n = nobs, sd = R_sqrt_diag)  #get randomly-distributed perturbations

# add perturbations to get synthetic enhancements
z <- Hstruth + rand_errs


# ~~~~~~~~~~~~~~~~~~~ save z to file ~~~~~~~~~~~~~~~~~~~#

# save measured signals
print("saving synthetic anthro signals to z.rds")
filepath <- paste(out_path, "z.rds", sep = "")
saveRDS(z, filepath)
