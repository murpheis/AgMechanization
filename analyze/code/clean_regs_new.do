set more off, perm

cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"


global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg valPerAcre_chg10"
global countyControls= "bankstot20 dist_closest_city farmsize10 popperacre10 farmpopperacre10 urbanperacre10 indagperacre10 indmanuperacre10 farmperacre10 valPerAcre10"
//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"
//global countyControls =  "bankstot20 dist_closest_city farmsize10  "
//global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg ind_manu_pct_chg10 valPerAcre_chg10"
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


* industry of employment without conditioning on employed
foreach var of varlist ind_ag_30 ind_mill_30-ind_bank_30 {
 replace `var' = 0 if empstat_30 == 30 
 replace `var' = 0 if empstat_30 == 20 
}

* recode lit
gen lit30 = lit_30 == 4
replace lit30 = . if lit_30 > 4




* IV first stages
reg tract30farm10 crops10farm10 pct_treated_crops_1910 
predict yhat

reg tractPerAcre30_10loc  pct_treated_crops_1910 
predict yhat2


reg tractPerAcre30_10loc  pct_treated_crops_1910  if region2num == 2
predict yhatmw


rename occfarmer_30 occfarm_30

gen cov = .


***** no county FEs ****

local industries "ind_ag_30 ind_manu_30 unemp_30 emp_30 nilf_30  moved_30 "
foreach var of varlist `industries' {
/*
	label var cov "Tractors"
	
	* all sexes
	replace cov = yhat2
	eststo iv_`var'_all: qui reg `var' cov i.stateicp $indControls $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm: qui reg `var' cov i.stateicp $indControls $countyControls $countyControls2 if farm_10, vce(cluster county)
	eststo iv_`var'_nf: qui reg `var' cov i.stateicp $indControls $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo iv_`var'_ag: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ind_ag_10==1, vce(cluster county)
	eststo iv_`var'_nag: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ind_ag_10==0 & empstat_10 == 10, vce(cluster county)

	
	*men only
	preserve
	keep if sex_10 == 1
	eststo iv_`var'_all_xy: qui reg `var' cov i.stateicp $indControls $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_xy: qui reg `var' cov  i.stateicp $indControls $countyControls $countyControls2 if farm_10, vce(cluster county)
	eststo iv_`var'_nf_xy: qui reg `var' cov i.stateicp $indControls $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo iv_`var'_ag_xy: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ind_ag_10==1, vce(cluster county)
	eststo iv_`var'_nag_xy: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ind_ag_10==0 & empstat_10 == 10, vce(cluster county)
	restore


	*no mw
	preserve
	drop if region2num == 2
	eststo iv_`var'_all_nmw: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_nmw: qui reg `var' cov  i.stateicp  $indControls $countyControls $countyControls2 if farm_10, vce(cluster county)
	eststo iv_`var'_nf_nmw: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo iv_`var'_ag_nmw: qui reg `var' cov i.stateicp   $indControls $countyControls $countyControls2 if ind_ag_10==1, vce(cluster county)
	eststo iv_`var'_nag_nmw: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ind_ag_10==0 & empstat_10 == 10, vce(cluster county)
	restore
*/

	* only mw
	preserve
	keep if region2num == 2
	replace cov = yhatmw
	eststo iv_`var'_all_mw: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_mw: qui reg `var' cov  i.stateicp  $indControls $countyControls $countyControls2 if farm_10, vce(cluster county)
	eststo iv_`var'_nf_mw: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ~farm_10, vce(cluster county)
	eststo iv_`var'_ag_mw: qui reg `var' cov i.stateicp   $indControls $countyControls $countyControls2 if ind_ag_10==1, vce(cluster county)
	eststo iv_`var'_nag_mw: qui reg `var' cov i.stateicp  $indControls $countyControls $countyControls2 if ind_ag_10==0 & empstat_10 == 10, vce(cluster county)
	restore


}


* MAKE SOME TABLES


esttab iv_unemp_30_ag iv_nilf_30_ag iv_emp_30_ag iv_ind_ag_30_ag iv_ind_manu_30_ag ///
	iv_unemp_30_nag  iv_nilf_30_nag iv_emp_30_nag iv_ind_ag_30_nag iv_ind_manu_30_nag ///
	using ./analyze/output/indemp_agnag_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." "Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_30_ag_xy iv_nilf_30_ag_xy iv_emp_30_ag_xy iv_ind_ag_30_ag_xy iv_ind_manu_30_ag_xy ///
	iv_unemp_30_nag_xy  iv_nilf_30_nag_xy iv_emp_30_nag_xy iv_ind_ag_30_nag_xy iv_ind_manu_30_nag_xy ///
	using ./analyze/output/indemp_agnag_xy_frag.tex, replace keep(cov) ///
	$tableopts fragment  mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." "Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_30_ag_mw iv_nilf_30_ag_mw iv_emp_30_ag_mw iv_ind_ag_30_ag_mw iv_ind_manu_30_ag_mw ///
	iv_unemp_30_nag_mw  iv_nilf_30_nag_mw iv_emp_30_nag_mw iv_ind_ag_30_nag_mw iv_ind_manu_30_nag_mw ///
	using ./analyze/output/indemp_agnag_mw_frag.tex, replace keep(cov) ///
	$tableopts fragment  mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." "Unemp."  "NILF" "Emp" "Ag." "Manu." )




esttab iv_unemp_30_farm  iv_nilf_30_farm iv_emp_30_farm iv_ind_ag_30_farm iv_ind_manu_30_farm ///
	using ./analyze/output/indemp_farm_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_30_ag iv_nilf_30_ag iv_emp_30_ag iv_ind_ag_30_ag iv_ind_manu_30_ag ///
	using ./analyze/output/indemp_ag_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_30_nag  iv_nilf_30_nag iv_emp_30_nag iv_ind_ag_30_nag iv_ind_manu_30_nag ///
	using ./analyze/output/indemp_nag_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_30_nf  iv_nilf_30_nf iv_emp_30_nf iv_ind_ag_30_nf iv_ind_manu_30_nf ///
	using ./analyze/output/indemp_nf_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )
	

