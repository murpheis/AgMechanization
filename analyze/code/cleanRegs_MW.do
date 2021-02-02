set more off, perm

cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"


//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"
global countyControls =  "bankstot20 dist_closest_city farmsize10  "
global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg ind_manu_pct_chg10 valPerAcre_chg10"



eststo clear

************************
**** 1910-1920 REGS ****
************************

/*
use ./analyze/temp/regdata1020.dta, clear

label var farm_10 "Farm"

* IV first stage
reg tract30farm10 crops10farm10 pct_treated_crops_1910 
predict yhat

gen cov = .

foreach var of varlist  moved_20 movedFar_20 {


	* Tables 1-2: moved  for each time period 00-10, 10-20, 10-30
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo reg`var'_1020_US: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 , vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var'_1020_IV: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"

	
}

estimates save ./analyze/output/linkedregests_1020, replace


*/
************************
**** 1910-1930 REGS ****
************************

use ./analyze/temp/regdata1030.dta, clear

* keep only MW
keep if region2num == 2


label var farm_10 "Farm"

* IV first stage
reg tract30farm10 crops10farm10 pct_treated_crops_1910 
predict yhat

rename occfarmer_30 occfarm_30

gen cov = .
foreach var of varlist   moved_30 movedFar_30  urbanized occ_min_pop occ_v_pop   occfarm_30 occoper_30  {



	* Main specification
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_US: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	
	* Main specification, IV
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"


	*  by age group
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_US_010: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 <= 10, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo reg`var'_1030_US_1030: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 10 & age_10 <=30, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo reg`var'_1030_US_30up: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 30 , vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV_010: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 <= 10, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo reg`var'_1030_IV_1030: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 10 & age_10 <=30, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo reg`var'_1030_IV_30up: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 30 , vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"



	*  by race
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_US_wh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo reg`var'_1030_US_nwh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"

	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV_wh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo reg`var'_1030_IV_nwh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	
	*  by homeowner
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_US_ho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2  if homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo reg`var'_1030_US_nho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"

	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV_ho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo reg`var'_1030_IV_nho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	
	
	**** MEN ONLY
	preserve
	keep if sex_10 == 1
	
	* Main specification
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_US: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	
	* Main specification, IV
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_IV: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"


	*  by age group
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo men_`var'_US_010: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 <= 10, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo men_`var'_US_1030: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 10 & age_10 <=30, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo men_`var'_US_30up: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 30 , vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_IV_010: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 <= 10, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo men_`var'_IV_1030: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 10 & age_10 <=30, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo men_`var'_IV_30up: qui reg `var' farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if age_10 > 30 , vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"



	*  by race
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_US_wh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo men_`var'_1030_US_nwh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"

	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_IV_wh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo men_`var'_1030_IV_nwh: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~white, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	
	*  by homeowner
	replace cov = tract30farm10
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_US_ho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2  if homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	eststo men_`var'_1030_US_nho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"

	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_IV_ho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	eststo men_`var'_1030_IV_nho: qui reg `var' farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"
	
	restore
	
}





* industry results
* IV first stage
reg tractPerAcre30_30loc  pct_treated_crops_1910 
predict yhat2
local industries "ind_ag_30 ind_mill_30-ind_bank_30"
foreach var of varlist `industries' {

	label var cov "Tractors"
	
	* all sexes
	replace cov = tractPerAcre30_30loc
	eststo ols_`var'_all: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 , vce(cluster county)
	*eststo ols_`var'_farm: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if farm_10, vce(cluster county)
	*eststo ols_`var'_nf: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo ols_`var'_ag: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ind_ag_10, vce(cluster county)
	replace cov = yhat2
	eststo iv_`var'_all: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 , vce(cluster county)
	*eststo iv_`var'_farm: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if farm_10, vce(cluster county)
	*eststo iv_`var'_nf: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo iv_`var'_ag: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ind_ag_10==1, vce(cluster county)
	
	*men only
	preserve
	keep if sex_10 == 1
	replace cov = tractPerAcre30_30loc
	eststo ols_`var'_all_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 , vce(cluster county)
	*eststo ols_`var'_farm_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if farm_10, vce(cluster county)
	*eststo ols_`var'_nf_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo ols_`var'_ag_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ind_ag_10, vce(cluster county)
	replace cov = yhat2
	eststo iv_`var'_all_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 , vce(cluster county)
	*eststo iv_`var'_farm_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if farm_10, vce(cluster county)
	*eststo iv_`var'_nf_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo iv_`var'_ag_xy: qui reg `var' cov i.county  age_10 agesq_10 sex_10 white homeowner $countyControls $countyControls2 if ind_ag_10==1, vce(cluster county)
	restore

}



/*

* joined farm, migrated in
reg tractPerAcre30_30loc pct_treated_crops_1910_30loc
predict yhat3

replace cov = tractPerAcre30_30loc
label var cov "Tractors"
eststo joinedfarm1930_ols: qui reg joinedfarm_30  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
eststo movedin1930_ols: qui reg moved_30  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
eststo movedinfromfar1930_ols: qui reg movedFar_30  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
replace cov = yhat3
label var cov "Tractors"
eststo joinedfarm1930_iv: qui reg joinedfarm_30  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
eststo movedin1930_iv: qui reg moved_30  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
eststo movedinfromfar1930_iv: qui reg movedFar_30  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if ~farm_10, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"

*/

* heterogeneity for industry
eststo estINDag: qui reg ind_ag_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDmanu: qui reg ind_manu_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDag_race: qui reg ind_ag_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~white, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDmanu_race: qui reg ind_manu_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~white, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDag_home: qui reg ind_ag_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDmanu_home: qui reg ind_manu_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDag_young: qui reg ind_ag_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if age010, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"
eststo estINDmanu_young: qui reg ind_manu_30  tract30farm10   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if age010, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Y"

eststo estINDag_IV: qui reg ind_ag_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDmanu_IV: qui reg ind_manu_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDag_race_IV: qui reg ind_ag_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~white, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDmanu_race_IV: qui reg ind_manu_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~white, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDag_home_IV: qui reg ind_ag_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDmanu_home_IV: qui reg ind_manu_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if ~homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDag_young_IV: qui reg ind_ag_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if age010, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"
eststo estINDmanu_young_IV: qui reg ind_manu_30  yhat   farm_10 white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 i.county if age010, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Y"


* adding controls progressively



* Main specification indAg, IV
replace cov = yhat
label var cov "Tractors*Farm"
eststo regindAg_1030_IV_c3: qui reg ind_ag_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3)+Pre-trends"
eststo regindAg_1030_IV_c2: qui reg ind_ag_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2)+County"
eststo regindAg_1030_IV_c1: qui reg ind_ag_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(1)+Individual"
eststo regindAg_1030_IV_c0: qui reg ind_ag_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"


* Main specification indManu, IV
replace cov = yhat
label var cov "Tractors*Farm"
eststo regindMan_1030_IV_c3: qui reg ind_manu_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3)+Pre-trends"
eststo regindMan_1030_IV_c2: qui reg ind_manu_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2)+County"
eststo regindMan_1030_IV_c1: qui reg ind_manu_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(1)+Individual"
eststo regindMan_1030_IV_c0: qui reg ind_manu_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"



* Main specification indAg, OLS
replace cov = tract30farm10
label var cov "Tractors*Farm"
eststo regindAg_1030_OLS_c3: qui reg ind_ag_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3)+Pre-trends"
eststo regindAg_1030_OLS_c2: qui reg ind_ag_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2)+County"
eststo regindAg_1030_OLS_c1: qui reg ind_ag_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(1)+Individual"
eststo regindAg_1030_OLS_c0: qui reg ind_ag_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"


* Main specification indManu, OLS
replace cov = tract30farm10
label var cov "Tractors*Farm"
eststo regindMan_1030_OLS_c3: qui reg ind_manu_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3)+Pre-trends"
eststo regindMan_1030_OLS_c2: qui reg ind_manu_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2)+County"
eststo regindMan_1030_OLS_c1: qui reg ind_manu_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(1)+Individual"
eststo regindMan_1030_OLS_c0: qui reg ind_manu_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"




