set more off, perm
clear


cd ~/TechChange


*===========================================*
* 		1920-1930
*===========================================*


/*
* IMPORT LINKED POPULATION CENSUS DATA
use ~/censusLinking/output/census2030linkedHP_JW.dta, clear


* destring distance measures
destring totdist_20, replace force


* limit to best links
keep if  totdist_20 < -4.5 
  
* SET UP OUTCOME VARIABLES
rename farm farm_20
gen leftfarm_30 = farm_20 == 2 & farm_30 == 1
gen joinedfarm_30 = farm_20 == 1 & farm_30 == 2
gen moved_30 = ((stateicp_30 ~= stateicp_20) | (stateicp_30 == stateicp_20 & county_30 ~= county_20))
gen movedFar_30 = (stateicp_30 ~= stateicp_20)
label var leftfarm_30 "Left Farm, 1920-30"
label var joinedfarm_30 "Joined Farm, 1920-30"
label var moved_30 "Moved Counties, 1920-30"
label var movedFar_30 "Moved States, 1920-30"
  
* SAVE
save ./clean/output/linked2030clean.dta, replace  



*===========================================*
* 		1920-1940
*===========================================*



* IMPORT LINKED POPULATION CENSUS DATA
use ~/censusLinking/output/census2040linkedHP_JW.dta, clear


* destring distance measures
destring totdist_20, replace force


* limit to best links
keep if  totdist_20 < -4.5 
  
* SET UP OUTCOME VARIABLES
gen leftfarm_40 = farm_20 == 2 & farm_40 == 1
gen joinedfarm_40 = farm_20 == 1 & farm_40 == 2
gen moved_40 = ((stateicp_40 ~= stateicp_20) | (stateicp_40 == stateicp_20 & county_40 ~= county_20))
gen movedFar_40 = (stateicp_40 ~= stateicp_20)
label var leftfarm_40 "Left Farm, 1930-40"
label var joinedfarm_40 "Joined Farm, 1930-40"
label var moved_40 "Moved Counties, 1930-40"
label var movedFar_40 "Moved States, 1930-40"  
  
  
* SAVE
save ./clean/output/linked2040clean.dta, replace  




*===========================================*
* 		1910-1920
*===========================================*



*import delimited using ~/censusLinking/output/census1020linkedHP_JW.csv, delim(tab) clear
*save ~/censusLinking/output/census1020linkedHP_JW.dta, replace


* IMPORT LINKED POPULATION CENSUS DATA
*use ~/censusLinking/output/census1020linkedHP_JW.dta, clear


import delimited using ~/censusLinking/output/census1020linkedHP_JW_best.csv, delim(tab) clear
save ~/censusLinking/output/census1020linkedHP_JW_best.dta, replace

use ~/censusLinking/output/census1020linkedHP_JW_best.dta, clear

* destring distance measures
destring totdist_20, replace force


* limit to best links
keep if  totdist_20 < -4.5 

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb


* SET UP OUTCOME VARIABLES
gen leftfarm_20 = farm_10 == 2 & farm_20 == 1
gen joinedfarm_20 = farm_10 == 1 & farm_20 == 2
gen moved_20 = ((stateicp_20 ~= stateicp_10) | (stateicp_20 == stateicp_10 & county_10 ~= county_20))
gen movedFar_20 = (stateicp_20 ~= stateicp_10)
label var leftfarm_20 "Left Farm, 1910-20"
label var joinedfarm_20 "Joined Farm, 1910-20"
label var moved_20 "Moved Counties, 1910-20"
label var movedFar_20 "Moved States, 1910-20"
  
* SAVE
save ./clean/output/linked1020clean_best.dta, replace  



*/

*===========================================*
* 		1900-1910
*===========================================*



*import delimited using ~/censusLinking/output/census010linkedHP_JW.csv, delim(tab) clear
*save ~/censusLinking/output/census010linkedHP_JW.dta, replace


import delimited using ~/censusLinking/output/census010linkedW.csv, delim(tab) clear
save ~/censusLinking/output/census010linkedJW_best.dta, replace



* IMPORT LINKED POPULATION CENSUS DATA
*use ~/censusLinking/output/census010linkedJW_best.dta, clear


* destring distance measures
destring totdist_10, replace force


* limit to best links
keep if  totdist_10 < -4.5 

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb

