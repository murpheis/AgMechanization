
set more off, perm

cd "/home/ipums/emily-ipums/TechChange/"




global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg valPerAcre_chg10"
global countyControls= "bankstot20 dist_closest_city farmsize10 popperacre10 farmpopperacre10 urbanperacre10 indagperacre10 indmanuperacre10 farmperacre10 valPerAcre10"


global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"


eststo clear


************************
**** 1910-1930 REGS ****
************************

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


* 10-30, no interactions
eststo clear
foreach var of varlist /*emp_30 nilf_30 unemp_30 */ ind_ag_30 ind_manu_30  moved_30 { //
di "`var'"



preserve
keep if ind_ag_10 == 1 & sex_10 == 2 & region2num == 2

*all 
eststo `var'_ag: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


* non-white / white
eststo `var'_nw: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_w: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


* non-homeowner / homeowner
eststo `var'_nh: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_h: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore 

* farm mw
preserve
keep if farm_10 ==1 & sex_10 == 2 & region2num == 2

* young / old
eststo `var'_y: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_o: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* homeowner / not homeowner if young
eststo `var'_ynh: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_yh: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-white / white
eststo `var'_fnw: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fw: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-homeowner / homeowner
eststo `var'_fnh: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fh: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore


}


************ tables


label var tractPerAcre30_10loc "Tractors"


esttab  nilf_30_ag emp_30_ag ind_ag_30_ag ind_manu_30_ag moved_30_ag, $tableopts st(N F J)
esttab  nilf_30_ag emp_30_ag ind_ag_30_ag ind_manu_30_ag moved_30_ag, ///
	using ./analyze/output/empind_agXX_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("NILF" "Emp." "Ag." "Manu." "Migrated") frag



esttab  nilf_30_y emp_30_y ind_ag_30_y ind_manu_30_y moved_30_y, $tableopts st(N F J)
esttab  nilf_30_y emp_30_y ind_ag_30_y ind_manu_30_y moved_30_y ///
	using ./analyze/output/empind_yfXX_1930.tex  ///
	, replace $tableopts st(N F J) mtitles( "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab  nilf_30_o emp_30_o ind_ag_30_o ind_manu_30_o moved_30_o, $tableopts st(N F J)
esttab  nilf_30_o emp_30_o ind_ag_30_o ind_manu_30_o moved_30_o ///
	using ./analyze/output/empind_ofXX_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab  nilf_30_h emp_30_h ind_ag_30_h ind_manu_30_h moved_30_h, $tableopts st(N F J)


esttab  nilf_30_nh emp_30_nh ind_ag_30_nh ind_manu_30_nh moved_30_nh, $tableopts st(N F J)

esttab  nilf_30_yh emp_30_yh ind_ag_30_yh ind_manu_30_yh moved_30_yh, $tableopts st(N F J)

esttab  nilf_30_ynh emp_30_ynh ind_ag_30_ynh ind_manu_30_ynh moved_30_ynh, $tableopts st(N F J)




* 10-30,  with interactions and county FEs
keep if region2num == 2
eststo clear
foreach var of varlist emp_30 nilf_30 unemp_30 ind_ag_30 ind_manu_30  moved_30 { 
di "`var'"


	* employed in ag vs. not
	preserve
	keep if sex_10 == 1 & empstat_10 == 10
	gen int1 = pct_wheat_1910 * ind_ag_10
	gen int2 = pct_oats_1910 * ind_ag_10
	gen int3 = pct_hay_1910 * ind_ag_10
	gen main = tractPerAcre30_10loc * ind_ag_10
	eststo intAg_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) ind_ag_10 i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore

	* race
	preserve
	keep if sex_10 == 1 & ind_ag_10 == 1 & empstat_10 == 10
	gen int1 = pct_wheat_1910 * white
	gen int2 = pct_oats_1910 * white
	gen int3 = pct_hay_1910 * white
	gen main = tractPerAcre30_10loc * white
	eststo intRace_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore

	* homeowner
	preserve
	keep if sex_10 == 1 & ind_ag_10 == 1 & empstat_10 == 10
	gen int1 = pct_wheat_1910 * homeowner
	gen int2 = pct_oats_1910 * homeowner
	gen int3 = pct_hay_1910 * homeowner
	gen main = tractPerAcre30_10loc * homeowner
	eststo intHome_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore
	
	* homeowner if young living on farm
	preserve
	keep if sex_10 == 1 & farm_10 == 1 & age_10 < 18
	gen int1 = pct_wheat_1910 * homeowner
	gen int2 = pct_oats_1910 * homeowner
	gen int3 = pct_hay_1910 * homeowner
	gen main = tractPerAcre30_10loc * homeowner
	eststo intHomeYouth_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore


	* young farm vs. nonfarm
	preserve
	keep if sex_10 == 1 & age_10 < 18
	gen int1 = pct_wheat_1910 * farm_10
	gen int2 = pct_oats_1910 * farm_10
	gen int3 = pct_hay_1910 * farm_10
	gen main = tractPerAcre30_10loc * farm_10
	eststo intFarmYouth_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) ind_ag_10 i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore



}



