### Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis
### Orihel et al.
### https://github.com/jjvenky/Internal_P_loading


### 02 Assemble data


#####################################
## Load Libraries
#####################################

library(dplyr)
library(tidyr)


#####################################
# Load data exported from the database
#####################################

geol <- read.csv(file = "GEOL.csv")
lakes <- read.csv(file = "LAKES.csv")
pflux <- read.csv(file = "PFLUX.csv")
sites <- read.csv(file = "SITES.csv")

# There are 38 rows that will get dropped because they were flagged as having an issue: nrow(subset(pflux, FLAG == 1))
# Details are in the paper
pflux <- subset(pflux, FLAG == 0)


#####################################
# Have to convert units to get everything into mg/m2/d
#####################################

# There are 5 sets of units in the pflux table for TP: 
# levels(pflux$TP.UNITS): "g/cm2/y"            "g/m2/y"             "mg/g/d"             "mg/m2/d"            "mg/m2/summer(=92d)"
# Convert all but mg/g/d to mg/m2/d
# Use mutate and case_when to handle all the units at once
pflux <- pflux %>% mutate(TP.VALUE_mg_m2_d = case_when(.$TP.UNITS == "g/cm2/y" ~ .$TP.VALUE * 1000 * 10000 / 365, 
                                                       .$TP.UNITS == "g/m2/y" ~ .$TP.VALUE * 1000 / 365, 
                                                       .$TP.UNITS == "mg/m2/d" ~ .$TP.VALUE,
                                                       .$TP.UNITS == "mg/m2/summer(=92d)" ~ .$TP.VALUE / 92))

# There are 5 sets of units in the pflux table for SRP: 
# levels(pflux$SRP.UNITS):"mg/m2/d"   "mmol/m2/d" "ug/cm2/h"  "ug/cm2/y"  "umol/m2/h"
# Convert all to mg/m2/d
# Use mutate and case_when to handle all the units at once
pflux <- pflux %>% mutate(SRP.VALUE_mg_m2_d = case_when(.$SRP.UNITS == "mg/m2/d" ~ .$SRP.VALUE, 
                                                        .$SRP.UNITS == "mmol/m2/d" ~ .$SRP.VALUE * 30.973762, 
                                                        .$SRP.UNITS == "ug/cm2/h" ~ .$SRP.VALUE * 1E-6 * 1000 * 10000 * 24, 
                                                        .$SRP.UNITS == "ug/cm2/y" ~ .$SRP.VALUE * 1E-6 * 1000 * 10000 / 365, 
                                                        .$SRP.UNITS == "umol/m2/h" ~ .$SRP.VALUE * 1E-6 * 30.973762 * 1000 * 24))

# There is only one unit in the pflux table for TDP: mg/m2/d
# Create a column with the same style of name as the other fluxes
pflux <- pflux %>% mutate(TDP.VALUE_mg_m2_d = TDP.VALUE)


#####################################
# Convert the SRP and TDP fluxes into TP with the relationships decribed in the Appendix
#####################################

pflux <- pflux %>% mutate(TP_from_TDP_mg_m2_d = 1.04 * TDP.VALUE_mg_m2_d + 0.029)
pflux <- pflux %>% mutate(TP_from_SRP_mg_m2_d = 1.11 * SRP.VALUE_mg_m2_d + 0.042)

# Get one TP flux per row (this means if multiple P fluxes were reported then they will produce multiple rows)
# Retain source of the TP fluxes in a new column
# Remove all the other P flux volums to simplify the data.frame
pflux <- pflux %>% 
  gather(TP.FLUX.mg_m2_d.source, TP.FLUX.mg_m2_d.value, TP.VALUE_mg_m2_d, TP_from_TDP_mg_m2_d, TP_from_SRP_mg_m2_d, na.rm = TRUE) %>% 
  select(-SRP.VALUE, -SRP.UNITS, -TDP.VALUE, -TDP.UNITS, -TP.VALUE, -TP.UNITS, -SRP.VALUE_mg_m2_d, -TDP.VALUE_mg_m2_d)

# Assemble data (this will throw a few errors but is fine)
pflux <- left_join(pflux, lakes, by = "LAKE.ID") %>% 
  left_join(., geol, by = "LAKE.ID") %>% 
  left_join(., sites, by = c("SITE.ID", "LAKE.ID"))

# pflux is now 634 observations of 49 variables
# Save pflux as a csv file for use in 03-Figures
write.csv(pflux, file = "PFLUX_assembled.csv", row.names = FALSE)

# EOF