* Main specification
replace cov = tract30farm10
label var cov "Tractors*Farm"
eststo regmoved_30_1030_US_c2: qui reg movedFar_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
eststo regmoved_30_1030_US_c1: qui reg movedFar_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
eststo regmoved_30_1030_US_c0: qui reg movedFar_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"

	
* Main specification, IV
replace cov = yhat
label var cov "Tractors*Farm"
eststo regmoved_30_1030_IV_c3: qui reg movedFar_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3)+Pre-trends"
eststo regmoved_30_1030_IV_c2: qui reg movedFar_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2)+County"
eststo regmoved_30_1030_IV_c1: qui reg movedFar_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(1)+Individual"
eststo regmoved_30_1030_IV_c0: qui reg movedFar_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"


* Main specification occfarm, IV
replace cov = yhat
label var cov "Tractors*Farm"
eststo regoccfarm_1030_IV_c3: qui reg occfarm_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3)+Pre-trends"
eststo regoccfarm_1030_IV_c2: qui reg occfarm_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2)+County"
eststo regoccfarm_1030_IV_c1: qui reg occfarm_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(1)+Individual"
eststo regoccfarm_1030_IV_c0: qui reg occfarm_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"


* Main specification occoper, IV
replace cov = yhat
label var cov "Tractors*Farm"
eststo regoccoper_1030_IV_c3: qui reg occoper_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3)+Pre-trends"
eststo regoccoper_1030_IV_c2: qui reg occoper_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2)+County"
eststo regoccoper_1030_IV_c1: qui reg occoper_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(1)+Individual"
eststo regoccoper_1030_IV_c0: qui reg occoper_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"




* Main specification occfarm, OLS
replace cov = tract30farm10
label var cov "Tractors*Farm"
eststo regoccfarm_1030_OLS_c3: qui reg occfarm_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3)+Pre-trends"
eststo regoccfarm_1030_OLS_c2: qui reg occfarm_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2)+County"
eststo regoccfarm_1030_OLS_c1: qui reg occfarm_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(1)+Individual"
eststo regoccfarm_1030_OLS_c0: qui reg occfarm_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"


* Main specification occoper, OLS
replace cov = tract30farm10
label var cov "Tractors*Farm"
eststo regoccoper_1030_OLS_c3: qui reg occoper_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls  $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3)+Pre-trends"
eststo regoccoper_1030_OLS_c2: qui reg occoper_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2)+County"
eststo regoccoper_1030_OLS_c1: qui reg occoper_30 farm_10  cov i.county white age_10 agesq_10 sex_10 homeowner, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(1)+Individual"
eststo regoccoper_1030_OLS_c0: qui reg occoper_30 farm_10  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"




replace cov = yhat
eststo regoccfarm_IV_white: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner white $countyControls $countyControls2, vce(cluster county)
eststo regoccfarm_IV_white: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo regoccfarm_IV_notwhite: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if   ~white, vce(cluster county)
eststo regoccfarm_IV_home: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if  homeowner, vce(cluster county)
eststo regoccfarm_IV_nothome: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
eststo regoccfarm_IV_010: qui reg occfarm_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=10, vce(cluster county)
eststo regoccfarm_IV_1030: qui reg occfarm_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
eststo regoccfarm_IV_30up: qui reg occfarm_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
replace cov = tract30farm10
eststo regoccfarm_OLS_white: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner white $countyControls $countyControls2, vce(cluster county)
eststo regoccfarm_OLS_white: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo regoccfarm_OLS_notwhite: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if   ~white, vce(cluster county)
eststo regoccfarm_OLS_home: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if  homeowner, vce(cluster county)
eststo regoccfarm_OLS_nothome: qui reg occfarm_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
eststo regoccfarm_OLS_010: qui reg occfarm_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=10, vce(cluster county)
eststo regoccfarm_OLS_1030: qui reg occfarm_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
eststo regoccfarm_OLS_30up: qui reg occfarm_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)


replace cov = yhat
eststo regoccoper_IV_white: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner white $countyControls $countyControls2, vce(cluster county)
eststo regoccoper_IV_white: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo regoccoper_IV_notwhite: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if   ~white, vce(cluster county)
eststo regoccoper_IV_home: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if  homeowner, vce(cluster county)
eststo regoccoper_IV_nothome: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
eststo regoccoper_IV_010: qui reg occoper_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=10, vce(cluster county)
eststo regoccoper_IV_1030: qui reg occoper_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
eststo regoccoper_IV_30up: qui reg occoper_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
replace cov = tract30farm10
eststo regoccoper_OLS_white: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner white $countyControls $countyControls2, vce(cluster county)
eststo regoccoper_OLS_white: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo regoccoper_OLS_notwhite: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if   ~white, vce(cluster county)
eststo regoccoper_OLS_home: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if  homeowner, vce(cluster county)
eststo regoccoper_OLS_nothome: qui reg occoper_30 farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
eststo regoccoper_OLS_010: qui reg occoper_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=10, vce(cluster county)
eststo regoccoper_OLS_1030: qui reg occoper_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
eststo regoccoper_OLS_30up: qui reg occoper_30 farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)



replace cov = yhat
eststo regoccpop_IV: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner white $countyControls $countyControls2, vce(cluster county)
eststo regoccpop_IV_white: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo regoccpop_IV_notwhite: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if   ~white, vce(cluster county)
eststo regoccpop_IV_home: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if  homeowner, vce(cluster county)
eststo regoccpop_IV_nothome: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
eststo regoccpop_IV_010: qui reg occ_min_pop farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=10, vce(cluster county)
eststo regoccpop_IV_1030: qui reg occ_min_pop farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
eststo regoccpop_IV_30up: qui reg occ_min_pop farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
replace cov = tract30farm10
eststo regoccpop_OLS: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner white $countyControls $countyControls2, vce(cluster county)
eststo regoccpop_OLS_white: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo regoccpop_OLS_notwhite: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 homeowner $countyControls $countyControls2 if   ~white, vce(cluster county)
eststo regoccpop_OLS_home: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if  homeowner, vce(cluster county)
eststo regoccpop_OLS_nothome: qui reg occ_min_pop farm_10  cov i.county  age_10 agesq_10 sex_10 white $countyControls $countyControls2 if ~homeowner, vce(cluster county)
eststo regoccpop_OLS_010: qui reg occ_min_pop farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=10, vce(cluster county)
eststo regoccpop_OLS_1030: qui reg occ_min_pop farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)
eststo regoccpop_OLS_30up: qui reg occ_min_pop farm_10  cov i.county   sex_10 white homeowner $countyControls $countyControls2 if age_10 <=30 & age_10 >10, vce(cluster county)




estimates save ./analyze/output/linkedregests_1030, replace




************************
**** 1900-1910 REGS ****
************************

use ./analyze/temp/regdata0010.dta, clear

label var farm_00 "Farm"

* IV first stage
reg tract30farm00 crops10farm00 pct_treated_crops_1910 
predict yhat

rename occfarmer_10 occfarm_10

gen cov = .
foreach var of varlist  moved_10 movedFar_10 urbanized occ_v_pop occ_min_pop occfarm_10 occoper_10 {


	* Tables 1-2: moved  for each time period 00-10, 10-20, 10-30
	replace cov = tract30farm00
	label var cov "Tractors*Farm"
	eststo reg`var'_0010_US: qui reg `var' farm_00  cov i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "N"
	
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var'_0010_IV: qui reg `var' farm_00  cov i.county white age_00 agesq_00 sex_00 homeowner $countyControls $countyControls2, vce(cluster county)
	estadd local FEs "Y"
	estadd local Controls "Y"
	estadd local IV "Y"

}


estimates save ./analyze/output/linkedregests_0010, replace




************************
**** 1920-1940 REGS ****
************************

use ./analyze/temp/regdata2040.dta, clear


* keep only mw
keep if region2num ==2

label var farm_20 "Farm"

label var crops10farm20 "Grains * Farm"
label var crops10white20 "Grains * White"
label var crops10white20farm "Grains * White * Farm"
label var crops10home "Grains * Homeowner"
label var crops10homefarm "Grains * Homeowner * Farm"