gen main = .
label var main "Tractors * Ag. Emp."
label var ind_ag_10 "Ag. Emp"
esttab intAg_*_30 ///
	,   keep(main ind_ag_10) $tableopts st(N F J) ///
	frag
esttab intAg_*_30 ///
	using ./analyze/output/intAg_empind30.tex ///
	,  replace keep(main ind_ag_10) $tableopts st(N F J) ///
	mtitles("Emp." "Unemp." "NILF" "Emp. = Ag." "Emp. = Manu." "Moved") frag
	
label var main "Tractors * Homeowner"
label var homeowner "Homeowner"
esttab intHome_*_30 ///
	,   keep(main homeowner) $tableopts st(N F J) ///
	frag
esttab intHome_*_30 ///
	using ./analyze/output/intHome_emp30.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles("Emp." "Unemp." "NILF" "Emp. = Ag." "Emp. = Manu." "Moved") frag


label var main "Tractors * White"
label var white "White"
esttab intRace_*_30 ///
	,   keep(main white) $tableopts st(N F J) ///
	frag
esttab intRace_*_30  ///
	using ./analyze/output/intRace_emp30.tex ///
	,  replace keep(main white) $tableopts st(N F J) ///
	mtitles("Emp." "Unemp." "NILF" "Emp. = Ag." "Emp. = Manu." "Moved") frag
	

label var main "Tractors * Homeowner"
label var homeowner "Homeowner"
esttab  intHomeYouth_*_30 ///
	,   keep(main homeowner) $tableopts st(N F J) ///
	frag
esttab  intHomeYouth_*_30 ///
	using ./analyze/output/intHomeYouth_emp30.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles("Emp." "Unemp." "NILF" "Emp. = Ag." "Emp. = Manu." "Moved") frag
	

label var main "Tractors * Farm Res."
label var farm_10 "Farm Res."
esttab  intFarmYouth_*_30 ///
	,   keep(main *farm_10*) $tableopts st(N F J) ///
	frag
esttab intFarmYouth_*_30 ///
	using ./analyze/output/intFarmYouth_emp30.tex ///
	,  replace keep(main *farm_10*) $tableopts st(N F J) ///
	mtitles("Emp." "Unemp." "NILF" "Emp. = Ag." "Emp. = Manu." "Moved") frag
	



************************
**** 1910-1940 REGS ****
************************

use ./analyze/temp/regdata1040.dta, clear

label var farm_10 "Farm"

gen unemp_40 = empstat_40 >= 20 & empstat_40 < 30

gen emp_40 = empstat_40 >= 10 & empstat_40 < 20

*gen nilf_40 = empstat_40 == 30
gen homework_40 = empstat_40 == 31
gen unablewk_40 = empstat_40 == 32
gen sch_40 = empstat_40 == 33
gen nilfoth_40 = empstat_40 == 34


* industry of employment without conditioning on employed
foreach var of varlist ind_ag_40 ind_manu_40 {
 replace `var' = 0 if nilf_40 == 1
 replace `var' = 0 if unemp_40 == 1
}

* fix income vars
replace incnonwg_40 = . if incnonwg_40 == 9
gen anynonwage_40 = 1 if incnonwg_40 == 1 | incnonwg_40 == 2 
replace anynonwage_40 = . if mi(incnonwg_40)
gen lrgnonwage_40 = 1 if incnonwg_40 == 2
replace lrgnonwage_40 = 0 if  incnonwg_40 == 1
replace lrgnonwage_40 = . if mi(incnonwg_40)
replace incwage_40 = . if incwage_40 == 999998 | incwage_40 == 999999
replace incwage_40 = 5001 if incwage_40 > 5000 & ~mi(incwage_40)


rename occfarmer_40 occfarm_40



