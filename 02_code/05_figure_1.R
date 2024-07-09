library(tidyverse)
library(ggpubr)

source("02_code/03_bootstrap_selection.R")

traits <- c("surv","fruits_plant","seeds_fruit","seeds_sdl")
ylabels<- c("Survival", "Fruits/plant", "Seeds/fruit", "Seeds/seedling")
names(ylabels) <- traits

plot_fitness <- vector('list', 4)
pd <- position_dodge(0.2)
for(t in 1:4){
  plot_fitness[[t]] <- boot_ci[[t]] %>% 
    separate(col = level, into = c('site', 'soil', 'geno'), sep = "_") %>% 
    mutate(
      Site = ifelse(site == "cast", "Italian", "Swedish"),
      Soil = ifelse(soil == "volc", "Italian", "Swedish"),
      Ecotype = ifelse(geno == "it", "Italian", "Swedish")
    ) %>% 
    ggplot(aes( x=Site, y = mean, colour=Ecotype, shape=Soil, group=paste(soil,geno))) +
    geom_errorbar(aes(ymin = lower, ymax = upper, width = 0), position=pd) +
    geom_line(position = pd) +
    geom_point(position = pd, size=2) +
    labs(
      y = ylabels[[t]],
      x = "Site"
    ) +
    theme_bw() +
    scale_color_manual(values=c("red3", "blue4"))
}

ggarrange(
  plotlist = plot_fitness,
  common.legend = TRUE,
  legend = "bottom"
)

ggsave(
  filename = "03_manuscript/figure1.eps",
  units = "cm", width = 11.2, height  = 12,
  device="eps"
  )