replace incwage_40 = . if incwage_40 == 999998

* IV first stage
reg tract20farm20 crops10farm20 pct_treated_crops_1910 
predict yhat

gen cov = .


* basic education result
replace cov = tract20farm20
eststo regsomeHS_40_2040_US: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo regsomeHS_40_2040_IV: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regsomeHS_40_2040_RF: qui reg someHS_40 farm_20  crops10farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"


* education placebo
replace cov = tract20farm20
eststo regsomeHS_placebo_2040_US: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 >= 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo regsomeHS_placebo_2040_IV: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 >= 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"


* education disaggragated
replace cov = tract20farm20
label var cov "Tractors * Farm"
label var whitefarm20tract "Tractors * Farm * White"
label var homeownertractfarm20 "Tractors * Farm * Homeowner"
label var tract20white "Tractors * White"
label var homeownertract "Tractors * Homeowner" 
label var white "White"
label var homeowner "Homeowner"
eststo regsomeHS_40_2040_race: qui reg someHS_40 farm_20 cov whitefarm20tract tract20white i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regsomeHS_40_2040_home: qui reg someHS_40 farm_20 cov homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regsomeHS_40_2040_rh: qui reg someHS_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regsomeHS_40_2040_a: qui reg someHS_40 farm_20 cov age010tract age1030tract age010tractfarm20 age1030tractfarm20  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
* IV  crops10farm20 crops10white20 crops10white20farm crops10age010-crops10age1030farm crops10home crops10homefarm
replace cov = yhat
eststo regsomeHS_40_2040_IV_r: qui reg someHS_40 farm_20  crops10farm20 crops10white20 crops10white20farm i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regsomeHS_40_2040_IV_h: qui reg someHS_40 farm_20 crops10farm20 crops10home crops10homefarm i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regsomeHS_40_2040_IV_rh: qui reg someHS_40 farm_20 crops10farm20 crops10white20 crops10white20farm crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regsomeHS_40_2040_IV_a: qui reg someHS_40 farm_20 crops10farm20 crops10age010 crops10age1030 crops10age010farm crops10age1030farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"

/*
replace cov = yhat
eststo regsomeHS_IV_white: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & white, vce(cluster county)
eststo regsomeHS_IV_notwhite: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & ~white, vce(cluster county)
eststo regsomeHS_IV_home: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & homeowner, vce(cluster county)
eststo regsomeHS_IV_nothome: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & ~homeowner, vce(cluster county)
replace cov = tract20farm20
eststo regsomeHS_OLS_white: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & white, vce(cluster county)
eststo regsomeHS_OLS_notwhite: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & ~white, vce(cluster county)
eststo regsomeHS_OLS_home: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & homeowner, vce(cluster county)
eststo regsomeHS_OLS_nothome: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & ~homeowner, vce(cluster county)
*/



* basic unemployment result
label var cov "Tractors*Farm"
label var yhat "Tractors*Farm"
label var farm_20 "Farm"
replace cov = tract20farm20
eststo regunemployed_40_2040_US: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo regunemployed_40_2040_IV: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
replace cov = tract20farm20
eststo regunemployed_40_2040_RF: qui reg unemployed_40 farm_20  crops10farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"



* unemployment heterogeneity by race and home
replace cov = tract20farm20
eststo regunemployed_40_2040_rh: qui reg unemployed_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regunemployed_40_2040_r: qui reg unemployed_40 farm_20 cov whitefarm20tract tract20white  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regunemployed_40_2040_h: qui reg unemployed_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regunemployed_40_2040_a: qui reg unemployed_40 farm_20 cov age010tract age1030tract age010tractfarm20 age1030tractfarm20  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo regunemployed_40_2040_IV_rh: qui reg unemployed_40 farm_20 crops10farm20 crops10white20 crops10white20farm crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regunemployed_40_2040_IV_r: qui reg unemployed_40 farm_20 crops10farm20 crops10white20 crops10white20farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regunemployed_40_2040_IV_h: qui reg unemployed_40 farm_20 crops10farm20  crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regunemployed_40_2040_IV_a: qui reg unemployed_40 farm_20 crops10farm20 crops10age010 crops10age1030 crops10age010farm crops10age1030farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"


* basic nilf result
label var cov "Tractors*Farm"
label var yhat "Tractors*Farm"
label var farm_20 "Farm"
replace cov = tract20farm20
eststo regnilf_40_2040_US: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo regnilf_40_2040_IV: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
replace cov = tract20farm20
eststo regnilf_40_2040_RF: qui reg nilf_40 farm_20  crops10farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"



* nilf heterogeneity by race and home
replace cov = tract20farm20
eststo regnilf_40_2040_rh: qui reg nilf_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regnilf_40_2040_r: qui reg nilf_40 farm_20 cov whitefarm20tract tract20white  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regnilf_40_2040_h: qui reg nilf_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo regnilf_40_2040_a: qui reg nilf_40 farm_20 cov age010tract age1030tract age010tractfarm20 age1030tractfarm20  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo regnilf_40_2040_IV_rh: qui reg nilf_40 farm_20 crops10farm20 crops10white20 crops10white20farm crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regnilf_40_2040_IV_r: qui reg nilf_40 farm_20 crops10farm20 crops10white20 crops10white20farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regnilf_40_2040_IV_h: qui reg nilf_40 farm_20 crops10farm20  crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regnilf_40_2040_IV_a: qui reg nilf_40 farm_20 crops10farm20 crops10age010 crops10age1030 crops10age010farm crops10age1030farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"


* basic income result
label var cov "Tractors*Farm"
label var yhat "Tractors*Farm"
label var farm_20 "Farm"
replace cov = tract20farm20
eststo reginc_40_2040_US: qui reg incwage_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo reginc_40_2040_IV: qui reg incwage_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
replace cov = tract20farm20
eststo reginc_40_2040_RF: qui reg incwage_40 farm_20  crops10farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"


* income heterogeneity by race and home
replace cov = tract20farm20
eststo reginc_40_2040_rh: qui reg incwage_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo reginc_40_2040_r: qui reg incwage_40 farm_20 cov whitefarm20tract tract20white  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo reginc_40_2040_h: qui reg incwage_40 farm_20 cov whitefarm20tract tract20white homeownertract homeownertractfarm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
eststo reginc_40_2040_a: qui reg incwage_40 farm_20 cov age010tract age1030tract age010tractfarm20 age1030tractfarm20  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "N"
replace cov = yhat
eststo reginc_40_2040_IV_rh: qui reg incwage_40 farm_20 crops10farm20 crops10white20 crops10white20farm crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo reginc_40_2040_IV_r: qui reg incwage_40 farm_20 crops10farm20 crops10white20 crops10white20farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo reginc_40_2040_IV_h: qui reg incwage_40 farm_20 crops10farm20  crops10home crops10homefarm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo reginc_40_2040_IV_a: qui reg incwage_40 farm_20 crops10farm20 crops10age010 crops10age1030 crops10age010farm crops10age1030farm  i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"


* adding controls one by one
replace cov = tract20farm20
eststo regnilf_40_2040_US_c0: qui reg nilf_40 farm_20  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"
eststo regnilf_40_2040_US_c1: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Individual"
eststo regnilf_40_2040_US_c2: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2) + County"
eststo regnilf_40_2040_US_c3: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3) + Pre-Trend"
replace cov = yhat
eststo regnilf_40_2040_IV_c0: qui reg nilf_40 farm_20  cov i.county, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"
eststo regnilf_40_2040_IV_c1: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Individual"
eststo regnilf_40_2040_IV_c2: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2) + County"
eststo regnilf_40_2040_IV_c3: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3) + Pre-Trend"



* adding controls one by one
replace cov = tract20farm20
eststo regunemployed_40_2040_US_c0: qui reg unemployed_40 farm_20  cov i.county if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"
eststo regunemployed_40_2040_US_c1: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Individual"
eststo regunemployed_40_2040_US_c2: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2) + County"
eststo regunemployed_40_2040_US_c3: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3) + Pre-Trend"
replace cov = yhat
eststo regunemployed_40_2040_IV_c0: qui reg unemployed_40 farm_20  cov i.county if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"
eststo regunemployed_40_2040_IV_c1: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Individual"
eststo regunemployed_40_2040_IV_c2: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2) + County"
eststo regunemployed_40_2040_IV_c3: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3) + Pre-Trend"