* 10-40, no interactions
eststo clear
foreach var of varlist  emp_40 nilf_40 unablewk_40 unemp_40 ind_ag_40 ind_manu_40  moved_40  someHS_40  incwage_40  lrgnonwage_40 { //
di "`var'"




preserve
keep if ind_ag_10 == 1 & sex_10 == 2 & region2num == 2

*all 
eststo `var'_ag: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore

* farm mw
preserve
keep if farm_10 ==1 & sex_10 == 2 & region2num == 2

* young / old
eststo `var'_y: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_o: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore


}



************ tables

label var tractPerAcre40_10loc "Tractors"


esttab unemp_40_y nilf_40_y emp_40_y ind_ag_40_y ind_manu_40_y moved_40_y, $tableopts st(N F J)
esttab unemp_40_y nilf_40_y emp_40_y ind_ag_40_y ind_manu_40_y moved_40_y  ///
	using ./analyze/output/empind_yfXX_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag



esttab unemp_40_o nilf_40_o emp_40_o ind_ag_40_o ind_manu_40_o moved_40_o, $tableopts st(N F J)
esttab unemp_40_o emp_40_o nilf_40_o ind_ag_40_o ind_manu_40_o moved_40_o ///
	using ./analyze/output/empind_ofXX_1940.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab  incwage_40_y lrgnonwage_40_y someHS_40_y incwage_40_o lrgnonwage_40_o someHS_40_o , $tableopts st(N F J)
esttab incwage_40_y lrgnonwage_40_y someHS_40_y incwage_40_o lrgnonwage_40_o someHS_40_o ///
	using ./analyze/output/inced_XX_1940.tex  ///
	, replace $tableopts st(N F J) mtitles("Wages, Age $<$ 18" "Non-Wage Inc., Age $<$ 18" "Some HS, Age $<$ 18" "Wages, Age $\geq$ 18" "Non-Wage Inc., Age $\geq$ 18" "Some HS, Age $\geq$ 18") frag



* 10-40,  with interactions and county FEs
keep if region2num == 2
eststo clear
foreach var of varlist emp_40 nilf_40 unablewk_40 unemp_40 ind_ag_40 ind_manu_40  moved_40  someHS_40  incwage_40  lrgnonwage_40  { 
di "`var'"


	* employed in ag vs. not
	preserve
	keep if sex_10 == 2 & empstat_10 == 10
	gen int1 = pct_wheat_1910 * ind_ag_10
	gen int2 = pct_oats_1910 * ind_ag_10
	gen int3 = pct_hay_1910 * ind_ag_10
	gen main = tractPerAcre40_10loc * ind_ag_10
	eststo intAg_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) ind_ag_10 i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore


	* young farm vs. nonfarm
	preserve
	keep if sex_10 == 2 & age_10 < 18
	gen int1 = pct_wheat_1910 * farm_10
	gen int2 = pct_oats_1910 * farm_10
	gen int3 = pct_hay_1910 * farm_10
	gen main = tractPerAcre40_10loc * farm_10
	eststo intFarmYouth_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) ind_ag_10 i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore


	* old farm vs. nonfarm
	preserve
	keep if sex_10 == 2 & age_10 >= 18
	gen int1 = pct_wheat_1910 * farm_10
	gen int2 = pct_oats_1910 * farm_10
	gen int3 = pct_hay_1910 * farm_10
	gen main = tractPerAcre40_10loc * farm_10
	eststo intFarm_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) ind_ag_10 i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore



}



gen main = .
label var main "Tractors * Ag. Emp."
label var ind_ag_10 "Ag. Emp"
esttab intAg_emp_40 intAg_nilf_40 intAg_unemp_40 intAg_ind_ag_40 intAg_ind_manu_40  ///
	, keep(main ind_ag_10) $tableopts st(N F J) ///
	 frag
esttab intAg_emp_40 intAg_nilf_40 intAg_unemp_40 intAg_ind_ag_40 intAg_ind_manu_40 ///
	using ./analyze/output/intAg_indemp40.tex ///
	,  replace keep(main ind_ag_10) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp." "Emp. = Ag." "Emp. = Manu.") frag
esttab intAg_moved_40  intAg_someHS_40  intAg_incwage_40   intAg_lrg*   ///
	, keep(main ind_ag_10) $tableopts st(N F J) ///
	 frag
esttab intAg_moved_40  intAg_someHS_40  intAg_incwage_40   intAg_lrg*  ///
	using ./analyze/output/intAg_inc40.tex ///
	,  replace keep(main ind_ag_10) $tableopts st(N F J) ///
	mtitles( "Moved" "Some HS" "Wage Inc." "Non-Wage Inc. $>$ 50") frag
		
	
	
	
