set more off, perm

cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"


*===============================================*
*		1910-40 DATA			*
*===============================================*


* IMPORT LINKED POPULATION CENSUS DATA
use ./clean/output/linked1040clean_best.dta, clear

* merge to control variables dataset
gen state = stateicp_10
gen county = county_10
gen year = 1910
merge m:1 state county year using ./clean/output/countyFCwithControls.dta
keep if _m == 3
drop _m

* merge in tractors to 1910 locations
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_10loc

* merge in tractors to  1940 locations
drop state county year
gen state = stateicp_40
gen county = county_40
gen year = 1940
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_40loc
rename *10loc_40loc *10loc

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb


* farm resident variables
replace farm_10 = farm_10 - 1
gen tract30farm10 = farm_10*tractPerAcre30_10loc
gen crops10farm10 = farm_10*pct_treated_crops_1910




* race variables
drop white
gen white = race_10 < 200 
gen tract30white = white*tractPerAcre30_10loc
gen whitefarm10 = white*farm_10
gen whitefarm10tract = white*farm_10*tractPerAcre30_10loc
gen crops10white10 = white*pct_treated_crops_1910
gen crops10white10farm = white*pct_treated_crops_1910*farm_10



* age related variables
gen agesq_10 = age_10^2
/*gen age010 = age_10 < 10
gen age1030 = age_20 >= 10 & age_20 < 30
gen age010tract = age010 * tractPerAcre30_20loc
gen age1030tract = age1030 * tractPerAcre30_20loc
gen age010farm20 = age010 * farm_20
gen age1030farm20 = age1030 * farm_20
gen age010tractfarm20 = age010 * tractPerAcre30_20loc * farm_20
gen age1030tractfarm20 = age1030 * tractPerAcre30_20loc * farm_20
gen crops10age010 = age010*pct_treated_crops_1910
gen crops10age1030 = age1030*pct_treated_crops_1910
gen crops10age010farm = age010*pct_treated_crops_1910 * farm_20
gen crops10age1030farm = age1030*pct_treated_crops_1910 * farm_20*/


* create home ownership variables
tab ownershp_10, gen(owner10cat_)
gen homeowner = ownershp_10 == 10
gen homeownertract = homeowner * tractPerAcre30_10loc
gen homeownerfarm10 = homeowner * farm_10
gen homeownertractfarm10 = homeowner * tractPerAcre30_10loc * farm_10
label var homeowner "Home Owner"
label var homeownertract "Home Owner * $\Delta$ tractors"
gen crops10home = homeowner*pct_treated_crops_1910
gen crops10homefarm = homeowner*pct_treated_crops_1910*farm_10


* employment outcomes
gen unemployed_40 = empstat_40 >= 20 & empstat_40 <=22
replace unemployed_40 = . if mi(empstat_40)
gen publicemp_40 = empstat_40 == 11
replace publicemp_40 = . if mi(empstat_40)
gen nilf_40 = empstat_40 >=30
replace nilf_40 = . if mi(empstat_40)


* education outcomes
gen grade8_40 = educ_40 <= 26
gen someHS_40 = educ_40 > 26 & educ_40 ~= 999
gen highered_40 = educ_40 >60 & educ_40 ~= 999
foreach var of varlist grade8_40  someHS_40 highered_40 {
	replace `var' = . if mi(educ_40)
}

* occupation outcomes
gen occfarmer_10 = (occ1950_10 >=100 & occ1950_10 <= 123) | (occ1950_10 >=810 & occ1950_10 <= 840)
gen occfarmer_40 = (occ1950_40 >=100 & occ1950_40 <= 123) | (occ1950_40 >=810 & occ1950_40 <= 840)
gen occcrafts_10 = (occ1950_10 >=500 & occ1950_10 <= 595)
gen occcrafts_40 = (occ1950_40 >=500 & occ1950_40 <= 595)
gen occoper_10 = (occ1950_10 >=600 & occ1950_10 <= 690)
gen occoper_40 = (occ1950_40 >=600 & occ1950_40 <= 690)
foreach year of numlist 10 40 {
	replace occfarmer_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occcrafts_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occoper_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
}



* occscore
replace occscore_10 = . if occscore_10 == 0
replace occscore_40 = . if occscore_40 == 0
gen occscore_improve = occscore_40 >= occscore_10 
replace occscore_imp = . if mi(occscore_10) | mi(occscore_40)
gen occscore_change = occscore_40 - occscore_10




* industry variables
gen ind_ag_10 = ind1950_10 >=105 & ind1950_10 <= 126
gen ind_ag_40 = ind1950_40 >=105  & ind1950_40 <= 126
replace ind_ag_10 = . if mi(ind1950_10)
replace ind_ag_40 = . if mi(ind1950_40)
gen ind_manu_10 = ind1950_10 >=306 & ind1950_10<=499
gen ind_manu_40 = ind1950_40 >=306 & ind1950_40<=499
replace ind_manu_10 = . if mi(ind1950_10)
replace ind_manu_40 = . if mi(ind1950_40)




save ./analyze/temp/regdata1040.dta, replace

*===============================================*
*		1920-40 DATA			*
*===============================================*


* IMPORT LINKED POPULATION CENSUS DATA
use ./clean/output/linked2040clean.dta, clear

* merge to control variables dataset
gen state = stateicp_20
gen county = county_20
gen year = 1920
merge m:1 state county year using ./clean/output/countyFCwithControls.dta
keep if _m == 3
drop _m

* merge in tractors to 1920 locations
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_20loc

* merge in tractors to  1940 locations
drop state county year
gen state = stateicp_40
gen county = county_40
gen year = 1940
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_40loc
rename *20loc_40loc *20loc

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb


* farm resident variables
replace farm_20 = farm_20 - 1
gen tract20farm20 = farm_20*tractPerAcre30_20loc
gen crops10farm20 = farm_20*pct_treated_crops_1910




* race variables
drop white
gen white = race_20 < 200 
gen tract20white = white*tractPerAcre30_20loc
gen whitefarm20 = white*farm_20
gen whitefarm20tract = white*farm_20*tractPerAcre30_20loc
gen crops10white20 = white*pct_treated_crops_1910
gen crops10white20farm = white*pct_treated_crops_1910*farm_20



* age related variables
gen agesq_20 = age_20^2
gen age010 = age_20 < 10
gen age1030 = age_20 >= 10 & age_20 < 30
gen age010tract = age010 * tractPerAcre30_20loc
gen age1030tract = age1030 * tractPerAcre30_20loc
gen age010farm20 = age010 * farm_20
gen age1030farm20 = age1030 * farm_20
gen age010tractfarm20 = age010 * tractPerAcre30_20loc * farm_20
gen age1030tractfarm20 = age1030 * tractPerAcre30_20loc * farm_20
gen crops10age010 = age010*pct_treated_crops_1910
gen crops10age1030 = age1030*pct_treated_crops_1910
gen crops10age010farm = age010*pct_treated_crops_1910 * farm_20
gen crops10age1030farm = age1030*pct_treated_crops_1910 * farm_20


* create home ownership variables
tab ownershp_20, gen(owner20cat_)
gen homeowner = ownershp_20 == 10
gen homeownertract = homeowner * tractPerAcre30_20loc
gen homeownerfarm20 = homeowner * farm_20
gen homeownertractfarm20 = homeowner * tractPerAcre30_20loc * farm_20
label var homeowner "Home Owner"
label var homeownertract "Home Owner * $\Delta$ tractors"
gen crops10home = homeowner*pct_treated_crops_1910
gen crops10homefarm = homeowner*pct_treated_crops_1910*farm_20


* employment outcomes
gen unemployed_40 = empstat_40 >= 20 & empstat_40 <=22
replace unemployed_40 = . if mi(empstat_40)
gen publicemp_40 = empstat_40 == 11
replace publicemp_40 = . if mi(empstat_40)
gen nilf_40 = empstat_40 >=30
replace nilf_40 = . if mi(empstat_40)


* education outcomes
gen grade8_40 = educ_40 <= 26
gen someHS_40 = educ_40 > 26 & educ_40 ~= 999
gen highered_40 = educ_40 >60 & educ_40 ~= 999
foreach var of varlist grade8_40  someHS_40 highered_40 {
	replace `var' = . if mi(educ_40)
}