* adding controls one by one, income
replace cov = tract20farm20
eststo regincwage_40_2040_US_c0: qui reg incwage_40  farm_20  cov i.county if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"
eststo regincwage_40_2040_US_c1: qui reg incwage_40  farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Individual"
eststo regincwage_40_2040_US_c2: qui reg incwage_40  farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2) + County"
eststo regincwage_40_2040_US_c3: qui reg incwage_40  farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3) + Pre-Trend"
replace cov = yhat
eststo regincwage_40_2040_IV_c0: qui reg incwage_40  farm_20  cov i.county if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"
eststo regincwage_40_2040_IV_c1: qui reg incwage_40  farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Individual"
eststo regincwage_40_2040_IV_c2: qui reg incwage_40  farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2) + County"
eststo regincwage_40_2040_IV_c3: qui reg incwage_40  farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3) + Pre-Trend"





* adding controls one by one for education
replace cov = tract20farm20
eststo regsomeHS_40_2040_US_c0: qui reg someHS_40 farm_20  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "None"
eststo regsomeHS_40_2040_US_c1: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "Individual"
eststo regsomeHS_40_2040_US_c2: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(2) + County"
eststo regsomeHS_40_2040_US_c3: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "N"
estadd local Controls "(3) + Pre-Trend"
replace cov = yhat
eststo regsomeHS_40_2040_IV_c0: qui reg someHS_40 farm_20  cov i.county , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "None"
eststo regsomeHS_40_2040_IV_c1: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "Individual"
eststo regsomeHS_40_2040_IV_c2: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(2) + County"
eststo regsomeHS_40_2040_IV_c3: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local IV "Y"
estadd local Controls "(3) + Pre-Trend"


/*replace cov = yhat
eststo regunemp_IV_white: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if !nilf_40 & white, vce(cluster county)
eststo regunemp_IV_notwhite: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if !nilf_40 & ~white, vce(cluster county)
eststo regunemp_IV_home: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if !nilf_40 & homeowner, vce(cluster county)
eststo regunemp_IV_nothome: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if !nilf_40 & ~homeowner, vce(cluster county)
replace cov = tract20farm20
eststo regunemp_OLS_white: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if !nilf_40 & white, vce(cluster county)
eststo regunemp_OLS_notwhite: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if !nilf_40 & ~white, vce(cluster county)
eststo regunemp_OLS_home: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if !nilf_40 & homeowner, vce(cluster county)
eststo regunemp_OLS_nothome: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if !nilf_40 & ~homeowner, vce(cluster county)



replace cov = yhat
eststo reginc_IV_white: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo reginc_IV_notwhite: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if  ~white, vce(cluster county)
eststo reginc_IV_home: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if   homeowner, vce(cluster county)
eststo reginc_IV_nothome: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if  ~homeowner, vce(cluster county)
replace cov = tract20farm20
eststo reginc_OLS_white: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if  white, vce(cluster county)
eststo reginc_OLS_notwhite: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if  ~white, vce(cluster county)
eststo reginc_OLS_home: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if homeowner, vce(cluster county)
eststo reginc_OLS_nothome: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if  ~homeowner, vce(cluster county)

*/





************************
****   MAKE TABLES  ****
************************

