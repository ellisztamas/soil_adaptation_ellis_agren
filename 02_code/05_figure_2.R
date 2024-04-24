library('tidyverse')

source("02_code/03_bootstrap_selection.R")

pd <- position_dodge(0.5)
boot_selcoef %>% 
  pivot_longer(cast_ferr : roda_volc, names_to = "site_soil", values_to = "selection") %>% 
  separate(site_soil, into=c("site", "soil"), sep = "_") %>% 
  mutate(
    trait= case_match(
      trait,
      'surv' ~ "Survival",
      "fruits_plant" ~ "Fruits/plant",
      "seeds_fruit" ~ "Seeds/fruit",
      "seeds_sdl" ~ "Seeds/seedling"
    ),
    trait = fct_relevel(trait, "Survival", "Fruits/plant", "Seeds/fruit", "Seeds/seedling")
  ) %>% 
  group_by(trait, site, soil) %>% 
  summarise(
    mean = mean(selection),
    lower = quantile(selection, 0.02),
    upper = quantile(selection, 0.98),
    .groups="drop_last"
  ) %>% 
  mutate(
    Soil = case_match(
      soil,
      'ferr' ~ "Swedish",
      "volc" ~ "Italian"
    ),
    site = ifelse(site == "cast", "Italian site", "Swedish site")
  ) %>% 
  ggplot(aes(x = trait, y = mean, colour = Soil)) +
  geom_point(position = pd) +
  geom_errorbar(aes(ymin=lower, ymax=upper), position = pd, width=0) +
  facet_grid(~site) +
  labs(
    y = "Selection"
  ) +
  theme_bw() + 
  theme(
    legend.position = 'bottom',
    axis.title.x = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )+ 
  scale_color_manual(values=c("red3", "blue4"))

ggsave(
  filename = "03_manuscript/figure2.eps",
  device = "eps",
  width = 14, height = 10, units = "cm"
)