* occupation outcomes
gen occfarmer_20 = (occ1950_20 >=100 & occ1950_20 <= 123) | (occ1950_20 >=810 & occ1950_20 <= 840)
gen occfarmer_40 = (occ1950_40 >=100 & occ1950_40 <= 123) | (occ1950_40 >=810 & occ1950_40 <= 840)
gen occcrafts_20 = (occ1950_20 >=500 & occ1950_20 <= 595)
gen occcrafts_40 = (occ1950_40 >=500 & occ1950_40 <= 595)
gen occoper_20 = (occ1950_20 >=600 & occ1950_20 <= 690)
gen occoper_40 = (occ1950_40 >=600 & occ1950_40 <= 690)
foreach year of numlist 20 40 {
	replace occfarmer_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occcrafts_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occoper_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
}



* occscore
replace occscore_20 = . if occscore_20 == 0
replace occscore_40 = . if occscore_40 == 0
gen occscore_improve = occscore_40 >= occscore_20 
replace occscore_imp = . if mi(occscore_20) | mi(occscore_40)
gen occscore_change = occscore_40 - occscore_20




* industry variables
gen ind_ag_20 = regexm(indstr_20,"FARM")
gen ind_ag_40 = regexm(indstr_40,"FARM")
replace ind_ag_20 = . if mi(indstr_20)
replace ind_ag_40 = . if mi(indstr_40)
gen left_ag = ind_ag_20 == 1 & ind_ag_40 == 0 
replace left_ag = . if mi(ind_ag_20) | mi(ind_ag_40)
gen ind_mill_40 = regexm(indstr_40,"MILL") 
replace ind_mill_40 = . if mi(ind_ag_40)
gen ind_manu_40 = regexm(indstr_40,"FACTORY") | regexm(indstr_40,"MFG") | regexm(indstr_40,"MANUFACTURING")
replace ind_manu_40 = . if mi(indstr_40)
gen ind_retail_40 = regexm(indstr_40,"STORE") | regexm(indstr_40,"SHOP") 
replace ind_retail_40 = . if mi(indstr_40)
gen ind_mine_40 = regexm(indstr_40,"MINE") | regexm(indstr_40,"COAL") | regexm(indstr_40," OIL ") 
replace ind_mine_40 = . if mi(indstr_40)
gen ind_ed_40 = regexm(indstr_40,"SCHOOL") 
replace ind_ed_40 = . if mi(indstr_40)
gen ind_railroad_40 = regexm(indstr_40,"RAIL") | regexm(indstr_40,"ROAD") | regexm(indstr_40,"R.R.")
replace ind_railroad_40 = . if mi(indstr_40)
gen ind_oddjobs_40 = regexm(indstr_40,"ODD JOBS") 
replace ind_oddjobs_40 = . if mi(indstr_40)
gen ind_bank_40 = regexm(indstr_40,"BANK") 
replace ind_bank_40 = . if mi(indstr_40)


save ./analyze/temp/regdata2040.dta, replace

***** Regressions *****
//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"

//global countyControls =  "bankstot20 dist_closest_city farmsize10  valPerAcre00 valPerAcre10 ind_manu10 pct_urban_1900  pct_urban_1910"
//global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg"

