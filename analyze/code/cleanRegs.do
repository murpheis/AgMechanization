set more off, perm
set matsize 11000, perm

cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"



global indControls = "farm_10 white i.age_10  sex_10 homeowner i.lit_10"

global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg valPerAcre_chg10"
global countyControls= "bankstot20 dist_closest_city farmsize10 popperacre10 farmpopperacre10 urbanperacre10 indagperacre10 indmanuperacre10 farmperacre10 valPerAcre10"



// ORIGINAL OLD ONE global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"
// SECOND ROUND global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg ind_manu_pct_chg10 valPerAcre_chg10"
// SECOND ROUND  global countyControls =  "bankstot20 dist_closest_city farmsize10  "

global indControls = "farm_10 white i.age_10  sex_10 homeowner i.lit_10"
global indControls40 = "farm_20 white i.age_20  sex_20 homeowner i.lit_20"
global indControls00 = "farm_00 white i.age_00  sex_00 homeowner i.lit_00"

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

* recode lit
gen lit30 = lit_30 == 4
replace lit30 = . if lit_30 > 4




* IV first stages
reg tract30farm10 crops10farm10 pct_treated_crops_1910 
predict yhat

reg tract30farm10 crops10farm10 pct_treated_crops_1910 if region2num == 2 
predict yhatmw


gen tract30ag10 = tractPerAcre30_10loc* ind_ag_10
replace tract30ag10 = 0 if mi(tract30ag10)
gen crops10ag10 = pct_treated_crops_1910* ind_ag_10
replace crops10ag10 = 0 if mi(crops10ag10)
reg tract30ag10 crops10ag10 pct_treated_crops_1910 
predict yhatemp

reg tract30ag10 crops10ag10 pct_treated_crops_1910  if region2num == 2
predict yhatempmw



reg tractPerAcre30_10loc  pct_treated_crops_1910 
predict yhat2




* industry of employment without conditioning on employed
foreach var of varlist ind_ag_30 ind_mill_30-ind_bank_30 {
 replace `var' = 0 if empstat_30 == 30 
 replace `var' = 0 if empstat_30 == 20 
}


rename occfarmer_30 occfarm_30

