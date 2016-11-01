# Interal P loading

Data and code associated with Orihel, Baulch, Casson, North, Parsons, Seckar, and Venkiteswaran. *Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis.*

Manuscript submitted October 2016.

The raw data and R-scripts used to perform the analyses and figures are here:

* Internal_P_Review_Database_for_archive.mdb: *MS Access database with six tables*
* 01-Export data.R: *R-script for pulling data from the mdb file via SQL commands or mdb.get*
* 02-Figures.R: *R-script for creating the data figures in the manuscript and associated statistics*
* Six csv files exported from the database

The R-scripts for the analyses and figures require (at the very least) RODBC or Hmisc, rpart, rpart.plot, ggplot2, grid, gridExtra, GGally, Cairo, plyr, dplyr. Thanks to the authors of these packages.