global countyControls =  "bankstot20 dist_closest_city farmsize10  "
global countyControls2 popperacre farmpopperacre urbanperacre indagperacre indmanuperacre ind_manu_pct valPerAcre10 farmperacre // horseperacre

foreach var of varlist  moved_40 movedFar_40 occfarmer_40 occoper_40 occcrafts_40 grade8_40 someHS_40 highered_40 unemployed_40 nilf_40 publicemp_40 incwage_40 occscore_improve occscore_change {

	* depvar on tract*farm
	eststo clear
	eststo: qui reg `var' farm_20  tract20farm20 , vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract.tex, replace `tableopts' stats(N) drop(*county*)


	* depvar on tract*farm by region
	eststo clear
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls  $countyControls2, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if region2num == 1, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if region2num == 2, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if region2num == 3, vce(cluster county)	
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if region2num == 4, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract_byregion.tex, replace `tableopts' stats(N) drop(*county*) mtitles("US" "NE" "MW" "SE" "Deep south" "West")

/*
	* heterogeneity 
	eststo clear 
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner , vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions.tex, replace `tableopts' stats(N)  drop(*county* ) 
*/
	* heterogeneity by region
	eststo clear 
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls $countyControls2 sex_20 homeowner , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls $countyControls2 sex_20 homeowner if region2num == 1, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_20 homeowner if region2num == 2 , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_20 homeowner if region2num == 3, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_20 homeowner if region2num == 4, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_20 homeowner if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions_byregion.tex, replace `tableopts' stats(N)  drop(*county* ) mtitles("US" "NE" "MW" "SE" "Deep south" "West")


}



* IV first stage
reg tract20farm20 crops10farm20 pct_treated_crops_1910
predict yhat
gen cov = .
foreach var of varlist incwage_40 occscore_improve occscore_change moved_40 movedFar_40 occfarmer_40 occoper_40 occcrafts_40 grade8_40 someHS_40 highered_40 unemployed_40 nilf_40 publicemp_40  {

	* IV comparison regs
	label var cov "Tract*Farm"
	eststo clear 
	replace cov = tract20farm20
	eststo: qui reg `var' farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2, vce(cluster county)
	replace cov = yhat
	eststo: qui reg `var' farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab*, drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'_IV.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("OLS" "IV")

}






/*


* regressions for whole country
local i = 1
foreach var of varlist  moved_30 movedFar_30 {
display "`i'"

/*
	if `i' ~= 1 {
	* depvar on tract*farm
	eststo clear
	eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 , vce(cluster county)
	eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 i.county, vce(cluster county)
	eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract.tex, replace `tableopts' stats(N) drop(*county*)
	}


* depvar on tract*race
eststo clear
eststo: qui reg `var' white tractPerAcre30_20loc tract20white   if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' white tractPerAcre30_20loc tract20white i.county  if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' white tractPerAcre30_20loc tract20white i.county  age_20 agesq_20 sex_20 homeowner if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' white tractPerAcre30_20loc tract20white i.county  age_20 agesq_20 sex_20 homeowner $countyControls if farm_20 == 1, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/`var'VsRaceTract.tex, replace `tableopts' stats(N) drop(*county*)


* depvar on tract*homeowner
eststo clear
eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract   if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract i.county  if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract i.county white age_20 agesq_20 sex_20  if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract i.county white age_20 agesq_20 sex_20 $countyControls if farm_20 == 1, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/`var'VsHomeOwnerTract.tex, replace `tableopts' stats(N)  drop(*county*)

* depvar on tract*age
eststo clear
eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract   if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract i.county  if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract i.county white  sex_20 homeowner if farm_20 == 1, vce(cluster county)
eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract i.county white  sex_20 homeowner $countyControls if farm_20 == 1, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/`var'VsAgeTract.tex, replace `tableopts' stats(N)  drop(*county*)

*/
* depvar on all interactions
eststo clear
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 homeowner white  if farm_20 == 1 , vce(cluster county)
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 homeowner white i.county  if farm_20 == 1 , vce(cluster county)
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner if farm_20 == 1 , vce(cluster county)
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 , vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/`var'VsAllInteractions.tex, replace `tableopts' stats(N)  drop(*county*)



local i = `i' + 1


}

/*
* by region
levelsof region2num, local(regions)
local i = 1
foreach var of varlist leftfarm_30 moved_30 movedFar_30 {
display "`i'"

	foreach region of local regions {

		if `i' ~= 1 {
		* depvar on tract*farm
		eststo clear
		eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 if region2num == `region', vce(cluster county)
		eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 i.county  if region2num == `region', vce(cluster county)
		eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner  if region2num == `region', vce(cluster county)
		eststo: qui reg `var' farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls if region2num == `region', vce(cluster county)
		local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
		esttab * , drop(*county*) `tableopts'
		esttab * using ./analyze/output/`var'VsFarmTract_region`region'.tex, replace `tableopts' stats(N) drop(*county*)
		}

	* depvar on tract*race
	eststo clear
	eststo: qui reg `var' white tractPerAcre30_20loc tract20white   if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' white tractPerAcre30_20loc tract20white i.county  if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' white tractPerAcre30_20loc tract20white i.county  age_20 agesq_20 sex_20 homeowner if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' white tractPerAcre30_20loc tract20white i.county  age_20 agesq_20 sex_20 homeowner $countyControls if farm_20 == 1 &  region2num == `region', vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsRaceTract_region`region'.tex, replace `tableopts' stats(N) drop(*county*)


	* depvar on tract*homeowner
	eststo clear
	eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract   if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract i.county  if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract i.county white age_20 agesq_20 sex_20  if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' homeowner tractPerAcre30_20loc homeownertract i.county white age_20 agesq_20 sex_20 $countyControls if farm_20 == 1 &  region2num == `region', vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsHomeOwnerTract_region`region'.tex, replace `tableopts' stats(N)  drop(*county*)

	* depvar on tract*age
	eststo clear
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract   if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract i.county  if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract i.county white  sex_20 homeowner if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc age010tract age1030tract i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num == `region', vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAgeTract_region`region'.tex, replace `tableopts' stats(N)  drop(*county*)


	* depvar on all interactions
	eststo clear
	eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 homeowner white  if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county  if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner if farm_20 == 1 &  region2num == `region', vce(cluster county)
	eststo: qui reg `var' age010 age1030 tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num == `region', vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions_region`region'.tex, replace `tableopts' stats(N)  drop(*county*)



	}

local i = `i' + 1
}

*/

* Tables that display regional results
eststo clear 
eststo: qui reg moved_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==1, vce(cluster county)
eststo: qui reg moved_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==2, vce(cluster county)
eststo: qui reg moved_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==3, vce(cluster county)
eststo: qui reg moved_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==4, vce(cluster county)
eststo: qui reg moved_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==5, vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/moved_30VsAllInteractions_allregions.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("NE" "MW" "SE" "Deep south" "West")

eststo clear 
eststo: qui reg movedFar_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==1, vce(cluster county)
eststo: qui reg movedFar_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==2, vce(cluster county)
eststo: qui reg movedFar_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==3, vce(cluster county)
eststo: qui reg movedFar_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==4, vce(cluster county)
eststo: qui reg movedFar_30  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==5, vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/movedFar_30VsAllInteractions_allregions.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("NE" "MW" "SE" "Deep south" "West")

/*
* depvar on tract*farm
eststo clear
eststo: qui reg moved_30 farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls if region2num == 1, vce(cluster county)
eststo: qui reg moved_30 farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls if region2num == 2, vce(cluster county)
eststo: qui reg moved_30 farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls if region2num == 3, vce(cluster county)
eststo: qui reg moved_30 farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls if region2num == 4, vce(cluster county)
eststo: qui reg moved_30 farm_20 tractPerAcre30_20loc tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls if region2num == 4, vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/moved_30VsFarmTract_allregions.tex, replace `tableopts' stats(N) drop(*county*)

*/


***** 1940 *******

* depvar on all interactions
foreach var of varlist grade8_40 someHS_40 highered_40 occfarmer_40 occcrafts_40 occoper_40 unemployed_40 {
eststo clear
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 homeowner white  if farm_20 == 1 , vce(cluster county)
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 homeowner white i.county  if farm_20 == 1 , vce(cluster county)
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner if farm_20 == 1 , vce(cluster county)
eststo: qui reg `var' tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 , vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/`var'VsAllInteractions.tex, replace `tableopts' stats(N)  drop(*county*)


}

* Tables that display regional results
eststo clear 
eststo: qui reg moved_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==1, vce(cluster county)
eststo: qui reg moved_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==2, vce(cluster county)
eststo: qui reg moved_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==3, vce(cluster county)
eststo: qui reg moved_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==4, vce(cluster county)
eststo: qui reg moved_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==5, vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/moved_40VsAllInteractions_allregions.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("NE" "MW" "SE" "Deep south" "West")

eststo clear 
eststo: qui reg movedFar_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==1, vce(cluster county)
eststo: qui reg movedFar_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==2, vce(cluster county)
eststo: qui reg movedFar_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==3, vce(cluster county)
eststo: qui reg movedFar_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==4, vce(cluster county)
eststo: qui reg movedFar_40  tractPerAcre30_20loc tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if farm_20 == 1 &  region2num ==5, vce(cluster county)
local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
esttab * , drop(*county*) `tableopts'
esttab * using ./analyze/output/movedFar_40VsAllInteractions_allregions.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("NE" "MW" "SE" "Deep south" "West")

*/

*===============================================*
*		1910-20 DATA			*
*===============================================*


* IMPORT LINKED POPULATION CENSUS DATA
use ./clean/output/linked1020clean.dta, clear

* merge to control variables dataset
gen state = stateicp_10
gen county = county_10
gen year = 1910
merge m:1 state county year using ./clean/output/countyFCwithControls.dta
keep if _m == 3
drop _m

* merge in tractors to 1910 locations
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_10loc


* merge in tractors to  1920 locations
drop state county year
gen state = stateicp_20
gen county = county_20
gen year = 1920
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_20loc
rename *10loc_20loc *10loc

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb



* farm resident variables
replace farm_10 = farm_10 - 1
gen tract30farm10 = farm_10*tractPerAcre30_10loc
gen crops10farm10 = farm_10*pct_treated_crops_1910

* race variables
drop white
gen white = race_10 < 200 
gen tract20white = white*tractPerAcre30_10loc
gen whitefarm10 = white*farm_10
gen whitefarm10tract = white*farm_10*tractPerAcre30_10loc
gen crops10white10 = white*pct_treated_crops_1910


* age related variables
gen agesq_10 = age_10^2
gen age010 = age_10 < 10
gen age1030 = age_10 >= 10 & age_10 < 30
gen age010tract = age010 * tractPerAcre30_10loc
gen age1030tract = age1030 * tractPerAcre30_10loc
gen age010farm10 = age010 * farm_10
gen age1030farm10 = age1030 * farm_10
gen age010tractfarm10 = age010 * tractPerAcre30_10loc * farm_10
gen age1030tractfarm10 = age1030 * tractPerAcre30_10loc * farm_10
gen crops10age010 = age010*pct_treated_crops_1910
gen crops10age1030 = age1030*pct_treated_crops_1910


* create home ownership variables
tab ownershp_10, gen(owner10cat_)
gen homeowner = ownershp_10 == 10
gen homeownertract = homeowner * tractPerAcre30_10loc
gen homeownerfarm10 = homeowner * farm_10
gen homeownertractfarm10 = homeowner * tractPerAcre30_10loc * farm_10
label var homeowner "Home Owner"
label var homeownertract "Home Owner * $\Delta$ tractors"
gen crops10home = homeowner*pct_treated_crops_1910

* occupation outcomes
gen occfarmer_10 = (occ1950_10 >=100 & occ1950_10 <= 123) | (occ1950_10 >=810 & occ1950_10 <= 840)
gen occfarmer_20 = (occ1950_20 >=100 & occ1950_20 <= 123) | (occ1950_20 >=810 & occ1950_20 <= 840)
gen occcrafts_10 = (occ1950_10 >=500 & occ1950_10 <= 595)
gen occcrafts_20 = (occ1950_20 >=500 & occ1950_20 <= 595)
gen occoper_10 = (occ1950_10 >=600 & occ1950_10 <= 690)
gen occoper_20 = (occ1950_20 >=600 & occ1950_20 <= 690)
foreach year of numlist 10 20  {
	replace occfarmer_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occcrafts_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occoper_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
}


* occscore
replace occscore_20 = . if occscore_20 == 0
replace occscore_10 = . if occscore_10 == 0
gen occscore_improve20 = occscore_20 >= occscore_10 
replace occscore_imp = . if mi(occscore_20) | mi(occscore_10)
gen occscore_change20 = occscore_20 - occscore_10




save ./analyze/temp/regdata1020.dta, replace


***** Regressions *****

//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"

global countyControls =  "bankstot20 dist_closest_city farmsize10  valPerAcre00 valPerAcre10 ind_manu10 pct_urban_1900  pct_urban_1910"
global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg"



foreach var of varlist  moved_20 movedFar_20 occfarmer_20 occoper_20 occcrafts_20 occscore_improve20 occscore_change20 {

/*
	* depvar on tract*farm
	eststo clear
	eststo: qui reg `var' farm_20  tract20farm20 , vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' farm_20  tract20farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract.tex, replace `tableopts' stats(N) drop(*county*)
*/

	* depvar on tract*farm by region
	eststo clear
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls if region2num == 1, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls if region2num == 2, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls if region2num == 3, vce(cluster county)	
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls if region2num == 4, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract_byregion.tex, replace `tableopts' stats(N) drop(*county* ) mtitles("US" "NE" "MW" "SE" "Deep south" "West")

/*
	* heterogeneity 
	eststo clear 
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner , vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions.tex, replace `tableopts' stats(N)  drop(*county* ) 
*/

	* heterogeneity by region
	eststo clear 
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract20white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract20white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls sex_20 homeowner if region2num == 1, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if region2num == 2 , vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if region2num == 3, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if region2num == 4, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions_byregion.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("US" "NE" "MW" "SE" "Deep south" "West")



}