gen cov = .
gen cov2 = .
foreach var of varlist   moved_30  unemp_30 emp_30  nilf_30 ind_ag_30 ind_manu_30 lit30  {

di "`var'"

	* Main specification
	
	
	* Main specification, IV
	*replace cov = yhat
	replace cov = yhatemp
	label var cov "Tractors*Ag."
	eststo `var'_agnag: qui reg `var'   cov ind_ag_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_agnag: qui reg `var'   cov ind_ag_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)
	replace cov = yhat
	eststo `var'_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)


	**** MW ONLY
	preserve
	keep if region2num == 2
	replace cov = yhatempmw
	eststo `var'_mw_agnag: qui reg `var'   cov ind_ag_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_mw_agnag: qui reg `var'   cov ind_ag_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)
	replace cov = yhatmw
	eststo `var'_mw_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_mw_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)
	
	restore
	
	* Homeownership
	
	* Main specification, IV
	*replace cov = yhat
	replace cov = yhat2
	eststo `var'_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)


	**** MW ONLY
	preserve
	keep if region2num == 2
	replace cov = yhatempmw
	eststo `var'_mw_agnag: qui reg `var'   cov ind_ag_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_mw_agnag: qui reg `var'   cov ind_ag_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)
	replace cov = yhatmw
	eststo `var'_mw_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var'_mw_fnf: qui reg `var'   cov farm_10 i.countyid $indControls $countyControls $countyControls2 if sex_10 == 1, vce(cluster countyid)
	
	restore
	
	


	/*
	* by age
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV_010: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if age_10 <= 10, vce(cluster countyid)
	eststo reg`var'_1030_IV_1030: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if age_10 > 10 & age_10 <=30, vce(cluster countyid)
	eststo reg`var'_1030_IV_30up: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if age_10 > 30 , vce(cluster countyid)

	replace cov = yhat2*age010
	replace cov2 = yhat2*age1030
	label var cov "Tractors*(Age<10)"
	label var cov2 "Tractors*(10<Age<30)"
	eststo est_`var'_1030_aint: qui reg `var'   cov cov2 yhat2 i.countyid  $indControls $countyControls $countyControls2 if farm_10 == 1, vce(cluster countyid)




	*  by race
	
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV_wh: qui reg `var'  cov i.countyid  $indControls $countyControls $countyControls2 if white, vce(cluster countyid)
	eststo reg`var'_1030_IV_nwh: qui reg `var'  cov i.countyid  $indControls $countyControls $countyControls2 if ~white, vce(cluster countyid)
	replace cov = yhat2*white
	label var cov "Tractors*White"
	eststo est_`var'_1030_rint: qui reg `var'   cov yhat2 i.county  $indControls $countyControls $countyControls2 if farm_10 == 1, vce(cluster countyid)
	
	
	
	*  by homeowner
	label var cov "Tractors*Farm"
	eststo reg`var'_1030_IV_ho: qui reg `var'   cov i.countyid  $indControls $countyControls $countyControls2 if homeowner, vce(cluster countyid)
	eststo reg`var'_1030_IV_nho: qui reg `var'   cov i.countyid  $indControls $countyControls $countyControls2 if ~homeowner, vce(cluster countyid)

	
	replace cov = yhat2*homeowner
	label var cov "Tractors*Homeowner"
	eststo est_`var'_1030_hint: qui reg `var'   cov yhat2 i.county  $indControls $countyControls $countyControls2 if farm_10 == 1, vce(cluster countyid)

	
	**** MEN ONLY
	preserve
	keep if sex_10 == 1
	
	
	* Main specification, IV
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_IV: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2, vce(cluster countyid)

	*  by age group
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_IV_010: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if age_10 <= 10, vce(cluster countyid)
	eststo men_`var'_IV_1030: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if age_10 > 10 & age_10 <=30, vce(cluster countyid)
	eststo men_`var'_IV_30up: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if age_10 > 30 , vce(cluster countyid)

	replace cov = yhat2*age010
	replace cov2 = yhat2*age1030
	label var cov "Tractors*(Age<10)"
	label var cov2 "Tractors*(10<Age<30)"
	eststo men_`var'_1030_aint: qui reg `var'   cov cov2 yhat2 i.countyid  $indControls $countyControls $countyControls2 if farm_10 == 1, vce(cluster countyid)


	*  by race
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_IV_wh: qui reg `var'   cov i.countyid  $indControls $countyControls $countyControls2 if white==1, vce(cluster countyid)
	eststo men_`var'_1030_IV_nwh: qui reg `var'   cov i.countyid $indControls $countyControls $countyControls2 if white==0, vce(cluster countyid)

	replace cov = yhat2*white
	label var cov "Tractors*White"
	eststo men_`var'_1030_rint: qui reg `var'   cov yhat2 i.countyid  $indControls $countyControls $countyControls2 if farm_10 == 1, vce(cluster countyid)
	
	
	*  by homeowner
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo men_`var'_1030_IV_ho: qui reg `var'   cov i.countyid  $indControls $countyControls $countyControls2 if homeowner==1, vce(cluster countyid)
	eststo men_`var'_1030_IV_nho: qui reg `var'   cov i.countyid  $indControls $countyControls $countyControls2 if homeowner==0, vce(cluster countyid)
	
	replace cov = yhat2*homeowner
	label var cov "Tractors*Homeowner"
	eststo men_`var'_1030_hint: qui reg `var'   cov yhat2 i.countyid  $indControls $countyControls $countyControls2 if farm_10 == 1, vce(cluster countyid)

	
	restore
	*/
}



* TABLES


global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"


esttab moved_30_agnag menmoved_30_agnag moved_30_1030_mw_agnag menmoved_30_1030_mw_agnag  , keep(cov) $tableopts
esttab emp_30_agnag menemp_30_agnag emp_30_1030_mw_agnag menemp_30_1030_mw_agnag  , keep(cov) $tableopts
esttab unemp_30_agnag menunemp_30_agnag unemp_30_1030_mw_agnag menunemp_30_1030_mw_agnag  , keep(cov) $tableopts
esttab nilf_30_agnag mennilf_30_agnag nilf_30_1030_mw_agnag mennilf_30_1030_mw_agnag  , keep(cov) $tableopts
esttab ind_ag_30_agnag menind_ag_30_agnag ind_ag_30_1030_mw_agnag menind_ag_30_1030_mw_agnag  , keep(cov) $tableopts
esttab ind_manu_30_agnag menind_manu_30_agnag ind_manu_30_mw_agnag menind_manu_30_mw_agnag  , keep(cov) $tableopts

esttab  moved_30_1030_mw_agnag ind_ag_30_1030_mw_agnag ind_manu_30_mw_agnag ///
	menmoved_30_1030_mw_agnag  menind_ag_30_1030_mw_agnag menind_manu_30_mw_agnag  ///
	using ./analyze/output/indmoved_1030_agnag.tex , replace keep(cov) $tableopts frag