* SET UP OUTCOME VARIABLES
gen leftfarm_10 = farm_00 == 2 & farm_10 == 1
gen joinedfarm_10 = farm_00 == 1 & farm_10 == 2
rename countyicp_10 county_10
gen moved_10 = ((stateicp_10 ~= stateicp_00) | (stateicp_10 == stateicp_00 & county_00 ~= county_10))
gen movedFar_10 = (stateicp_10 ~= stateicp_00)
label var leftfarm_10 "Left Farm, 1900-10"
label var joinedfarm_10 "Joined Farm, 1900-10"
label var moved_10 "Moved Counties, 1900-10"
label var movedFar_10 "Moved States, 1900-10"
  
* SAVE
save ./clean/output/linked0010clean_best.dta, replace  




*===========================================*
* 		1910-1940
*===========================================*




*import delimited using ~/censusLinking/output/census1040linkedHP_JW.csv,  clear
import delimited using ~/censusLinking/output/census1040linkedHP_JW_best.csv,  clear
save ~/censusLinking/output/census1040linkedJW_best.dta, replace



* IMPORT LINKED POPULATION CENSUS DATA
*use ~/censusLinking/output/census010linkedJW_best.dta, clear


* limit to best links
*keep if  totdist_40 < -4.5 

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb

* SET UP OUTCOME VARIABLES
gen leftfarm_40 = farm_10 == 2 & farm_40 == 1
gen joinedfarm_40 = farm_10 == 1 & farm_40 == 2
rename countyicp_10 county_10
rename countyicp_40 county_40
gen moved_40 = ((stateicp_40 ~= stateicp_10) | (stateicp_40 == stateicp_10 & county_10 ~= county_40))
gen movedFar_40 = (stateicp_40 ~= stateicp_10)
label var leftfarm_40 "Left Farm, 1910-40"
label var joinedfarm_40 "Joined Farm, 1910-40"
label var moved_40 "Moved Counties, 1910-40"
label var movedFar_40 "Moved States, 1910-40"
  
* SAVE
save ./clean/output/linked1040clean_best.dta, replace  




*===========================================*
* 		1910-1930
*===========================================*
/*

*import delimited using ~/censusLinking/output/census1030linkedHP_JW.csv, delim(tab) clear
*save ~/censusLinking/output/census1030linkedHP_JW.dta, replace


* IMPORT LINKED POPULATION CENSUS DATA
*use ~/censusLinking/output/census1030linkedHP_JW.dta, clear

import delimited using ~/censusLinking/output/census1030linkedHP_JW_best.csv, delim(tab) clear
save ~/censusLinking/output/census1030linkedHP_JW.dta_best, replace


* destring distance measures
destring totdist_30, replace force


* limit to best links
keep if  totdist_30 < -4.5 

* fix duplicates issue
bysort id_a: gen Na = _n
keep if Na == 1 
bysort id_b: gen Nb = _n
keep if Nb == 1
drop Na Nb

* SET UP OUTCOME VARIABLES
gen leftfarm_30 = farm_10 == 2 & farm_30 == 1
gen joinedfarm_30 = farm_10 == 1 & farm_30 == 2
gen moved_30 = ((stateicp_30 ~= stateicp_10) | (stateicp_30 == stateicp_10 & county_10 ~= county_30))
gen movedFar_30 = (stateicp_30 ~= stateicp_10)
label var leftfarm_30 "Left Farm, 1910-30"
label var joinedfarm_30 "Joined Farm, 1910-30"
label var moved_30 "Moved Counties, 1910-30"
label var movedFar_30 "Moved States, 1910-30"
  
* SAVE
save ./clean/output/linked1030clean_best.dta, replace  
*/

**********************
* CLEAN MOM/DAD DATA *
**********************

*1900
import delimited ../censusLinking/output/1900dads.csv, clear
rename * *_00
rename * pop_*
rename pop_serialp_00 serialp_00
gen poploc_00 = pop_pernum_00
save ./clean/output/1900dads.dta, replace
import delimited ../censusLinking/output/1900moms.csv, clear
rename * *_00
rename * mom_*
rename mom_serialp_00 serialp_00
gen momloc_00 = mom_pernum_00
save ./clean/output/1900moms.dta, replace


*1910
import delimited ../censusLinking/output/1910dads.csv, clear
rename * *_10
rename * pop_*
rename pop_serialp_10 serialp_10
gen poploc_10 = pop_pernum_10
save ./clean/output/1910dads.dta, replace
import delimited ../censusLinking/output/1910moms.csv, clear
rename * *_10
rename * mom_*
rename mom_serialp_10 serialp_10
gen momloc_10 = mom_pernum_10
save ./clean/output/1910moms.dta, replace