esttab iv_unemp_30_all  iv_nilf_30_all iv_emp_30_all iv_ind_ag_30_all iv_ind_manu_30_all ///
	using ./analyze/output/indemp_all_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )
	



esttab iv_unemp_30_farm_mw  iv_nilf_30_farm_mw iv_emp_30_farm_mw iv_ind_ag_30_farm_mw iv_ind_manu_30_farm_mw ///
	using ./analyze/output/indemp_farm_mw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_30_ag_mw iv_nilf_30_ag_mw iv_emp_30_ag_mw iv_ind_ag_30_ag_mw iv_ind_manu_30_ag_mw ///
	using ./analyze/output/indemp_ag_mw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_30_nag_mw  iv_nilf_30_nag_mw iv_emp_30_nag_mw iv_ind_ag_30_nag_mw iv_ind_manu_30_nag_mw ///
	using ./analyze/output/indemp_nag_mw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_30_nf_mw  iv_nilf_30_nf_mw iv_emp_30_nf_mw iv_ind_ag_30_nf_mw iv_ind_manu_30_nf_mw ///
	using ./analyze/output/indemp_nf_mw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )
	

esttab iv_unemp_30_all_mw  iv_nilf_30_all_mw iv_emp_30_all_mw iv_ind_ag_30_all_mw iv_ind_manu_30_all_mw ///
	using ./analyze/output/indemp_all_mw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )
	


esttab iv_unemp_30_farm_xy  iv_nilf_30_farm_xy iv_emp_30_farm_xy iv_ind_ag_30_farm_xy iv_ind_manu_30_farm_xy ///
	using ./analyze/output/indemp_farm_xy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_30_ag_xy iv_nilf_30_ag_xy iv_emp_30_ag_xy iv_ind_ag_30_ag_xy iv_ind_manu_30_ag_xy ///
	using ./analyze/output/indemp_ag_xy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_30_nag_xy  iv_nilf_30_nag_xy iv_emp_30_nag_xy iv_ind_ag_30_nag_xy iv_ind_manu_30_nag_xy ///
	using ./analyze/output/indemp_nag_xy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_30_nf_xy  iv_nilf_30_nf_xy iv_emp_30_nf_xy iv_ind_ag_30_nf_xy iv_ind_manu_30_nf_xy ///
	using ./analyze/output/indemp_nf_xy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp." "Emp" "NILF" "Ag." "Manu." )
	

esttab iv_unemp_30_all_xy  iv_nilf_30_all_xy iv_emp_30_all_xy iv_ind_ag_30_all_xy iv_ind_manu_30_all_xy ///
	using ./analyze/output/indemp_all_xy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )
	

