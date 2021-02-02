

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
**** 1900-1910 REGS ****
************************

use ./analyze/temp/regdata0010.dta, clear


gen unemp_10 = empstat_10 == 20

gen emp_10 = empstat_10 == 10

gen nilf_10 = empstat_10 == 30

* industry of employment without conditioning on employed
foreach var of varlist ind_ag_10-ind_bank_10 {
 replace `var' = 0 if empstat_10 == 30 
 replace `var' = 0 if empstat_10 == 20 
}



* recode lit
gen lit10 = lit_10 == 4
replace lit10 = . if lit_10 > 4



***** no county FEs ****
local industries " unemp_10 emp_10 nilf_10  moved_10 ind_ag_10 ind_manu_10 "
foreach var of varlist `industries' {

di "`var'"

preserve
keep if labforce_00 == 2 &  sex_00 == 1 & region2num == 2
eststo `var'_tot: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2 , cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore



*in labor force
preserve
keep if labforce_00 == 2 & farm_00 == 0 & sex_00 == 1 & region2num == 2
eststo `var'_nf: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2 , cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore


preserve
keep if labforce_00 == 2 & farm_00 == 1 & sex_00 == 1 & region2num == 2

*all 
eststo `var'_f: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2 , cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore 

preserve
keep if sex_00 == 1 & region2num == 2

* young / old
eststo `var'_yf: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2  if age_00<18 & farm_00 ==1 , cluster(stateicp) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_ynf: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white $countyControls  $countyControls2  if age_00<18 & farm_00 ==0, cluster(stateicp) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   i.farm_00 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore

/*
* whole USA
preserve
keep if labforce_00 == 2 & sex_00 == 1 
eststo `var'_nf_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp white $countyControls  $countyControls2 if farm_00 == 0, cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

eststo `var'_f_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp    white $countyControls  $countyControls2 if farm_00 == 1, cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore

preserve
keep if sex_00 == 1
eststo `var'_yf_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   white $countyControls  $countyControls2  if age_00<18 & farm_00 == 1, cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


eststo `var'_ynf_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   white $countyControls  $countyControls2  if age_00<18 & farm_00 == 0, cluster(countyid) partial(i.stateicp i.lit_00 homeowner sex_00 age_00 agesq_00 i.stateicp   white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore
*/
}


* tables

label var tractPerAcre30_10loc "Tractors"

esttab unemp_10_yf emp_10_yf nilf_10_yf ind_ag_10_yf ind_manu_10_yf moved_10_yf, $tableopts st(N F J)
esttab unemp_10_yf emp_10_yf nilf_10_yf ind_ag_10_yf ind_manu_10_yf moved_10_yf ///
	using ./analyze/output/empind_yfmw_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF" "Ag." "Manu." "Migrated") frag

esttab unemp_10_ynf emp_10_ynf nilf_10_ynf ind_ag_10_ynf ind_manu_10_ynf moved_10_ynf, $tableopts st(N F J)
esttab unemp_10_ynf emp_10_ynf nilf_10_ynf ind_ag_10_ynf ind_manu_10_ynf moved_10_ynf ///
	using ./analyze/output/empind_ynfmw_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF"  "Ag." "Manu." "Migrated") frag

esttab unemp_10_f emp_10_f nilf_10_f ind_ag_10_f ind_manu_10_f moved_10_f, $tableopts st(N F J)
esttab unemp_10_f emp_10_f nilf_10_f ind_ag_10_f ind_manu_10_f moved_10_f  ///
	using ./analyze/output/empind_fmw_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp."  "NILF" "Ag." "Manu." "Migrated") frag

esttab unemp_10_nf emp_10_nf nilf_10_nf ind_ag_10_nf ind_manu_10_nf moved_10_nf, $tableopts st(N F J)
esttab unemp_10_nf emp_10_nf nilf_10_nf ind_ag_10_nf ind_manu_10_nf moved_10_nf ///
	using ./analyze/output/empind_nfmw_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF"  "Ag." "Manu." "Migrated") frag

esttab unemp_10_yf_us emp_10_yf_us ind_ag_10_yf_us ind_manu_10_yf_us moved_10_yf_us, $tableopts st(N F J)
esttab unemp_10_yf_us emp_10_yf_us ind_ag_10_yf_us ind_manu_10_yf_us moved_10_yf_us ///
	using ./analyze/output/empind_yfus_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF"  "Ag." "Manu." "Migrated") frag