esttab emp_30_1030_mw_agnag nilf_30_1030_mw_agnag unemp_30_1030_mw_agnag ///
	menemp_30_1030_mw_agnag mennilf_30_1030_mw_agnag menunemp_30_1030_mw_agnag ///
	using ./analyze/output/emp_1030_mw_agnag.tex , replace keep(cov) $tableopts frag


esttab  moved_30_1030_mw_fnf ind_ag_30_1030_mw_fnf ind_manu_30_mw_fnf ///
	menmoved_30_1030_mw_fnf  menind_ag_30_1030_mw_fnf menind_manu_30_mw_fnf  ///
	using ./analyze/output/indmoved_1030_fnf.tex , replace keep(cov) $tableopts frag
esttab emp_30_1030_mw_fnf nilf_30_1030_mw_fnf unemp_30_1030_mw_fnf ///
	menemp_30_1030_mw_fnf mennilf_30_1030_mw_fnf menunemp_30_1030_mw_fnf ///
	using ./analyze/output/emp_1030_mw_fnf.tex , replace keep(cov) $tableopts frag


esttab  moved_30_1030_agnag ind_ag_30_1030_agnag ind_manu_30_agnag ///
	menmoved_30_1030_agnag  menind_ag_30_1030_agnag menind_manu_30_agnag  ///
	using ./analyze/output/indmoved_1030_agnag.tex , replace keep(cov) $tableopts frag
esttab emp_30_1030_agnag nilf_30_1030_agnag unemp_30_1030_agnag ///
	menemp_30_1030_agnag mennilf_30_1030_agnag menunemp_30_1030_agnag ///
	using ./analyze/output/emp_1030_agnag.tex , replace keep(cov) $tableopts frag


esttab  moved_30_1030_fnf ind_ag_30_1030_fnf ind_manu_30_fnf ///
	menmoved_30_1030_fnf  menind_ag_30_1030_fnf menind_manu_30_fnf  ///
	using ./analyze/output/indmoved_1030_fnf.tex , replace keep(cov) $tableopts frag
esttab emp_30_1030_fnf nilf_30_1030_fnf unemp_30_1030_fnf ///
	menemp_30_1030_fnf mennilf_30_1030_fnf menunemp_30_1030_fnf ///
	using ./analyze/output/emp_1030_fnf.tex , replace keep(cov) $tableopts frag




