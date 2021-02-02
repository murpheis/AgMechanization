set more off, perm
set scheme plotplain
set matsize 11000
cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"


//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"

//global countyControls =  "bankstot20 dist_closest_city farmsize10 valPerAcre10   ind_manu10  farmsize10 pct_urban_1910 "
//global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg ind_manu_pct_chg10 valPerAcre_chg10"



global countyControls2 = "popperacre10_chg farmpopperacre10_chg urbanperacre10_chg indagperacre10_chg indmanuperacre10_chg farmperacre10_chg valPerAcre_chg10"
global countyControls= "bankstot20 dist_closest_city farmsize10 popperacre10 farmpopperacre10 urbanperacre10 indagperacre10 indmanuperacre10 farmperacre10 valPerAcre10"



global tableopts "se wrap l star(+ 0.10 ** 0.05 *** 0.01) compress nogaps"



*===============================================*
*		SET UP DATA			*
*===============================================*


use ./clean/output/countyFCwithControls.dta, clear
drop statefip
merge 1:1 state county year using ./clean/output/tractorVars.dta



* fix fips variable
bysort county stateicp: egen temp = max(fips)
replace fips = temp if mi(fips)
drop temp
** fips for wyoming is extra weird
replace fips = 56000 + county/10 if stateicp == 68

* set as panel
drop if year == 1925
xtset countyid t


* descriptive variables
gen man_pct = ind_manu / pop *100
gen ag_pct = ind_ag / pop *100
gen farm_pct = farm/pop*100


* farm pop in 1910
gen farmpop_1910 =  farm if year == 1910
bysort countyid: egen temp = max(farmpop_1910)
replace farmpop_1910 = temp
drop temp


* horses and mules
replace horsemule = horses + mules if mi(horsemule)
gen horsemuleperacre = horsemule / acfarm

gen farmownperacre = farmowner / acfarm

* outcome variables for 1910-30 changes
gen farmchangepct = (farm - L2.farm)/L2.pop * 100
gen indmanuchangepct = (ind_manu - L2.ind_manu)/L2.pop * 100
gen indagchangepct = (ind_ag - L2.ind_ag)/L2.pop * 100
gen popchangepct = (pop - L2.pop)/L2.pop * 100
gen farmownchangepct = (farmowner - L2.farmowner)/L2.pop * 100
gen aachangepct = (aframer - L2.aframer)/L2.pop * 100
gen aafarmownchangepct = (aafarmown - L2.aafarmown) / L2.pop *100
gen farmlabchangepct = ((farm - farmowner) - (L2.farm - L2.farmowner)) /L2.pop *100


* outcome variables for 1910-30 changes
gen farmchange_ac = (farm - L2.farm)/L2.acfarm * 100
gen indmanuchange_ac = (ind_manu - L2.ind_manu)/L2.acfarm * 100
gen indagchange_ac = (ind_ag - L2.ind_ag)/L2.acfarm * 100
gen popchange_ac = (pop - L2.pop)/L2.acfarm * 100
gen farmownchange_ac = (farmowner - L2.farmowner)/L2.acfarm * 100
gen aachange_ac = (aframer - L2.aframer)/L2.acfarm * 100
gen aafarmownchange_ac = (aafarmowner - L2.aafarmowner) / L2.acfarm *100
gen farmlabchange_ac = ((farm - farmowner) - (L2.farm - L2.farmowner)) / L2.acfarm *100



gen farms_chg = (farms - L2.farms)/L2.farms * 100
gen acfarm_chg = (acfarm - L2.acfarm)/L2.acfarm * 100
replace farmsize = acfarm / farms
gen farmsize_chg = (farmsize - (L2.farmsize))/(L2.farmsize) * 100



* outcome variables for 1900-10 changes 
gen farmchange10_ac = (farm - L.farm)/L.acfarm * 100
gen indmanuchange10_ac = (ind_manu - L.ind_manu)/L.acfarm * 100
gen indagchange10_ac = (ind_ag - L.ind_ag)/L.acfarm * 100
gen popchange10_ac = (pop - L.pop)/L.acfarm * 100
gen farmownchange10_ac = (farmowner - L.farmowner)/L.acfarm * 100
gen aachange10_ac = (aframer - L.aframer)/L.acfarm * 100
gen aafarmownchange10_ac = (aafarmowner - L.aafarmowner) / L.acfarm *100

gen farms10_chg = (farms - L.farms)/L.farms * 100
gen acfarm10_chg = (acfarm - L.acfarm)/L.acfarm * 100
gen farmsize10_chg = (farmsize - (L.farmsize))/(L.farmsize) * 100



*change scale of pct_treated_crops_1910
replace pct_treated_crops_1910 = 100* pct_treated_crops_1910
replace pct_treated_crops = 100* pct_treated_crops

winsor2 popchange* farmchange* tract* indag* indmanu* farmownchange* farmlabchange* aachange* aafarmown* farmsize_chg farms_chg acfarm_chg, cut(5 95) trim

*===============================================*
* 		CHARTS				*
*===============================================*