esttab unemp_10_ynf_us emp_10_ynf_us ind_ag_10_ynf_us ind_manu_10_ynf_us moved_10_ynf_us, $tableopts st(N F J)
esttab unemp_10_ynf_us emp_10_ynf_us ind_ag_10_ynf_us ind_manu_10_ynf_us moved_10_ynf_us ///
	using ./analyze/output/empind_ynfus_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF"  "Ag." "Manu." "Migrated") frag

esttab unemp_10_f_us emp_10_f_us ind_ag_10_f_us ind_manu_10_f_us moved_10_f_us, $tableopts st(N F J)
esttab unemp_10_f_us emp_10_f_us ind_ag_10_f_us ind_manu_10_f_us moved_10_f_us ///
	using ./analyze/output/empind_fus_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF"  "Ag." "Manu." "Migrated") frag

esttab unemp_10_nf_us emp_10_nf_us ind_ag_10_nf_us ind_manu_10_nf_us moved_10_nf_us, $tableopts st(N F J)
esttab unemp_10_nf_us emp_10_nf_us ind_ag_10_nf_us ind_manu_10_nf_us moved_10_nf_us ///
	using ./analyze/output/empind_nfus_1910.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "Emp." "NILF"  "Ag." "Manu." "Migrated") frag


* coefplots