/*
label var cov "Tractors*Farm"
esttab   men_emp_30_1030_IV men_unemp_30_1030_IV men_nilf_30_1030_IV men_ind_ag_30_1030_IV men_ind_manu_30_1030_IV ///
	, st(N ) keep(cov) $tableopts  mtitles("Emp" "Unemp" "NILF" "Ag|ILF" "Manu|ILF") fragment
esttab   men_emp_30_1030_IV men_unemp_30_1030_IV men_nilf_30_1030_IV men_ind_ag_30_1030_IV men_ind_manu_30_1030_IV ///
	using ./analyze/output/empIV30_men.tex,  replace ///
	st(N ) keep(cov) ///
	$tableopts  mtitles("Emp" "Unemp" "NILF" "Ag|ILF" "Manu|ILF") fragment
esttab   regemp_30_1030_IV regunemp_30_1030_IV regnilf_30_1030_IV regind_ag_30_1030_IV regind_manu_30_1030_IV ///
	using ./analyze/output/empIV30.tex,  replace ///
	st(N ) keep(cov) ///
	$tableopts  mtitles("Emp" "Unemp" "NILF" "Ag|ILF" "Manu|ILF") fragment


esttab men_unemp_30_1030_IV_wh men_unemp_30_1030_IV_nwh men_unemp_30_1030_rint men_unemp_30_1030_IV_ho men_unemp_30_1030_IV_nho men_unemp_30_1030_hint ///
	using ./analyze/output/men_unempIV30_het.tex,  replace  ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment

esttab regunemp_30_1030_IV_wh regunemp_30_1030_IV_nwh est_unemp_30_1030_rint regunemp_30_1030_IV_ho regunemp_30_1030_IV_nho est_unemp_30_1030_hint ///
	using ./analyze/output/unempIV30_het.tex,  replace  ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment


esttab men_emp_30_1030_IV_wh men_emp_30_1030_IV_nwh men_emp_30_1030_rint men_emp_30_1030_IV_ho men_emp_30_1030_IV_nho men_emp_30_1030_hint ///
	using ./analyze/output/men_empIV30_het.tex,  replace ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm") fragment

esttab regemp_30_1030_IV_wh regemp_30_1030_IV_nwh est_emp_30_1030_rint regemp_30_1030_IV_ho regemp_30_1030_IV_nho est_emp_30_1030_hint ///
	using ./analyze/output/empIV30_het.tex,  replace ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm") fragment


esttab men_nilf_30_1030_IV_wh men_nilf_30_1030_IV_nwh men_nilf_30_1030_rint men_nilf_30_1030_IV_ho men_nilf_30_1030_IV_nho men_nilf_30_1030_hint ///
	using ./analyze/output/men_nilfIV30_het.tex,  replace  ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment


esttab regnilf_30_1030_IV_wh regnilf_30_1030_IV_nwh est_nilf_30_1030_rint regnilf_30_1030_IV_ho regnilf_30_1030_IV_nho est_nilf_30_1030_hint ///
	using ./analyze/output/nilfIV30_het.tex,  replace  ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment


esttab men_moved_30_1030_IV_wh men_moved_30_1030_IV_nwh men_moved_30_1030_rint men_moved_30_1030_IV_ho men_moved_30_1030_IV_nho men_moved_30_1030_hint ///
	using ./analyze/output/men_movedIV30_het.tex,  replace   ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment


esttab regmoved_30_1030_IV_wh regmoved_30_1030_IV_nwh est_moved_30_1030_rint regmoved_30_1030_IV_ho regmoved_30_1030_IV_nho est_moved_30_1030_hint ///
	using ./analyze/output/movedIV30_het.tex,  replace   ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment


esttab men_lit30_1030_IV_wh men_lit30_1030_IV_nwh men_lit30_1030_rint men_lit30_1030_IV_ho men_lit30_1030_IV_nho men_lit30_1030_hint ///
	using ./analyze/output/men_movedIV30_het.tex,  replace ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment


esttab reglit30_1030_IV_wh reglit30_1030_IV_nwh est_lit30_1030_rint reglit30_1030_IV_ho reglit30_1030_IV_nho est_lit30_1030_hint ///
	using ./analyze/output/litIV30_het.tex, replace ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("White" "Not White" "White*Tract|Farm"  "Homeowner" "Non-Homeowner"  "Home*Tract|Farm" ) fragment



esttab men_unemp_30_IV_010 men_unemp_30_IV_1030 men_unemp_30_IV_30up  ///
	using ./analyze/output/unempIV30_agehet.tex, replace  ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("0-10" "10-30" "$>$30" ) fragment




esttab men_emp_30_IV_010 men_emp_30_IV_1030 men_emp_30_IV_30up  ///
	using ./analyze/output/empIV30_agehet.tex, replace ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("0-10" "10-30" "$>$30" ) fragment




label var cov "Tractors*(age<=10)"
label var cov2 "Tractors*(10<age<=30)"
esttab men_emp_30_1030_aint men_unemp_30_1030_aint men_nilf_30_1030_aint ///
	,  ///
	st(N ) keep(cov cov2) ///
	$tableopts  mtitles("emp" "unemp" "nilf") fragment


esttab men_moved_30_IV_010 men_moved_30_IV_1030 men_moved_30_IV_30up  ///
	,  ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("0-10" "10-30" "$>$30" ) fragment
	

esttab men_lit30_IV_010 men_lit30_IV_1030 men_lit30_IV_30up men_lit30_1030_aint ///
	,  ///
	st(N ) keep(cov cov2) ///
	$tableopts  mtitles("0-10" "10-30" "$>$30" "Int") fragment

*/

/*
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

*/

	



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




* IV first stages
reg tract30farm00 crops10farm00 pct_treated_crops_1910 
predict yhat

reg tractPerAcre30_10loc  pct_treated_crops_1910 
predict yhat2

reg tract30farm00 crops10farm00 pct_treated_crops_1910 if region2num == 2
predict yhatmw

reg tractPerAcre30_10loc  pct_treated_crops_1910  if region2num == 2
predict yhatmw2


gen cov = .

foreach var of varlist  moved_10 lit10 emp_10 unemp_10 nilf_10 ind_ag_10 ind_manu_10 {


	* farm v non-farm w county FEs
	replace cov = yhat
	label var cov "Tractors*Farm"
	eststo reg`var': qui reg `var' farm_00  cov i.countyid white i.age_00 sex_00 homeowner $countyControls $countyControls2, vce(cluster countyid)
	eststo men`var': qui reg `var' farm_00  cov i.countyid white i.age_00 sex_00 homeowner $countyControls $countyControls2 if sex_00 == 1, vce(cluster countyid)
	replace cov = yhatmw
	eststo mw`var': qui reg `var' farm_00  cov i.countyid white i.age_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 2, vce(cluster countyid)
	eststo mwxy`var': qui reg `var' farm_00  cov i.countyid white i.age_00 sex_00 homeowner $countyControls $countyControls2 if region2num == 2 & sex_00 == 1, vce(cluster countyid)


}