* AGGREGATE TRENDS
{
* US AGGREGATES OVER TIME
preserve
drop if year == 1925
collapse (sum) pop farm ind_ag urban ind_manu *farmowner, by(year)
foreach var of varlist farm ind_ag urban ind_manu farmowner {
	gen `var'_pct = `var'/pop * 100
}


line farm_pct year if year >= 1860, ///
	ytitle("Percent of Total US Population") ///
	xtitle("Year") ///
	title("Percent of US Population Living on a Farm") ///
	xline(1917) 

line farm_pct year if year >= 1900, ///
	ytitle("Percent of Total US Population") ///
	xtitle("Year") ///
	title("Percent of US Population Living on a Farm") ///
	xline(1917) 
	graph export ./analyze/output/farmpopUS.png, replace as(png)

gen farmnonowner = farm - farmowner
label var farm "Total Farm Residents"
label var farmowner "Farm Home Owners"
label var farmnonowner "Farm Non-Home Owners"
line farmnonowner farmowner year if year >=1900, ///
	ytitle("Total") xtitle("Year") ///
	title("Farm Residents by Home Ownership Status") ///
	xline(1917) legend(ring(0))
	graph export ./analyze/output/farmOwnerUS.png, replace as(png)

gen farmnonown_pct = farmnonowner / pop * 100
line farm_pct farmowner_pct year if year >=1900
line farmnonown_pct farmowner_pct year if year >=1900

line farmowner aafarmowner year if year >= 1900
line farm pop year if year >= 1900



label var ind_ag_pct "Agriculture"
label var ind_manu_pct "Manufacturing"
line ind_ag_pct ind_manu_pct year if year >= 1880, ///
	ytitle("Percent of Total US Population") ///
	xtitle("Year") ///
	title("Percent of US Population Employed in Given Sector") ///
	xline(1917) legend(ring(0))
	graph export ./analyze/output/empBySectorUS.png, replace as(png)

line urban_pct year
restore


* MW AGGREGATES OVER TIME
preserve
drop if year == 1925
keep if region2num == 2
collapse (sum) pop farm ind_ag urban ind_manu *farmowner acfarm acfarm10, by(year)
foreach var of varlist farm ind_ag urban ind_manu farmowner {
	gen `var'_pct = `var'/pop * 100
	gen `var'_ac = `var'/acfarm10 * 100
}

gen ln_pop = ln(pop)
line ln_pop year if year >= 1900, ///
	ytitle("Log(Population), Midwest") ///
	xtitle("Year") ///
	title("") ///
	xline(1917) 


line farm_pct year if year >= 1860, ///
	ytitle("Percent of Total US Population") ///
	xtitle("Year") ///
	title("Percent of US Population Living on a Farm") ///
	xline(1917) 
	
line farm_ac year if year >= 1900, ///
	ytitle("") ///
	xtitle("Year") ///
	title("Farm Residents per 100 Farm Acres") ///
	xline(1917) 
	*graph export ./analyze/output/farmresperacre_mw.png, replace as(png)


label var farmowner_ac "Farm Home Owners"
label var farm_ac "All Farm Residents"
line farmowner_ac farm_ac year if year >= 1900, ///
	ytitle("") ///
	xtitle("Year") ///
	title("Farm Homeowners per 1910 Farm Acres") ///
	xline(1917) legend(ring(0) pos(7))
	graph export ./analyze/output/farmresperacre_mw.png, replace as(png)



line ind_ag_ac year if year >= 1900, ///
	ytitle("") ///
	xtitle("Year") ///
	title("Agricultural Employment per 1910 Farm Acres") ///
	xline(1917) 
	graph export ./analyze/output/indagperacre_mw.png, replace as(png)

line acfarm year if year >= 1900, ///
	ytitle("Acres") ///
	xtitle("Year") ///
	title("Total Farm Acres in the Mid-West") ///
	xline(1917) 
	graph export ./analyze/output/farmacres_mw.png, replace as(png)
	
		
	
	

line farm year if year >= 1900, ///
	ytitle("People") ///
	xtitle("Year") ///
	title("MW Population Living on a Farm") ///
	xline(1917) 


line farm_pct year if year >= 1900, ///
	ytitle("Percent of Total US Population") ///
	xtitle("Year") ///
	title("Percent of US Population Living on a Farm") ///
	xline(1917) 
	graph export ./analyze/output/farmpopMW.png, replace as(png)

gen farmnonowner = farm - farmowner
label var farm "Total Farm Residents"
label var farmowner "Farm Home Owners"
label var farmnonowner "Farm Non-Home Owners"
line farmnonowner farmowner year if year >=1900, ///
	ytitle("Total") xtitle("Year") ///
	title("Farm Residents by Home Ownership Status") ///
	xline(1917) legend(ring(0))
	graph export ./analyze/output/farmOwnerMW.png, replace as(png)





label var ind_ag_pct "Agriculture"
label var ind_manu_pct "Manufacturing"
line ind_ag_pct ind_manu_pct year if year >= 1880, ///
	ytitle("Percent of Total US Population") ///
	xtitle("Year") ///
	title("Percent of US Population Employed in Given Sector") ///
	xline(1917) legend(ring(0))
	graph export ./analyze/output/empBySectorMW.png, replace as(png)

line urban_pct year



restore

}

* DENSITY TRACTORS

