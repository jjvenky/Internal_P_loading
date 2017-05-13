# Internal P Loading

Data and code associated with Orihel, Baulch, Casson, North, Parsons, Seckar, and Venkiteswaran. *Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis.*

# Schema for Internal_P_Review_Database

Table B2. Fields in the database table “REF”
--------------------------------------------

||| 
|------ |-------------------------------------|
|REF_ID |       PDF File Name (e.g. YYYY_Lastname)|
|FirstAuthor    |      Last name of first author|
|Type_PData |   Type of P data ("SRP", "TDP", or "TP")|
|Comment    | Comment regarding paper|
|Ref_Title  | Title of reference|
|Ref_Journal    | Name of journal or report type of reference|
|Ref_Volume | Volume of journal or report of reference|
|Ref_Pages  | Pages of reference|
|Ref_Thesis_Univ    | University where reference thesis was completed|
|Ref_Thesis_Level   | M.Sc. or Ph.D thesis of reference|
|DOI    | Digital object identifier if available for the reference|


Table B3. Fields in the database table “LAKES”
----------------------------------------------

|||
|------ |-------------------------------------|
|LAKE_ID	| Lake ID (from LAKES table)|
|Lake_Name	| Lake name from paper (use sentence case, e.g., Nakamun Lake)|
|Province	| Province (BC, AB, SK, MB, ON, QC, NB, NS, PE, NL, YT, NT, NU) lake is located in|
|Lat	| Latitude in decimal degrees (N) of approximate centre of lake|
|Long	| Longitude in decimal degrees (W) of approximate centre of lake|
|Elevation	| Elevation (m.a.s.l.) of lake surface|
|Lake_Area	| Area of lake (km2)|
|Lake_MaxDepth	| Maximum depth of lake (m)|
|Waterbody_Type	| Type of waterbody (Natural Lake, Regulated Lake, Artificial Reservoir, Wetland)|
|Trophic_State	| Trophic state of waterbody, as defined in (Wetzel 2001) (Oligotrophic, Mesotrophic, Eutrophic, Hypereutrophic)|
|Res_Tim	| Residence time (y)|
|LakepH_Cat	| Lake pH category, as defined in Hounslow, A. (1995) "Water Quality Data: Analysis and Interpretation." Lewis Publishers. (Strongly Acidic, Moderately Acidic, Neutral, Moderatory Alkaline, Strongly Alkaline)|
|Ref_ID_1 to 6	| Reference the lake is referred to in (from REF table)|
|Comment	| Comment about lake|


Table B4. Fields in the database table “GEOL”
---------------------------------------------

|||
|------ |-------------------------------------|
|LAKE_ID    | Lake ID (from LAKES table)
|Rock_Detail    | Extracted from the SUBRXTP layer of Wheeler et al. (1996) based on the latitude and longitude of the water body
|Rock   | Extracted from the RXTP layer of Wheeler et al. (1996) based on the latitude and longitude of the water body


Table B5. Fields in the database table “SITES”
----------------------------------------------

|||
|------ |-------------------------------------|
|SITE_ID    | Unique 4-character site code (alphanumeric/all caps)
|Lake_ID    | Lake ID (from LAKES table)
|Site_Depth | Site depth (m)
|LOI     | Loss on ignition (%)
|Site_Sed_P | Surface sediment P (mg/g dry weight)
|Site_Sed_Fe    | Surface sediment Fe (mg/g dry weight)
|Site_Desc  | Site description as described in reference
|Ref_ID | Reference (from REF table)
|Comment    | Additional comments regarding site


Table B6. Fields in the database table “PFLUX”
----------------------------------------------

|||
|------ |-------------------------------------|
F_ID	| Unique flux ID (FXXXX)|
|Lake_ID	| Lake ID (from LAKES table)|
|Site_ID	| Site ID (from SITES table)|
|Method	| Method of measurements (CORE INCUBATION, POREWATER PROFILE, MASS BALANCE, OTHER MODEL)|
|F_Class	| Classification of flux as Lnet or Lgross.|
|Start_Season	| Season at start of study (SPRING: March 1 to May 31; SUMMER: June 1 to August 31, FALL: September 1 to November 30, WINTER: December 1 to February 28/29)|
|End_Season	| Season at end of study (leave blank if not multiple-season study)(SPRING: March 1 to May 31; SUMMER: June 1 to August 21, FALL: September 1 to November 30, WINTER: December 1 to February 28/29)|
|Start_Date	| Date of flux measurement (dd-MMM-yy)|
|Duration	| Duration of experiment (days)|
|Temperature	| Temperature of experiment (degrees Celcius)|
|pH	| pH of overlying water in experiment|
|O2_Cat	| Category of oxygen conditions (OXIC >2 mg/L; HYPOXIC <2 mg/L and >0.5 mg/L; ANOXIC <0.5 mg/L for lab studies; INSITU(OXIC); INSITU(HYPOXIC); INSITU(ANOXIC) ;INSITU(UNKNOWN) for field studies)|
|Light_Cat	| Category of light conditions (LIGHT; DARK; INSITU)|
|Reps	| Number of experimental replicates|
|SRP_Value	| Value of soluble reactive phosphorus (SRP)|
|SRP_Units	| Units of SRP|
|TDP_Value	| Value of total dissolved phosphorus (TDP)|
|TDP_Units	| Units of TDP|
|TP_Value	| Value of total phosphorus (TP)|
|TP_Units	| Units of TP|
|Ref_ID	| Reference from REF table|
|Comment	| Comment about P flux data|
|Flag	| Record flagged if an error/problem is detected with it or it is a whole-lake experiment with phosphorus impacts; allows possible exclusion from the dataset.|
|Flag_Comment	| Description of why the record is flagged|