coefplot (unemp_10_yf, aseq(Unemp.) mc(blue))  ///
	( emp_10_yf, aseq(Emp) mc(blue)) ///
	( nilf_10_yf, aseq(NILF) mc(blue)) ///
        ( ind_ag_10_yf, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_yf, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_yf, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	subtitle("Sample = MW Male Youth Residing on Farms in 1900")
	 graph export ./analyze/output/coefplot_empind_young_mwpretrend.png, as(png) replace	



coefplot (unemp_10_ynf, aseq(Unemp.) mc(blue))  ///
	( emp_10_ynf, aseq(Emp) mc(blue)) ///
	( nilf_10_ynf, aseq(NILF) mc(blue)) ///
        ( ind_ag_10_ynf, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_ynf, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_ynf, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	subtitle("Sample = MW Male Youth NOT Residing on Farms in 1900")
	graph export ./analyze/output/coefplot_empind_NFyoung_mwpretrend.png, as(png) replace	


coefplot (unemp_10_yf_us, aseq(Unemp.) mc(blue))  ///
	( emp_10_yf_us, aseq(Emp) mc(blue)) ///
        ( ind_ag_10_yf_us, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_yf_us, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_yf_us, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	subtitle("Sample = US Male Youth Residing on Farms in 1900")
	 graph export ./analyze/output/coefplot_empind_young_uspretrend.png, as(png) replace	


coefplot (unemp_10_ynf_us, aseq(Unemp.) mc(blue))  ///
	( emp_10_ynf_us, aseq(Emp) mc(blue)) ///
        ( ind_ag_10_ynf_us, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_ynf_us, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_ynf_us, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)4) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	subtitle("Sample = US Male Youth NOT Residing on Farms in 1900")
	graph export ./analyze/output/coefplot_empind_NFyoung_uspretrend.png, as(png) replace 

coefplot (unemp_10_f, aseq(Unemp.) mc(blue))  ///
	( emp_10_f, aseq(Emp) mc(blue)) ///
	( nilf_10_f, aseq(NILF) mc(blue)) ///
        ( ind_ag_10_f, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_f, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_f, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	subtitle("Sample = MW Male Labor Force Participants Residing on Farms in 1900")
	 graph export ./analyze/output/coefplot_empind_farm_mwpretrend.png, as(png) replace	


coefplot (unemp_10_nf, aseq(Unemp.) mc(blue))  ///
	( emp_10_nf, aseq(Emp) mc(blue)) ///
	( nilf_10_nf, aseq(NILF) mc(blue)) ///
        ( ind_ag_10_nf, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_nf, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_nf, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	subtitle("Sample = MW Male Labor Force Participants NOT Residing on Farms in 1900")
	 graph export ./analyze/output/coefplot_empind_nf_mwpretrend.png, as(png) replace	


coefplot (unemp_10_f_us, aseq(Unemp.) mc(blue))  ///
	( emp_10_f_us, aseq(Emp) mc(blue)) ///
        ( ind_ag_10_f_us, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_f_us, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_f_us, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	 subtitle("Sample = US Male Labor Force Participants Residing on Farms in 1900")
	 graph export ./analyze/output/coefplot_empind_farm_uspretrend.png, as(png) replace	
	 


coefplot (unemp_10_nf_us, aseq(Unemp.) mc(blue))  ///
	( emp_10_nf_us, aseq(Emp) mc(blue)) ///
        ( ind_ag_10_nf_us, aseq(Emp=Ag.) mc(blue)) ///
        ( ind_manu_10_nf_us, aseq(Emp=Manu.) mc(blue))  ///
	( moved_10_nf_us, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0)  legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	 subtitle("Sample = US Male Labor Force Participants NOT Residing on Farms in 1900")
	 graph export ./analyze/output/coefplot_empind_nf_uspretrend.png, as(png) replace	

	 

/*
* with county FEs
preserve
keep if sex_10 == 1 & region2num == 2
gen int1 = .
gen int2 = .
gen int3 = .
gen main = .
foreach var of varlist  moved_10 lit10 emp_10 unemp_10 nilf_10 ind_ag_10 ind_manu_10 {


	* farm vs. nonfarm
	replace int1 = pct_wheat_1910 * farm_00
	replace int2 = pct_oats_1910 * farm_00
	replace int3 = pct_hay_1910 * farm_00
	replace main = tractPerAcre30_10loc * farm_00
	*eststo intfarm00_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 )  i.lit_00 homeowner sex_00 age_00 agesq_00 i.countyid    white, cluster(countyid) partial( i.lit_00 homeowner sex_00 age_00 agesq_00 i.countyid   i.farm_00 white)  gmm2s
	*estadd scalar F=e(widstat), replace
	*estadd scalar J =  e(jp), replace
	
	* young farm vs. nonfarm
	eststo intFarmYouth_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 )  i.lit_00 homeowner sex_00 age_00 agesq_00 i.countyid    white  if  age_00 < 18, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	
	
	* homeowner
	replace int1 = pct_wheat_1910 * homeowner
	replace int2 = pct_oats_1910 * homeowner
	replace int3 = pct_hay_1910 * homeowner
	replace main = tractPerAcre30_10loc * homeowner
	eststo intHome_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.countyid    white if farm_00==1, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace

	
	* homeowner if young living on farm
	eststo intHomeYouth_`var': qui ivreg2  `var' (main = int1 int2 int3 pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_00 homeowner sex_00 age_00 agesq_00 i.countyid   i.farm_00 white if  farm_00 == 1 & age_00 < 18, cluster(countyid) partial(i.countyid)  gmm2s
	estadd scalar F=e(widstat), replace
	estadd scalar J =  e(jp), replace
	


	

}
restore


esttab intfarm00* , keep(main ) se

esttab intFarmYouth*_10 , keep(main ) se

esttab intHome_*_10 , keep(main ) se

esttab intHomeYouth_*_10 , keep(main ) se


coefplot (intfarm00_nilf_10, aseq(NILF) mc(blue))  ///
	(intfarm00_unemp_10, aseq(Unemp.) mc(blue))  ///
	(intfarm00_emp_10, aseq(Emp.) mc(blue))  ///
	 (intfarm00_ind_ag_10, aseq(Ag. Emp.) mc(blue))  ///
	  (intfarm00_ind_manu_10, aseq(Manu. Emp.) mc(blue))  ///
	 (intfarm00_moved_10, aseq(Migrated) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(main) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting 1910 Outcomes")
	graph export ./analyze/output/coefplot_intfarm_pretrend.png, as(png) replace	
*/




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





* REDUCDE SIZE FOR FUTZING
*gen rand = runiform()
*keep if rand < 0.10



* 10-30, no interactions
eststo clear
foreach var of varlist emp_30 nilf_30 unemp_30 ind_ag_30 ind_manu_30  moved_30 { //
di "`var'"


*non-ag
preserve
keep if ind_ag_10 == 0 & empstat_10 != 30 & sex_10 == 1 & region2num == 2
eststo `var'_nag: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore

/*
*non-ag us
preserve
keep if ind_ag_10 == 0 & empstat_10 != 30 & sex_10 == 1 
eststo `var'_nag_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
restore
*/


preserve
keep if ind_ag_10 == 1 & sex_10 == 1 & region2num == 2

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
/*
* us ag
preserve
keep if ind_ag_10 == 1 & sex_10 == 1 

*all 
eststo `var'_ag_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2 , cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


* non-white / white
eststo `var'_nw_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_w_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


* non-homeowner / homeowner
eststo `var'_nh_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_h_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore 
*/
* farm mw
preserve
keep if farm_10 ==1 & sex_10 == 1 & region2num == 2

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

/*
* farm us
preserve
keep if farm_10 ==1 & sex_10 == 1 

* young / old
eststo `var'_y_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_o_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* homeowner / not homeowner if young
eststo `var'_ynh_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_yh_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1 & age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-white / white
eststo `var'_fnw_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 0, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fw_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 $countyControls  $countyControls2  if white == 1, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10   $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

* non-homeowner / homeowner
eststo `var'_fnh_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 0, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_fh_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if homeowner == 1, cluster(stateicp) partial(i.stateicp i.lit_10  sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

restore
*/
*non-farm mw
preserve
keep if farm_10 ==0 & sex_10 == 1 & region2num == 2

* young / old
eststo `var'_ynf: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_onf: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

eststo `var'_allnf: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


restore

/*
*non-farm us
preserve
keep if farm_10 ==0 & sex_10 == 1 

* young / old
eststo `var'_ynf_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10<18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo `var'_onf_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

eststo `var'_allnf_us: qui ivreg2  `var' (tractPerAcre30_10loc = pct_wheat_1910 pct_oats_1910 pct_hay_1910 ) i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white $countyControls  $countyControls2  if age_10>=18, cluster(stateicp) partial(i.stateicp i.lit_10 homeowner sex_10 age_10 agesq_10 i.stateicp   i.farm_10 white  $countyControls  $countyControls2)  gmm2s
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace


restore
*/

}


************ tables

label var tractPerAcre30_10loc "Tractors"

esttab unemp_30_y nilf_30_y emp_30_y ind_ag_30_y ind_manu_30_y moved_30_y, $tableopts st(N F J)
esttab unemp_30_y nilf_30_y emp_30_y ind_ag_30_y ind_manu_30_y moved_30_y ///
	using ./analyze/output/empind_yfmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_30_ynf nilf_30_ynf emp_30_ynf ind_ag_30_ynf ind_manu_30_ynf moved_30_ynf, $tableopts st(N F J)
esttab unemp_30_ynf nilf_30_ynf emp_30_ynf ind_ag_30_ynf ind_manu_30_ynf moved_30_ynf ///
	using ./analyze/output/empind_ynfmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_30_o nilf_30_o emp_30_o ind_ag_30_o ind_manu_30_o moved_30_o, $tableopts st(N F J)
esttab unemp_30_o nilf_30_o emp_30_o ind_ag_30_o ind_manu_30_o moved_30_o ///
	using ./analyze/output/empind_fmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_30_onf nilf_30_onf emp_30_onf ind_ag_30_onf ind_manu_30_onf moved_30_onf, $tableopts st(N F J)
esttab unemp_30_onf nilf_30_onf emp_30_onf ind_ag_30_onf ind_manu_30_onf moved_30_onf ///
	using ./analyze/output/empind_nfmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_30_w nilf_30_w emp_30_w ind_ag_30_w ind_manu_30_w moved_30_w, $tableopts st(N F J)
esttab unemp_30_w nilf_30_w emp_30_w ind_ag_30_w ind_manu_30_w moved_30_w ///
	using ./analyze/output/empind_wmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_30_nw nilf_30_nw emp_30_nw ind_ag_30_nw ind_manu_30_nw moved_30_nw, $tableopts st(N F J)
esttab unemp_30_nw nilf_30_nw emp_30_nw ind_ag_30_nw ind_manu_30_nw moved_30_nw ///
	using ./analyze/output/empind_nwmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_30_h nilf_30_h emp_30_h ind_ag_30_h ind_manu_30_h moved_30_h, $tableopts st(N F J)
esttab unemp_30_h nilf_30_h emp_30_h ind_ag_30_h ind_manu_30_h moved_30_h ///
	using ./analyze/output/empind_hmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF"  "Emp." "Ag." "Manu." "Migrated") frag


esttab unemp_30_nh nilf_30_nh emp_30_nh ind_ag_30_nh ind_manu_30_nh moved_30_nh, $tableopts st(N F J)
esttab unemp_30_nh nilf_30_nh emp_30_nh ind_ag_30_nh ind_manu_30_nh moved_30_nh ///
	using ./analyze/output/empind_nhmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_30_yh nilf_30_yh emp_30_yh ind_ag_30_yh ind_manu_30_yh moved_30_yh, $tableopts st(N F J)
esttab unemp_30_yh nilf_30_yh emp_30_yh ind_ag_30_yh ind_manu_30_yh moved_30_yh ///
	using ./analyze/output/empind_yhmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag

esttab unemp_30_ynh nilf_30_ynh emp_30_ynh ind_ag_30_ynh ind_manu_30_ynh moved_30_ynh, $tableopts st(N F J)
esttab unemp_30_ynh nilf_30_ynh emp_30_ynh ind_ag_30_ynh ind_manu_30_ynh moved_30_ynh ///
	using ./analyze/output/empind_ynhmw_1930.tex  ///
	, replace $tableopts st(N F J) mtitles("Unemp." "NILF" "Emp." "Ag." "Manu." "Migrated") frag


************ coefplots


coefplot (unemp_30_nag, aseq(Unemp.) mc(blue))  ///
	(unemp_30_ag, aseq(Unemp.) mc(red))  ///
        ( nilf_30_nag, aseq(NILF) mc(blue)) ///
	( nilf_30_ag, aseq(NILF) mc(red))  ///
	( emp_30_nag, aseq(Emp) mc(blue)) ///
	( emp_30_ag, aseq(Emp) mc(red))  ///
        ( ind_ag_30_nag, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_30_ag, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_30_nag, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_30_ag, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Employed NOT in Ag in 1910, Red = Employed in Ag in 1910")
	 graph export ./analyze/output/coefplot_empind_agnag_mw.png, as(png) replace	


coefplot (unemp_30_onf, aseq(Unemp.) mc(blue))  ///
	(unemp_30_o, aseq(Unemp.) mc(red))  ///
        ( nilf_30_onf, aseq(NILF) mc(blue)) ///
	( nilf_30_o, aseq(NILF) mc(red))  ///
	( emp_30_onf, aseq(Emp) mc(blue)) ///
	( emp_30_o, aseq(Emp) mc(red))  ///
        ( ind_ag_30_onf, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_30_o, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_30_onf, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_30_o, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("MW Males >= 18 Yrs. Old in 1910") ///
	 subtitle("Blue = NOT Farm Residents in 1910, Red = Farm Residents in 1910")
	 graph export ./analyze/output/coefplot_empind_fnfold_mw.png, as(png) replace	



coefplot (unemp_30_ynf, aseq(Unemp.) mc(blue))  ///
	(unemp_30_y, aseq(Unemp.) mc(red))  ///
        ( nilf_30_ynf, aseq(NILF) mc(blue)) ///
	( nilf_30_y, aseq(NILF) mc(red))  ///
	( emp_30_ynf, aseq(Emp) mc(blue)) ///
	( emp_30_y, aseq(Emp) mc(red))  ///
        ( ind_ag_30_ynf, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_30_y, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_30_ynf, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_30_y, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("MW Males < 18 Yrs. Old in 1910") ///
	 subtitle("Blue = NOT Farm Residents in 1910, Red = Farm Residents in 1910")
	 graph export ./analyze/output/coefplot_empind_fnfyoung_mw.png, as(png) replace	


coefplot (unemp_30_h, aseq(Unemp.) mc(blue))  ///
	(unemp_30_nh, aseq(Unemp.) mc(red))  ///
        ( nilf_30_h, aseq(NILF) mc(blue)) ///
	( nilf_30_nh, aseq(NILF) mc(red))  ///
	( emp_30_h, aseq(Emp) mc(blue)) ///
	( emp_30_nh, aseq(Emp) mc(red))  ///
        ( ind_ag_30_h, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_30_nh, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_30_h, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_30_nh, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) ylabel(-1(.2)1) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Homeowner , Red = NOT Homeowner")
	 graph export ./analyze/output/coefplot_empind_home_mw.png, as(png) replace	



coefplot (unemp_30_w, aseq(Unemp.) mc(blue))  ///
	(unemp_30_nw, aseq(Unemp.) mc(red))  ///
        ( nilf_30_w, aseq(NILF) mc(blue)) ///
	( nilf_30_nw, aseq(NILF) mc(red))  ///
	( emp_30_w, aseq(Emp) mc(blue)) ///
	( emp_30_nw, aseq(Emp) mc(red))  ///
        ( ind_ag_30_w, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_30_nw, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_30_w, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_30_nw, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = White , Red = Non-White")
	 graph export ./analyze/output/coefplot_empind_race_mw.png, as(png) replace	



coefplot (unemp_30_yh, aseq(Unemp.) mc(blue))  ///
	(unemp_30_ynh, aseq(Unemp.) mc(red))  ///
        ( nilf_30_yh, aseq(NILF) mc(blue)) ///
	( nilf_30_ynh, aseq(NILF) mc(red))  ///
	( emp_30_yh, aseq(Emp) mc(blue)) ///
	( emp_30_ynh, aseq(Emp) mc(red))  ///
        ( ind_ag_30_yh, aseq(Emp=Ag.) mc(blue)) ///
	( ind_ag_30_ynh, aseq(Emp=Ag.) mc(red)) ///
        ( ind_manu_30_yh, aseq(Emp=Manu.) mc(blue))  ///
        ( ind_manu_30_ynh, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Homeowner Parents , Red = NON-Homeowner Parents")
	graph export ./analyze/output/coefplot_empind_youthhome_mw.png, as(png) replace	



coefplot ( moved_30_all, aseq(Ag.) mc(blue))  ///
        ( moved_30_nag, aseq(Non Ag.) mc(blue)) ///
        ( moved_30_w, aseq(White) mc(red))  ///
        ( moved_30_nw, aseq(Not White) mc(red)) ///
	 ( moved_30_h, aseq(Homeowner) mc(green))  ///
        ( moved_30_nh, aseq(Not Homeowner) mc(green)) ///
	 ( moved_30_y, aseq(Young) mc(orange))  ///
        ( moved_30_o, aseq(Old) mc(orange)) ///
	 ( moved_30_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( moved_30_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Migration, 1910-1930") 
	graph export ./analyze/output/coefplot_moved_mw.png, as(png) replace	



coefplot ( emp_30_ag, aseq(Ag.) mc(blue))  ///
        ( emp_30_nag, aseq(Non Ag.) mc(blue)) ///
        ( emp_30_w, aseq(White) mc(red))  ///
        ( emp_30_nw, aseq(Not White) mc(red)) ///
	 ( emp_30_h, aseq(Homeowner) mc(green))  ///
        ( emp_30_nh, aseq(Not Homeowner) mc(green)) ///
	 ( emp_30_y, aseq(Young) mc(orange))  ///
        ( emp_30_o, aseq(Old) mc(orange)) ///
	 ( emp_30_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( emp_30_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Employment, 1910-1930") 
	graph export ./analyze/output/coefplot_emp30_mw.png, as(png) replace	


coefplot ( ind_ag_30_ag, aseq(Ag.) mc(blue))  ///
        ( ind_ag_30_nag, aseq(Non Ag.) mc(blue)) ///
        ( ind_ag_30_w, aseq(White) mc(red))  ///
        ( ind_ag_30_nw, aseq(Not White) mc(red)) ///
	 ( ind_ag_30_h, aseq(Homeowner) mc(green))  ///
        ( ind_ag_30_nh, aseq(Not Homeowner) mc(green)) ///
	 ( ind_ag_30_y, aseq(Young) mc(orange))  ///
        ( ind_ag_30_o, aseq(Old) mc(orange)) ///
	 ( ind_ag_30_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( ind_ag_30_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Agricultural Employment, 1910-1930") 
	graph export ./analyze/output/coefplot_indag30_mw.png, as(png) replace	



coefplot ( ind_manu_30_ag, aseq(Ag.) mc(blue))  ///
        ( ind_manu_30_nag, aseq(Non Ag.) mc(blue)) ///
        ( ind_manu_30_w, aseq(White) mc(red))  ///
        ( ind_manu_30_nw, aseq(Not White) mc(red)) ///
	 ( ind_manu_30_h, aseq(Homeowner) mc(green))  ///
        ( ind_manu_30_nh, aseq(Not Homeowner) mc(green)) ///
	 ( ind_manu_30_y, aseq(Young) mc(orange))  ///
        ( ind_manu_30_o, aseq(Old) mc(orange)) ///
	 ( ind_manu_30_yh, aseq(Child of Homeowner) mc(purple))  ///
        ( ind_manu_30_ynh, aseq(Child of Non-Homeowner) mc(purple)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(tractPerAcre30_10loc) swapnames ///
	 ytitle("") title("Coefficient in Regression Predicting Manufacturing Employment, 1910-1930") 
	graph export ./analyze/output/coefplot_indmanu30_mw.png, as(png) replace	



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



* save all estimates
local i = 1
foreach var of varlist  emp_30 nilf_30 unemp_30 ind_ag_30 ind_manu_30  moved_30 {

estimates restore intAg_`var'
if `i' == 1 {
	estimates save ./analyze/output/intestimates.est, replace
}
if `i' !=1 {
	estimates save ./analyze/output/intestimates.est, append
}

estimates restore intRace_`var'
estimates save ./analyze/output/intestimates.est, append

estimates restore intHome_`var'
estimates save ./analyze/output/intestimates.est, append

estimates restore intHomeYouth_`var'
estimates save ./analyze/output/intestimates.est, append

estimates restore intFarmYouth_`var'
estimates save ./analyze/output/intestimates.est, append


local i = `i' + 1
}
*


* reload estimates 
local i = 1
foreach var of varlist  emp_30 nilf_30 unemp_30 ind_ag_30 ind_manu_30  moved_30 {

estimates use ./analyze/output/intestimates.est, number(`i')
eststo intAg_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates.est, number(`i')
eststo intRace_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates.est, number(`i')
eststo intHome_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates.est, number(`i')
eststo intHomeYouth_`var'
local i = `i' + 1

estimates use ./analyze/output/intestimates.est, number(`i')
eststo intFarmYouth_`var'
local i = `i' + 1

}
*


gen main = .
label var main "Tractors * Ag. Emp."
label var ind_ag_10 "Ag. Emp"
esttab intAg_*_30 ///
	,   keep(main ind_ag_10) $tableopts st(N F J) ///
	frag
esttab intAg_*_30 ///
	using ./analyze/output/intAg_empind30.tex ///
	,  replace keep(main ind_ag_10) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp."  "Emp. = Ag." "Emp. = Manu." "Moved") frag
	
label var main "Tractors * Homeowner"
label var homeowner "Homeowner"
esttab intHome_*_30 ///
	,   keep(main homeowner) $tableopts st(N F J) ///
	frag
esttab intHome_*_30 ///
	using ./analyze/output/intHome_emp30.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp."  "Emp. = Ag." "Emp. = Manu." "Moved") frag

label var main "Tractors * White"
label var white "White"
esttab intRace_*_30 ///
	,   keep(main white) $tableopts st(N F J) ///
	frag
esttab intRace_*_30  ///
	using ./analyze/output/intRace_emp30.tex ///
	,  replace keep(main white) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp."  "Emp. = Ag." "Emp. = Manu." "Moved") frag
	

label var main "Tractors * Homeowner"
label var homeowner "Homeowner"
esttab  intHomeYouth_*_30 ///
	,   keep(main homeowner) $tableopts st(N F J) ///
	frag
esttab  intHomeYouth_*_30 ///
	using ./analyze/output/intHomeYouth_emp30.tex ///
	,  replace keep(main homeowner) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp."  "Emp. = Ag." "Emp. = Manu." "Moved") frag
	

label var main "Tractors * Farm Res."
label var farm_10 "Farm Res."
esttab  intFarmYouth_*_30 ///
	,   keep(main *farm_10*) $tableopts st(N F J) ///
	frag
esttab intFarmYouth_*_30 ///
	using ./analyze/output/intFarmYouth_emp30.tex ///
	,  replace keep(main *farm_10*) $tableopts st(N F J) ///
	mtitles("Emp." "NILF" "Unemp."  "Emp. = Ag." "Emp. = Manu." "Moved") frag
	