{
twoway (kdensity tractPerAcre25_w if year == 1930) ///
	|| (kdensity tractPerAcre30_w if year == 1930) ///
	|| (kdensity tractPerAcre40_w if year == 1930), ///
	legend(ring(0) lab(1 "1925") lab(2 "1930") lab(3 "1940")) ///
	title("Density For Tractors per 100 Farm Acres, Over Counties") ///
	xtitle("Tractor Per 100 Farm Acres")
graph export ./analyze/output/tractordensity.png, replace as(png)

twoway (kdensity tractPerAcre25 if year == 1930 & region2num ==2) ///
	|| (kdensity tractPerAcre30 if year == 1930 & region2num ==2) ///
	|| (kdensity tractPerAcre40 if year == 1930 & region2num ==2), ///
	legend(ring(0) lab(1 "1925") lab(2 "1930") lab(3 "1940")) ///
	title("Density For Tractors per 100 Farm Acres, Over MidWest Counties") ///
	xtitle("Tractor Per 100 Farm Acres")
graph export ./analyze/output/tractordensity_MW.png, replace as(png)



twoway (kdensity tractPerAcre25_w if year == 1930 & (region2num ==3 | region2num == 4)) ///
	|| (kdensity tractPerAcre30_w if year == 1930 & (region2num ==3 | region2num == 4)) ///
	|| (kdensity tractPerAcre40_w if year == 1930 & (region2num ==3 | region2num == 4)), ///
	legend(ring(0) lab(1 "1925") lab(2 "1930") lab(3 "1940")) ///
	title("Density For Tractors per 100 Farm Acres, Over Southern Counties") ///
	xtitle("Tractor Per 100 Farm Acres")
graph export ./analyze/output/tractordensity_south.png, replace as(png)



twoway (kdensity tractPerAcre25_w if year == 1930 & (region2num ==5)) ///
	|| (kdensity tractPerAcre30_w if year == 1930 & (region2num ==5)) ///
	|| (kdensity tractPerAcre40_w if year == 1930 & (region2num ==5)), ///
	legend(ring(0) lab(1 "1925") lab(2 "1930") lab(3 "1940")) ///
	title("Density For Tractors per 100 Farm Acres, Over Western Counties") ///
	xtitle("Tractor Per 100 Farm Acres")
graph export ./analyze/output/tractordensity_west.png, replace as(png)


}


****************
* event study  *
****************
{

replace farm1000 = farm1000plus if mi(farm1000)

* midwest
eststo clear
eststo indagES: reg indagperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo indmanuES: reg indmanuperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo farmES: reg farmperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo farmvalES: reg valPerAcre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo farmpopES: reg farmpopperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo horseES: reg horsemuleperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo popES: reg popperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo farmownES: reg farmownperacre i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo acfarmES: reg acfarm i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo farmsizeES: reg farmsize i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)
eststo farm1000ES: reg farm1000 i.stateicp#c.year  i.year i.countyid pct_treated_crops_1910 ib1910.year#c.pct_treated_crops_1910   [aw=acfarm10] if region2num == 2, noconst  allbaselevels vce(cluster countyid)


coefplot indagES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ylabel(-.002(.0005).002) yline(0) ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Agricultural Employment per County Farm Acre") ytitle("Coefficient on Pct. Treated Crops as of 1910" "Interacted with Year Dummy")
	graph export ./analyze/output/indag_EventStudy_MW.png, as(png) replace



coefplot indmanuES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ylabel(-.02(.005).02) yline(0)  ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Manufacutring Employment per County Farm Acre")  ytitle("Coefficient on Pct. Treated Crops as of 1910" "Interacted with Year Dummy")
	graph export ./analyze/output/indmanu_EventStudy_MW.png, as(png) replace



coefplot farmES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Farms per County Farm Acre") xline() 
	graph export ./analyze/output/farms_EventStudy_MW.png, as(png) replace

coefplot farmsizeES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ///
	vert ylabel(-15(5)15) yline(0) coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Farm Size (Acres)") xline() 
	graph export ./analyze/output/farmsize_EventStudy_MW.png, as(png) replace



coefplot farmvalES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) yline(0) ylabel(-1.5(.5)1.5) ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Farm Value per County Farm Acre") xline() 
	graph export ./analyze/output/farmval_EventStudy_MW.png, as(png) replace


coefplot farmpopES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ylabel(-.01(.0025).01) yline(0)  ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Farm Residents per County Farm Acre") ytitle("Coefficient on Pct. Treated Crops as of 1910" "Interacted with Year Dummy")
	graph export ./analyze/output/farmres_EventStudy_MW.png, as(png) replace


coefplot horseES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Horses/Mules per County Farm Acre") xline() 
	graph export ./analyze/output/horsemule_EventStudy_MW.png, as(png) replace


coefplot popES , baselevels omitted ///
	keep(*year*pct_treated_crops* ) ///
	vert yline(0) ylabel(-0.1(.02).1) coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Total Population per County Farm Acre") xline() 
	graph export ./analyze/output/totpop_EventStudy_MW.png, as(png) replace


coefplot farmownES , baselevels omitted ///
	keep(*year*pct_treated_crops* )  yline(0)  ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Farm Owners per County Farm Acre") ytitle("Coefficient on Pct. Treated Crops as of 1910" "Interacted with Year Dummy")
	graph export ./analyze/output/farmown_EventStudy_MW.png, as(png) replace


