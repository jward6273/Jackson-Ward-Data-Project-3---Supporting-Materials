/*

Data Project 3

Name: Jackson Ward

*/
cap log close
log using "dta_prjct3.txt", replace

******MERGING ZIP-LEVEL DATASETS******

cd "/Users/hacksonward/Downloads"
import excel using "COUNTY_ZIP_062020", first clear

*convert zip to 3 digit zip*
gen zip3=substr(ZIP,1,3)

save "COUNTY_ZIP_062020.dta", replace

*get 2020&2021 housing data*
import excel using "hpi_at_zip3", cellrange(A6:D42056) first clear 
keep if Year == 2020 | Year == 2021
gen zip3 = string(ThreeDigitZIPCode, "%03.0f")
keep zip3 Year HPI 
reshape wide HPI, i(zip3) j(Year)
rename HPI2020 hpi_2020
rename HPI2021 hpi_2021
save "HPI_2020_2021_wide.dta", replace

*merge together*
use COUNTY_ZIP_062020, clear
merge m:1 zip3 using "HPI_2020_2021_wide.dta"
drop if _merge == 1
drop _merge
collapse (mean) hpi_2020 hpi_2021 [aweight=RES_RATIO], by(COUNTY)
destring COUNTY, gen(fips)
drop COUNTY
save "county_hpi.dta", replace

******COUNTY LEVEL INCOME CONTROLS******
*Clean 2020 SAIPE Data*
import excel using "est20all", cellrange(A4:Y3199) first clear
destring CountyFIPSCode, replace
drop if CountyFIPSCode == 0
destring StateFIPSCode, replace
gen fips = (StateFIPSCode * 1000) + CountyFIPSCode

rename PovertyPercentAllAges pov_2020
rename MedianHouseholdIncome inc_2020
destring pov_2020 inc_2020, replace force
keep fips pov_2020 inc_2020
save "SAIPE_2020.dta", replace

*Clean 2021 SAIPE Data*
import excel using "est21all", cellrange(A4:Y3199) first clear
destring CountyFIPSCode, replace
drop if CountyFIPSCode == 0
destring StateFIPSCode, replace
gen fips = (StateFIPSCode * 1000) + CountyFIPSCode

rename PovertyPercentAllAges pov_2021
rename MedianHouseholdIncome inc_2021
destring pov_2021 inc_2021, replace force
keep fips pov_2021 inc_2021
save "SAIPE_2021.dta", replace

******MERGING COUNTY POP & COUNTY COVID DATA******
import delimited using "co-est2025-alldata.csv", clear 
*Dropping the state totals listed in the dataset*
drop if county == 0

gen fips = (state*1000)+county
keep fips estimatesbase2020
*dropping duplicate fips for a successful merge*
duplicates drop fips, force
save "2020_countypop.dta", replace

import delimited using "us-counties-2020.csv", clear
drop if fips == .
keep fips deaths state
collapse (max) deaths, by(fips state)
*merge together*
merge 1:1 fips using "2020_countypop.dta"
keep if _merge==3
drop _merge
save "2020_county_popdeath", replace

******FINAL MERGE******

use "county_hpi.dta", clear

* Merge in Mortality & Population data (from Part 1)
merge 1:1 fips using "2020_county_popdeath.dta"
drop if _merge == 2
drop _merge

* Merge in SAIPE data (from Part 3)
merge 1:1 fips using "SAIPE_2020.dta"
drop if _merge == 2
drop _merge

merge 1:1 fips using "SAIPE_2021.dta"
drop if _merge == 2
drop _merge

*Creating a variable to represent deaths per 1000, to make analysis more clear*
gen deathr = (deaths/estimatesbase2020)*1000
/*Overall we are missing the data for several counties, which may skew the results*/

******EMPIRICAL ANALYSIS******
*summary statistics*
summarize deathr hpi_2020 hpi_2021 pov_2020 pov_2021 inc_2020 inc_2021 

*visualization*
twoway scatter hpi_2021 deathr, mcolor(midblue) msize(vtiny) ///
    xtitle("Deaths per 1,000 Residents (2020)") ///
    ytitle("Housing Price Index (2021)")
graph export hpi_deathr.png, replace

*uncontrolled regression*
reg hpi_2021 deathr, robust

*controlled first differences regression with state dummies*
gen hpi_change = hpi_2021 - hpi_2020
gen inc_change = inc_2021 - inc_2020
gen pov_change = pov_2021 - pov_2020
encode state, gen(state_fe)
reg hpi_change deathr inc_change pov_change inc_2020 pov_2020 i.state_fe, robust

cap log close
