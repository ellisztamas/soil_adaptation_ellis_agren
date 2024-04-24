# Standard error, with correction for small sample sizes.
# NA items will be removed.
st_err <- function(x){
  sd(x, na.rm = T) / sqrt(sum(is.finite(x)))
}

# Summarise the mean, standard error, and SE limits for a vector, indexed by another vector of factors.
int_table <- function(x, by){
  xbar <- tapply(x, by, mean, na.rm=T)
  se   <- tapply(x, by, st_err)
  data.frame(level = names(xbar),
             mean = xbar,
             se   = se,
             upper = xbar + se,
             lower = xbar - se,
             row.names = NULL)
}

#' Calculate seed number for a whole plant.
#' 
#' Multiply fruit counts for individual plants by group-mean seed number per
#' fruit.
#' 
#' @param seed_number Numeric vector of seed number per fruit, usually with fewer
#' finite entries than fruit number.
#' @param  fruit_number Numeric vector of fruit number for whole plants.
#' @param by Vector of factors indicating grouping for seed number.
#' @return Vector of estimated seed number per plant.
seeds_per_plant <- function(seed_number, fruit_number, by){
  seed_means <- tapply(seed_number, by, mean, na.rm=T)
  vals <- seed_means[match(by, names(seed_means))] * fruit_number
  return(as.vector(vals))
}

#' Calculate selection coefficients.
#' 
#' Calculate a vector of selection coefficients for two vectors of absolute
#' fitnesses.
#' 
#' For each pair of values in the two vectors, this will determine which is the
#' maxmimum, and divide each absolute value by that.
#' 
#' @param x,y Vectors of absolute fitness values for types x and y.
#' 
#' @return Vector of differences in relative fitness with respect to x (i.e.
#' eqn{x/\max(x,y) - y/ \max(x,y)}).
#' 
selcoef <- function(x, y){
  fit <- data.frame(x, y)
  max <- apply(fit, 1, max)
  s <- (fit$x / max) - (fit$y / max)
  return(s)
}