global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"
/*

	
**** PRETREND TABLES

* Table 1: moved far for each time period 00-10, 10-20, 10-30
esttab regmovedFar_10_0010_US regmovedFar_10_0010_IV  regmovedFar_30_1030_US regmovedFar_30_1030_IV  , ///
	st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2  white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910"  "1910-1930" "1910-1930") ///
	title("Dep Var: 1(Moved States)")
esttab regmovedFar_10_0010_US regmovedFar_10_0010_IV   regmovedFar_30_1030_US regmovedFar_30_1030_IV ///
	using ./analyze/output/movedstates1.tex, replace st(N IV FEs Controls) drop(*county* *cons* $countyControls2  $countyControls white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910"  "1910-1930" "1910-1930") ///
	title("Dep Var: 1(Moved States)")


* Table 2: moved  for each time period 00-10, 10-20, 10-30
esttab regmoved_10_0010_US regmoved_10_0010_IV  regmoved_30_1030_US regmoved_30_1030_IV ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2  white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910" "1910-1930" "1910-1930") ///
	title("Dependent Variable: 1(Moved Counties)")
esttab regmoved_10_0010_US regmoved_10_0010_IV  regmoved_30_1030_US regmoved_30_1030_IV ///
	using ./analyze/output/movedcounties1.tex, ///
	replace st(N IV FEs Controls) drop(*county* *cons* $countyControls  $countyControls2 white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910" "1910-1930" "1910-1930") ///
	title("Dependent Variable: 1(Moved Counties)")


* Education baseline table 
esttab regsomeHS_40_2040_US regsomeHS_40_2040_IV  regsomeHS_plac*,  ///
	st(N IV FEs Controls) drop(*cons*  *county* *homeowner* $countyControls $countyControls2 white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $>$ 18" "Some HS, Age $>$ 18") ///
	title("Dependent Variable: Attained at least some high school education as of 1940. Based on age in 1920.")
esttab regsomeHS_40_2040_US regsomeHS_40_2040_IV  regsomeHS_plac* ///
	using ./analyze/output/educ1.tex, ///
	replace  st(N IV FEs Controls) drop(*cons* *county* *homeowner* $countyControls $countyControls2 white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $>$ 18" "Some HS, Age $>$ 18") ///
	title("Dependent Variable: Attained at least some high school education as of 1940. Based on age in 1920.")





****** ADDING CONTROLS PROGRESSIVELY


* migration varying controls
esttab  regmoved_30_1030_IV_c0 regmoved_30_1030_IV_c1 regmoved_30_1030_IV_c2 regmoved_30_1030_IV_c3 ,    ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: Moved States between 1910 and 1930 (IV)") nomtitles 
esttab  regmoved_30_1030_IV_c0 regmoved_30_1030_IV_c1 regmoved_30_1030_IV_c2 regmoved_30_1030_IV_c3 	///
	using ./analyze/output/moved_30_controlsIV.tex,   replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: Moved States between 1910 and 1930 (IV)") nomtitles 
esttab  regmoved_30_1030_US_c0 regmoved_30_1030_US_c1 regmoved_30_1030_US_c2 regmoved_30_1030_US , ///
	st(N IV FEs Controls) drop(*county*  $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: Moved Counties between 1910 and 1930 (OLS)") nomtitles 
esttab  regmoved_30_1030_US_c0 regmoved_30_1030_US_c1 regmoved_30_1030_US_c2 regmoved_30_1030_US 	///
	using ./analyze/output/moved_30_controlsOLS.tex,   replace ///
	st(N IV FEs Controls) drop(*county*  $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: Moved Counties between 1910 and 1930 (OLS)") nomtitles 


* occupations 1930 varying controls
esttab  regoccfarm_1030_IV_c0 regoccfarm_1030_IV_c1 regoccfarm_1030_IV_c2 regoccfarm_1030_IV_c3 	///
	using ./analyze/output/occfarm30_controlsIV.tex,   replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: 1(occupation = farmer) (IV)") nomtitles 
esttab  regoccoper_1030_IV_c0 regoccoper_1030_IV_c1 regoccoper_1030_IV_c2 regoccoper_1030_IV_c3 	///
	using ./analyze/output/occoper_30_controlsIV.tex,  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: 1(occupation = operations) (IV)") nomtitles 
esttab  regoccfarm_1030_OLS_c0 regoccfarm_1030_OLS_c1 regoccfarm_1030_OLS_c2 regoccfarm_1030_OLS_c3 	///
	using ./analyze/output/occfarm30_controlsOLS.tex,   replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: 1(occupation = farmer) (OLS)") nomtitles 
esttab  regoccoper_1030_OLS_c0 regoccoper_1030_OLS_c1 regoccoper_1030_OLS_c2 regoccoper_1030_OLS_c3 	///
	using ./analyze/output/occoper_30_controlsOLS.tex,  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: 1(occupation = operations) (OLS)") nomtitles 


* industries 1930 varying controls
esttab  regindAg_1030_IV_c0 regindAg_1030_IV_c1 regindAg_1030_IV_c2 regindAg_1030_IV_c3 	///
	using ./analyze/output/indAg30_controlsIV.tex,   replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: 1(industry = agriculture) (IV)") nomtitles 
esttab  regindMan_1030_IV_c0 regindMan_1030_IV_c1 regindMan_1030_IV_c2 regindMan_1030_IV_c3 	///
	using ./analyze/output/indMan30_controlsIV.tex,  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: 1(industry = manufacturing) (IV)") nomtitles 
esttab  regindAg_1030_OLS_c0 regindAg_1030_OLS_c1 regindAg_1030_OLS_c2 regindAg_1030_OLS_c3 	///
	using ./analyze/output/indAg30_controlsOLS.tex,   replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: 1(industry = agriculture) (OLS)") nomtitles 
esttab  regindMan_1030_OLS_c0 regindMan_1030_OLS_c1 regindMan_1030_OLS_c2 regindMan_1030_OLS_c3 	///
	using ./analyze/output/indMan30_controlsOLS.tex,  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 title("Dependent Variable: 1(industry = manufacturing) (OLS)") nomtitles 


* unemployment varying controls
eststo regmean: qui reg unemployed_40 if ~ nilf_40
esttab  regmean regunemployed_40_2040_US_c0 regunemployed_40_2040_US_c1 regunemployed_40_2040_US_c2 regunemployed_40_2040_US_c3 	///
	using ./analyze/output/unemp_controls_test.tex, fragment  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 nomtitles 
esttab  regmean regunemployed_40_2040_US_c0 regunemployed_40_2040_US_c1 regunemployed_40_2040_US_c2 regunemployed_40_2040_US_c3 	///
	using ./analyze/output/unemp_controls.tex,   replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: 1(Unemployed in 1940)") ///
	 nomtitles 
esttab  regmean regunemployed_40_2040_IV_c0 regunemployed_40_2040_IV_c1 regunemployed_40_2040_IV_c2 regunemployed_40_2040_IV_c3 	///
	using ./analyze/output/unempIV_controls.tex,   replace ///
	  st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	  title("Dependent Variable: 1(Unemployed in 1940)") ///
	 nomtitles
	 
* nilf varying controls
eststo regmean: qui reg nilf 
esttab  regmean regnilf_40_2040_US_c0 regnilf_40_2040_US_c1 regnilf_40_2040_US_c2 regnilf_40_2040_US_c3 , ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 nomtitles 
esttab  regmean regnilf_40_2040_US_c0 regnilf_40_2040_US_c1 regnilf_40_2040_US_c2 regnilf_40_2040_US_c3	///
	using ./analyze/output/nilf_controls.tex,   replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: 1(NILF in 1940)") ///
	 nomtitles 
esttab  regmean regnilf_40_2040_IV_c0 regnilf_40_2040_IV_c1 regnilf_40_2040_IV_c2 regnilf_40_2040_IV_c3 	///
	using ./analyze/output/nilfIV_controls.tex,   replace ///
	  st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	  title("Dependent Variable: 1(NILF in 1940)") ///
	 nomtitles
esttab  regmean regnilf_40_2040_US_c0 regnilf_40_2040_US_c1 regnilf_40_2040_US_c2 regnilf_40_2040_US_c3	///
	using ./analyze/output/nilf_controls_test.tex, fragment  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 nomtitles 	 
esttab  regmean regnilf_40_2040_IV_c0 regnilf_40_2040_IV_c1 regnilf_40_2040_IV_c2 regnilf_40_2040_IV_c3 	///
	using ./analyze/output/nilfIV_controls_test.tex, fragment  replace ///
	st(N IV FEs Controls) drop(*county*   $countyControls  $countyControls2 homeowner white age_* agesq_* sex_*  ) $tableopts  ///
	 nomtitles 



* education varying controls
eststo regmean: qui reg someHS_40 if age_20 <= 18
esttab  regmean regsomeHS_40_2040_US_c0 regsomeHS_40_2040_US_c1 regsomeHS_40_2040_US_c2 regsomeHS_40_2040_US_c3 	///
	,   ///
	st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: 1(attained some high school)") ///
	 nomtitles 
esttab  regmean regsomeHS_40_2040_US_c0 regsomeHS_40_2040_US_c1 regsomeHS_40_2040_US_c2 regsomeHS_40_2040_US_c3 	///
	using ./analyze/output/someHS_controls_OLS.tex,   replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: 1(attained some high school)") ///
	 nomtitles 
esttab  regmean regsomeHS_40_2040_IV_c0 regsomeHS_40_2040_IV_c1 regsomeHS_40_2040_IV_c2 regsomeHS_40_2040_IV_c3 	///
	using ./analyze/output/someHS_IV_controls.tex,   replace ///
	  st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	  title("Dependent Variable: 1(attained some high school)") ///
	 nomtitles

* income varying controls
label var cov "Tractors*Farm"
eststo regmean: qui reg incwage_40 
esttab  regmean regincwage_40_2040_US_c0 regincwage_40_2040_US_c1 regincwage_40_2040_US_c2 regincwage_40_2040_US_c3 	///
	using ./analyze/output/incwage_controls.tex,   replace ///
	st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: Income (USD)") ///
	 nomtitles 
esttab  regmean regincwage_40_2040_IV_c0 regincwage_40_2040_IV_c1 regincwage_40_2040_IV_c2 regincwage_40_2040_IV_c3 	///
	using ./analyze/output/incwage_controlsIV.tex,   replace ///
	  st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	  title("Dependent Variable: Income (USD)") ///
	 nomtitles

* income varying controls 
eststo regmean: qui reg incwage_40 
esttab  regmean regincwage_40_2040_US_c0 regincwage_40_2040_US_c1 regincwage_40_2040_US_c2 regincwage_40_2040_US_c3 	///
	using ./analyze/output/incwage_controls_frag.tex,  fragment replace ///
	st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	 title("Dependent Variable: Income (USD)") ///
	 nomtitles 
esttab  regmean regincwage_40_2040_IV_c0 regincwage_40_2040_IV_c1 regincwage_40_2040_IV_c2 regincwage_40_2040_IV_c3 	///
	using ./analyze/output/incwage_controlsIV_frag.tex,  fragment replace ///
	  st(N IV FEs Controls) drop(*county* $countyControls  $countyControls2 homeowner white age_* agesq_* sex_* ) $tableopts  ///
	  title("Dependent Variable: Income (USD)") ///
	 nomtitles



** HETEROGENEITY


* education heterogeneity
esttab regsomeHS_40_2040_US  regsomeHS_40_2040_race regsomeHS_40_2040_home regsomeHS_40_2040_rh ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  mtitles("Some HS, Age<18" "Some HS, Age<18" "Some HS, Age<18" "Some HS, Age<18" "Some HS, Age<18" ) ///
	title("Dependent Variable: Attained at least some high school education as of 1940. Based on age in 1920. Heterogeneity analysis by race and homeownership.")
esttab regsomeHS_40_2040_US  regsomeHS_40_2040_race regsomeHS_40_2040_home regsomeHS_40_2040_rh  using ./analyze/output/ed_hetero.tex, replace   ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18") ///
	title("OLS, 1(Attained at least some high school education). Heterogeneity analysis by race and homeownership.")
esttab regsomeHS_40_2040_RF  regsomeHS_40_2040_IV_r regsomeHS_40_2040_IV_h regsomeHS_40_2040_IV_rh ,   ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18") ///
	title("Dependent Variable: Attained at least some high school education as of 1940. Based on age in 1920. Heterogeneity analysis by race and homeownership.")
esttab regsomeHS_40_2040_RF  regsomeHS_40_2040_IV_r regsomeHS_40_2040_IV_h regsomeHS_40_2040_IV_rh using ./analyze/output/ed_heteroIV.tex, replace   ///
	st(N FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18") ///
	title("Reduced Form, 1(Attained at least some high school education). Heterogeneity analysis by race and homeownership.")
	
esttab regsomeHS_40_2040_US  regsomeHS_40_2040_race regsomeHS_40_2040_home regsomeHS_40_2040_rh using ./analyze/output/ed_hetero_frag.tex, replace  fragment ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18") ///
	title("Dependent Variable: Attained at least some high school education as of 1940. Based on age in 1920. Heterogeneity analysis by race and homeownership.")
esttab regsomeHS_40_2040_IV  regsomeHS_40_2040_IV_r regsomeHS_40_2040_IV_h regsomeHS_40_2040_IV_rh using ./analyze/output/ed_heteroIV_frag.tex, replace fragment  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  mtitles("Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18" "Some HS, Age $<$ 18") ///
	title("Dependent Variable: Attained at least some high school education as of 1940. Based on age in 1920. Heterogeneity analysis by race and homeownership.")


*unemp heterogeneity
esttab regunemployed_40_2040_RF  regunemployed_40_2040_IV_r regunemployed_40_2040_IV_h regunemployed_40_2040_IV_rh  regunemployed_40_2040_IV_a , ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  nomtitles ///
	title("Dependent Variable: Unemployed in 1940. Heterogeneity analysis by race and homeownership.")
esttab regunemployed_40_2040_RF  regunemployed_40_2040_IV_r regunemployed_40_2040_IV_h regunemployed_40_2040_IV_rh regunemployed_40_2040_IV_a   ///
	using ./analyze/output/unemp_het_IV.tex, replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  nomtitles ///
	title("Dependent Variable: Unemployed in 1940. Heterogeneity analysis by race and homeownership.")

*nilf heterogeneity
esttab regnilf_40_2040_RF  regnilf_40_2040_IV_r regnilf_40_2040_IV_h regnilf_40_2040_IV_rh  regnilf_40_2040_IV_a ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  ///
	title("Dependent Variable: Not in Labor Force in 1940. Heterogeneity analysis by race and homeownership.")
esttab regnilf_40_2040_RF  regnilf_40_2040_IV_r regnilf_40_2040_IV_h regnilf_40_2040_IV_rh  regnilf_40_2040_IV_a  ///
	using ./analyze/output/nilf_het_IV.tex, replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts  ///
	title("Dependent Variable: Not in Labor Force in 1940. Heterogeneity analysis by race and homeownership.")

*incwage heterogeneity
esttab reginc_40_2040_RF  reginc_40_2040_IV_r reginc_40_2040_IV_h reginc_40_2040_IV_rh  reginc_40_2040_IV_a ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts nomtitles  ///
	title("Dependent Variable: Income in 1940. Heterogeneity analysis by race and homeownership.")

esttab reginc_40_2040_RF  reginc_40_2040_IV_r reginc_40_2040_IV_h reginc_40_2040_IV_rh  reginc_40_2040_IV_a ///
	using ./analyze/output/income_het_IV.tex, replace  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts nomtitles  ///
	title("Dependent Variable: Income in 1940. Heterogeneity analysis by race and homeownership.")



* industry het
label var yhat "Tractor*Farm"
label var cov "Tractor*Farm"
esttab estINDag_*IV using ./analyze/output/indag_het_IV.tex, ///
	  replace  ///
	st(N ) drop(*county* $countyControls $countyControls2 homeowner white age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts mtitles("IV:All" "IV:Non-White" "IV:Non-Homeowner" "IV:Young") ///
	title("Dependent Variable: Employed in Agriculture, 1930")
esttab estINDmanu_*IV using ./analyze/output/indmanu_het_IV.tex, ///
	  replace  ///
	st(N ) drop(*county* $countyControls $countyControls2 homeowner white  age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts mtitles("IV:All" "IV:Non-White" "IV:Non-Homeowner" "IV:Young") ///
	title("Dependent Variable: Employed in Manufacturing, 1930")


esttab estINDmanu estINDmanu_race estINDmanu_home estINDmanu_young using ./analyze/output/indmanu_het.tex, ///
	  replace  ///
	st(N ) drop(*county* $countyControls $countyControls2 homeowner white age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts mtitles("OLS:All" "OLS:Non-White" "OLS:Non-Homeowner" "OLS:Young") ///
	title("Dependent Variable: Employed in Manufacturing, 1930")
esttab estINDag estINDag_race estINDag_home estINDag_young using ./analyze/output/indag_het.tex, ///
	  replace  ///
	st(N ) drop(*county* $countyControls $countyControls2 homeowner white age_* agesq_* sex_*  farm* *cons*) ///
	$tableopts mtitles("OLS:All" "OLS:Non-White" "OLS:Non-Homeowner" "OLS:Young") ///
	title("Dependent Variable: Employed in Agriculture, 1930")


* migration by age 
/*
esttab regmoved_30_1030_US_010 regmoved_30_1030_IV_010  regmoved_30_1030_US_1030 regmoved_30_1030_IV_1030 regmoved_30_1030_US_30up regmoved_30_1030_IV_30up ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls *white* *homeowner* age_* agesq_* sex_*  *_cons ) ///
	$tableopts  mtitles("Ages 0-10" "Ages 10-30" "Ages 30+"  ) 
esttab regmovedFar_30_1030_US_010 regmovedFar_30_1030_IV_010 regmoved_30_1030_US_1030 regmoved_30_1030_IV_1030 regmoved_30_1030_US_30up regmoved_30_1030_IV_30up ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls *white* *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("Ages 0-10" "Ages 10-30" "Ages 30+"  ) 	
*/		




