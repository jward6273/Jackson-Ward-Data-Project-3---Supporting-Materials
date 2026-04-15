# Jackson-Ward-Data-Project-3---Supporting-Materials
Descriptions of and links to the raw datasets used in this experiment

### New York Times Covid Cases data for each US county
"us-counties-2020.csv"

-->https://github.com/nytimes/covid-19-data

Tallies covid deaths in each county, I used this data to aggregate a figure for yearly 2020 total deaths for each county.

### Federal Housing Finance Agency HPI 
Three-Digit ZIP Codes (Developmental Index; Not Seasonally Adjusted) "hpi_at_zip3.xlsx"

-->https://www.fhfa.gov/data/hpi/datasets?tab=annual-data

Contains House Price Index for each county, I used data from 2020 and 2021 to show change in HPI over this period. 

### Census Bureau Population Estimates
Datasets - Annual Resident Population Estimates "CO-EST2025-alldata.csv" 

-->https://www.census.gov/data/tables/time-series/demo/popest/2020s-counties-total.html

This contains total population estimates for each county which were used along with death totals to create death rates (deaths per 1000 residents)


### Census Bureau Small Area Income and Poverty Estimates (2020 & 2021)
2020 - US and All States and Counties "estall20.xls"

-->https://www.census.gov/data/datasets/2020/demo/saipe/2020-state-and-county.html 


2021 - US and All States and Counties "estall21.xls"

-->https://www.census.gov/data/datasets/2021/demo/saipe/2021-state-and-county.html

THese data sets give estimates for Household Income and Poverty Rates annually, which were used as control variables in my experiment, along with several other variables not included in this experiment.


### US Zipcode crosswalk
County-Zip, 2nd Quarter 2020 "COUNTY_ZIP_062020.xlsx"

-->https://www.huduser.gov/apps/public/uspscrosswalk/home

Used for matching zip codes and fips codes in HPI dataset to prepare for final merge.