coefplot acfarmES , baselevels omitted ///
	keep(*year*pct_treated_crops* )  yline(0) ylabel(-10000(2000)10000) ///
	vert  coeflabels(1900*pct_treated_crops* = "1900" *1910*pct_treated_crops*= "1910" 1920*pct_treated_crops* = "1920" 1930*pct_treated_crops*= "1930" 1940*pct_treated_crops*= "1940"  ) ///
	title("Dep. Var. = Farm Acrage") ytitle("Coefficient on Pct. Treated Crops as of 1910" "Interacted with Year Dummy")
	graph export ./analyze/output/acfarm_EventStudy_MW.png, as(png) replace



}




*************
* SCATTERS  *
*************
{

* first stage

cap drop yhat
qui: reg tractPerAcre30 pct_treated_crops_1910 $countyControls $countyControls2 i.stateicp if  year ==1930 [aw= acfarm10], vce(cluster stateicp)
predict yhat
local slope = _b[pct_treated_crops_1910]
local se = _se[pct_treated_crops_1910]
di e(F)

binscatter tractPerAcre30 pct_treated_crops_1910 [aw= acfarm10], controls($countyControls $countyControls2) absorb(stateicp) ///
	n(100) reportreg  text( .15 8  "slope = `slope'") text( .145 8  "se = `se'") ///
	xtitle("Percent Farm Acres in Small Grains") ytitle("Tractors per 100 Farm Acres") ///
	title("First Stage with Full Set of Controls, Entire USA")
	graph export ./analyze/output/bin_firststage_USA.png, as(png) replace


cap drop yhatMW
reg tractPerAcre30 pct_treated_crops_1910 $countyControls $countyControls2 i.stateicp if region2num == 2 & year ==1930 [aw= acfarm10], vce(cluster stateicp)
predict yhatMW
local slope = _b[pct_treated_crops_1910]
local se = _se[pct_treated_crops_1910]
di e(F)


binscatter tractPerAcre30 pct_treated_crops_1910 if region2num == 2 & year == 1930 [aw= acfarm10], controls($countyControls $countyControls2) absorb(stateicp) ///
	n(100) reportreg  text( .2 19  "slope = `slope'") text( .195 19  "se = `se'")  ///
	xtitle("Percent Farm Acres in Small Grains, 1910") ytitle("Tractors per 100 Farm Acres") ///
	title("First Stage with Full Set of Controls, 1910-1930")
	graph export ./analyze/output/bin_firststage_MW1930.png, as(png) replace



cap drop yhatMW
reg tractPerAcre40 pct_treated_crops_1910 $countyControls $countyControls2 i.stateicp if region2num == 2 & year ==1940 [aw= acfarm10], vce(cluster stateicp)
predict yhatMW
local slope = _b[pct_treated_crops_1910]
local se = _se[pct_treated_crops_1910]
di e(F)


binscatter tractPerAcre40 pct_treated_crops_1910 if region2num == 2 [aw= acfarm10], controls($countyControls $countyControls2) absorb(stateicp) ///
	n(100) reportreg  text( .34 19  "slope = `slope'") text( .33 19  "se = `se'")  ///
	xtitle("Percent Farm Acres in Small Grains, 1910") ytitle("Tractors per 100 Farm Acres") ///
	title("First Stage with Full Set of Controls, 1910-1940")
	graph export ./analyze/output/bin_firststage_MW1940.png, as(png) replace


}


******************
* MAPS		 *
******************

{

preserve
drop if mi(fips) 

maptile farm_pct if year == 1910, ///
	geo(uscounty1930) ///
	 geofolder("$geofolder/1930") ///
      twopt(title("Farm Residents as Percent of Total Pop., 1910")) 
graph export ./analyze/output/map_farmpct_1910.png, as(png) replace


maptile farm_pct if year == 1930, ///
	geo(uscounty1930) ///
	 geofolder("$geofolder/1930") ///
      twopt(title("Farm Residents as Percent of Total Pop., 1930")) 
graph export ./analyze/output/map_farmpct_1930.png, as(png) replace


maptile farm_pct if year == 1940, ///
	geo(uscounty1930) ///
	 geofolder("$geofolder/1930") ///
      twopt(title("Farm Residents as Percent of Total Pop., 1940")) 
graph export ./analyze/output/map_farmpct_1940.png, as(png) replace




maptile farmchange_ac_w if year == 1930, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Change in Farm Residents per 100 Farm Acres, 1910-30")) 
graph export ./analyze/output/farmchange_ac_2030.png, as(png) replace



maptile farmchange_ac_tr if year == 1930 & region2num == 2, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Change in Farm Residents per 100 Farm Acres, 1910-30")) 
graph export ./analyze/output/farmchange_ac_1030_mw.png, as(png) replace



maptile tractPerAcre25 if year == 1930, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Tractors per 100 Farm Acres, 1925")) 
graph export ./analyze/output/map_tractorsPerAcre1925.png, as(png) replace
     


maptile tractPerAcre if year == 1930, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Tractors per 100 Farm Acres, 1930")) 
    graph export ./analyze/output/map_tractorsPerAcre1930.png, as(png) replace


maptile tractPerAcre if year == 1930 & region2num == 2, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Tractors per 100 Farm Acres, 1930")) 
    graph export ./analyze/output/map_tractorsPerAcre1930_mw.png, as(png) replace

      
    
      
maptile tractPerAcre if year == 1940, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Tractors per 100 Farm Acres, 1940")) 
	graph export ./analyze/output/map_tractorsPerAcre1940.png, as(png) replace

      
maptile tractPerAcre if year == 1940 & region2num == 2, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Tractors per 100 Farm Acres, 1940")) 
	graph export ./analyze/output/map_tractorsPerAcre1940_mw.png, as(png) replace


maptile pct_treated_crops_1910 if year == 1930 & region2num == 2, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Percent of Farm Acres in Small Grains, 1910")) 
    graph export ./analyze/output/map_crops1910_mw.png, as(png) replace

      

cap drop uhat
qui reg pct_treated_crops_1910 i.stateicp $countyControls $countyControls2
predict uhat, resid
maptile uhat if year == 1930, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Crop Variation After Residualizing on County Controls")) 
	graph export ./analyze/output/map_cropResid.png, as(png) replace


cap drop uhat_mw
qui reg pct_treated_crops_1910 i.stateicp $countyControls $countyControls2 if region2num == 2
predict uhat_mw, resid
maptile uhat if year == 1930 & region2num == 2, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Crop Variation After Residualizing on County Controls")) 
	graph export ./analyze/output/map_cropResid_mw.png, as(png) replace






maptile popchange_ac_w if year == 1930, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Population Change per 100 Farm Acres, 1930")) 
graph export ./analyze/output/popchange_ac_30.png, as(png) replace




maptile popchange_ac_tr if year == 1930 & region2num == 2, ///
	geo(uscounty1930) ///
      geofolder("$geofolder/1930") ///
      twopt(title("Population Change per 100 Farm Acres, 1930")) 
graph export ./analyze/output/popchange_ac_30.png, as(png) replace


restore

}



