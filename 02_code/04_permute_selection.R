source("02_code/02_import_data.R")

library(tidyverse)
n_permutations <- 1000

permuted_s <- list(
  surv = matrix(nrow=n_permutations, ncol = 2),
  fruits_plant   = matrix(nrow=n_permutations, ncol = 2),
  seeds_fruit = matrix(nrow=n_permutations, ncol = 2),
  seeds_sdl = matrix(nrow=n_permutations, ncol = 2)
)

for(i in 1:n_permutations){
  
  permuted_ix <- c(
    sample(   1:1040, replace = FALSE),
    sample(1041:2080, replace = FALSE)
  )
  
  soil_permuted <- soil %>% 
    # New vector permuting the order of soil labels
    mutate(
      soil = soil[permuted_ix],
      trt  = paste(site, soil, geno, sep="_")
    )  
  
  
  # Get mean values and SEs for each treatment level
  permuted_means <- lapply(traits, function(x) int_table(soil_permuted[,x], soil_permuted$trt))
  names(permuted_means) <- traits
  # Relative fitness values favouring the *local* genotype :
  # In Italy on the Swedish soil
  # In Italy on the Italian soil
  # In Sweden on the Swedish soil
  # In Sweden on the Italian soil
  permuted_relfit <- lapply(permuted_means, function(x) selcoef(x$mean[c(1,3,6,8)], x$mean[c(2,4,5,7)]))
  # Differences in selection on each soil type
  permuted_delta_s <- sapply(permuted_relfit, function(x) as.vector(c(x[2]-x[1], x[3]-x[4])))

  # Save the outputs
  # No ! this needs to compare columns to get the difference!
  permuted_s$surv[i,]         <- permuted_delta_s[,1]
  permuted_s$fruits_plant[i,] <- permuted_delta_s[,2]
  permuted_s$seeds_fruit[i,]  <- permuted_delta_s[,3]
  permuted_s$seeds_sdl[i,]    <- permuted_delta_s[,4]
}

# p-values in Italy
mean(permuted_s$surv[,1]         > delta_s[1,1]) * 2
mean(permuted_s$fruits_plant[,1] > delta_s[1,2]) * 2
mean(permuted_s$seeds_fruit[,1]  > delta_s[1,3]) * 2
mean(permuted_s$seeds_sdl[,1]    > delta_s[1,4]) * 2
# p-values in Sweden
mean(permuted_s$surv[,2]         < delta_s[2,1]) * 2
mean(permuted_s$fruits_plant[,2] < delta_s[2,2]) * 2
mean(permuted_s$seeds_fruit[,2]  > delta_s[2,3]) * 2
mean(permuted_s$seeds_sdl[,2]    < delta_s[2,4]) * 2

soil %>% 
  filter(site == "cast", geno == "sw") %>% 
  nrow()