esttab regmoved_10 menmoved_10 mwmoved_10 mwxymoved_10 ///
	using ./analyze/output/moved_pretrend.tex, keep(cov) replace ///
	st(N ) ///
	$tableopts  mtitles("All" "Men" "MW" "MW Men" ) fragment


esttab regemp_10 menemp_10 mwemp_10 mwxyemp_10 ///
	using ./analyze/output/emp_pretrend.tex, keep(cov) replace ///
	st(N ) ///
	$tableopts  mtitles("All" "Men" "MW" "MW Men" ) fragment

esttab regunemp_10 menunemp_10 mwunemp_10 mwxyunemp_10 ///
	using ./analyze/output/unemp_pretrend.tex, keep(cov) replace ///
	st(N ) ///
	$tableopts  mtitles("All" "Men" "MW" "MW Men" ) fragment

esttab regnilf_10 mennilf_10 mwnilf_10 mwxynilf_10 ///
	using ./analyze/output/nilf_pretrend.tex, keep(cov) replace ///
	st(N ) ///
	$tableopts  mtitles("All" "Men" "MW" "MW Men" ) fragment

esttab regind_ag_10 menind_ag_10 mwind_ag_10 mwind_ag_10 ///
	using ./analyze/output/indag_pretrend.tex, keep(cov) replace ///
	st(N ) ///
	$tableopts  mtitles("All" "Men" "MW" "MW Men" ) fragment

esttab regind_manu_10 menind_manu_10 mwind_manu_10 mwind_manu_10 ///
	using ./analyze/output/indmanu_pretrend.tex, keep(cov) replace ///
	st(N ) ///
	$tableopts  mtitles("All" "Men" "MW" "MW Men" ) fragment
	

	esttab  menmoved_10 mwxymoved_10 menmoved_30_fnf menmoved_30_1030_mw_fnf ///
		using ./analyze/output/moved_001030.tex, replace ///
		st(N ) ///
		$tableopts  mtitles("US Men" "MW Men" "US Men" "MW Men" ) fragment


	esttab menemp_10 mwxyemp_10 menemp_30_fnf menemp_30_1030_mw_fnf ///
		using ./analyze/output/emp_001030.tex, keep(cov) replace ///
		st(N ) ///
		$tableopts  mtitles("US Men" "MW Men" "US Men" "MW Men" ) fragment

	esttab menunemp_10 mwxyunemp_10 menunemp_30_fnf menunemp_30_1030_mw_fnf ///
		using ./analyze/output/unemp_001030.tex, keep(cov) replace ///
		st(N ) ///
		$tableopts  mtitles("US Men" "MW Men" "US Men" "MW Men") fragment

	esttab mennilf_10 mwxynilf_10 mennilf_30_fnf mennilf_30_1030_mw_fnf ///
		using ./analyze/output/nilf_001030.tex, keep(cov) replace ///
		st(N ) ///
		$tableopts  mtitles("US Men" "MW Men" "US Men" "MW Men") fragment

	esttab menind_ag_10 mwxyind_ag_10 menind_ag_30_fnf menind_ag_30_1030_mw_fnf ///
		using ./analyze/output/indag_001030.tex, keep(cov) replace ///
		st(N ) ///
		$tableopts  mtitles("MW" "MW Men" "MW" "MW Men" ) fragment

	esttab menind_manu_10 menind_manu_10 menind_manu_30_fnf menind_manu_30_mw_fnf ///
		using ./analyze/output/indmanu_001030.tex, keep(cov) replace ///
		st(N ) ///
		$tableopts  mtitles("MW" "MW Men" "MW" "MW Men" ) fragment



estimates save ./analyze/output/linkedregests_0010, replace




esttab regmoved_10_0010_IV menmoved_10_0010_IV mwmoved_10_0010_IV, keep(cov)


esttab reglit10_0010_IV menlit10_0010_IV mwlit10_0010_IV, keep(cov)

esttab  regmoved_10_0010_IV regmoved_30_1030_IV menmoved_10_0010_IV  men_moved_30_1030_IV ///
	using ./analyze/output/moved_pretrend.tex, replace ///
	st(N ) keep(cov ) ///
	$tableopts  mtitles("1900-10" "1910-30" "1900-10" "1910-30" ) fragment