*****************
* BALANCE TABLE *
*****************


{


label var popperacre "Population per 100 county acres"
label var farmpopperacre "Farm residents per 100 county acres"
label var urbanperacre "Urban Pop. per 100 county acres"
label var indagperacre "Ag. employment per 100 county acres"
label var indmanuperacre "Manu. employment per 100 county acres"
label var farmperacre "Farm acres per 100 county acres"
label var horseperacre "Horses per 100 county acres"
label var valPerAcre "Farm Value per Acre"
label var ind_manu_pct "Manufacturing Emp. Share"


//global countyControls = "popchange1910 farmpopchg1910 bankstot20 dist_closest_city valPerAcre20 valPerAcre10  valPerAcre00 ind_manu10  farmsize10 pct_urban_1910 pct_urban_1900"

//global countyControls =  "bankstot20 dist_closest_city farmsize10 valPerAcre10   ind_manu10  farmsize10 pct_urban_1910 "

global countyControls = ""

//global countyControls =  "bankstot20 dist_closest_city farmsize10  valPerAcre00 valPerAcre10 ind_manu10 pct_urban_1900  pct_urban_1910"

//global countyControls =  "bankstot20 dist_closest_city farmsize10   valPerAcre10 ind_manu10   pct_urban_1910"

//global countyControls =  "bankstot20 dist_closest_city farmsize10  valPerAcre10"

//global countyControls =  "bankstot20 dist_closest_city farmsize10  "


global DESCVARS popperacre farmpopperacre urbanperacre indagperacre indmanuperacre  valPerAcre10 farmperacre // horseperacre ind_manu_pct
mata: mata clear

local i = 1


foreach var in $DESCVARS {
    reg `var' tractPerAcre30 i.state $countyControls if year == 1910
    outreg, keep(tractPerAcre30)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diff3) append(row`i') ctitles("", Levels ) ///
        store(diff3) note("")
    local ++i
}
outreg, replay(diff3)

local i = 1

foreach var in $DESCVARS {
    reg d.`var' tractPerAcre30 i.state $countyControls if year == 1910
    outreg, keep(tractPerAcre30)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diffdiff3) append(row`i') ctitles("",Changes ) ///
        store(diffdiff3) note("")
    local ++i
}
outreg, replay(diffdiff3)


outreg, replay(diff3) merge(diffdiff3) store(final)


* with IV

cap drop yhat
reg tractPerAcre30 pct_treated_crops_1910 
predict yhat



local i = 1

foreach var in $DESCVARS {
    reg `var' yhat i.state $countyControls if year == 1910
    outreg, keep(yhat)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diff3iv) append(row`i') ctitles("",Levels) ///
        store(diff3iv) note("")
    local ++i
}
outreg, replay(diff3iv)


local i = 1

foreach var in $DESCVARS {
    reg d.`var' yhat i.state $countyControls if year == 1910
    outreg, keep(yhat)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diffdiff3iv) append(row`i') ctitles("",Changes ) ///
        store(diffdiff3iv) note("")
    local ++i
}
outreg, replay(diffdiff3iv)


outreg, replay(final) merge(diff3iv) store(final)
outreg, replay(final) merge(diffdiff3iv) store(final)


* Then Summary statistics
local count: word count $DESCVARS
local dim = `count' * 2
mat sumstat = J(`dim',1,.)

local i = 1
foreach var in $DESCVARS {
    quietly: summarize `var'
    mat sumstat[`i',1] = r(mean)
    local i = `i' + 2
  }
frmttable, statmat(sumstat) store(sumstat) sfmt(f)
outreg, replay(sumstat)

outreg, replay(sumstat) merge(final) store(final)  


outreg, replay(final)  varlabels ctitles("", Sample, OLS, "", IV,  "" \ "", Mean, Levels, Changes, Levels, Changes) 

outreg using "./analyze/output/balance1.tex", ///
    replay(final)  tex nocenter note("") fragment plain replace ///
    varlabels ctitles("", Sample, OLS, "", IV,  "" \ All US Counties, Mean, Levels, Changes, Levels, Changes\ "",(1) ,(2),(3),(4),(5)) 


**** midwest

mata: mata clear

local i = 1

foreach var in $DESCVARS {
    reg `var' tractPerAcre30 i.state $countyControls if year == 1910 & region2num == 2
    outreg, keep(tractPerAcre30)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diff3) append(row`i') ctitles("", Levels ) ///
        store(diff3) note("")
    local ++i
}
outreg, replay(diff3)

local i = 1

foreach var in $DESCVARS {
    reg d.`var' tractPerAcre30 i.state $countyControls if year == 1910 & region2num == 2
    outreg, keep(tractPerAcre30)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diffdiff3) append(row`i') ctitles("",Changes ) ///
        store(diffdiff3) note("")
    local ++i
}
outreg, replay(diffdiff3)


outreg, replay(diff3) merge(diffdiff3) store(final)


* with IV

cap drop yhat
reg tractPerAcre30 pct_treated_crops_1910 if region2num == 2
predict yhat


local i = 1

foreach var in $DESCVARS {
    reg `var' yhat i.state $countyControls if year == 1910 & region2num == 2
    outreg, keep(yhat)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diff3iv) append(row`i') ctitles("",Levels) ///
        store(diff3iv) note("")
    local ++i
}
outreg, replay(diff3iv)


local i = 1

foreach var in $DESCVARS {
    reg d.`var' yhat i.state $countyControls if year == 1910 & region2num == 2
    outreg, keep(yhat)  rtitle("`: var label `var''") stats(b se) ///
        noautosumm store(row`i')  starlevels(5 1 .1) starloc(1)
    outreg, replay(diffdiff3iv) append(row`i') ctitles("",Changes ) ///
        store(diffdiff3iv) note("")
    local ++i
}
outreg, replay(diffdiff3iv)


outreg, replay(final) merge(diff3iv) store(final)
outreg, replay(final) merge(diffdiff3iv) store(final)

* Then Summary statistics
local count: word count $DESCVARS
local dim = `count' * 2
mat sumstat = J(`dim',1,.)

local i = 1
foreach var in $DESCVARS {
    quietly: summarize `var' if region2num == 2
    mat sumstat[`i',1] = r(mean)
    local i = `i' + 2
  }
frmttable, statmat(sumstat) store(sumstat) sfmt(f)
outreg, replay(sumstat)

outreg, replay(sumstat) merge(final) store(final)  

outreg, replay(final)  varlabels ctitles("", Sample, OLS, "", IV,  "" \ "", Mean, Levels, Changes, Levels, Changes) 

outreg using "./analyze/output/balance_mw.tex", ///
    replay(final)  tex nocenter note("") fragment plain replace ///
    varlabels ctitles("", Sample, OLS, "", IV,  "" \ MidWest Counties, Mean, Levels, Changes, Levels, Changes \ "",(1) ,(2),(3),(4),(5)) 



}



*********************************
* 	1940 outcomes		*
*********************************




use ./clean/output/countyFCwithControls.dta, clear
drop statefip
merge 1:1 state county year using ./clean/output/tractorVars.dta



* fix fips variable
bysort county stateicp: egen temp = max(fips)
replace fips = temp if mi(fips)
drop temp
** fips for wyoming is extra weird
replace fips = 56000 + county/10 if stateicp == 68

* set as panel
drop if year == 1925
xtset countyid t


* descriptive variables
gen man_pct = ind_manu / pop *100
gen ag_pct = ind_ag / pop *100
gen farm_pct = farm/pop*100


* farm pop in 1910
gen farmpop_1910 =  farm if year == 1910
bysort countyid: egen temp = max(farmpop_1910)
replace farmpop_1910 = temp
drop temp


* outcome variables for 1910-30 changes
gen farmchangepct = (farm - L3.farm)/L3.pop * 100
gen indmanuchangepct = (ind_manu - L3.ind_manu)/L3.pop * 100
gen indagchangepct = (ind_ag - L3.ind_ag)/L3.pop * 100
gen popchangepct = (pop - L3.pop)/L3.pop * 100
gen farmownchangepct = (farmowner - L3.farmowner)/L3.pop * 100
gen aachangepct = (aframer - L3.aframer)/L3.pop * 100
gen aafarmownchangepct = (aafarmown - L3.aafarmown) / L3.pop *100


* outcome variables for 1910-30 changes
gen farmchange_ac = (farm - L3.farm)/L3.acfarm * 100
gen indmanuchange_ac = (ind_manu - L3.ind_manu)/L3.acfarm * 100
gen indagchange_ac = (ind_ag - L3.ind_ag)/L3.acfarm * 100
gen popchange_ac = (pop - L3.pop)/L3.acfarm * 100
gen farmownchange_ac = (farmowner - L3.farmowner)/L3.acfarm * 100
gen aachange_ac = (aframer - L3.aframer)/L3.acfarm * 100
gen aafarmownchange_ac = (aafarmowner - L3.aafarmowner) / L3.acfarm *100








gen farms_chg = (farms - L3.farms)/L3.farms * 100
gen acfarm_chg = (acfarm - L3.acfarm)/L3.acfarm * 100
replace farmsize = acfarm / farms
gen farmsize_chg = (farmsize - (L3.farmsize))/(L3.farmsize) * 100
gen farmvalchg1040 = farmval/acfarm - L3.farmval/L3.acfarm if year == 1940


*change scale of pct_treated_crops_1910
replace pct_treated_crops_1910 = 100* pct_treated_crops_1910
replace pct_treated_crops = 100* pct_treated_crops






winsor2 popchange* farmchange* tract* indag* indmanu* farmownchange* aachange* aafarmown* farmsize_chg farms_chg acfarm_chg, cut(5 95) trim





cap drop residual
qui reg pct_treated_crops_1910 i.stateicp $countyControls  if year == 1940 & region2num == 2
predict residual, resid


kdensity residual if year == 1940 & region2num == 2
kdensity popchange_ac_tr if year == 1940 & region2num == 2
kdensity farmchange_ac_tr if year == 1940 & region2num == 2
kdensity indagchange_ac_tr if year == 1940 & region2num == 2
kdensity indmanuchange_ac_tr if year == 1940 & region2num == 2


reg popchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  popchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]) ///
	(lfit  popchange_ac_tr residual if year == 1940 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)
	
reg farmchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  farmchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]) ///
	(lfit  farmchange_ac_tr residual if year == 1940 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)
	
	
reg indagchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  indagchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]) ///
	(lfit  indagchange_ac_tr residual if year == 1940 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)
	

reg indmanuchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  indmanuchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]) ///
	(lfit  indmanuchange_ac_tr residual if year == 1940 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)







cap drop residual
qui reg pct_treated_crops_1910 i.stateicp $countyControls $countyControls2 if year == 1940 & region2num == 2
predict residual, resid




reg popchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  popchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]) ///
	(lfit  popchange_ac_tr residual if year == 1940 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)
	
reg farmchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  farmchange_ac_tr residual if year == 1940 & region2num == 2  [aw=acfarm10]) ///
	(lfit  farmchange_ac_tr residual if year == 1940 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)
	
reg indagchange_ac_tr residual if year == 1930 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  indagchange_ac_tr residual if year == 1930 & region2num == 2  [aw=acfarm10]) ///
	(lfit  indagchange_ac_tr residual if year == 1930 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)
	

reg indmanuchange_ac_tr residual if year == 1930 & region2num == 2  [aw=acfarm10]
local slope = _b[residual]
local se = _se[residual]
twoway (scatter  indmanuchange_ac_tr residual if year == 1930 & region2num == 2  [aw=acfarm10]) ///
	(lfit  indmanuchange_ac_tr residual if year == 1930 & region2num == 2 [aw=acfarm10]),  ///
	xtitle("Pct. Treated Crops") ytitle("People per 1910 Farm Acres") title("MW: Change in Total Population per 100 Farm Acres") ///
	subtitle("Slope = `slope' , SE = `se'") legend(off)






binscatter popchange_ac_w tractPerAcre40 if year == 1940 [aw=acfarm10], n(100) 
binscatter farmchange_ac_w tractPerAcre40 if year == 1940 [aw=acfarm10], n(100)
binscatter indagchange_ac_w tractPerAcre40 if year == 1940 [aw=acfarm10], n(100)
binscatter indmanuchange_ac_w tractPerAcre40 if year == 1940 [aw=acfarm10], n(100)



binscatter popchange_ac_w pct_treated_crops_1910 if year == 1940 [aw=acfarm10], n(100) 
binscatter farmchange_ac_w pct_treated_crops_1910 if year == 1940 [aw=acfarm10], n(100)
binscatter indagchange_ac_w pct_treated_crops_1910 if year == 1940 [aw=acfarm10], n(100)
binscatter indmanuchange_ac_w pct_treated_crops_1910 if year == 1940 [aw=acfarm10], n(100)




* tables

eststo pop_mw: qui ivreg2  popchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)  i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp)
eststo pop_cont1_mw: qui ivreg2  popchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)  $countyControls   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo pop_cont2_mw: qui ivreg2  popchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)  $countyControls $countyControls2  i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp  ) partial(i.stateicp $countyControls $countyControls2)
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo farm_mw: qui ivreg2  farmchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)    i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp)
eststo farm_cont1_mw: qui ivreg2  farmchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   $countyControls   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo farm_cont2_mw: qui ivreg2  farmchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)  $countyControls $countyControls2  i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls $countyControls2 )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo indag_mw: qui ivreg2  indagchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)    i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp)
eststo indag_cont1_mw: qui ivreg2  indagchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   $countyControls   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo indag_cont2_mw: qui ivreg2  indagchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   $countyControls $countyControls2  i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls $countyControls2 )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo indmanu_mw: qui ivreg2  indmanuchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp)
eststo indmanu_cont1_mw: qui ivreg2  indmanuchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   $countyControls   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo indmanu_cont2_mw: qui ivreg2  indmanuchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)  $countyControls $countyControls2  i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls $countyControls2 )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo farmown_mw: qui ivreg2  farmownchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp)
eststo farmown_cont1_mw: qui ivreg2  farmownchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)  $countyControls   i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace
eststo farmown_cont2_mw: qui ivreg2  farmownchange_ac_tr (tractPerAcre40 = pct_wheat_1910 pct_oats_1910 pct_hay_1910)   $countyControls $countyControls2  i.stateicp if year == 1940 & region2num == 2 [aw= acfarm10], gmm2s cluster(stateicp) partial(i.stateicp $countyControls $countyControls2 )
estadd scalar F=e(widstat), replace
estadd scalar J =  e(jp), replace

