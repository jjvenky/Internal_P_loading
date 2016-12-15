### Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis
### Orihel et al.
### https://github.com/jjvenky/Internal_P_loading


### 01 Export data


#####################################
### Pull tables from the database file
### Version 1, works in Windows with MS Access installed
#####################################

library(RODBC)

# open channel to connect to Internal P database
channel <- odbcConnectAccess("Internal P Review Database_for archive")

# extract tables from database
geol <- sqlQuery( channel , paste ("select *
 from GEOL"))
lakes <- sqlQuery( channel , paste ("select *
 from LAKES"))
porep <- sqlQuery( channel , paste ("select *
 from POREP"))
pflux <- sqlQuery( channel , paste ("select *
 from PFLUX"))
ref <- sqlQuery( channel , paste ("select *
 from REF"))
sits <- sqlQuery( channel , paste ("select *
 from SITES"))

# write .csv files from each of the database tables
write.csv(GEOL, file = "GEOL.csv", row.names = FALSE)
write.csv(LAKES, file = "LAKES.csv", row.names = FALSE)
write.csv(POREP, file = "POREP.csv", row.names = FALSE)
write.csv(PFLUX, file = "PFLUX.csv", row.names = FALSE)
write.csv(REF, file = "REF.csv", row.names = FALSE)
write.csv(SITES, file = "SITES.csv", row.names = FALSE)

# close channel to database
odbcCloseAll()


#####################################
### Pull tables from the database file
### Version 2, works in Linux where MS Access is not installed
### Uses mdbtools
#####################################

library(Hmisc)

db.df <- mdb.get("Internal_P_Review_Database_for_archive.mdb")

# write .csv files from each of the database tables
write.csv(db.df$GEOL, file = "GEOL.csv", row.names = FALSE)
write.csv(db.df$LAKES, file = "LAKES.csv", row.names = FALSE)
write.csv(db.df$POREP, file = "POREP.csv", row.names = FALSE)
write.csv(db.df$PFLUX, file = "PFLUX.csv", row.names = FALSE)
write.csv(db.df$REF, file = "REF.csv", row.names = FALSE)
write.csv(db.df$SITES, file = "SITES.csv", row.names = FALSE)

# EOF