esttab reglit10_0010_IV reglit30_1030_IV menlit10_0010_IV men_lit30_1030_IV, keep(cov)




************************
**** 1920-1940 REGS ****
************************

use ./analyze/temp/regdata2040.dta, clear

label var farm_20 "Farm"

label var crops10farm20 "Grains * Farm"
label var crops10white20 "Grains * White"
label var crops10white20farm "Grains * White * Farm"
label var crops10home "Grains * Homeowner"
label var crops10homefarm "Grains * Homeowner * Farm"

replace incwage_40 = . if incwage_40 == 999998



gen emp_40 = empstat_40 == 10




* IV first stage
reg tract20farm20 crops10farm20 pct_treated_crops_1910 
predict yhat

gen cov = .


*** EDUCATION ***

* basic education result
replace cov = yhat
eststo regsomeHS_40_2040_IV: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo regsomeHS_40_2040_RF: qui reg someHS_40 farm_20  crops10farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
eststo mensomeHS_40_2040_IV: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & sex_20 == 1, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo mensomeHS_40_2040_RF: qui reg someHS_40 farm_20  crops10farm20 i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & sex_20 == 1, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"

* education placebo
replace cov = yhat
eststo regsomeHS_placebo_2040_IV: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 >= 18, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"
eststo mensomeHS_placebo_2040_IV: qui reg someHS_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 >= 18 & sex_20 == 1, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"

* ed heterogeneity
replace cov = yhat
eststo regsomeHS_IV_white: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & white==1, vce(cluster county)
eststo regsomeHS_IV_notwhite: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & white==0, vce(cluster county)
eststo regsomeHS_IV_home: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & homeowner==1, vce(cluster county)
eststo regsomeHS_IV_nothome: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & homeowner==0, vce(cluster county)

eststo regsomeHS_IV_xy: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & sex_20==1, vce(cluster county)
eststo regsomeHS_IV_xx: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & sex_20==2, vce(cluster county)

eststo regsomeHS_IV_mw: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & region2num == 2, vce(cluster county)
eststo regsomeHS_IV_mwplac: qui reg someHS_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 >= 18 & region2num==2, vce(cluster county)

        

coefplot (regsomeHS_placebo_2040_IV, aseq(Age >= 18) mc(blue))  ///
	(regsomeHS_40_2040_IV, aseq(Age < 18) mc(blue))  ///
        ( regsomeHS_IV_white, aseq(White) mc(red)) ///
	( regsomeHS_IV_notwhite, aseq(Not White) mc(red))  ///
        ( regsomeHS_IV_home, aseq(Homeowner) mc(green)) ///
	( regsomeHS_IV_nothome, aseq(Not Homeowner) mc(green))  ///
        ( regsomeHS_IV_xx, aseq(Female Identified) mc(orange)) ///
	( regsomeHS_IV_xy, aseq(Male Identified) mc(orange)) ///
	, m(circle) msize(large) ciopts(lcolor(black))  ///
	 xline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Impact of Tractors on High School Educational Attainment") 
graph export ./analyze/output/educhet_coefplot.png, as(png) replace






* basic unemployment result
label var cov "Tractors*Farm"
eststo regunemployed_40_2040_IV: qui reg unemployed_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"



* basic employment result
label var cov "Tractors*Farm"
eststo regemp_40_2040_IV: qui reg emp_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"


* ed heterogeneity
replace cov = yhat
eststo emp40_IV_white: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & white==1, vce(cluster county)
eststo emp40_IV_notwhite: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if age_20 < 18 & white==0, vce(cluster county)
eststo emp40_IV_home: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & homeowner==1, vce(cluster county)
eststo emp40_IV_nothome: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if age_20 < 18 & homeowner==0, vce(cluster county)
eststo emp40_IV_youth: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   age_20 <=18 &  ~nilf_40, vce(cluster county)
eststo emp40_IV_notyouth: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if  age_20 > 18&  ~nilf_40, vce(cluster county)
eststo emp40_IV_ag40: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    occfarmer_40==1, vce(cluster county)
eststo emp40_IV_nonag40: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    occfarmer_40 == 0 & emp_40 ==1, vce(cluster county)
eststo emp40_IV_noemp40: qui reg emp_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   emp_40==0, vce(cluster county)




* basic nilf result
label var cov "Tractors*Farm"
replace cov = yhat
eststo regnilf_40_2040_IV: qui reg nilf_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 , vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"