* migration by race
esttab regmoved_30_1030_US_wh regmoved_30_1030_US_nwh regmoved_30_1030_IV_wh regmoved_30_1030_IV_nwh  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("white" "not white" "white" "not white" ) 
esttab regmovedFar_30_1030_US_wh regmovedFar_30_1030_US_nwh regmovedFar_30_1030_IV_wh regmovedFar_30_1030_IV_nwh  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("white" "not white" "white" "not white" ) 


* migration by homeownership
esttab regmoved_30_1030_US_ho regmoved_30_1030_US_nho regmoved_30_1030_IV_ho regmoved_30_1030_IV_nho  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("homeowner" "not homeowner" "homeowner" "not homeowner" ) 
esttab regmovedFar_30_1030_US_ho regmovedFar_30_1030_US_nho regmovedFar_30_1030_IV_ho regmovedFar_30_1030_IV_nho  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("homeowner" "not homeowner" "homeowner" "not homeowner" ) 



* occ score compared to father by age
esttab regocc_v_pop_1030_US_010 regocc_v_pop_1030_US_1030 regocc_v_pop_1030_US_30up regocc_v_pop_1030_IV_010 regocc_v_pop_1030_IV_1030 regocc_v_pop_1030_IV_30up,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("Ages 0-10" "Ages 10-30" "Ages 30+"  "Ages 0-10" "Ages 10-30" "Ages 30+"  ) 	
esttab regocc_min_pop_1030_US_010 regocc_min_pop_1030_US_1030 regocc_min_pop_1030_US_30up regocc_min_pop_1030_IV_010 regocc_min_pop_1030_IV_1030 regocc_min_pop_1030_IV_30up ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  *white* *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("Ages 0-10" "Ages 10-30" "Ages 30+"  "Ages 0-10" "Ages 10-30" "Ages 30+"  ) 		
esttab regocc_v_pop_1030_US_010 regocc_v_pop_1030_US_1030 regocc_v_pop_1030_US_30up regocc_v_pop_1030_IV_010 regocc_v_pop_1030_IV_1030 regocc_v_pop_1030_IV_30up using ./analyze/output/occscoreV_age.tex, replace  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("Ages 0-10" "Ages 10-30" "Ages 30+"  "Ages 0-10" "Ages 10-30" "Ages 30+"  ) ///
		title("Dep Var: 1(Occ Score \geq Father's Occ Score)" )
