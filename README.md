[![DOI](https://zenodo.org/badge/67434289.svg)](https://zenodo.org/badge/latestdoi/67434289)

# Internal P loading

Data and code associated with Orihel, Baulch, Casson, North, Parsons, Seckar, and Venkiteswaran. 2017. *Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis.* Canadian Journal of Fisheries and Aquatic Sciences, 74(12): 2005-2029, https://doi.org/10.1139/cjfas-2016-0500

The raw data and R-scripts used to perform the analyses and create the figures are here:

- Internal_P_Review_Database_for_archive.mdb: *MS Access database with six tables*
- 01-Export data.R: *R-script for pulling data from the mdb file via SQL commands or mdb.get*
- 02-Assemble data.R: *R-script for assembling the data tables, converting to common units, and preparing for further analysis*
- 03-Figures.R: *R-script for creating the data figures in the manuscript and associated statistics*
- LAKES.csv: *Lake information, see Appendix B*
- PFLUX.csv: *Phosphorus fluxes, see Appendix B*
- POREP.csv: *Porewater phosphorus*
- REF.csv: *References that identify the source of the data*
- SITES.csv: *Site specific information, see Appendix B*
- PFLUX_assembled.csv: *Assembled data file (created in "02-Assemble data.R") that can be used to perform the analyses and create the figures*

The R-scripts for the analyses and figures require (at the very least):
* RODBC or Hmisc to export the tables from the mdb file
* ggplot2, grid, gridExtra, GGally, Cairo, dplyr, tidyr

Thanks to the authors of these packages.