/*
replace cov = yhat
eststo pop: qui reg  popchange_ac_w cov  i.stateicp if year == 1940 [aw= acfarm10]
eststo pop_cont2: qui reg  popchange_ac_w cov $countyControls $countyControls2  i.stateicp if year == 1940 [aw= acfarm10]
eststo farm: qui reg  farmchange_ac_w cov  i.stateicp if year == 1940  [aw= acfarm10]
eststo farm_cont2: qui reg  farmchange_ac_w cov $countyControls $countyControls2  i.stateicp if year == 1940  [aw= acfarm10]
eststo indag: qui reg  indagchange_ac_w cov  i.stateicp if year == 1940  [aw= acfarm10]
eststo indag_cont2: qui reg  indagchange_ac_w cov $countyControls $countyControls2  i.stateicp if year == 1940 [aw= acfarm10]
eststo indmanu: qui reg  indmanuchange_ac_w cov  i.stateicp if year == 1940 [aw= acfarm10]
eststo indmanu_cont2: qui reg  indmanuchange_ac_w cov $countyControls $countyControls2  i.stateicp if year == 1940  [aw= acfarm10]


label var cov "Predicted Tractors"
esttab  indag_cont2_mw  indmanu_cont2_mw  indag_cont2  indmanu_cont2 , keep(cov)  $tableopts
esttab  indag_cont2_mw  indmanu_cont2_mw  indag_cont2  indmanu_cont2 ///
	using ./analyze/output/countytable_industries1940_frag.tex, replace ///
	keep(cov)  $tableopts frag mtitles("Ag, US"  "Manu, US" "Ag, MW" "Manu, MW"  )
*/