* basic income result
label var cov "Tractors*Farm"
replace cov = yhat
eststo reginc_40_2040_IV: qui reg incwage_40 farm_20  cov i.county white age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if ~nilf_40, vce(cluster county)
estadd local FEs "Y"
estadd local Controls "Y"
estadd local IV "Y"



replace cov = yhat
eststo regunemp_IV_white: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if !nilf_40 & white==1, vce(cluster county)
eststo regunemp_IV_notwhite: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if !nilf_40 & white==0, vce(cluster county)
eststo regunemp_IV_home: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if !nilf_40 & homeowner==1, vce(cluster county)
eststo regunemp_IV_nothome: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if !nilf_40 & homeowner==0, vce(cluster county)
eststo regunemp_IV_youth: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   age_20 <=18 &  ~nilf_40, vce(cluster county)
eststo regunemp_IV_notyouth: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if  age_20 > 18&  ~nilf_40, vce(cluster county)
eststo regunemp_IV_ag40: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    occfarmer_40==1, vce(cluster county)
eststo regunemp_IV_nonag40: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    occfarmer_40 == 0 & emp_40 ==1, vce(cluster county)
eststo regunemp_IV_noemp40: qui reg unemployed_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   emp_40==0, vce(cluster county)



replace cov = yhat
eststo reginc_IV_white: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if  white==1 &  ~nilf_40, vce(cluster county)
eststo reginc_IV_notwhite: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 homeowner $countyControls $countyControls2 if  white==0 &  ~nilf_40, vce(cluster county)
eststo reginc_IV_home: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if   homeowner==1 &  ~nilf_40, vce(cluster county)
eststo reginc_IV_nothome: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white $countyControls $countyControls2 if  homeowner==0 &  ~nilf_40, vce(cluster county)
eststo reginc_IV_youth: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   age_20 <=18 &  ~nilf_40, vce(cluster county)
eststo reginc_IV_notyouth: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if  age_20 > 18&  ~nilf_40, vce(cluster county)
eststo reginc_IV_ag40: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    occfarmer_40==1, vce(cluster county)
eststo reginc_IV_nonag40: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    occfarmer_40 == 0 & emp_40 ==1, vce(cluster county)
eststo reginc_IV_noemp40: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   emp_40==0, vce(cluster county)
eststo reginc_IV_moved40: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if   moved_40==1, vce(cluster county)
eststo reginc_IV_stayed40: qui reg incwage_40 farm_20  cov i.county  age_20 agesq_20 sex_20 white homeowner $countyControls $countyControls2 if    moved_40== 0 , vce(cluster county)


/*
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

*/

* TABLES


global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"


