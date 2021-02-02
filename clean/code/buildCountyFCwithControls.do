
set scheme plotplain , permanently
set more off, perm

cd "/home/ipums/emily-ipums/TechChange"


*===========================================*
* 		SET UP DATA
*===========================================*


* import aggregated County Data
use ./clean/output/countiesFC.dta, clear


* merge to banks
merge 1:1 stateicp county year using ./analyze/input/banks19201930.dta
drop if _m == 2
drop _m
drop level


* merge to distances file
merge m:1 stateicp county using ./analyze/input/majorcity_distances.dta
drop if _m == 2
drop _m
qui sum dist_closest_city
replace dist_closest_city = (dist_closest_city- r(mean))/r(sd)


* MERGE TO AG CENSUS
gen state = stateicp
drop statefip
merge 1:1 state county year using ./clean/output/AgPanel.dta
drop if year == 1925


* SET AS PANEL
gen countyid = state * 10000 + county
bysort countyid (year): gen t = _n
xtset countyid t


* ag census controls
bysort county state: gen acfarm10 = acfarm if year == 1910
bysort county state: egen acfarm10_max = max(acfarm10)
replace acfarm10 = acfarm10_max
drop acfarm10_max
bysort county state: gen farmsize10 = acfarm/farms /100 if year == 1910
bysort county state: egen farmsize10_max = max(farmsize10)
replace farmsize10 = farmsize10_max
drop farmsize10_max
rename ipotatoac potatoesac
rename csugarac sugarac
local variables "wheat oats cotton sugar potatoes corn tobacco hay"
foreach var of local variables {
  replace `var'ac = 0 if mi(`var'ac)
  gen pct_`var' = `var'ac/ acfarm
  gen pct_`var'_1920 = pct_`var' if year == 1920
  gen pct_`var'_1910 = pct_`var' if year == 1910
  bysort countyid: egen pct_`var'_1920_max = max(pct_`var'_1920)
  bysort countyid: egen pct_`var'_1910_max = max(pct_`var'_1910)
  replace pct_`var'_1920 = pct_`var'_1920_max
  replace pct_`var'_1910 = pct_`var'_1910_max
  drop  pct_`var'_1920_max
  drop  pct_`var'_1910_max
}

* TREATED CROPS
gen pct_treated_crops = pct_hay + pct_wheat + pct_oats
gen pct_treated_crops_1910 = pct_hay_1910 + pct_wheat_1910 + pct_oats_1910


* REGIONAL CONTROLS
encode region1, gen(region1num)
encode region2, gen(region2num)
tab region1, gen(region1cat)
tab region2, gen(region2cat)
tab state, gen(statecat)
bysort countyid : egen temp = max(region1num)
replace region1num = temp
drop temp
bysort countyid : egen temp = max(region2num)
replace region2num = temp
drop temp


* SYNTHETIC JOBS AT THREAT
gen farmerperacre = farm/acfarm 
qui sum farmerperacre if year == 1910 [aw=acfarm10]
gen insecure_jobs = pct_treated_crops_1910 * r(mean) * 100
rename insecure_jobs insecure_jobs_1910


* define baseline controls
xtset countyid t
gen Dmanu = ind_manu/pop - (L.ind_manu/L.pop)
bysort countyid (t): gen Dmanu10 = Dmanu if year == 1910
bysort countyid (t): egen Dmanu10_max = max(Dmanu10)
replace Dmanu10 = Dmanu10_max
drop Dmanu10_max
label var Dmanu10 "Man. Growth 1900-10"


* keep manu proportion for 1910 as separate var
gen ind_manu_pct = ind_manu/pop
bysort countyid (t): gen ind_manu10 = ind_manu_pct if year == 1910
bysort countyid (t): egen ind_manu10_max = max(ind_manu10)
replace ind_manu10 = ind_manu10_max
drop ind_manu10_max
label var ind_manu10 "Manu. \% 1910"
gen ind_manu_pct_chg = ind_manu_pct - L.ind_manu_pct
bysort countyid (t): gen ind_manu_pct_chg10 = ind_manu_pct_chg if year == 1910
bysort countyid (t): egen temp = max(ind_manu_pct_chg10)
replace ind_manu_pct_chg10 = temp
drop temp
label var ind_manu_pct_chg10 "Manu. \% 1910"


