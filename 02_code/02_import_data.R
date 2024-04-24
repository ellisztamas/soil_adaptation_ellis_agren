source('02_code/01_utils.R')

# Import data. See format_raw_data.R for processing datafile
soil <- read.csv('01_data/SoilFieldExpt_bothsites_2017.csv', stringsAsFactors = F)
soil$trt <- paste(soil$site, soil$soil, soil$geno, sep="_") # add treatment label
soil$ID <- 1:nrow(soil) # unique ID for each row
# Add estimated seed number per seedling
soil$seeds_sdl <- seeds_per_plant(soil$seeds_fruit, soil$fruits_sdl, soil$trt)

# Get mean values and SEs for each treatment level
traits <- c("surv","fruits_plant","seeds_fruit","seeds_sdl")
trt_means <- lapply(traits, function(x) int_table(soil[,x], soil$trt))
names(trt_means) <- traits

# Relative fitness values.
relfit <- lapply(trt_means, function(x) selcoef(x$mean[c(1,3,6,8)], x$mean[c(2,4,5,7)]))
# Differences in selection on each soil type
delta_s <- sapply(relfit, function(x) as.vector(c(x[2]-x[1], x[3]-x[4])))
# Proportion adaptive differentiation due to soil type.
# i.e. differences between sel. coefficient on each soil type, divided by selection on the local soil
pve_soil <- sapply(relfit, function(x) c((x[2] - x[1]) / x[2], (x[3] - x[4]) / x[4]))

