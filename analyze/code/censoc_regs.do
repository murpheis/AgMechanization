
set scheme plotplain , permanently
set more off, perm
set matsize 11000  



cd "/home/ipums/emily-ipums/TechChange/"




//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"
global countyControls1 =  "bankstot20 dist_closest_city farmsize10  "
global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg ind_manu_pct_chg10 valPerAcre_chg10"



* import data
use "/home/ipums/emily-ipums/WPA/clean/output/censoc1940.dta", clear


*merge to tractors
gen state = stateicp
gen county = countyicp
rename statefip statefipnum
merge m:1 state county year using ./clean/output/tractorVars.dta
keep if _m == 3
drop _m

* merge controls
merge m:1 state county year using ./clean/output/countyFCwithControls.dta
keep if _m == 3
drop _m

* REDUCDE SIZE FOR FUTZING
*gen rand = runiform()
*keep if rand < 0.1
*drop rand


* age at death variable
*gen age_at_death = dyear - birthyr


* pubicly employed in 1940
gen publicEmp1940 = empstat == 11



* farm resident variables
replace farm = farm - 1
gen tract40farm40 = farm*tractPerAcre40
gen crops10farm40 = farm*pct_treated_crops_1910




* race variables
drop white
gen white = race < 200 
gen tract20white = white*tractPerAcre40
gen whitefarm = white*farm
gen whitefarmtract = white*farm*tractPerAcre40
gen crops10white = white*pct_treated_crops_1910
gen crops10whitefarm = white*pct_treated_crops_1910*farm



* age related variables
gen agesq = age^2
gen age010 = age < 10
gen age1030 = age >= 10 & age < 30
gen age010tract = age010 * tractPerAcre40
gen age1030tract = age1030 * tractPerAcre40
gen age010farm = age010 * farm
gen age1030farm = age1030 * farm
gen age010tractfarm = age010 * tractPerAcre40 * farm
gen age1030tractfarm = age1030 * tractPerAcre40 * farm
gen crops10age010 = age010*pct_treated_crops_1910
gen crops10age1030 = age1030*pct_treated_crops_1910
gen crops10age010farm = age010*pct_treated_crops_1910 * farm
gen crops10age1030farm = age1030*pct_treated_crops_1910 * farm




* LABEL VARIABLES
label var agesq "age sq."
label var sex "female"


* factor variables
tab educ, gen(educcat)
tab race, gen(racecat)
tab sex, gen(sexcat)



* first stage predictions

* charts

preserve

keep if age_at_death > 40 & ~mi(age_at_death) & region2num == 2 & age < 18 & farm == 1
reg tractPerAcre40 pct_treated_crops_1910 if region2num == 2
predict yhatMW

reg yhatMW $countyControls1 $countyControls2 i.sex i.race i.educ age agesq i.state
predict yhatMW_res, resid

sum yhatMW_res if region2num == 2 & farm == 1, de 


twoway (hist age_at_death if yhatMW_res < -.03, color(green) discrete) ///
	///
	(hist age_at_death if yhatMW_res >= 0.03, color(blue) fcolor(none) discrete) ///
	, legend(ring(0) pos(1) label(1 "Few Tractors") label(2 "Many Tractors")) ///
	xtitle("Age at Death")
	graph export ./analyze/output/histogram_deathage.png, as(png) replace
restore




* regressions

global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"

preserve
keep if region2num == 2 & sex == 1 & age_at_death >= 45
label var farm "Farm Res."
label var pct_treated_crops_1910 "Pct. Treated Crops, 1910"
label var crops10farm40 "Crops * Farm"
eststo clear
eststo : qui reg age_at_death i.byear pct_treated_crops_1910 i.state $countyControls $countyControls2 sexcat1 white
eststo : qui reg age_at_death i.byear pct_treated_crops_1910 i.state $countyControls $countyControls2 sexcat1 white if farm == 1
eststo : qui reg age_at_death i.byear pct_treated_crops_1910 i.state $countyControls $countyControls2 sexcat1 white if farm == 0
eststo : qui reg age_at_death farm i.byear   crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 
eststo : qui reg age_at_death farm i.byear   crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 if age < 18
eststo : qui reg age_at_death farm i.byear   crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 if age >=  18
esttab *, keep(pct_treated_crops* farm crops10*) $tableopts mtitles(none)
esttab * using ./analyze/output/ageatdeath_reg.tex, replace keep(pct_treated_crops* farm crops10*) $tableopts mtitles("All" "Farm" "Non-Farm" "All" "Age $<$ 18" "Age $\geq$ 18")
restore


*eststo clear
*eststo : qui reg age_at_death i.byear pct_treated_crops_1910 
*eststo : qui reg age_at_death i.byear pct_treated_crops_1910 i.state 
*eststo : qui reg age_at_death i.byear pct_treated_crops_1910 i.state $countyControls
/*eststo clear
eststo : qui reg age_at_death farm i.byear  tract40farm40 i.countyid
eststo : qui reg age_at_death farm i.byear  tract40farm40 i.countyid sexcat1 white 
eststo : qui reg age_at_death farm i.byear  tract40farm40 i.countyid sexcat1 white $countyControls
eststo : qui reg age_at_death farm i.byear  tract40farm40 i.countyid sexcat1 white $countyControls $countyControls2 
esttab *, drop(*byear* *county* $countyControls $countyControls2 sexcat1 white pct_treated_crops_1910) $tableopts 
esttab * using ./analyze/output/censoc_aad_crops_controls.tex , replace ///
	 drop(*byear* *county* $countyControls $countyControls2 sexcat1 white pct_treated_crops_1910) ///
	$tableopts 

eststo clear
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910 crops10farm40 i.countyid
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910 crops10farm40 i.countyid sexcat1 white 
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910 crops10farm40 i.countyid sexcat1 white $countyControls
*/

/*esttab * using ./analyze/output/censoc_aad_crops_controls.tex , replace ///
	 drop(*byear* *county* $countyControls $countyControls2 sexcat1 white pct_treated_crops_1910) ///
	$tableopts 




eststo clear
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910 crops10farm40 i.countyid , vce(cluster countyid)
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910 crops10farm40 i.countyid sexcat1 white , vce(cluster countyid)
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910 crops10farm40 i.countyid sexcat1 white $countyControls , vce(cluster countyid)
eststo : qui reg age_at_death farm i.byear pct_treated_crops_1910  crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 , vce(cluster countyid)

label var crops10farm40 "Crops*Farm"
label var age_at_death "Age at Death"
esttab *, drop(*byear* *county* $countyControls $countyControls2 sexcat1 white pct_treated_crops_1910)
esttab * using ./analyze/output/censoc_aad_crops_controls.tex , replace ///
	 keep(crops10farm40) $tableopts



foreach num of numlist 1890(5)1920 {

di `num' 
eststo agemort_`num': qui reg age_at_death farm  pct_treated_crops_1910  crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 if byear == `num', vce(cluster countyid)
eststo agemort_farm0_`num': qui reg age_at_death farm  pct_treated_crops_1910  crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 if byear == `num' & farm==0, vce(cluster countyid)
eststo agemort_farm1_`num': qui reg age_at_death farm  pct_treated_crops_1910  crops10farm40 i.countyid sexcat1 white $countyControls $countyControls2 if byear == `num' & farm==1, vce(cluster countyid)


}