coefplot (iv_unemp_30_nf, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_30_farm, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_30_nf, aseq(NILF) mc(blue)) ///
	( iv_nilf_30_farm, aseq(NILF) mc(red))  ///
	( iv_emp_30_nf, aseq(Emp) mc(blue)) ///
	( iv_emp_30_farm, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_30_nf, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_30_farm, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_30_nf, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_30_farm, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Non-Farm, Red = Farm")
	 graph export ./analyze/output/coefplot_empind.png, as(png) replace	



coefplot (iv_unemp_30_nag, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_30_ag, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_30_nag, aseq(NILF) mc(blue)) ///
	( iv_nilf_30_ag, aseq(NILF) mc(red))  ///
	( iv_emp_30_nag, aseq(Emp) mc(blue)) ///
	( iv_emp_30_ag, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_30_nag, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_30_ag, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_30_nag, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_30_ag, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Employed NOT in Ag in 1910, Red = Employed in Ag in 1910")
	 graph export ./analyze/output/coefplot_empind_agnag.png, as(png) replace	


coefplot (iv_unemp_30_nf_mw, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_30_farm_mw, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_30_nf_mw, aseq(NILF) mc(blue)) ///
	( iv_nilf_30_farm_mw, aseq(NILF) mc(red))  ///
	( iv_emp_30_nf_mw, aseq(Emp) mc(blue)) ///
	( iv_emp_30_farm_mw, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_30_nf_mw, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_30_farm_mw, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_30_nf_mw, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_30_farm_mw, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames  ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930 (MidWest)") ///
	 subtitle("Blue = Non-Farm, Red = Farm") ylabel(-.3(.05).3)
	 graph export ./analyze/output/coefplot_empind_mw.png, as(png) replace	



coefplot (iv_unemp_30_nag_mw, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_30_ag_mw, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_30_nag_mw, aseq(NILF) mc(blue)) ///
	( iv_nilf_30_ag_mw, aseq(NILF) mc(red))  ///
	( iv_emp_30_nag_mw, aseq(Emp) mc(blue)) ///
	( iv_emp_30_ag_mw, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_30_nag_mw, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_30_ag_mw, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_30_nag_mw, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_30_ag_mw, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ylabel(-.3(.05).3) ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930 (MidWest)") ///
	 subtitle("Blue = Employed NOT in Ag in 1910, Red = Employed in Ag in 1910")
	 graph export ./analyze/output/coefplot_empind_mw_agnag.png, as(png) replace	




coefplot (iv_unemp_30_all, aseq(Unemp.) mc(blue))  ///
        ( iv_nilf_30_all, aseq(NILF) mc(blue)) ///
	( iv_emp_30_all, aseq(Emp) mc(blue)) ///
        ( iv_ind_ag_30_all, aseq(Emp=Ag.) mc(blue)) ///
        ( iv_ind_manu_30_all, aseq(Emp=Manu.) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Full Population in Sample")
	 graph export ./analyze/output/coefplot_empind_all.png, as(png) replace	




coefplot (iv_unemp_30_nf_mw, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_30_farm_mw, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_30_nf_mw, aseq(NILF) mc(blue)) ///
	( iv_nilf_30_farm_mw, aseq(NILF) mc(red))  ///
	( iv_emp_30_nf_mw, aseq(Emp) mc(blue)) ///
	( iv_emp_30_farm_mw, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_30_nf_mw, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_30_farm_mw, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_30_nf_mw, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_30_farm_mw, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Non-Farm, Red = Farm")
	 graph export ./analyze/output/coefplot_empind_mw.png, as(png) replace	



coefplot (iv_unemp_30_nag_mw, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_30_ag_mw, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_30_nag_mw, aseq(NILF) mc(blue)) ///
	( iv_nilf_30_ag_mw, aseq(NILF) mc(red))  ///
	( iv_emp_30_nag_mw, aseq(Emp) mc(blue)) ///
	( iv_emp_30_ag_mw, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_30_nag_mw, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_30_ag_mw, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_30_nag_mw, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_30_ag_mw, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Blue = Employed NOT in Ag in 1910, Red = Employed in Ag in 1910")
	 graph export ./analyze/output/coefplot_empind_agnag_mw.png, as(png) replace	


coefplot (iv_unemp_30_all_mw, aseq(Unemp.) mc(blue))  ///
        ( iv_nilf_30_all_mw, aseq(NILF) mc(blue)) ///
	( iv_emp_30_all_mw, aseq(Emp) mc(blue)) ///
        ( iv_ind_ag_30_all_mw, aseq(Emp=Ag.) mc(blue)) ///
        ( iv_ind_manu_30_all_mw, aseq(Emp=Manu.) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1930") ///
	 subtitle("Full Population in Sample")
	 graph export ./analyze/output/coefplot_empind_all_mw.png, as(png) replace	




	


/*
* DO STUFF BY AGE
foreach num of numlist 1890 1895 1900 1905 1910 {

eststo emp30_`num': qui reg emp_30  yhat2   $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==1, vce(cluster county)
eststo unemp30_`num': qui reg unemp_30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==1, vce(cluster county)
eststo indag30_`num': qui reg ind_ag_30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==1, vce(cluster county)
eststo indmanu30_`num': qui reg ind_manu_30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==1, vce(cluster county)
eststo moved30_`num': qui reg moved_30  yhat2 $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==1, vce(cluster county)
eststo lit30_`num': qui reg lit30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==1, vce(cluster county)


eststo emp30nf_`num': qui reg emp_30  yhat2   $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==0, vce(cluster county)
eststo unemp30nf_`num': qui reg unemp_30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==0, vce(cluster county)
eststo indag30nf_`num': qui reg ind_ag_30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==0, vce(cluster county)
eststo indmanu30nf_`num': qui reg ind_manu_30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==0, vce(cluster county)
eststo moved30nf_`num': qui reg moved_30  yhat2 $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==0, vce(cluster county)
eststo lit30nf_`num': qui reg lit30  yhat2  $indControls $countyControls $countyControls2 i.county if birthyr_10 == `num' & farm_10==0, vce(cluster county)


/*
*mw
preserve
keep if region2num == 2
eststo emp30_`num'_mw: qui reg emp_30  yhatmw   $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
eststo unemp30_`num'_mw: qui reg unemp_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
eststo nilf30_`num'_mw: qui reg nilf_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
eststo indag30_`num'_mw: qui reg ind_ag_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
eststo indmanu30_`num'_mw: qui reg ind_manu_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
eststo moved30_`num'_mw: qui reg moved_30  yhatmw $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
eststo lit30_`num'_mw: qui reg lit30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10, vce(cluster county)
restore


*mw
preserve
keep if region2num == 2
*eststo emp30_`num'_mw_nf: qui reg emp_30  yhatmw   $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
*eststo unemp30_`num'_mw_nf: qui reg unemp_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
eststo nilf30_`num'_mw_nf: qui reg nilf_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
*eststo indag30_`num'_mw_nf: qui reg ind_ag_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
*eststo indmanu30_`num'_mw_nf: qui reg ind_manu_30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
*eststo moved30_`num'_mw_nf: qui reg moved_30  yhatmw $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
*eststo lit30_`num'_mw_nf: qui reg lit30  yhatmw  $indControls $countyControls $countyControls2 i.stateicp if birthyr_10 == `num' & farm_10==0, vce(cluster county)
restore
*/

}


esttab emp30_1890 emp30_1895  emp30_1900 emp30_1905  emp30_1910 , keep(yhat2) se
esttab emp30nf_1890 emp30nf_1895  emp30nf_1900 emp30nf_1905  emp30nf_1910 , keep(yhat2) se

esttab unemp30_1890 unemp30_1895  unemp30_1900 unemp30_1905  unemp30_1910 , keep(yhat2) se
esttab unemp30nf_1890 unemp30nf_1895  unemp30nf_1900 unemp30nf_1905  unemp30nf_1910 , keep(yhat2) se


esttab moved30_1890 moved30_1895  moved30_1900 moved30_1905  moved30_1910 , keep(yhat2) se
esttab moved30nf_1890 moved30nf_1895  moved30nf_1900 moved30nf_1905  moved30nf_1910 , keep(yhat2) se



esttab emp30_1890_mw emp30_1895_mw  emp30_1900_mw emp30_1905_mw  emp30_1910_mw , keep(yhatmw) se
esttab emp30_1890_mw_nf emp30_1895_mw_nf  emp30_1900_mw_nf emp30_1905_mw_nf  emp30_1910_mw_nf , keep(yhatmw) se


esttab unemp30_1890_mw unemp30_1895_mw  unemp30_1900_mw unemp30_1905_mw  unemp30_1910_mw , keep(yhatmw) se
esttab unemp30_1890_mw_nf unemp30_1895_mw_nf  unemp30_1900_mw_nf unemp30_1905_mw_nf  unemp30_1910_mw_nf , keep(yhatmw) se


esttab nilf30_1890_mw nilf30_1895_mw  nilf30_1900_mw nilf30_1905_mw  nilf30_1910_mw , keep(yhatmw) se
esttab nilf30_1890_mw_nf nilf30_1895_mw_nf  nilf30_1900_mw_nf nilf30_1905_mw_nf  nilf30_1910_mw_nf , keep(yhatmw) se


esttab indag30_1890_mw indag30_1895_mw  indag30_1900_mw indag30_1905_mw  indag30_1910_mw , keep(yhatmw) se
esttab indag30_1890_mw_nf indag30_1895_mw_nf  indag30_1900_mw_nf indag30_1905_mw_nf  indag30_1910_mw_nf , keep(yhatmw) se

esttab indmanu30_1890_mw indmanu30_1895_mw  indmanu30_1900_mw indmanu30_1905_mw  indmanu30_1910_mw , keep(yhatmw) se
esttab indmanu30_1890_mw_nf indmanu30_1895_mw_nf  indmanu30_1900_mw_nf indmanu30_1905_mw_nf  indmanu30_1910_mw_nf , keep(yhatmw) se


esttab lit30_1890_mw lit30_1895_mw  lit30_1900_mw lit30_1905_mw  lit30_1910_mw , keep(yhatmw) se
esttab lit30_1890_mw_nf lit30_1895_mw_nf  lit30_1900_mw_nf lit30_1905_mw_nf  lit30_1910_mw_nf , keep(yhatmw) se


esttab moved30_1890_mw moved30_1895_mw  moved30_1900_mw moved30_1905_mw  moved30_1910_mw , keep(yhatmw) se
esttab moved30_1890_mw_nf moved30_1895_mw_nf  moved30_1900_mw_nf moved30_1905_mw_nf  moved30_1910_mw_nf , keep(yhatmw) se



coefplot (indag30_1890_mw, aseq(1890) mc(blue))  ///
	(indag30_1890_mw_nf, aseq(1890) mc(red))  ///
        ( indag30_1895_mw, aseq(1895) mc(blue)) ///
	( indag30_1895_mw_nf, aseq(1895) mc(red))  ///
        ( indag30_1900_mw, aseq(1900) mc(blue)) ///
	( indag30_1900_mw_nf, aseq(1900) mc(red))  ///
        ( indag30_1905_mw, aseq(1905) mc(blue)) ///
	( indag30_1905_mw_nf, aseq(1905) mc(red)) ///
        ( indag30_1910_mw, aseq(1910) mc(blue))  ///
        ( indag30_1910_mw_nf, aseq(1910) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(yhatmw) swapnames ///
	 xtitle("Year of Birth") title("Coefficient in Regression Predicting Agricultural Employment, 1930") ///
	 subtitle("Red = Non-Farm, Blue = Farm")
	 graph export ./analyze/output/coefplot1030_indag_age.png, as(png) replace
	

coefplot (indmanu30_1890_mw, aseq(1890) mc(blue))  ///
	(indmanu30_1890_mw_nf, aseq(1890) mc(red))  ///
        ( indmanu30_1895_mw, aseq(1895) mc(blue)) ///
	( indmanu30_1895_mw_nf, aseq(1895) mc(red))  ///
        ( indmanu30_1900_mw, aseq(1900) mc(blue)) ///
	( indmanu30_1900_mw_nf, aseq(1900) mc(red))  ///
        ( indmanu30_1905_mw, aseq(1905) mc(blue)) ///
	( indmanu30_1905_mw_nf, aseq(1905) mc(red)) ///
        ( indmanu30_1910_mw, aseq(1910) mc(blue))  ///
        ( indmanu30_1910_mw_nf, aseq(1910) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(yhatmw) swapnames ///
	 xtitle("Year of Birth") title("Coefficient in Regression Predicting Manufacturing Employment, 1930") ///
	 subtitle("Red = Non-Farm, Blue = Farm")
	 graph export ./analyze/output/coefplot1030_indmanu_age.png, as(png) replace
		
	
coefplot (emp30_1890_mw, aseq(1890) mc(blue))  ///
	(emp30_1890_mw_nf, aseq(1890) mc(red))  ///
        ( emp30_1895_mw, aseq(1895) mc(blue)) ///
	( emp30_1895_mw_nf, aseq(1895) mc(red))  ///
        ( emp30_1900_mw, aseq(1900) mc(blue)) ///
	( emp30_1900_mw_nf, aseq(1900) mc(red))  ///
        ( emp30_1905_mw, aseq(1905) mc(blue)) ///
	(emp30_1905_mw_nf, aseq(1905) mc(red)) ///
        ( emp30_1910_mw, aseq(1910) mc(blue))  ///
        ( emp30_1910_mw_nf, aseq(1910) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(yhatmw) swapnames ///
	 xtitle("Year of Birth") title("Coefficient in Regression Predicting Employment, 1930") ///
	 subtitle("Red = Non-Farm, Blue = Farm")
	 graph export ./analyze/output/coefplot1030_emp_age.png, as(png) replace
	

coefplot (unemp30_1890_mw, aseq(1890) mc(blue))  ///
	(unemp30_1890_mw_nf, aseq(1890) mc(red))  ///
        ( unemp30_1895_mw, aseq(1895) mc(blue)) ///
	( unemp30_1895_mw_nf, aseq(1895) mc(red))  ///
        ( unemp30_1900_mw, aseq(1900) mc(blue)) ///
	( unemp30_1900_mw_nf, aseq(1900) mc(red))  ///
        ( unemp30_1905_mw, aseq(1905) mc(blue)) ///
	(unemp30_1905_mw_nf, aseq(1905) mc(red)) ///
        ( unemp30_1910_mw, aseq(1910) mc(blue))  ///
        ( unemp30_1910_mw_nf, aseq(1910) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(yhatmw) swapnames ///
	 xtitle("Year of Birth") title("Coefficient in Regression Predicting Unemployment, 1930") ///
	 subtitle("Red = Non-Farm, Blue = Farm")
	 graph export ./analyze/output/coefplot1030_unemp_age.png, as(png) replace



coefplot (moved30_1890_mw, aseq(1890) mc(blue))  ///
	(moved30_1890_mw_nf, aseq(1890) mc(red))  ///
        ( moved30_1895_mw, aseq(1895) mc(blue)) ///
	( moved30_1895_mw_nf, aseq(1895) mc(red))  ///
        ( moved30_1900_mw, aseq(1900) mc(blue)) ///
	( moved30_1900_mw_nf, aseq(1900) mc(red))  ///
        ( moved30_1905_mw, aseq(1905) mc(blue)) ///
	(moved30_1905_mw_nf, aseq(1905) mc(red)) ///
        ( moved30_1910_mw, aseq(1910) mc(blue))  ///
        ( moved30_1910_mw_nf, aseq(1910) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(yhatmw) swapnames ///
	 xtitle("Year of Birth") title("Coefficient in Regression Predicting Migration, 1930") ///
	 subtitle("Red = Non-Farm, Blue = Farm")
	 graph export ./analyze/output/coefplot1030_moved_age.png, as(png) replace


*/


************************
**** 1920-1940 REGS ****
************************

use ./analyze/temp/regdata2040.dta, clear

label var farm_20 "Farm"

gen unemp_40 = empstat_40 >= 20 & empstat_40 < 30

gen emp_40 = empstat_40 >= 10 & empstat_40 < 20

* industry of employment without conditioning on employed
foreach var of varlist ind_ag_40 ind_mill_40-ind_bank_40 {
 replace `var' = 0 if empstat_40 == 30 
 replace `var' = 0 if empstat_40 == 20 
}


* gen 
gen tract40farm20 = tractPerAcre40_20loc * farm_20

* IV first stages
reg tract40farm20 crops10farm20 pct_treated_crops_1910 
predict yhat

reg tractPerAcre40_20loc  pct_treated_crops_1910 
predict yhat2


reg tractPerAcre40_20loc  pct_treated_crops_1910  if region2num == 2
predict yhatmw


label var crops10farm20 "Grains * Farm"
label var crops10white20 "Grains * White"
label var crops10white20farm "Grains * White * Farm"
label var crops10home "Grains * Homeowner"
label var crops10homefarm "Grains * Homeowner * Farm"

replace incwage_40 = . if incwage_40 == 999998



gen cov = .




***** no county FEs ****

local outcomes "someHS_40 unemp_40 emp_40 nilf_40  moved_40 incwage_40 ind_ag_40 ind_manu_40"
foreach var of varlist `outcomes' {

	label var cov "Tractors"
	
	* all sexes
	replace cov = yhat2
	eststo iv_`var'_all: qui reg `var' cov i.stateicp $indControls40 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm: qui reg `var' cov i.stateicp $indControls40 $countyControls $countyControls2 if farm_20, vce(cluster county)
	eststo iv_`var'_nf: qui reg `var' cov i.stateicp $indControls40 $countyControls $countyControls2 if ~farm_20, vce(cluster county)
	eststo iv_`var'_ag: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ind_ag_20==1 & labforce_20 == 2, vce(cluster county)
	eststo iv_`var'_nag: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ind_ag_20==0 & labforce_20 == 2, vce(cluster county)

	*men only
	preserve
	keep if sex_20 == 1
	eststo iv_`var'_all_xy: qui reg `var' cov i.stateicp $indControls40 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_xy: qui reg `var' cov  i.stateicp $indControls40 $countyControls $countyControls2 if farm_20, vce(cluster county)
	eststo iv_`var'_nf_xy: qui reg `var' cov i.stateicp $indControls40 $countyControls $countyControls2 if ~farm_20, vce(cluster county)
	eststo iv_`var'_ag_xy: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ind_ag_20==1 & labforce_20 == 2, vce(cluster county)
	eststo iv_`var'_nag_xy: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ind_ag_20==0 & labforce_20 == 2, vce(cluster county)
	restore


	/**no mw
	preserve
	drop if region2num == 2
	eststo iv_`var'_all_nmw: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_nmw: qui reg `var' cov  i.stateicp  $indControls40 $countyControls $countyControls2 if farm_20, vce(cluster county)
	eststo iv_`var'_nf_nmw: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ~farm_20, vce(cluster county)
	eststo iv_`var'_ag_nmw: qui reg `var' cov i.stateicp   $indControls40 $countyControls $countyControls2 if ind_ag_20==1, vce(cluster county)
	restore */

	* only mw
	preserve
	keep if region2num == 2
	replace cov = yhatmw
	eststo iv_`var'_all_mw: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_mw: qui reg `var' cov  i.stateicp  $indControls40 $countyControls $countyControls2 if farm_20, vce(cluster county)
	eststo iv_`var'_nf_mw: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ~farm_20, vce(cluster county)
	eststo iv_`var'_ag_mw: qui reg `var' cov i.stateicp   $indControls40 $countyControls $countyControls2 if ind_ag_20==1 & labforce_20 == 2, vce(cluster county)
	eststo iv_`var'_nag_mw: qui reg `var' cov i.stateicp  $indControls40 $countyControls $countyControls2 if ind_ag_20==0 & labforce_20 == 2, vce(cluster county)
	restore


}


* fragment tables 
esttab iv_unemp_40_farm iv_emp_40_farm iv_nilf_40_farm  iv_unemp_40_ag iv_emp_40_ag iv_nilf_40_ag ///
	using ./analyze/output/emp40_iv_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp." "Emp" "NILF" "Unemp." "Emp" "NILF" )

esttab iv_unemp_40_farm_mw iv_emp_40_farm_mw iv_nilf_40_farm_mw  iv_unemp_40_ag_mw iv_emp_40_ag_mw iv_nilf_40_ag_mw ///
	using ./analyze/output/emp40_iv_frag_mw.tex, replace  keep(cov) ///
	$tableopts fragment mtitles("Unemp." "Emp" "NILF" "Unemp." "Emp" "NILF" )


esttab iv_unemp_40_farm_xy iv_emp_40_farm_xy iv_nilf_40_farm_xy  iv_unemp_40_ag_xy iv_emp_40_ag_xy iv_nilf_40_ag_xy ///
	using ./analyze/output/emp40_iv_frag_xy.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp." "Emp" "NILF" "Unemp." "Emp" "NILF" )


esttab iv_moved_40_farm iv_incwage_40_farm iv_moved_40_ag iv_incwage_40_ag ///
	, keep(cov) ///
	$tableopts fragment mtitles("moved" "inc" "moved" "inc" )



* DO STUFF BY AGE
foreach num of numlist /*1890 1895*/ 1900 1905 1910 1915 1920 {

eststo someHS_`num': qui reg someHS_40  yhat2   $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo emp40_`num': qui reg emp_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo unemp40_`num': qui reg unemp_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo nilf40_`num': qui reg nilf_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo indag40_`num': qui reg ind_ag_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo indmanu40_`num': qui reg ind_manu_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo moved40_`num': qui reg moved_40  yhat2 $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo inc40_`num': qui reg incwage_40  yhat2 $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)



eststo someHS_`num'_nf: qui reg someHS_40  yhat2   $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo emp40_`num'_nf: qui reg emp_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo unemp40_`num'_nf: qui reg unemp_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo nilf40_`num'_nf: qui reg nilf_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo indag40_`num'_nf: qui reg ind_ag_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo indmanu40_`num'_nf: qui reg ind_manu_40  yhat2  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo moved40_`num'_nf: qui reg moved_40  yhat2 $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo inc40_`num'_nf: qui reg incwage_40  yhat2 $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)



*mw
preserve
keep if region2num == 2
eststo someHS_`num'_mw: qui reg someHS_40  yhatmw   $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo emp40_`num'_mw: qui reg emp_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo unemp40_`num'_mw: qui reg unemp_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo nilf40_`num'_mw: qui reg nilf_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo indag40_`num'_mw: qui reg ind_ag_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo indmanu40_`num'_mw: qui reg ind_manu_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo moved40_`num'_mw: qui reg moved_40  yhatmw $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
eststo inc40_`num'_mw: qui reg incwage_40  yhatmw $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20, vce(cluster county)
restore


*mw
preserve
keep if region2num == 2
eststo someHS_`num'_mw_nf: qui reg someHS_40  yhatmw   $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo emp40_`num'_mw_nf: qui reg emp_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo unemp40_`num'_mw_nf: qui reg unemp_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo nilf40_`num'_mw_nf: qui reg nilf_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo indag40_`num'_mw_nf: qui reg ind_ag_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo indmanu40_`num'_mw_nf: qui reg ind_manu_40  yhatmw  $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo moved40_`num'_mw_nf: qui reg moved_40  yhatmw $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
eststo inc40_`num'_mw_nf: qui reg incwage_40  yhatmw $indControls40 $countyControls $countyControls2 i.county if birthyr_20 == `num' & farm_20==0, vce(cluster county)
restore


}


esttab inc40_1890  inc40_1895  inc40_1900 inc40_1905 inc40_1910 inc40_1915 , keep(yhat2) $tableOpts
esttab inc40_1890_nf  inc40_1895_nf  inc40_1900_nf inc40_1905_nf inc40_1910_nf inc40_1915_nf , keep(yhat2) $tableOpts



esttab inc40_1890_mw  inc40_1895_mw  inc40_1900_mw inc40_1905_mw inc40_1910_mw inc40_1915_mw , keep(yhatmw) $tableOpts
esttab inc40_1890_mw_nf  inc40_1895_mw_nf  inc40_1900_mw_nf inc40_1905_mw_nf inc40_1910_mw_nf inc40_1915_mw_nf , keep(yhatmw) $tableOpts




esttab someHS_1890_mw  someHS_1895_mw  someHS_1900_mw someHS_1905_mw someHS_1910_mw someHS_1915_mw , keep(yhatmw) $tableOpts
esttab someHS_1890_mw_nf  someHS_1895_mw_nf  someHS_1900_mw_nf someHS_1905_mw_nf someHS_1910_mw_nf someHS_1915_mw_nf , keep(yhatmw) $tableOpts



esttab someHS_1890  someHS_1895  someHS_1900 someHS_1905 someHS_1910 someHS_1915, keep(yhat2) $tableOpts
esttab someHS_1890_nf  someHS_1895_nf  someHS_1900_nf someHS_1905_nf someHS_1910_nf someHS_1915_nf , keep(yhat2) $tableOpts




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


reg tractPerAcre30_10loc  pct_treated_crops_1910  if region2num == 2
predict yhatmw


gen cov = .


***** no county FEs ****

local industries " unemp_10 emp_10 nilf_10  moved_10 ind_ag_10 ind_manu_10 "
foreach var of varlist `industries' {

	label var cov "Tractors"
	
	* all sexes
	replace cov = yhat2
	eststo iv_`var'_all: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 if farm_00, vce(cluster county)
	eststo iv_`var'_nf: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 if ~farm_00, vce(cluster county)
	eststo iv_`var'_lab: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 if labforce_00==2, vce(cluster county)
	
	
	*men only
	preserve
	keep if sex_10 == 1
	eststo iv_`var'_all_xy: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_xy: qui reg `var' cov  i.stateicp $indConstrols00 $countyControls $countyControls2 if farm_00, vce(cluster county)
	eststo iv_`var'_nf_xy: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 if ~farm_00, vce(cluster county)
	eststo iv_`var'_lab_xy: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 if labforce_00==2, vce(cluster county)
	restore


	* only mw
	preserve
	keep if region2num == 2
	replace cov = yhatmw
	eststo iv_`var'_all_mw: qui reg `var' cov i.stateicp  $indConstrols00 $countyControls $countyControls2 , vce(cluster county)
	eststo iv_`var'_farm_mw: qui reg `var' cov  i.stateicp  $indConstrols00 $countyControls $countyControls2 if farm_00, vce(cluster county)
	eststo iv_`var'_nf_mw: qui reg `var' cov i.stateicp  $indConstrols00 $countyControls $countyControls2 if ~farm_00, vce(cluster county)
	eststo iv_`var'_lab_mw: qui reg `var' cov i.stateicp $indConstrols00 $countyControls $countyControls2 if labforce_00==2, vce(cluster county)
	restore


}



esttab iv_emp_10_all iv_unemp_10_all iv_nilf_10_all iv_moved_10_all iv_ind_ag_10_all iv_ind_manu_10_all , keep(cov) se
esttab iv_emp_10_farm iv_unemp_10_farm iv_nilf_10_farm iv_moved_10_farm iv_ind_ag_10_farm iv_ind_manu_10_farm , keep(cov) se
esttab iv_emp_10_nf iv_unemp_10_nf iv_nilf_10_nf iv_moved_10_nf iv_ind_ag_10_nf iv_ind_manu_10_nf , keep(cov) se
esttab iv_emp_10_lab iv_unemp_10_lab iv_nilf_10_lab iv_moved_10_lab iv_ind_ag_10_lab iv_ind_manu_10_lab , keep(cov) se

esttab iv_emp_10_all_xy iv_unemp_10_all_xy iv_nilf_10_all_xy iv_moved_10_all_xy iv_ind_ag_10_all_xy iv_ind_manu_10_all_xy , keep(cov) se
esttab iv_emp_10_farm_xy iv_unemp_10_farm_xy iv_nilf_10_farm_xy iv_moved_10_farm_xy iv_ind_ag_10_farm_xy iv_ind_manu_10_farm_xy , keep(cov) se
esttab iv_emp_10_nf_xy iv_unemp_10_nf_xy iv_nilf_10_nf_xy iv_moved_10_nf_xy iv_ind_ag_10_nf_xy iv_ind_manu_10_nf_xy , keep(cov) se
esttab iv_emp_10_lab_xy iv_unemp_10_lab_xy iv_nilf_10_lab_xy iv_moved_10_lab_xy iv_ind_ag_10_lab_xy iv_ind_manu_10_lab_xy , keep(cov) se


esttab iv_emp_10_all_mw iv_unemp_10_all_mw iv_nilf_10_all_mw iv_moved_10_all_mw iv_ind_ag_10_all_mw iv_ind_manu_10_all_mw , keep(cov) se
esttab iv_emp_10_farm_mw iv_unemp_10_farm_mw iv_nilf_10_farm_mw iv_moved_10_farm_mw iv_ind_ag_10_farm_mw iv_ind_manu_10_farm_mw , keep(cov) se
esttab iv_emp_10_nf_mw iv_unemp_10_nf_mw iv_nilf_10_nf_mw iv_moved_10_nf_mw iv_ind_ag_10_nf_mw iv_ind_manu_10_nf_mw , keep(cov) se
esttab iv_emp_10_lab_mw iv_unemp_10_lab_mw iv_nilf_10_lab_mw iv_moved_10_lab_mw iv_ind_ag_10_lab_mw iv_ind_manu_10_lab_mw , keep(cov) se



* MAKE SOME TABLES


esttab iv_unemp_10_all iv_nilf_10_all iv_emp_10_all iv_ind_ag_10_all iv_ind_manu_10_all ///
	using ./analyze/output/indemp10_all_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_10_all_xy iv_nilf_10_all_xy iv_emp_10_all_xy iv_ind_ag_10_all_xy iv_ind_manu_10_all_xy ///
	using ./analyze/output/indemp10_allxy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_10_all_mw iv_nilf_10_all_mw iv_emp_10_all_mw iv_ind_ag_10_all_mw iv_ind_manu_10_all_mw ///
	using ./analyze/output/indemp10_allmw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_10_lab iv_nilf_10_lab iv_emp_10_lab iv_ind_ag_10_lab iv_ind_manu_10_lab ///
	using ./analyze/output/indemp10_lab_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_10_lab_xy iv_nilf_10_lab_xy iv_emp_10_lab_xy iv_ind_ag_10_lab_xy iv_ind_manu_10_lab_xy ///
	using ./analyze/output/indemp10_labxy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_10_lab_mw iv_nilf_10_lab_mw iv_emp_10_lab_mw iv_ind_ag_10_lab_mw iv_ind_manu_10_lab_mw ///
	using ./analyze/output/indemp10_labmw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." )



esttab iv_unemp_10_farm iv_nilf_10_farm iv_emp_10_farm iv_ind_ag_10_farm iv_ind_manu_10_farm ///
	iv_unemp_10_nf  iv_nilf_10_nf iv_emp_10_nf iv_ind_ag_10_nf iv_ind_manu_10_nf ///
	using ./analyze/output/indemp10_fnf_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." "Unemp."  "NILF" "Emp" "Ag." "Manu." )


esttab iv_unemp_10_farm_xy iv_nilf_10_farm_xy iv_emp_10_farm_xy iv_ind_ag_10_farm_xy iv_ind_manu_10_farm_xy ///
	iv_unemp_10_nf_xy  iv_nilf_10_nf_xy iv_emp_10_nf_xy iv_ind_ag_10_nf_xy iv_ind_manu_10_nf_xy ///
	using ./analyze/output/indemp10_fnfxy_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." "Unemp."  "NILF" "Emp" "Ag." "Manu." )

esttab iv_unemp_10_farm_mw iv_nilf_10_farm_mw iv_emp_10_farm_mw iv_ind_ag_10_farm_mw iv_ind_manu_10_farm_mw ///
	iv_unemp_10_nf_mw  iv_nilf_10_nf_mw iv_emp_10_nf_mw iv_ind_ag_10_nf_mw iv_ind_manu_10_nf_mw ///
	using ./analyze/output/indemp10_fnfmw_frag.tex, replace keep(cov) ///
	$tableopts fragment mtitles("Unemp."  "NILF" "Emp" "Ag." "Manu." "Unemp."  "NILF" "Emp" "Ag." "Manu." )




coefplot (iv_unemp_10_nf_mw, aseq(Unemp.) mc(blue))  ///
	(iv_unemp_10_farm_mw, aseq(Unemp.) mc(red))  ///
        ( iv_nilf_10_nf_mw, aseq(NILF) mc(blue)) ///
	( iv_nilf_10_farm_mw, aseq(NILF) mc(red))  ///
	( iv_emp_10_nf_mw, aseq(Emp) mc(blue)) ///
	( iv_emp_10_farm_mw, aseq(Emp) mc(red))  ///
        ( iv_ind_ag_10_nf_mw, aseq(Emp=Ag.) mc(blue)) ///
	( iv_ind_ag_10_farm_mw, aseq(Emp=Ag.) mc(red)) ///
        ( iv_ind_manu_10_nf_mw, aseq(Emp=Manu.) mc(blue))  ///
        ( iv_ind_manu_10_farm_mw, aseq(Emp=Manu.) mc(red)) ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	 subtitle("Blue = Non-Farm, Red = Farm") ylabel(-.3(.05).3) 
	 graph export ./analyze/output/coefplot_empind_1910mw.png, as(png) replace	




coefplot (iv_unemp_10_all_mw, aseq(Unemp.) mc(blue))  ///
        ( iv_nilf_10_all_mw, aseq(NILF) mc(blue)) ///
	( iv_emp_10_all_mw, aseq(Emp) mc(blue)) ///
        ( iv_ind_ag_10_all_mw, aseq(Emp=Ag.) mc(blue)) ///
        ( iv_ind_manu_10_all_mw, aseq(Emp=Manu.) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	 subtitle("Full Population in Sample")
	 graph export ./analyze/output/coefplot_empind_all_1910mw.png, as(png) replace	



coefplot (iv_unemp_10_lab_mw, aseq(Unemp.) mc(blue))  ///
        ( iv_nilf_10_lab_mw, aseq(NILF) mc(blue)) ///
	( iv_emp_10_lab_mw, aseq(Emp) mc(blue)) ///
        ( iv_ind_ag_10_lab_mw, aseq(Emp=Ag.) mc(blue)) ///
        ( iv_ind_manu_10_lab_mw, aseq(Emp=Manu.) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	 subtitle("Labor Force Participants")
	 graph export ./analyze/output/coefplot_empind_lab_1910mw.png, as(png) replace	


	
* compare to 1930
coefplot ( iv_nilf_10_nf_mw, aseq(NILF 1910) mc(blue)) ///
	( iv_nilf_10_farm_mw, aseq(NILF 1910) mc(red))  ///
	( iv_nilf_30_nf_mw, aseq(NILF 1930) mc(blue)) ///
	( iv_nilf_30_farm_mw, aseq(NILF 1930) mc(red))  ///
	( iv_emp_10_nf_mw, aseq(Emp 1910) mc(blue)) ///
	( iv_emp_10_farm_mw, aseq(Emp 1910) mc(red))  ///
	( iv_emp_30_nf_mw, aseq(Emp 1930) mc(blue)) ///
	( iv_emp_30_farm_mw, aseq(Emp 1930) mc(red))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status") ///
	 subtitle("Blue = Non-Farm, Red = Farm") ylabel(-.3(.05).3) 
	 graph export ./analyze/output/coefplot_empind1030_mw.png, as(png) replace	



coefplot (iv_unemp_10_all, aseq(Unemp.) mc(blue))  ///
        ( iv_nilf_10_all, aseq(NILF) mc(blue)) ///
	( iv_emp_10_all, aseq(Emp) mc(blue)) ///
        ( iv_ind_ag_10_all, aseq(Emp=Ag.) mc(blue)) ///
        ( iv_ind_manu_10_all, aseq(Emp=Manu.) mc(blue))  ///
	, m(circle) msize(large) ciopts(lcolor(black)) vertical ///
	 yline(0) legend(off) keep(cov) swapnames ///
	 xtitle("") title("Coefficient in Regression Predicting Employment Status in 1910") ///
	 subtitle("Full Population in Sample") ylabel(-.3(.05).3) 
	 graph export ./analyze/output/coefplot_empind_all_1910.png, as(png) replace	