esttab regocc_min_pop_1030_US_010 regocc_min_pop_1030_US_1030 regocc_min_pop_1030_US_30up regocc_min_pop_1030_IV_010 regocc_min_pop_1030_IV_1030 regocc_min_pop_1030_IV_30up using ./analyze/output/occscoreMIN_age.tex, replace  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  *white* *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("Ages 0-10" "Ages 10-30" "Ages 30+"  "Ages 0-10" "Ages 10-30" "Ages 30+"  ) ///
		title("Dep Var: (Occ Score - Father's Occ Score)" )		


* urbanized by race
esttab regurbanized_1030_US_wh regurbanized_1030_US_nwh regurbanized_1030_IV_wh regurbanized_1030_IV_nwh  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("white" "not white" "white" "not white" ) 


* occ mobility by homeownership
esttab regocc_v_pop_1030_US_ho regocc_v_pop_1030_US_nho regocc_v_pop_1030_IV_ho regocc_v_pop_1030_IV_nho  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("homeowner" "not homeowner" "homeowner" "not homeowner" ) 

esttab regocc_min_pop_1030_US_ho regocc_min_pop_1030_US_nho regocc_min_pop_1030_IV_ho regocc_min_pop_1030_IV_nho  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("OLS: homeowner" "OLS: not homeowner" "IV: homeowner" "IV: not homeowner" ) fragment
esttab regocc_min_pop_1030_US_ho regocc_min_pop_1030_US_nho regocc_min_pop_1030_IV_ho regocc_min_pop_1030_IV_nho    ///
	using ./analyze/output/occpop_home.tex , replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("OLS: homeowner" "OLS: not homeowner" "IV: homeowner" "IV: not homeowner" ) ///
	title("Occ-Score Relative to Father's Occ-Score")
esttab regocc_min_pop_1030_US_wh regocc_min_pop_1030_US_nwh regocc_min_pop_1030_IV_wh regocc_min_pop_1030_IV_nwh  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("OLS: white" "OLS: not non-white" "IV: white" "IV: non-white" ) 
esttab regocc_min_pop_1030_US_wh regocc_min_pop_1030_US_nwh regocc_min_pop_1030_IV_wh regocc_min_pop_1030_IV_nwh    ///
	using ./analyze/output/occpop_race.tex , replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *homeowner* age_* agesq_* sex_* *farm* *_cons ) ///
	$tableopts  mtitles("OLS: white" "OLS: not non-white" "IV: white" "IV: non-white" ) title("Occ-Score Relative to Father's Occ-Score")


* occ  by race
esttab  regoccfarm_30_1030_US_wh   regoccfarm_30_1030_US_nwh   regoccoper_30_1030_US_wh   regoccoper_30_1030_US_nwh    ///
	using ./analyze/output/occraceOLS.tex, replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* *homeowner* sex_* *cons* farm*) ///
	$tableopts  mtitles("farm, white" "farm, non-white" "operations, white" "operations, nonwhite") ///
	title("Dep Var: Occupation, 1930")

* occ  by race. IV
esttab  regoccfarm_30_1030_IV_wh   regoccfarm_30_1030_IV_nwh   regoccoper_30_1030_IV_wh   regoccoper_30_1030_IV_nwh    , ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* *homeowner* farm* *cons) ///
	$tableopts  mtitles("farm, white" "farm, non-white" "operations, white" "operations, nonwhite") ///
	title("Dep Var: Occupation, 1930")
esttab  regoccfarm_30_1030_IV_wh   regoccfarm_30_1030_IV_nwh   regoccoper_30_1030_IV_wh   regoccoper_30_1030_IV_nwh    ///
	using ./analyze/output/occraceIV.tex, replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *homeowner* age_* agesq_* sex_* *cons farm*) ///
	$tableopts  mtitles("farm, white" "farm, non-white" "operations, white" "operations, nonwhite") ///
	title("Dep Var: Occupation, 1930")
	
	

* occ farm by home ownership
esttab  regoccfarm_30_1030_US_ho   regoccfarm_30_1030_US_nho   regoccoper_30_1030_US_ho   regoccoper_30_1030_US_nho  ,  ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *cons* farm*) ///
	$tableopts  mtitles("farm, homeowner" "farm, non-homeowner" "operations, homeowner" "operations, non-homeowner")  ///
	title("Dep Var: Occupation, 1930")
esttab  regoccfarm_30_1030_US_ho   regoccfarm_30_1030_US_nho   regoccoper_30_1030_US_ho   regoccoper_30_1030_US_nho    ///
	using ./analyze/output/occhomeOLS.tex, replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *cons* farm*) ///
	$tableopts  mtitles("farm, homeowner" "farm, non-homeowner" "operations, homeowner" "operations, non-homeowner")  ///
	title("Dep Var: Occupation, 1930")
esttab  regoccfarm_30_1030_IV_ho   regoccfarm_30_1030_IV_nho   regoccoper_30_1030_IV_ho   regoccoper_30_1030_IV_nho    ///
	using ./analyze/output/occhomeIV.tex, replace ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2 *white* age_* agesq_* sex_* *cons* farm*) ///
	$tableopts  mtitles("farm, homeowner" "farm, non-homeowner" "operations, homeowner" "operations, non-homeowner") ///
	title("Dep Var: Occupation, 1930")



	
* occ oper baseline....not good
esttab  regoccoper_30_1030_US_wh  regoccoper_30_1030_IV_wh regoccoper_30_1030_US_nwh  regoccoper_30_1030_IV_nwh   , ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910" "1910-1930" "1910-1930") ///
	title("Dep Var: 1(occ = operations)")


* occ farm by race
esttab  regoccfarm_30_1030_US_ho  regoccfarm_30_1030_IV_ho regoccfarm_30_1030_US_nho  regoccfarm_30_1030_IV_nho   , ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_*  farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910" "1910-1930" "1910-1930") ///
	title("Dep Var: 1(occ = farmer)")


* occ oper baseline....not good
esttab  regoccoper_30_1030_US_wh  regoccoper_30_1030_IV_wh regoccoper_30_1030_US_nwh  regoccoper_30_1030_IV_nwh   , ///
	st(N IV FEs Controls) drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("1900-1910" "1900-1910" "1910-1930" "1910-1930") ///
	title("Dep Var: 1(occ = operations)")

*/


* industry 

esttab ols_ind_ag_30_ag ols_ind_manu_30_ag ols_ind_mill_30_ag ols_ind_retail_30_ag ols_ind_railroad_30_ag ///
	using ./analyze/output/ind_ols_ag_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_ag iv_ind_manu_30_ag iv_ind_mill_30_ag iv_ind_retail_30_ag iv_ind_railroad_30_ag ///
	using ./analyze/output/ind_iv_ag_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab ols_ind_ag_30_all ols_ind_manu_30_all ols_ind_mill_30_all ols_ind_retail_30_all ols_ind_railroad_30_all ///
	using ./analyze/output/ind_ols_all_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_all iv_ind_manu_30_all iv_ind_mill_30_all iv_ind_retail_30_all iv_ind_railroad_30_all ///
	using ./analyze/output/ind_iv_all_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")



esttab ols_ind_ag_30_ag_xy ols_ind_manu_30_ag_xy ols_ind_mill_30_ag_xy ols_ind_retail_30_ag_xy ols_ind_railroad_30_ag_xy ///
	using ./analyze/output/ind_ols_ag_xy_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_ag_xy iv_ind_manu_30_ag_xy iv_ind_mill_30_ag_xy iv_ind_retail_30_ag_xy iv_ind_railroad_30_ag_xy ///
	using ./analyze/output/ind_iv_ag_xy_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")


esttab ols_ind_ag_30_all_xy ols_ind_manu_30_all_xy ols_ind_mill_30_all_xy ols_ind_retail_30_all_xy ols_ind_railroad_30_all_xy ///
	using ./analyze/output/ind_ols_all_xy_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_all_xy iv_ind_manu_30_all_xy iv_ind_mill_30_all_xy iv_ind_retail_30_all_xy iv_ind_railroad_30_all_xy ///
	using ./analyze/output/ind_iv_all_xy_mw.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")





*************************
****   MAKE FIGURES  ****
*************************