* IV first stage
reg tract30farm10 crops10farm10 pct_treated_crops_1910
predict yhat

gen cov = .
foreach var of varlist  moved_20 movedFar_20 occfarmer_20 occoper_20 occcrafts_20 occscore_improve20 occscore_change20 {

	* IV comparison regs
	label var cov "Tract*Farm"
	eststo clear 
	replace cov = tract30farm10
	eststo: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
	replace cov = yhat
	eststo: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab*, drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'_IV.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("OLS" "IV")

}





*===============================================*
*		1910-30 DATA			*
*===============================================*


* IMPORT LINKED POPULATION CENSUS DATA
use ./clean/output/linked1030clean_best.dta, clear

* merge to control variables dataset
gen state = stateicp_10
gen county = county_10
gen year = 1910
merge m:1 state county year using ./clean/output/countyFCwithControls.dta
keep if _m == 3
drop _m

* merge crop data for 1930 locations
replace year = 1930
rename pct_treated_crops_1910 pct_treated_crops_1910_10loc
merge m:1 state county year using ./clean/output/countyFCwithControls.dta, keepusing(pct_treated_crops_1910)
rename pct_treated_crops_1910 pct_treated_crops_1910_30loc
rename pct_treated_crops_1910_10loc pct_treated_crops_1910
replace year = 1910
drop _m


