
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

* Migration Probability by Age
binscatter moved_30 age_10, line(connect) by(farm_10) ytitle("P(Migrating Counties Between 1910 and 1930)")  ///
	xtitle("Age in 1910") legend(ring(0) label(1 "Non-Farm" ) label(2 "Farm" ))
	graph export ./analyze/output/migrationByAge.png, as(png) replace

* Employment Probability by Age
binscatter emp_30 age_10, line(connect) by(farm_10) ytitle("P(Employment in 1930)") ///
	xtitle("Age in 1910") legend(ring(0) label(1 "Non-Farm" ) label(2 "Farm" ))
	graph export ./analyze/output/employmentByAge.png, as(png) replace


* Farm Probability by Age
binscatter farm_30 age_10, line(connect) by(farm_10) ytitle("P(Farm Residence in 1930)") ///
	 xtitle("Age in 1910") legend(ring(0) label(1 "Non-Farm" ) label(2 "Farm" ))
	graph export ./analyze/output/FarmResByAge.png, as(png) replace



* Farm Probability by Age
binscatter ind_ag_30 age_10 if emp_30==1, line(connect) by(farm_10) ytitle("P(Ag. Employment in 1930 | Employed)") ///
	 xtitle("Age in 1910") legend(ring(0) label(1 "Non-Farm" ) label(2 "Farm" ))
	graph export ./analyze/output/IndAgByAge.png, as(png) replace


* Link Quality
binscatter totdist_30 pct_treated_crops_1910 if region2num == 2, n(100) ///
	absorb(stateicp) control($countyControls1 $countyControls2  homeowner age_10 agesq_10 farm_10 white) reportreg ///
	xtitle(Pct. Treated Crops) ytitle(Link Quality)
	graph export ./analyze/output/linkquality1030menMW_crops.png, as(png) replace

binscatter totdist_30 tractPerAcre30_10loc if region2num == 2, n(100) ///
	absorb(stateicp) control($countyControls1 $countyControls2 homeowner age_10 agesq_10 farm_10 white) reportreg ///
	xtitle(Tractors per 100 Farm Acres) ytitle(Link Quality)
	graph export ./analyze/output/linkquality1030menMW_tract.png, as(png) replace




**** 1910-1940 LINKS ****

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



* income distribution
twoway (kdensity incwage_40 if farm_10 == 0 & incwage_40 > 0, color(green)) ///
	(kdensity incwage_40 if farm_10 == 1 & incwage_40 > 0, color(blue)) ///
	, legend(ring(0) label(1 "Non-Farm") label(2 "Farm") pos(2)) ///
	xtitle(1940 Wage Income) ytitle("Density") title(1940 Wage Income Distribution Conditional on Incomes > 0)
	graph export ./analyze/output/wagedist1940.png, as(png) replace




* Link Quality
binscatter totdist_40 pct_treated_crops_1910 if region2num == 2 & sex_10 == 1, n(100) ///
	absorb(stateicp) control($countyControls1 $countyControls2  homeowner age_10 agesq_10 farm_10 white) reportreg ///
	xtitle(Pct. Treated Crops) ytitle(Link Quality)
	graph export ./analyze/output/linkquality1040menMW_crops.png, as(png) replace

binscatter totdist_40 tractPerAcre40_10loc if region2num == 2 & sex_10 == 1, n(100) ///
	absorb(stateicp) control($countyControls1 $countyControls2 homeowner age_10 agesq_10 farm_10 white) reportreg ///
	xtitle(Tractors per 100 Farm Acres) ytitle(Link Quality)
	graph export ./analyze/output/linkquality1040menMW_tract.png, as(png) replace




