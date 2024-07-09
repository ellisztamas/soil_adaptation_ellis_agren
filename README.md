[![DOI](https://zenodo.org/badge/791326327.svg)](https://zenodo.org/doi/10.5281/zenodo.11060798)

# soil_adaptation_ellis_agren

Data and code to reproduce the results in the manuscript "Adaptation to soil type contributes little to local adaptation in an Italian and a Swedish population of Arabidopsis thaliana growing on contrasting soils"
by Thomas James Ellis and Jon Ågren.

This information is also available on GitHub (https://github.com/ellisztamas/soil_adaptation_ellis_agren) and Zenodo (https://doi.org/10.5281/zenodo.12697234)

## Experimental set up

[Ågren & Schemske (2012)](https://nph.onlinelibrary.wiley.com/doi/abs/10.1111/j.1469-8137.2012.04112.x) have previously described two locally adapted populations of *A. thaliana* from sites in Sweden and Italy, the sites, and basic experimental set up. We transplanted seedlings of the accessions they describe on soils collected at the source sites reciprocally at both sites. Seedlings were transplanted into one of four 299-well trays. We compared selection coefficients on the two soil types.

There are three variables, each with two treatments levels, giving a total of eight treatment levels.

1. **Site**: Italy vs Sweden
2. **Soil**: Italian vs. Swedish
3. **Genotype**: Italian vs. Swedish

## Data files

Data are given in `01_data/SoilFieldExpt_bothsites_2017.csv`.
Since site, soil and genotypes are all basically 'Italian vs. Swedish', they
have been given more specific factor names. 

Column headers used

* site: Castelnuovo (cast) or Rödåsen (roda)
* tray: One of four 299-well plug trays at each site.
* pos: Plug position within tray. 1-299.
* soil: Soil type; Italian volcanic soil (volc) or Swedish ferrous soil (ferr).
* geno: Genotype; Italian (it) or Swedish (sw)
* surv,fruits_plant,fruits_sdl,seeds_fruit: Phenotype data.

There are five phenotypes, which only four are discussed in the manuscript:

1. **surv**: Survival to reproduction.
2. **fruits_plant**: Fruit number per reproductive plant, a component of fecundity.
3. **fruits_sdl**: : Fruit number per planted seedling, a proxy for fitness.
4. **seeds_fruit**: Seed number per fruit, a component of fecundity
5. **seeds_sdl**: Fruit number per planted seedling, a proxy for fitness that includes seed number (estimated from 3 and 4).

Traits 1 to 3 defined by [Ågren & Schemske (2012)](https://nph.onlinelibrary.wiley.com/doi/abs/10.1111/j.1469-8137.2012.04112.x).
Traits 4 and 5 are described by [Ellis *et al.* (2021)](https://onlinelibrary.wiley.com/doi/abs/10.1111/mec.15941).

Ellis, Thomas James and Ågren, Jon (2024), 

## Dependencies

I ran analyses in R 4.2.1 using the `tidyverse` suite of packages, as well as `ggpubr` for plotting.
Full list of packages can be viewed in the file `session_info` (this is the output of `devtools::session_info()`).

## Scripts

Scripts to process and analyse the data are given in `02_code`:

* `01_utils.R` contains functions to automate tasks used in other scripts.
* `02_import_data.R` loads and formats the data for further use.
* `03_boostrap_selection.R` estimates 95% confidence intervals for selection coefficients by non-parametric bootsrapping.
* `04_permute_selection.R` assesses the statistical significance of differences in selection compare to the null hypothesis that selection within a site is no different on either soil.
* `05_figure_1.R` creates Figure 1.
* `06_figure_2.R` creates Figure 2.

## Authors

Thomas James Ellis and Jon Ågren.

## License

This repository is released under the MIT license.