* merge in tractors to 1910 locations
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_10loc


* merge in tractors to  1930 locations
drop state county year
gen state = stateicp_30
gen county = county_30
gen year = 1930
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_30loc
rename *10loc_30loc *10loc


* merge to mom and pop datasets
merge m:1 poploc_10 serialp_10 using ./clean/output/1910dads.dta
drop if _m == 2
drop _m
merge m:1 momloc_10 serialp_10 using ./clean/output/1910moms.dta
drop if _m == 2
drop _m


* farm resident variables
replace farm_10 = farm_10 - 1
gen tract30farm10 = farm_10*tractPerAcre30_10loc
gen crops10farm10 = farm_10*pct_treated_crops_1910

* race variables
drop white
gen white = race_10 < 200 
gen tract30white = white*tractPerAcre30_10loc
gen whitefarm10 = white*farm_10
gen whitefarm10tract = white*farm_10*tractPerAcre30_10loc
gen crops10white10 = white*pct_treated_crops_1910
gen crops10white10farm = white*pct_treated_crops_1910*farm_10


* age related variables
gen agesq_10 = age_10^2
gen age010 = age_10 < 10
gen age1030 = age_10 >= 10 & age_10 < 30
gen age010tract = age010 * tractPerAcre30_10loc
gen age1030tract = age1030 * tractPerAcre30_10loc
gen age010farm10 = age010 * farm_10
gen age1030farm10 = age1030 * farm_10
gen age010tractfarm10 = age010 * tractPerAcre30_10loc * farm_10
gen age1030tractfarm10 = age1030 * tractPerAcre30_10loc * farm_10
gen crops10age010 = age010*pct_treated_crops_1910
gen crops10age1030 = age1030*pct_treated_crops_1910
gen crops10age010farm = age010*pct_treated_crops_1910* farm_10
gen crops10age1030farm = age1030*pct_treated_crops_1910* farm_10