label var cov ""
coefplot (regsomeHS_40_2040_IV, label(full sample))  (regsomeHS_IV_white, label(white)) ///
	(regsomeHS_IV_notwhite, label(not white)) ///
	(regsomeHS_IV_home, label(homeowner)) ///
	(regsomeHS_IV_nothome, label(not homeowner)), ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor Uptake on Educational Outcomes by Sub-Sample") ///
	xline(.209) msize(large)
	graph export ./analyze/output/coefplot_educheteroIV.png, as(png) replace

label var cov ""
coefplot (regsomeHS_40_2040_US, label(full sample))  (regsomeHS_OLS_white, label(white)) ///
	(regsomeHS_OLS_notwhite, label(not white)) ///
	(regsomeHS_OLS_home, label(homeowner)) ///
	(regsomeHS_OLS_nothome, label(not homeowner)), ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("OLS: Impact of Tractor Uptake on Educational Outcomes by Sub-Sample") ///
	xline(.176) msize(large)
	graph export ./analyze/output/coefplot_educheteroOLS.png, as(png) replace

label var cov ""
coefplot (regunemployed_40_2040_IV, label(full sample))  (regunemp_IV_white, label(white)) ///
	(regunemp_IV_notwhite, label(not white)) ///
	(regunemp_IV_home, label(homeowner)) ///
	(regunemp_IV_nothome, label(not homeowner)), ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor Uptake on Unemployment by Sub-Sample") ///
	xline(-.043) msize(large)
	graph export ./analyze/output/coefplot_unempheteroIV.png, as(png) replace
	
label var cov ""
coefplot (regunemployed_40_2040_US, label(full sample))  (regunemp_OLS_white, label(white)) ///
	(regunemp_OLS_notwhite, label(not white)) ///
	(regunemp_OLS_home, label(homeowner)) ///
	(regunemp_OLS_nothome, label(not homeowner)), ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor Uptake on Unemployment by Sub-Sample") ///
	xline(-.0245) msize(large)
	graph export ./analyze/output/coefplot_unempheteroOLS.png, as(png) replace

label var cov ""
coefplot (regincwage_40_2040_IV_c3, label(full sample))  (reginc_IV_white, label(white)) ///
	(reginc_IV_notwhite, label(not white)) ///
	(reginc_IV_home, label(homeowner)) ///
	(reginc_IV_nothome, label(not homeowner)), ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(4)) xline(-37) ///
	title("IV: Impact of Tractor Uptake on 1940 Income by Sub-Sample") msize(large)
	graph export ./analyze/output/coefplot_inchetIV.png, as(png) replace
	
label var cov ""
coefplot (regincwage_40_2040_US_c3, label(full sample))  (reginc_OLS_white, label(white)) ///
	(reginc_OLS_notwhite, label(not white)) ///
	(reginc_OLS_home, label(homeowner)) ///
	(reginc_OLS_nothome, label(not homeowner)), ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(4)) xline(98.7) ///
	title("OLS: Impact of Tractor Uptake on Income by Sub-Sample") msize(large)
	graph export ./analyze/output/coefplot_inchetOLS.png, as(png) replace




label var cov ""
coefplot (regoccfarm_1030_IV_c3, label(full sample))  ///
	(regoccfarm_IV_010, label(age < 10)) ///
	(regoccfarm_IV_1030, label(10 < age < 30)) ///
	(regoccfarm_IV_30up, label(30 < age)), xline(.137) ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor Uptake on 1930 Occupation=Farmer, by Age-Group") msize(large)
	graph export ./analyze/output/coefplot_occfarm_age_IV.png, as(png) replace


label var cov ""
coefplot (regoccoper_1030_IV_c3, label(full sample))  ///
	(regoccoper_IV_010, label(age < 10)) ///
	(regoccoper_IV_1030, label(10 < age < 30)) ///
	(regoccoper_IV_30up, label(30 < age)), xline(-0.031) ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(4)) ///
	title("IV: Impact of Tractor Uptake on 1930 Occupation=Operator, by Age-Group") msize(large)
	graph export ./analyze/output/coefplot_occoper_age_IV.png, as(png) replace


label var cov ""
coefplot (regoccfarm_1030_IV_c3, label(full sample))  ///
	(regoccfarm_IV_white, label(white)) ///
	(regoccfarm_IV_notwhite, label(not white)) ///
	(regoccfarm_IV_home, label(homeowner)) ///
	(regoccfarm_IV_nothome, label(homeowner)), xline(.137) ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor Uptake on 1930 Occupation=Farmer, by Sub-Sample") msize(large)
	graph export ./analyze/output/coefplot_occfarm_rh_IV.png, as(png) replace

label var cov ""
coefplot (regoccoper_1030_IV_c3, label(full sample))  ///
	(regoccoper_IV_white, label(white)) ///
	(regoccoper_IV_notwhite, label(not white)) ///
	(regoccoper_IV_home, label(homeowner)) ///
	(regoccoper_IV_nothome, label(homeowner)), xline(-0.031) ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(4)) ///
	title("IV: Impact of Tractor Uptake on 1930 Occupation=Operator, by Sub-Sample") msize(large)
	graph export ./analyze/output/coefplot_occoper_rh_IV.png, as(png) replace


label var cov ""
coefplot (regoccpop_IV, label(full sample))  ///
	(regoccpop_IV_white, label(white)) ///
	(regoccpop_IV_notwhite, label(not white)) ///
	(regoccpop_IV_home, label(homeowner)) ///
	(regoccpop_IV_nothome, label(homeowner)), xline(-0.258) ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(4)) ///
	title("IV: Impact of Tractor on Occ-Score relative to Father's, by Sub-Sample") msize(large)
	graph export ./analyze/output/coefplot_occpop_rh_IV.png, as(png) replace

label var cov ""
coefplot (regoccpop_IV, label(full sample))  ///
	(regoccpop_IV_010, label(age < 10)) ///
	(regoccpop_IV_1030, label(10 < age < 30)) ///
	(regoccpop_IV_30up, label(30 < age)), xline(-.258) ///
	keep(cov) coeflabels(cov = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor on Occ-Score relative to Father's, by Age-Group") msize(large)
	graph export ./analyze/output/coefplot_occpop_age_IV.png, as(png) replace


label var cov ""
coefplot (estINDag, label(Ag, full sample))  ///
	(estINDag_race, label(Ag, non-white)) ///
	(estINDmanu, label(Manu, full sample)) ///
	(estINDmanu_race, label(Manu, non-white)), xline(0) ///
	keep(tract30farm10) coeflabels(tract30farm10 = " ") legend(ring(0) pos(7)) ///
	title("OLS: Impact of Tractor on 1930 Industry of Employment") msize(large)
	graph export ./analyze/output/coefplot_ind_race_OLS.png, as(png) replace
	
label var cov ""
coefplot (estINDag_IV, label(Ag, full sample))  ///
	(estINDag_race_IV, label(Ag, non-white)) ///
	(estINDmanu_IV, label(Manu, full sample)) ///
	(estINDmanu_race_IV, label(Manu, non-white)), xline(0) ///
	keep(yhat) coeflabels(yhat = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor on 1930 Industry of Employment") msize(large)
	graph export ./analyze/output/coefplot_ind_race_IV.png, as(png) replace
	
label var cov ""
coefplot (estINDag, label(Ag, full sample))  ///
	(estINDag_young, label(Ag, youth)) ///
	(estINDmanu, label(Manu, full sample)) ///
	(estINDmanu_young, label(Manu, youth)), xline(0) ///
	keep(tract30farm10) coeflabels(tract30farm10 = " ") legend(ring(0) pos(7)) ///
	title("OLS: Impact of Tractor on 1930 Industry of Employment") msize(large)
	graph export ./analyze/output/coefplot_ind_age_OLS.png, as(png) replace
	
label var cov ""
coefplot (estINDag_IV, label(Ag, full sample))  ///
	(estINDag_young_IV, label(Ag, youth)) ///
	(estINDmanu_IV, label(Manu, full sample)) ///
	(estINDmanu_young_IV, label(Manu, youth)), xline(0) ///
	keep(yhat) coeflabels(yhat = " ") legend(ring(0) pos(7)) ///
	title("IV: Impact of Tractor on 1930 Industry of Employment") msize(large)
	graph export ./analyze/output/coefplot_ind_age_IV.png, as(png) replace
	
