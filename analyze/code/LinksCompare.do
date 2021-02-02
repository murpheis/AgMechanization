
set more off, perm

cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"





global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg valPerAcre_chg10"
global countyControls= "bankstot20 dist_closest_city farmsize10 popperacre10 farmpopperacre10 urbanperacre10 indagperacre10 indmanuperacre10 farmperacre10 valPerAcre10"



global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"




*===============================================*
*		SET UP DATA			*
*===============================================*


* 1910-1930 Links
use ./analyze/temp/regdata1030.dta, clear

label var farm_10 "Farm"

gen unemp_30 = empstat_30 == 20

gen emp_30 = empstat_30 == 10

gen nilf_30 = empstat_30 == 30


* industry of employment without conditioning on employed
foreach var of varlist ind_ag_30 ind_mill_30-ind_bank_30 {
 replace `var' = 0 if empstat_30 == 30 
 replace `var' = 0 if empstat_30 == 20 
}

* recode lit
gen lit30 = lit_30 == 4
replace lit30 = . if lit_30 > 4

rename occfarmer_30 occfarm_30

* recode farm_30
replace farm_30 = farm_30 - 1


* keep only men
keep if sex_10 == 1



* Link Quality
binscatter totdist_30 pct_treated_crops_1910 if region2num == 2, n(100) ///
	absorb(stateicp) control($countyControls1 $countyControls2  homeowner age_10 agesq_10 farm_10 white) reportreg


binscatter totdist_30 tractPerAcre30_10loc if region2num == 2, n(100) ///
	absorb(stateicp) control($countyControls1 $countyControls2 homeowner age_10 agesq_10 farm_10 white) reportreg



binscatter totdist_30 pct_treated_crops_1910 if region2num == 2, n(100) ///
	absorb(stateicp)  reportreg


binscatter totdist_30 tractPerAcre30_10loc if region2num == 2, n(100) ///
	absorb(stateicp)  reportreg
	
	