esttab  regsomeHS_plac* regsomeHS_40_2040_IV  regsomeHS_IV_notwhite   regsomeHS_IV_nothome ///
	using ./analyze/output/educIV_het.tex,  replace ///
	st(N ) drop(*cons*  *county* *homeowner* $countyControls $countyControls2 white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("Some HS, Age $>$ 18" "Some HS, Age $<$ 18" "Non-White"  "Non-Homeowner") fragment

esttab   regemp_40_2040_IV regunemployed_40_2040_IV regnilf_40_2040_IV reginc_40_2040_IV ///
	using ./analyze/output/empIV40.tex,  replace ///
	st(N ) drop(*cons*  *county* *homeowner* $countyControls $countyControls2 white age_* agesq_* sex_* homeowner* farm*) ///
	$tableopts  mtitles("Emp" "Unemp" "NILF" "Wages, USD") fragment

esttab   emp40_IV_white emp40_IV_notwhite emp40_IV_home emp40_IV_nothome  ///
	using ./analyze/output/empIV40_het.tex,  replace  ///
	st(N ) keep(cov) ///
	$tableopts  mtitles("White" "Not White" "Homeowner" "Non-Homeowner") fragment


esttab regunemp_IV_white regunemp_IV_notwhite regunemp_IV_home regunemp_IV_nothome ///
	using ./analyze/output/unempIV40_het.tex,  replace  ///
	st(N ) keep(cov) ///
	$tableopts  mtitles("White" "Not White" "Homeowner" "Non-Homeowner") fragment



esttab reginc_IV_youth reginc_IV_notyouth reginc_IV_white reginc_IV_notwhite reginc_IV_home reginc_IV_nothome ///
	using ./analyze/output/incIV40_het1.tex,  replace  ///
	st(N ) keep(cov) ///
	$tableopts  mtitles("Youth" "Adult" "White" "Not White" "Homeowner" "Non-Homeowner") fragment


esttab  reginc_IV_ag40 reginc_IV_nonag40  reginc_IV_noemp40 reginc_IV_moved40  reginc_IV_stayed40    ///
	using ./analyze/output/incIV40_het2.tex,  replace  ///
	st(N ) keep(cov) ///
	$tableopts  mtitles("Farmer, 1940" "Other Employment, 1940" "No Emp, 1940" "Moved" "Stayed") fragment







************************
****   MAKE TABLES  ****
************************

global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"


	
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


* industry 
esttab ols_ind_ag_30_farm ols_ind_manu_30_farm ols_ind_mill_30_farm ols_ind_retail_30_farm ols_ind_railroad_30_farm ///
	using ./analyze/output/ind_ols_farm.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab ols_ind_ag_30_nonfarm ols_ind_manu_30_nonfarm ols_ind_mill_30_nonfarm ols_ind_retail_30_nonfarm ols_ind_railroad_30_nonfarm ///
	using ./analyze/output/ind_ols_nonfarm.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_farm iv_ind_manu_30_farm iv_ind_mill_30_farm iv_ind_retail_30_farm iv_ind_railroad_30_farm ///
	using ./analyze/output/ind_iv_farm.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_nonfarm iv_ind_manu_30_nonfarm iv_ind_mill_30_nonfarm iv_ind_retail_30_nf iv_ind_railroad_30_nf ///
	using ./analyze/output/ind_iv_nonfarm.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab ols_ind_ag_30_ag ols_ind_manu_30_ag ols_ind_mill_30_ag ols_ind_retail_30_ag ols_ind_railroad_30_ag ///
	using ./analyze/output/ind_ols_ag.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_ag iv_ind_manu_30_ag iv_ind_mill_30_ag iv_ind_retail_30_ag iv_ind_railroad_30_ag ///
	using ./analyze/output/ind_iv_ag.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab ols_ind_ag_30_all ols_ind_manu_30_all ols_ind_mill_30_all ols_ind_retail_30_all ols_ind_railroad_30_all ///
	using ./analyze/output/ind_ols_all.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_all iv_ind_manu_30_all iv_ind_mill_30_all iv_ind_retail_30_all iv_ind_railroad_30_all ///
	using ./analyze/output/ind_iv_all.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")



esttab ols_ind_ag_30_farm_xy ols_ind_manu_30_farm_xy ols_ind_mill_30_farm_xy ols_ind_retail_30_farm_xy ols_ind_railroad_30_farm_xy ///
	using ./analyze/output/ind_ols_farm_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab ols_ind_ag_30_nonfarm_xy ols_ind_manu_30_nonfarm_xy ols_ind_mill_30_nonfarm_xy ols_ind_retail_30_nf_xy ols_ind_railroad_30_nf_xy ///
	using ./analyze/output/ind_ols_nonfarm_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_farm_xy iv_ind_manu_30_farm_xy iv_ind_mill_30_farm_xy iv_ind_retail_30_farm_xy iv_ind_railroad_30_farm_xy ///
	using ./analyze/output/ind_iv_farm_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_nonfarm_xy iv_ind_manu_30_nonfarm_xy iv_ind_mill_30_nonfarm_xy iv_ind_retail_30_nf_xy iv_ind_railroad_30_nf_xy ///
	using ./analyze/output/ind_iv_nonfarm_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab ols_ind_ag_30_ag_xy ols_ind_manu_30_ag_xy ols_ind_mill_30_ag_xy ols_ind_retail_30_ag_xy ols_ind_railroad_30_ag_xy ///
	using ./analyze/output/ind_ols_ag_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_ag_xy iv_ind_manu_30_ag_xy iv_ind_mill_30_ag_xy iv_ind_retail_30_ag_xy iv_ind_railroad_30_ag_xy ///
	using ./analyze/output/ind_iv_ag_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")


esttab ols_ind_ag_30_all_xy ols_ind_manu_30_all_xy ols_ind_mill_30_all_xy ols_ind_retail_30_all_xy ols_ind_railroad_30_all_xy ///
	using ./analyze/output/ind_ols_all_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

esttab iv_ind_ag_30_all_xy iv_ind_manu_30_all_xy iv_ind_mill_30_all_xy iv_ind_retail_30_all_xy iv_ind_railroad_30_all_xy ///
	using ./analyze/output/ind_iv_all_xy.tex, replace drop(*county* $countyControls $countyControls2  age_* agesq_* sex_* homeowner* white) $tableopts  mtitles("Ag." "Manu." "Mill" "Retail" "Rail")

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
	