esttab  pop_cont2_mw    farm_cont2_mw   indag_cont2_mw indmanu_cont2_mw, ///
keep(tractPerAcre40) st(N F J) $tableopts frag mtitles("Population" "Farm Residents"   "Ag. Employment" "Manu. Employment" )
esttab  pop_cont2_mw    farm_cont2_mw   indag_cont2_mw indmanu_cont2_mw ///
	using ./analyze/output/countytable_MW1940_c2.tex, replace ///
	keep(tractPerAcre40) st(N F J) $tableopts frag mtitles("Population" "Farm Residents"  "Ag. Employment" "Manu. Employment" )


esttab  pop_cont1_mw    farm_cont1_mw   indag_cont1_mw indmanu_cont1_mw, ///
keep(tractPerAcre40) st(N F J)  $tableopts frag mtitles("Population" "Farm Residents"   "Ag. Employment" "Manu. Employment" )
esttab  pop_cont1_mw    farm_cont1_mw   indag_cont1_mw indmanu_cont1_mw ///
	using ./analyze/output/countytable_MW1940_c1.tex, replace ///
	keep(tractPerAcre40) st(N F J) $tableopts frag mtitles("Population" "Farm Residents"  "Ag. Employment" "Manu. Employment" )





*** farm consolidation, etc