* create home ownership variables
tab ownershp_10, gen(owner10cat_)
gen homeowner = ownershp_10 == 10
gen homeownertract = homeowner * tractPerAcre30_10loc
gen homeownerfarm10 = homeowner * farm_10
gen homeownertractfarm10 = homeowner * tractPerAcre30_10loc * farm_10
label var homeowner "Home Owner"
label var homeownertract "Home Owner * $\Delta$ tractors"
gen crops10home = homeowner*pct_treated_crops_1910
gen crops10homefarm = homeowner*pct_treated_crops_1910 * farm_10


* occupation outcomes
gen occfarmer_10 = (occ1950_10 >=100 & occ1950_10 <= 123) | (occ1950_10 >=810 & occ1950_10 <= 840)
gen occfarmer_30 = (occ1950_30 >=100 & occ1950_30 <= 123) | (occ1950_30 >=810 & occ1950_30 <= 840)
gen occcrafts_10 = (occ1950_10 >=500 & occ1950_10 <= 595)
gen occcrafts_30 = (occ1950_30 >=500 & occ1950_30 <= 595)
gen occoper_10 = (occ1950_10 >=600 & occ1950_10 <= 690)
gen occoper_30 = (occ1950_30 >=600 & occ1950_30 <= 690)
gen popfarm_10 = (pop_occ1950_10 >=100 & pop_occ1950_10 <= 123) | (pop_occ1950_10 >=810 & pop_occ1950_10 <= 840)
replace popfarm_10 = . if pop_occ1950_10 == . | pop_occ1950_10>=997
foreach year of numlist 10 30  {
	replace occfarmer_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occcrafts_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occoper_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
}


* occscore
replace occscore_30 = . if occscore_30 == 0
replace occscore_10 = . if occscore_10 == 0
gen occscore_improve30 = occscore_30 >= occscore_10 
replace occscore_imp = . if mi(occscore_30) | mi(occscore_10)
gen occscore_change30 = occscore_30 - occscore_10
gen occ_min_pop = occscore_30 - pop_occscore_10
gen occ_v_pop = occscore_30 > pop_occscore_10


* occupation strings
gen occstr_farm_10 = regexm(occstr_10,"FARM")
gen occstr_farmlab_10 = regexm(occstr_10,"FARM LABOR")
gen occstr_labor_10 = regexm(occstr_10,"LABOR")

gen occstr_farm_30 = regexm(occstr_30,"FARM")
gen occstr_farmlab_30 = regexm(occstr_30,"FARM LABOR")
gen occstr_labor_30 = regexm(occstr_30,"LABOR")

* industry variables
gen ind_ag_10 = regexm(indstr_10,"FARM")
gen ind_ag_30 = regexm(indstr_30,"FARM")
replace ind_ag_10 = . if mi(indstr_10)
replace ind_ag_30 = . if mi(indstr_30)
gen left_ag = ind_ag_10 == 1 & ind_ag_30 == 0 
replace left_ag = . if mi(ind_ag_10) | mi(ind_ag_30)
gen ind_mill_30 = regexm(indstr_30,"MILL") 
replace ind_mill_30 = . if mi(ind_ag_30)
gen ind_manu_30 = regexm(indstr_30,"FACTORY") | regexm(indstr_30,"MFG") | regexm(indstr_30,"MANUFACTURING")
replace ind_manu_30 = . if mi(indstr_30)
gen ind_retail_30 = regexm(indstr_30,"STORE") | regexm(indstr_30,"SHOP") 
replace ind_retail_30 = . if mi(indstr_30)
gen ind_mine_30 = regexm(indstr_30,"MINE") | regexm(indstr_30,"COAL") | regexm(indstr_30," OIL ") 
replace ind_mine_30 = . if mi(indstr_30)
gen ind_ed_30 = regexm(indstr_30,"SCHOOL") 
replace ind_ed_30 = . if mi(indstr_30)
gen ind_railroad_30 = regexm(indstr_30,"RAIL") | regexm(indstr_30,"ROAD") | regexm(indstr_30,"R.R.")
replace ind_railroad_30 = . if mi(indstr_30)
gen ind_oddjobs_30 = regexm(indstr_30,"ODD JOBS") 
replace ind_oddjobs_30 = . if mi(indstr_30)
gen ind_bank_30 = regexm(indstr_30,"BANK") 
replace ind_bank_30 = . if mi(indstr_30)


* urbanization
gen urbanized = urban_30 == 2 & urban_10 == 1




save ./analyze/temp/regdata1030.dta, replace


***** Regressions *****

//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"
global countyControls =  "bankstot20 dist_closest_city farmsize10  valPerAcre00 valPerAcre10 ind_manu10 pct_urban_1900  pct_urban_1910"
global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg"