label var main "Tractors * Homeowner"
label var homeowner "Homeowner"
esttab intHome_emp_40 intHome_nilf_40 intHome_unemp_40 intHome_ind_ag_40 intHome_ind_manu_40  ///
	, keep(main homeowner) $tableopts st(N F J) ///
	 frag
esttab intHome_emp_40 intHome_nilf_40 intHome_unemp_40 intHome_ind_ag_40 intHome_ind_manu_40 ///
	using ./analyze/output/intHome_indemp40.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp." "Emp. = Ag." "Emp. = Manu.") frag
esttab intHome_moved_40  intHome_someHS_40  intHome_incwage_40   intHome_lrg*   ///
	, keep(main homeowner) $tableopts st(N F J) ///
	 frag
esttab intHome_moved_40  intHome_someHS_40  intHome_incwage_40   intHome_lrg*  ///
	using ./analyze/output/intHome_inc40.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles( "Moved" "Some HS" "Wage Inc." "Non-Wage Inc. $>$ 50") frag


label var main "Tractors * White"
label var white "White"
esttab intRace_emp_40 intRace_nilf_40 intRace_unemp_40 intRace_ind_ag_40 intRace_ind_manu_40  ///
	, keep(main white) $tableopts st(N F J) ///
	 frag
esttab intRace_emp_40 intRace_nilf_40 intRace_unemp_40 intRace_ind_ag_40 intRace_ind_manu_40 ///
	using ./analyze/output/intRace_indemp40.tex ///
	,  replace keep(main white) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp." "Emp. = Ag." "Emp. = Manu.") frag
esttab intRace_moved_40  intRace_someHS_40  intRace_incwage_40   intRace_lrg*   ///
	, keep(main white) $tableopts st(N F J) ///
	 frag
esttab intRace_moved_40  intRace_someHS_40  intRace_incwage_40   intRace_lrg*  ///
	using ./analyze/output/intRace_inc40.tex ///
	,  replace keep(main white) $tableopts st(N F J) ///
	mtitles( "Moved" "Some HS" "Wage Inc." "Non-Wage Inc. $>$ 50") frag



label var main "Tractors * Homeowner"
label var homeowner "Homeowner"
esttab intHomeYouth_emp_40 intHomeYouth_nilf_40 intHomeYouth_unemp_40 intHomeYouth_ind_ag_40 intHomeYouth_ind_manu_40  ///
	, keep(main homeowner) $tableopts st(N F J) ///
	 frag
esttab intHomeYouth_emp_40 intHomeYouth_nilf_40 intHomeYouth_unemp_40 intHomeYouth_ind_ag_40 intHomeYouth_ind_manu_40 ///
	using ./analyze/output/intHomeYouth_indemp40.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp." "Emp. = Ag." "Emp. = Manu.") frag
esttab intHomeYouth_moved_40  intHomeYouth_someHS_40  intHomeYouth_incwage_40   intHomeYouth_lrg*   ///
	, keep(main homeowner) $tableopts st(N F J) ///
	 frag
esttab intHomeYouth_moved_40  intHomeYouth_someHS_40  intHomeYouth_incwage_40   intHomeYouth_lrg*  ///
	using ./analyze/output/intHomeYouth_inc40.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles( "Moved" "Some HS" "Wage Inc." "Non-Wage Inc. $>$ 50") frag

	

label var main "Tractors * Farm Res."
label var farm_10 "Farm Res."
esttab intFarmYouth_emp_40 intFarmYouth_nilf_40 intFarmYouth_unemp_40 intFarmYouth_ind_ag_40 intFarmYouth_ind_manu_40  ///
	, keep(main *farm*) $tableopts st(N F J) ///
	 frag
esttab  intFarmYouth_emp_40 intFarmYouth_nilf_40 intFarmYouth_unemp_40 intFarmYouth_ind_ag_40 intFarmYouth_ind_manu_40 ///
	using ./analyze/output/intFarmYouth_indemp40.tex ///
	,  replace keep(main *farm*) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp." "Emp. = Ag." "Emp. = Manu.") frag
esttab intFarmYouth_moved_40  intFarmYouth_someHS_40  intFarmYouth_incwage_40   intFarmYouth_lrg*   ///
	, keep(main *farm*) $tableopts st(N F J) ///
	 frag
esttab intFarmYouth_moved_40  intFarmYouth_someHS_40  intFarmYouth_incwage_40   intFarmYouth_lrg*  ///
	using ./analyze/output/intFarmYouth_inc40.tex ///
	,  replace keep(main *farm*) $tableopts st(N F J) ///
	mtitles( "Moved" "Some HS" "Wage Inc." "Non-Wage Inc. $>$ 50") frag

	