binscatter farms_chg_w pct_treated_crops_1910 if year == 1940 & region2num == 2 [aw=acfarm10] , ///
	n(100) absorb(stateicp) controls($countyControls $countyControls2) reportreg ///
	xtitle("Percent Treated Crops, 1910") ///
	ytitle("Change in No. of Farms, 1910-1940")
	

binscatter farms_chg_w tractPerAcre30 if year == 1940 & region2num == 2 [aw=acfarm10] , ///
	n(100) absorb(stateicp) controls($countyControls $countyControls2) reportreg ///
	xtitle("Chg. in Tractors per Farm Acre, 1910-1940") ///
	ytitle("Change in No. of Farms, 1910-1940")


binscatter acfarm_chg_w pct_treated_crops_1910 if year == 1940 & region2num == 2 [aw=acfarm10] , ///
	n(100) absorb(stateicp) controls($countyControls $countyControls2) reportreg ///
	xtitle("Percent Treated Crops, 1910") ///
	ytitle("Change County Farm Acres, 1910-1940")

binscatter acfarm_chg_w tractPerAcre30 if year == 1940 & region2num == 2 [aw=acfarm10] , ///
	n(100) absorb(stateicp) controls($countyControls $countyControls2) reportreg ///
	xtitle("Chg. in Tractors per Farm Acre, 1910-1940") ///
	ytitle("Change in No. of Farms, 1910-1940")



binscatter farmsize_chg_w pct_treated_crops_1910 if year == 1940 & region2num == 2 [aw=acfarm10] , n(100) absorb(stateicp) controls($countyControls $countyControls2) reportreg ///
	title("Change in Acreage per Farm, 1910-1940") xtitle("Percent Treated Crops") ytitle("Percentage Points")
	
binscatter farmownchange_ac_w pct_treated_crops_1910 if year == 1940  & region2num == 2 [aw=acfarm10],  n(100) absorb(stateicp) controls($countyControls $countyControls2) reportreg


