source("02_code/02_import_data.R")

library(tidyverse)

# number of bootstrap draws
nreps <- 1000
# Empty lists to store bootstrap draws for confidence intervals and selection coefficients
boot_ci <- boot_selcoef <- lapply(traits, function(x) NA)
names(boot_ci) <- names(boot_selcoef) <- traits

set.seed(45)
for(t in traits){
  valid_ix <- soil[!is.na(soil[t]),c("ID", "trt", t)]
  draws <- lapply(
    split(valid_ix$ID, valid_ix$trt),
    function(x) sample(x, size=length(x)*nreps, replace=T)
  )
  draws <- lapply(
    draws,
    function(x) colMeans(matrix(soil[match(x, soil$ID),t], ncol=nreps))
  )
  
  boot_ci[[t]] <- data.frame(
    mean = trt_means[[t]]$mean,
    t(sapply( draws, quantile,  c(0.025, 0.975) ))
  )
  colnames(boot_ci[[t]]) <- c("mean", "lower", 'upper')
  boot_ci[[t]]$level <- row.names(boot_ci[[t]])
  
  new_selcoef <- tibble(
    trait     = t,
    cast_ferr = selcoef(draws$cast_ferr_it, draws$cast_ferr_sw),
    cast_volc = selcoef(draws$cast_volc_it, draws$cast_volc_sw),
    roda_ferr = selcoef(draws$roda_ferr_sw, draws$roda_ferr_it),
    roda_volc = selcoef(draws$roda_volc_sw, draws$roda_volc_it)
  )
  boot_selcoef[[t]] <-new_selcoef

}

boot_selcoef <- do.call(what='rbind', boot_selcoef)

# Summarise how often the local genotype is fitter than the non-local genotype
boot_selcoef %>% 
  mutate(
    p_italy = cast_volc > cast_ferr,
    p_sweden = roda_ferr > roda_volc
      ) %>% 
  group_by(trait) %>% 
  summarise(
    p_italy = 2*(1-mean(p_italy)),
    p_sweden = 2*mean(p_sweden)
  )