* keep banks in 1920 as separate var
bysort countyid (t): gen bankstot20 = bankstot if year == 1920
bysort countyid (t): egen bankstot20_max = max(bankstot20)
replace bankstot20 = bankstot20_max
drop bankstot20_max
label var bankstot20 "Banks 1920"


* keep farm land value change in 1920 as separate var
gen valPerAcre = totval/acfarm
gen pctD_valPerAcre = (valPerAcre - L.valPerAcre)/L.valPerAcre
bysort countyid (t): gen pctD_valPerAcre20 = pctD_valPerAcre if year == 1920
bysort countyid (t): egen pctD_valPerAcre20_max = max(pctD_valPerAcre20)
replace pctD_valPerAcre20 = pctD_valPerAcre20_max
drop pctD_valPerAcre20_max
label var pctD_valPerAcre20 "\% $\Delta$ Farm Land Val. 1910-20"
bysort countyid (t): gen pctD_valPerAcre30 = pctD_valPerAcre if year == 1930
bysort countyid (t): egen pctD_valPerAcre30_max = max(pctD_valPerAcre30)
replace pctD_valPerAcre30 = pctD_valPerAcre30_max
drop pctD_valPerAcre30_max
label var pctD_valPerAcre30 "\% $\Delta$ Farm Land Val. 1920-30"
bysort countyid (t): gen pctD_valPerAcre10 = pctD_valPerAcre if year == 1910
bysort countyid (t): egen pctD_valPerAcre10_max = max(pctD_valPerAcre10)
replace pctD_valPerAcre10 = pctD_valPerAcre10_max
drop pctD_valPerAcre10_max
label var pctD_valPerAcre10 "\% $\Delta$ Farm Land Val. 1900-10"
bysort countyid (t): gen valPerAcre10 = valPerAcre if year == 1910
bysort countyid (t): egen valPerAcre10_max = max(valPerAcre10)
replace valPerAcre10 = valPerAcre10_max
drop valPerAcre10_max
label var valPerAcre10 "Farm Val/Acre, 1910"
bysort countyid (t): gen valPerAcre20 = valPerAcre if year == 1920
bysort countyid (t): egen valPerAcre20_max = max(valPerAcre20)
replace valPerAcre20 = valPerAcre20_max
drop valPerAcre20_max
label var valPerAcre20 "Farm Val/Acre, 1920"
bysort countyid (t): gen valPerAcre00 = valPerAcre if year == 1900
bysort countyid (t): egen valPerAcre00_max = max(valPerAcre00)
replace valPerAcre00 = valPerAcre00_max
drop valPerAcre00_max
label var valPerAcre00 "Farm Val/Acre, 1900"

gen valPerAcre_chg = (valPerAcre - L.valPerAcre)
bysort countyid (t): gen valPerAcre_chg10 = valPerAcre_chg if year == 1910
bysort countyid (t): egen temp = max(valPerAcre_chg10)
replace valPerAcre_chg10 = temp
drop temp
label var valPerAcre_chg10 "$\Delta$ Farm Land Val. 1900-10"

* keep pct urban in 1910
gen pct_urban = urban / pop
bysort countyid (t): gen pct_urban_1910 = pct_urban if year == 1910
bysort countyid (t): egen pct_urban_1910_max = max(pct_urban_1910)
replace pct_urban_1910 = pct_urban_1910_max
drop pct_urban_1910_max
bysort countyid (t): gen pct_urban_1900 = pct_urban if year == 1900
bysort countyid (t): egen pct_urban_1900_max = max(pct_urban_1900)
replace pct_urban_1900 = pct_urban_1900_max
drop pct_urban_1900_max


