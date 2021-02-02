
set more off, perm

cd "/home/ipums/emily-ipums/TechChange/"




* DELETE WHEN CARL FIXES THINGS
adopath + "/admin/x86_64_apps/stata15/ado/base/"
sysdir set BASE "~/ado/plus/"






global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"







global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg valPerAcre_chg10"
global countyControls= "bankstot20 dist_closest_city farmsize10 popperacre10 farmpopperacre10 urbanperacre10 indagperacre10 indmanuperacre10 farmperacre10 valPerAcre10"
//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"
//global countyControls =  "bankstot20 dist_closest_city farmsize10  "
//global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg ind_manu_pct_chg10 valPerAcre_chg10"
global indControls = "farm_10 white age_10 agesq_10 sex_10 homeowner"
global indControls40 = "farm_20 white age_20 agesq_20  sex_20 homeowner "
global indControls00 = "farm_00 white age_00 agesq_00 sex_00 homeowner "

global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"


eststo clear







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





* REDUCDE SIZE FOR FUTZING
*gen rand = runiform()
*keep if rand < 0.10



* 10-40, no interactions
eststo clear
foreach var of varlist  emp_40 nilf_40 unablewk_40 unemp_40 ind_ag_40 ind_manu_40  moved_40  someHS_40  incwage_40  lrgnonwage_40 { //
di "`var'"


*non-ag
preserve
keep if ind_ag_10 == 0 & empstat_10 != 30 & sex_10 == 1 & region2num == 2
eststo `var'_nag: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner  age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner  age_10 agesq_10   i.farm_10 white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore




preserve
keep if ind_ag_10 == 1 & sex_10 == 1 & region2num == 2

*all 
eststo `var'_ag: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


* non-white / white
eststo `var'_nw: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_w: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


* non-homeowner / homeowner
eststo `var'_nh: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_h: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore 


* farm mw
preserve
keep if farm_10 ==1 & sex_10 == 1 & region2num == 2

* young / old
eststo `var'_y: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_o: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* homeowner / not homeowner if young
eststo `var'_ynh: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_yh: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-white / white
eststo `var'_fnw: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fw: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-homeowner / homeowner
eststo `var'_fnh: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fh: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore

/*
* farm us
preserve
keep if farm_10 ==1 & sex_10 == 1 

* young / old
eststo `var'_y_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_o_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* homeowner / not homeowner if young
eststo `var'_ynh_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_yh_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-white / white
eststo `var'_fnw_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fw_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-homeowner / homeowner
eststo `var'_fnh_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fh_us: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore
*/
*non-farm mw
preserve
keep if farm_10 ==0 & sex_10 == 1 & region2num == 2

* young / old
eststo `var'_ynf: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_onf: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

eststo `var'_allnf: qui ivreg2  `var' (tractPerAcre40_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


restore




}


* tables


************ tables

label var tractPerAcre40_10loc "Tractors"


esttab unemp_40_y nilf_40_y emp_40_y ind_ag_40_y ind_manu_40_y moved_40_y, $tableopts st(N F J)
esttab unemp_40_y nilf_40_y emp_40_y ind_ag_40_y ind_manu_40_y moved_40_y  ///
	using ./analyze/output/empind_yfmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag



esttab unemp_40_o nilf_40_o emp_40_o ind_ag_40_o ind_manu_40_o moved_40_o, $tableopts st(N F J)
esttab unemp_40_o emp_40_o nilf_40_o ind_ag_40_o ind_manu_40_o moved_40_o ///
	using ./analyze/output/empind_ofmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag



esttab unemp_40_onf nilf_40_onf emp_40_onf ind_ag_40_onf ind_manu_40_onf moved_40_onf, $tableopts st(N F J)
esttab unemp_40_onf nilf_40_onf emp_40_onf  ind_ag_40_onf ind_manu_40_onf moved_40_onf ///
	using ./analyze/output/empind_onfmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_40_ynf nilf_40_ynf emp_40_ynf ind_ag_40_ynf ind_manu_40_ynf moved_40_ynf, $tableopts st(N F J)
esttab unemp_40_ynf nilf_40_ynf emp_40_ynf ind_ag_40_ynf ind_manu_40_ynf moved_40_ynf ///
	using ./analyze/output/empind_ynfmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_40_yh nilf_40_yh emp_40_yh ind_ag_40_yh ind_manu_40_yh moved_40_yh, $tableopts st(N F J)
esttab unemp_40_yh nilf_40_yh emp_40_yh ind_ag_40_yh ind_manu_40_yh moved_40_yh ///
	using ./analyze/output/empind_yhmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_40_ynh nilf_40_ynh emp_40_ynh ind_ag_40_ynh ind_manu_40_ynh moved_40_ynh, $tableopts st(N F J)
esttab unemp_40_ynh nilf_40_ynh emp_40_ynh ind_ag_40_ynh ind_manu_40_ynh moved_40_ynh ///
	using ./analyze/output/empind_ynhmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_40_h nilf_40_h emp_40_h ind_ag_40_h ind_manu_40_h moved_40_h, $tableopts st(N F J)
esttab unemp_40_h nilf_40_h emp_40_h ind_ag_40_h ind_manu_40_h moved_40_h ///
	using ./analyze/output/empind_hmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_40_nh nilf_40_nh emp_40_nh ind_ag_40_nh ind_manu_40_nh moved_40_nh, $tableopts st(N F J)
esttab unemp_40_nh nilf_40_nh emp_40_nh ind_ag_40_nh ind_manu_40_nh moved_40_nh ///
	using ./analyze/output/empind_nhmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_40_w nilf_40_w emp_40_w ind_ag_40_w ind_manu_40_w moved_40_w, $tableopts st(N F J)
esttab unemp_40_w nilf_40_w emp_40_w ind_ag_40_w ind_manu_40_w moved_40_w ///
	using ./analyze/output/empind_wmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_40_nw nilf_40_nw emp_40_nw ind_ag_40_nw ind_manu_40_nw moved_40_nw, $tableopts st(N F J)
esttab unemp_40_nw nilf_40_nw emp_40_nw ind_ag_40_nw ind_manu_40_nw moved_40_nw ///
	using ./analyze/output/empind_nwmw_1940.tex  ///
	, replace $tableopts st(N F J) mtitles( "Unemp" "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab incwage_40_o incwage_40_y incwage_40_onf incwage_40_ynf , $tableopts st(N F J)
esttab incwage_40_o incwage_40_y incwage_40_onf incwage_40_ynf ///
	using ./analyze/output/incwage40.tex  ///
	, replace $tableopts st(N F J) mtitles( "Farm, Age $\geq$ 18" "Farm, Age $<$ 18" "Non-Farm, Age $\geq$ 18" "Non-Farm, Age $<$ 18") frag



esttab lrgnonwage_40_o lrgnonwage_40_y lrgnonwage_40_onf lrgnonwage_40_ynf , $tableopts st(N F J)
esttab lrgnonwage_40_o lrgnonwage_40_y lrgnonwage_40_onf lrgnonwage_40_ynf ///
	using ./analyze/output/lrgnonwage40.tex  ///
	, replace $tableopts st(N F J) mtitles( "Farm, Age $\geq$ 18" "Farm, Age $<$ 18" "Non-Farm, Age $\geq$ 18" "Non-Farm, Age $<$ 18") frag

esttab someHS_40_o someHS_40_y someHS_40_onf someHS_40_ynf , $tableopts st(N F J)
esttab someHS_40_o someHS_40_y someHS_40_onf someHS_40_ynf ///
	using ./analyze/output/someHS40.tex  ///
	, replace $tableopts st(N F J) mtitles( "Farm, Age $\geq$ 18" "Farm, Age $<$ 18" "Non-Farm, Age $\geq$ 18" "Non-Farm, Age $<$ 18") frag





* coefplots
coefplot (unemp_40_nag, aseq(Unemp.) mc(blue))  ///
	(unemp_40_ag, aseq(Unemp.) mc(red))  ///
        ( nilf_40_nag, aseq(NILF) mc(blue)) ///
	( nilf_40_ag, aseq(NILF) mc(red))  ///
	( emp_40_nag, aseq(Emp) mc(blue)) ///
	( emp_40_ag, aseq(Emp) mc(red))  ///
        ( ind_ag_40_nag, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_ag, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_nag, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_ag, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-.5(.1).5) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1940") ///
	 subtitle("Blue = Employed NOT in Ag in 1910, Red = Employed in Ag in 1910")
	graph export ./analyze/output/empind_agnag_mw_1940.png, replace
	
	
coefplot (unemp_40_onf, aseq(Unemp.) mc(blue))  ///
	(unemp_40_o, aseq(Unemp.) mc(red))  ///
        ( nilf_40_onf, aseq(NILF) mc(blue)) ///
	( nilf_40_o, aseq(NILF) mc(red))  ///
	( emp_40_onf, aseq(Emp) mc(blue)) ///
	( emp_40_o, aseq(Emp) mc(red))  ///
        ( ind_ag_40_onf, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_o, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_onf, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_o, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-.5(.1).5) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("MW Males >= 18 in 1910") ///
	 subtitle("Blue = Non-Farm Resident in 1910, Red = Farm Resident in 1910")
	graph export ./analyze/output/empind_fnfold_mw_1940.png, replace
	
	
coefplot (unemp_40_ynf, aseq(Unemp.) mc(blue))  ///
	(unemp_40_y, aseq(Unemp.) mc(red))  ///
        ( nilf_40_ynf, aseq(NILF) mc(blue)) ///
	( nilf_40_y, aseq(NILF) mc(red))  ///
	( emp_40_ynf, aseq(Emp) mc(blue)) ///
	( emp_40_y, aseq(Emp) mc(red))  ///
        ( ind_ag_40_ynf, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_y, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_ynf, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_y, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-.5(.1).5) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("MW Males < 18 in 1910") ///
	 subtitle("Blue = Non-Farm Resident in 1910, Red = Farm Resident in 1910")
	graph export ./analyze/output/empind_fnfyoung_mw_1940.png, replace
	
coefplot (unemp_40_nag_us, aseq(Unemp.) mc(blue))  ///
	(unemp_40_ag_us, aseq(Unemp.) mc(red))  ///
        ( nilf_40_nag_us, aseq(NILF) mc(blue)) ///
	( nilf_40_ag_us, aseq(NILF) mc(red))  ///
	 ( unablewk_40_nag_us, aseq(NILF=Unable) mc(blue)) ///
	( unablewk_40_ag_us, aseq(NILF=Unable) mc(red))  ///
	( emp_40_nag_us, aseq(Emp) mc(blue)) ///
	( emp_40_ag_us, aseq(Emp) mc(red))  ///
        ( ind_ag_40_nag_us, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_ag_us, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_nag_us, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_ag_us, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("US: Coefficient in Regression Predicting Employment Status in 1940") ///
	 subtitle("Blue = Employed NOT in Ag in 1910, Red = Employed in Ag in 1910")
	graph export ./analyze/output/empind_agnag_us_1940.png, replace

coefplot (unemp_40_y, aseq(Unemp.) mc(blue))  ///
	(unemp_40_o, aseq(Unemp.) mc(red))  ///
        ( nilf_40_y, aseq(NILF) mc(blue)) ///
	( nilf_40_o, aseq(NILF) mc(red))  ///
	( emp_40_y, aseq(Emp) mc(blue)) ///
	( emp_40_o, aseq(Emp) mc(red))  ///
        ( ind_ag_40_y, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_o, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_y, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_o, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1940") ///
	 subtitle("Blue = Less than 18 Yrs. Old in 1910, Red = 18 or Older in 1910")
	graph export ./analyze/output/empind_yo_mw_1940.png, replace


coefplot (unemp_40_h, aseq(Unemp.) mc(blue))  ///
	(unemp_40_nh, aseq(Unemp.) mc(red))  ///
        ( nilf_40_h, aseq(NILF) mc(blue)) ///
	( nilf_40_nh, aseq(NILF) mc(red))  ///
	 ( unablewk_40_h, aseq(NILF=Unable) mc(blue)) ///
	( unablewk_40_nh, aseq(NILF=Unable) mc(red))  ///
	( emp_40_h, aseq(Emp) mc(blue)) ///
	( emp_40_nh, aseq(Emp) mc(red))  ///
        ( ind_ag_40_h, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_nh, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_h, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_nh, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1940") ///
	 subtitle("Blue = Homeowner, Red = Non-Homeowner")
	 graph export ./analyze/output/empind_home_mw_1940.png, replace

coefplot (unemp_40_yh, aseq(Unemp.) mc(blue))  ///
	(unemp_40_ynh, aseq(Unemp.) mc(red))  ///
        ( nilf_40_yh, aseq(NILF) mc(blue)) ///
	( nilf_40_ynh, aseq(NILF) mc(red))  ///
	 ( unablewk_40_yh, aseq(NILF=Unable) mc(blue)) ///
	( unablewk_40_ynh, aseq(NILF=Unable) mc(red))  ///
	( emp_40_yh, aseq(Emp) mc(blue)) ///
	( emp_40_ynh, aseq(Emp) mc(red))  ///
        ( ind_ag_40_yh, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_40_ynh, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_40_yh, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_40_ynh, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1940") ///
	 subtitle("Blue = Homeowner Parents, Red = Non-Homeowner Parents")
	 graph export ./analyze/output/empind_youthhome_mw_1940.png, replace

coefplot ( moved_40_ag, aseq(Ag.) mc(blue))  ///
        ( moved_40_nag, aseq(Non Ag.) mc(blue)) ///
        ( moved_40_w, aseq(White) mc(red))  ///
        ( moved_40_nw, aseq(Not White) mc(red)) ///
	 ( moved_40_h, aseq(Homeowner) mc(green))  ///
        ( moved_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( moved_40_y, aseq(Young) mc(orange))  ///
        ( moved_40_o, aseq(Old) mc(orange)) ///
	 ( moved_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( moved_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Migration, 1910-1940") 
	graph export ./analyze/output/coefplot_moved40_mw.png, as(png) replace	


coefplot ( incwage_40_ag, aseq(Ag.) mc(blue))  ///
        ( incwage_40_nag, aseq(Non Ag.) mc(blue)) ///
	( incwage_40_w, aseq(White) mc(red))  ///
        ( incwage_40_nw, aseq(Not White) mc(red)) ///
	 ( incwage_40_h, aseq(Homeowner) mc(green))  ///
        ( incwage_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( incwage_40_y, aseq(Young) mc(orange))  ///
        ( incwage_40_o, aseq(Old) mc(orange)) ///
	 ( incwage_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( incwage_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Wage Income, 1910-1940") 
	graph export ./analyze/output/coefplot_incwage40_mw.png, as(png) replace	


coefplot ( lrgnonwage_40_ag, aseq(Ag.) mc(blue))  ///
        ( lrgnonwage_40_nag, aseq(Non Ag.) mc(blue)) ///
        ( lrgnonwage_40_w, aseq(White) mc(red))  ///
        ( lrgnonwage_40_nw, aseq(Not White) mc(red)) ///
	 ( lrgnonwage_40_h, aseq(Homeowner) mc(green))  ///
        ( lrgnonwage_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( lrgnonwage_40_y, aseq(Young) mc(orange))  ///
        ( lrgnonwage_40_o, aseq(Old) mc(orange)) ///
	 ( lrgnonwage_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( lrgnonwage_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Non-Wage Income > $50, 1910-1940") 
	graph export ./analyze/output/coefplot_lrgnonwage40_mw.png, as(png) replace	


coefplot ( someHS_40_ag, aseq(Ag.) mc(blue))  ///
        ( someHS_40_nag, aseq(Non Ag.) mc(blue)) ///
        ( someHS_40_w, aseq(White) mc(red))  ///
        ( someHS_40_nw, aseq(Not White) mc(red)) ///
	 ( someHS_40_h, aseq(Homeowner) mc(green))  ///
        ( someHS_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( someHS_40_y, aseq(Young) mc(orange))  ///
        ( someHS_40_o, aseq(Old) mc(orange)) ///
	 ( someHS_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( someHS_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Some HS Education Attained, 1910-1940") 
	graph export ./analyze/output/coefplot_someHS40_mw.png, as(png) replace	



coefplot ( emp_40_ag, aseq(Ag.) mc(blue))  ///
        (  emp_40_nag, aseq(Non Ag.) mc(blue)) ///
        (  emp_40_w, aseq(White) mc(red))  ///
        (  emp_40_nw, aseq(Not White) mc(red)) ///
	 (  emp_40_h, aseq(Homeowner) mc(green))  ///
        (  emp_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( emp_40_y, aseq(Young) mc(orange))  ///
        ( emp_40_o, aseq(Old) mc(orange)) ///
	 (  emp_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        (  emp_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Employment, 1910-1940") 
	graph export ./analyze/output/coefplot_emp40_mw.png, as(png) replace	


coefplot ( ind_ag_40_ag, aseq(Ag.) mc(blue))  ///
        (  ind_ag_40_nag, aseq(Non Ag.) mc(blue)) ///
        (  ind_ag_40_w, aseq(White) mc(red))  ///
        (  ind_ag_40_nw, aseq(Not White) mc(red)) ///
	 (  ind_ag_40_h, aseq(Homeowner) mc(green))  ///
        (  ind_ag_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( ind_ag_40_y, aseq(Young) mc(orange))  ///
        ( ind_ag_40_o, aseq(Old) mc(orange)) ///
	 (  ind_ag_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        (  ind_ag_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Employment, 1910-1940") 
	graph export ./analyze/output/coefplot_indag40_mw.png, as(png) replace	



coefplot ( ind_manu_40_ag, aseq(Ag.) mc(blue))  ///
        (  ind_manu_40_nag, aseq(Non Ag.) mc(blue)) ///
        (  ind_manu_40_w, aseq(White) mc(red))  ///
        (  ind_manu_40_nw, aseq(Not White) mc(red)) ///
	 (  ind_manu_40_h, aseq(Homeowner) mc(green))  ///
        (  ind_manu_40_nh, aseq(Not Homeowner) mc(green)) ///
	 ( ind_manu_40_y, aseq(Young) mc(orange))  ///
        ( ind_manu_40_o, aseq(Old) mc(orange)) ///
	 (  ind_manu_40_yh, aseq(Child of Homeowner) mc(purple))  ///
        (  ind_manu_40_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre40_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Manu. Employment, 1910-1940") 
	graph export ./analyze/output/coefplot_indmanu40_mw.png, as(png) replace	




* 10-40,  with interactions and county FEs
keep if region2num == 2
eststo clear
foreach var of varlist emp_40 nilf_40 unablewk_40 unemp_40 ind_ag_40 ind_manu_40  moved_40  someHS_40  incwage_40  lrgnonwage_40  { 
di "`var'"


	* employed in ag vs. not
	preserve
	keep if sex_10 == 1 & empstat_10 == 10
	gen int1 = pct_wheat_1910 * ind_ag_10
	gen int2 = pct_oats_1910 * ind_ag_10
	gen int3 = pct_hay_1910 * ind_ag_10
	gen main = tractPerAcre40_10loc * ind_ag_10
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
	gen main = tractPerAcre40_10loc * white
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
	gen main = tractPerAcre40_10loc * homeowner
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
	gen main = tractPerAcre40_10loc * homeowner
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
	gen main = tractPerAcre40_10loc * farm_10
	eststo intFarmYouth_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) ind_ag_10 i.lit_10 homeowner sex_10 age_10 agesq_10 i.countyid   i.farm_10 white, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	restore



}



* save all estimates
local i = 1
foreach var of varlist   emp_40 nilf_40 unablewk_40 unemp_40 ind_ag_40 ind_manu_40  moved_40  someHS_40  incwage_40  lrgnonwage_40  {

estimates restore intAg_`var'
if `i' == 1 {
	estimates save ./analyze/output/intestimates40.est, replace
}
if `i' !=1 {
	estimates save ./analyze/output/intestimates40.est, append
}

estimates restore intRace_`var'
estimates save ./analyze/output/intestimates40.est, append

estimates restore intHome_`var'
estimates save ./analyze/output/intestimates40.est, append

estimates restore intHomeYouth_`var'
estimates save ./analyze/output/intestimates40.est, append

estimates restore intFarmYouth_`var'
estimates save ./analyze/output/intestimates40.est, append


local i = `i' + 1
}
*


* reload estimates 
local i = 1
foreach var of varlist  emp_40 nilf_40 unablewk_40 unemp_40 ind_ag_40 ind_manu_40  moved_40  someHS_40  incwage_40  lrgnonwage_40 {

estimates use ./analyze/output/intestimates40.est, number(`i')
eststo intAg_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates40.est, number(`i')
eststo intRace_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates40.est, number(`i')
eststo intHome_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates40.est, number(`i')
eststo intHomeYouth_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates40.est, number(`i')
eststo intFarmYouth_`var'
local i = `i' + 1

}
*



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

	