foreach var of varlist  moved_30 movedFar_30 occfarmer_30 occoper_30 occcrafts_30 occscore_improve30 occscore_change30 {


	* depvar on tract*farm
	eststo clear
	eststo: qui reg `var' farm_10  tract30farm10 , vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract_1030.tex, replace `tableopts' stats(N) drop(*county*)


	* depvar on tract*farm by region
	eststo clear
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 , vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if region2num == 1, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if region2num == 2, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if region2num == 3, vce(cluster county)	
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if region2num == 4, vce(cluster county)
	eststo: qui reg `var' farm_10  tract30farm10 i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract_byregion_1030.tex, replace `tableopts' stats(N) drop(*county* ) mtitles("US" "NE" "MW" "SE" "Deep south" "West")

/*
	* heterogeneity 
	eststo clear 
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner , vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions.tex, replace `tableopts' stats(N)  drop(*county* ) 
*/

	* heterogeneity by region
	eststo clear 
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract30white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls  $countyControls2 sex_10 homeowner, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract30white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls  $countyControls2 sex_10 homeowner if region2num == 1, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls  $countyControls2 sex_10 homeowner if region2num == 2 , vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls  $countyControls2 sex_10 homeowner if region2num == 3, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls  $countyControls2 sex_10 homeowner if region2num == 4, vce(cluster county)
	eststo: qui reg `var' tract30farm10 whitefarm10tract homeownertractfarm10 age010tractfarm10 age1030tractfarm10 whitefarm10 homeownerfarm10 age010farm10 age1030farm10 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls  $countyControls2 sex_10 homeowner if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions_byregion_1030.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("US" "NE" "MW" "SE" "Deep south" "West")



}

* IV first stage
reg tract30farm10 crops10farm10 pct_treated_crops_1910
predict yhat

gen cov = .
foreach var of varlist  moved_30 movedFar_30 occfarmer_30 occoper_30 occcrafts_30 occscore_improve30 occscore_change30 {

	* IV comparison regs
	label var cov "Tract*Farm"
	eststo clear 
	replace cov = tract30farm10
	eststo: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2, vce(cluster county)
	replace cov = yhat
	eststo: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 , vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab*, drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'_IV_1030.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("OLS" "IV")

}




*****************************************
*		1900-1910		*
*****************************************


* IMPORT LINKED POPULATION CENSUS DATA
use ./clean/output/linked0010clean_best.dta, clear

* merge to control variables dataset
gen state = stateicp_0
gen county = county_0
gen year = 1900
merge m:1 state county year using ./clean/output/countyFCwithControls.dta
keep if _m == 3
drop _m

* merge in tractors to 1910 locations
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_00loc


* merge in tractors to  1910 locations
drop state county year
gen state = stateicp_10
gen county = county_10
gen year = 1910
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m
rename tract* tract*_10loc
rename *00loc_10loc *00loc




* merge to mom and pop datasets
merge m:1 poploc_00 serialp_00 using ./clean/output/1900dads.dta
drop if _m == 2
drop _m
merge m:1 momloc_00 serialp_00 using ./clean/output/1900moms.dta
drop if _m == 2
drop _m



* farm resident variables
replace farm_00 = farm_00 - 1
gen tract30farm00 = farm_00*tractPerAcre30_00loc
gen crops10farm00 = farm_00*pct_treated_crops_1910

* race variables
drop white
gen white = race_00 < 200 
gen tract30white = white*tractPerAcre30_00loc
gen whitefarm00 = white*farm_00
gen whitefarm00tract = white*farm_00*tractPerAcre30_00loc
gen crops10white00 = white*pct_treated_crops_1910


* age related variables
gen agesq_00 = age_00^2
gen age010 = age_00 < 10
gen age1030 = age_00 >= 10 & age_00 < 30
gen age010tract = age010 * tractPerAcre30_00loc
gen age1030tract = age1030 * tractPerAcre30_00loc
gen age010farm00 = age010 * farm_00
gen age1030farm00 = age1030 * farm_00
gen age010tractfarm00 = age010 * tractPerAcre30_00loc * farm_00
gen age1030tractfarm00 = age1030 * tractPerAcre30_00loc * farm_00
gen crops10age010 = age010*pct_treated_crops_1910
gen crops10age1030 = age1030*pct_treated_crops_1910


* create home ownership variables
tab ownershp_00, gen(owner00cat_)
gen homeowner = ownershp_00 == 10
gen homeownertract = homeowner * tractPerAcre30_00loc
gen homeownerfarm00 = homeowner * farm_00
gen homeownertractfarm00 = homeowner * tractPerAcre30_00loc * farm_00
label var homeowner "Home Owner"
label var homeownertract "Home Owner * $\Delta$ tractors"
gen crops10home = homeowner*pct_treated_crops_1910

* occupation outcomes
gen occfarmer_00 = (occ1950_00 >=100 & occ1950_00 <= 123) | (occ1950_00 >=810 & occ1950_00 <= 840)
gen occfarmer_10 = (occ1950_10 >=100 & occ1950_10 <= 123) | (occ1950_10 >=810 & occ1950_10 <= 840)
gen occcrafts_00 = (occ1950_00 >=500 & occ1950_00 <= 595)
gen occcrafts_10 = (occ1950_10 >=500 & occ1950_10 <= 595)
gen occoper_00 = (occ1950_00 >=600 & occ1950_00 <= 690)
gen occoper_10 = (occ1950_10 >=600 & occ1950_10 <= 690)
foreach year of numlist 00 10  {
	replace occfarmer_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occcrafts_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
	replace occoper_`year' = . if occ1950_`year' ==. | occ1950_`year' >= 997
}


* occscore
replace occscore_10 = . if occscore_10 == 0
replace occscore_00 = . if occscore_00 == 0
gen occscore_improve10 = occscore_10 >= occscore_00 
replace occscore_imp = . if mi(occscore_10) | mi(occscore_00)
gen occscore_change10 = occscore_10 - occscore_00

gen occ_min_pop = occscore_10 - pop_occscore_00
gen occ_v_pop = occscore_10 > pop_occscore_00



* industry variables
gen ind_ag_10 = regexm(indstr_10,"FARM")
replace ind_ag_10 = . if mi(indstr_10)
gen ind_mill_10 = regexm(indstr_10,"MILL") 
replace ind_mill_10 = . if mi(ind_ag_10)
gen ind_manu_10 = regexm(indstr_10,"FACTORY") | regexm(indstr_10,"MFG") | regexm(indstr_10,"MANUFACTURING")
replace ind_manu_10 = . if mi(indstr_10)
gen ind_retail_10 = regexm(indstr_10,"STORE") | regexm(indstr_10,"SHOP") 
replace ind_retail_10 = . if mi(indstr_10)
gen ind_mine_10 = regexm(indstr_10,"MINE") | regexm(indstr_10,"COAL") | regexm(indstr_10," OIL ") 
replace ind_mine_10 = . if mi(indstr_10)
gen ind_ed_10 = regexm(indstr_10,"SCHOOL") 
replace ind_ed_10 = . if mi(indstr_10)
gen ind_railroad_10 = regexm(indstr_10,"RAIL") | regexm(indstr_10,"ROAD") | regexm(indstr_10,"R.R.")
replace ind_railroad_10 = . if mi(indstr_10)
gen ind_oddjobs_10 = regexm(indstr_10,"ODD JOBS") 
replace ind_oddjobs_10 = . if mi(indstr_10)
gen ind_bank_10 = regexm(indstr_10,"BANK") 
replace ind_bank_10 = . if mi(indstr_10)


* urbanization
gen urbanized = urban_10 == 2 & urban_00 == 1

save ./analyze/temp/regdata0010.dta, replace

***** Regressions *****

use ./analyze/temp/regdata0010.dta, clear

//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"


foreach var of varlist  moved_10 movedFar_10 occfarmer_10 occoper_10 occcrafts_10 occscore_improve10 occscore_change10 {


	* depvar on tract*farm
	eststo clear
	eststo: qui reg `var' farm_00  tract30farm00 , vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county, vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner, vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls, vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls  $countyControls2, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract_0010.tex, replace `tableopts' stats(N) drop(*county*)


	* depvar on tract*farm by region
	eststo clear
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 , vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 1, vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 2, vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 3, vce(cluster county)	
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 4, vce(cluster county)
	eststo: qui reg `var' farm_00  tract30farm00 i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsFarmTract_byregion_0010.tex, replace `tableopts' stats(N) drop(*county* ) mtitles("US" "NE" "MW" "SE" "Deep south" "West")

/*
	* heterogeneity 
	eststo clear 
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county  , vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white  sex_20 homeowner, vce(cluster county)
	eststo: qui reg `var' tract20farm20 whitefarm20tract homeownertractfarm20 age010tractfarm20 age1030tractfarm20 whitefarm20 homeownerfarm20 age010farm20 age1030farm20 tract20white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls sex_20 homeowner , vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions.tex, replace `tableopts' stats(N)  drop(*county* ) 
*/

	* heterogeneity by region
	eststo clear 
	eststo: qui reg `var' tract30farm00 whitefarm00tract homeownertractfarm00 age010tractfarm00 age1030tractfarm00 whitefarm00 homeownerfarm00 age010farm00 age1030farm00 tract30white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls $countyControls2 sex_00 homeowner, vce(cluster county)
	eststo: qui reg `var' tract30farm00 whitefarm00tract homeownertractfarm00 age010tractfarm00 age1030tractfarm00 whitefarm00 homeownerfarm00 age010farm00 age1030farm00 tract30white homeownertract age010tract age1030tract age010 age1030  i.county white $countyControls $countyControls2 sex_00 homeowner if region2num == 1, vce(cluster county)
	eststo: qui reg `var' tract30farm00 whitefarm00tract homeownertractfarm00 age010tractfarm00 age1030tractfarm00 whitefarm00 homeownerfarm00 age010farm00 age1030farm00 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_00 homeowner if region2num == 2 , vce(cluster county)
	eststo: qui reg `var' tract30farm00 whitefarm00tract homeownertractfarm00 age010tractfarm00 age1030tractfarm00 whitefarm00 homeownerfarm00 age010farm00 age1030farm00 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_00 homeowner if region2num == 3, vce(cluster county)
	eststo: qui reg `var' tract30farm00 whitefarm00tract homeownertractfarm00 age010tractfarm00 age1030tractfarm00 whitefarm00 homeownerfarm00 age010farm00 age1030farm00 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_00 homeowner if region2num == 4, vce(cluster county)
	eststo: qui reg `var' tract30farm00 whitefarm00tract homeownertractfarm00 age010tractfarm00 age1030tractfarm00 whitefarm00 homeownerfarm00 age010farm00 age1030farm00 tract30white homeownertract age010tract age1030tract age010 age1030 i.county white $countyControls $countyControls2 sex_00 homeowner if region2num == 5, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab * , drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'VsAllInteractions_byregion_0010.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("US" "NE" "MW" "SE" "Deep south" "West")



}

* IV first stage
reg tract30farm00 crops10farm00 pct_treated_crops_1910
predict yhat

gen cov = .
foreach var of varlist  moved_10 movedFar_10 occfarmer_10 occoper_10 occcrafts_10 occscore_improve10 occscore_change10 {

	* IV comparison regs
	label var cov "Tract*Farm"
	eststo clear 
	replace cov = tract30farm00
	eststo: qui reg `var' farm_00  cov i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2 , vce(cluster county)
	replace cov = yhat
	eststo: qui reg `var' farm_00  cov i.county white age_00 agesq_00 sex_00 homeowner $countyControls  $countyControls2, vce(cluster county)
	local tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
	esttab*, drop(*county*) `tableopts'
	esttab * using ./analyze/output/`var'_IV_0010.tex, replace `tableopts' stats(N)  drop(*county*) mtitles("OLS" "IV")

}