* population and farm population change pre 1910
gen popchange1910 = (pop - L.pop ) /L.acfarm * 100 if year == 1910
bysort countyid (t): egen temp = max(popchange1910)
replace popchange1910 = temp
drop temp
label var popchange1910 "$\Delta$ Pop, 1900-10"
gen farmpopchg1910 = (farm - L.farm)   /L.pop * 100 if year == 1910
bysort countyid (t): egen temp = max(farmpopchg1910)
replace farmpopchg1910 = temp
drop temp
gen farmlabchg1910 = ((farm - farmowner) - (L.farm - L.farmowner)) / L.pop * 100 if year == 1910
bysort countyid (t): egen temp = max(farmlabchg1910)
replace farmlabchg1910 = temp
drop temp



* outcome variables
gen popperacre = pop / area * 100 
gen popperacre10 = popperacre if year == 1910
bysort countyid (t): egen temp = max(popperacre10)
replace popperacre10 = temp
drop temp
gen popperacre10_chg = popperacre - L.popperacre if year == 1910
bysort countyid (t): egen temp = max(popperacre10_chg)
replace popperacre10_chg = temp
drop temp

gen farmpopperacre = farm / area * 100
gen farmpopperacre10 = farmpopperacre if year == 1910
bysort countyid (t): egen temp = max(farmpopperacre10)
replace farmpopperacre10 = temp
drop temp
gen farmpopperacre10_chg = farmpopperacre - L.farmpopperacre if year == 1910
bysort countyid (t): egen temp = max(farmpopperacre10_chg)
replace farmpopperacre10_chg = temp
drop temp

gen indagperacre = ind_ag / area * 100
gen indagperacre10 = indagperacre if year == 1910
bysort countyid (t): egen temp = max(indagperacre10)
replace indagperacre10 = temp
drop temp
gen indagperacre10_chg = indagperacre - L.indagperacre if year == 1910
bysort countyid (t): egen temp = max(indagperacre10_chg)
replace indagperacre10_chg = temp
drop temp

gen indmanuperacre = ind_manu / area * 100
gen indmanuperacre10 = indmanuperacre if year == 1910
bysort countyid (t): egen temp = max(indmanuperacre10)
replace indmanuperacre10 = temp
drop temp
gen indmanuperacre10_chg = indmanuperacre - L.indmanuperacre if year == 1910
bysort countyid (t): egen temp = max(indmanuperacre10_chg)
replace indmanuperacre10_chg = temp
drop temp

gen urbanperacre = urban / area * 100
gen urbanperacre10 = urbanperacre if year == 1910
bysort countyid (t): egen temp = max(urbanperacre10)
replace urbanperacre10 = temp
drop temp
gen urbanperacre10_chg = urbanperacre - L.urbanperacre if year == 1910
bysort countyid (t): egen temp = max(urbanperacre10_chg)
replace urbanperacre10_chg = temp
drop temp

* farm stuff
gen horseperacre = horses/area * 100
gen horseperacre10 = horseperacre if year == 1910
bysort countyid (t): egen temp = max(horseperacre10)
replace horseperacre10 = temp
drop temp
gen horseperacre10_chg = horseperacre - L.horseperacre if year == 1910
bysort countyid (t): egen temp = max(horseperacre10_chg)
replace horseperacre10_chg = temp
drop temp

gen farmperacre = acfarm / area * 100
gen farmperacre10 = farmperacre if year == 1910
bysort countyid (t): egen temp = max(farmperacre10)
replace farmperacre10 = temp
drop temp
gen farmperacre10_chg = farmperacre - L.farmperacre if year == 1910
bysort countyid (t): egen temp = max(farmperacre10_chg)
replace farmperacre10_chg = temp
drop temp


* winsorize
winsor2 tract*  popchange* popperacre* farmpopperacre*  ///
	  indagperacre* indmanuperacre* ///
	horseperacre* farmperacre* urbanperacre*   valPerAcre* ///
	, replace cut(1 99)




* SAVE
drop _merge
save ./clean/output/countyFCwithControls.dta, replace

