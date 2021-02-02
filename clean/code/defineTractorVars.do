

*import data
use ./clean/output/AgPanel.dta, clear

* SET AS PANEL
gen countyid = state * 10000 + county
bysort countyid (year): gen t = _n
xtset countyid t


* define tractor variables for 1930
gen tractPerAcre = tractors / acfarm * 100
gen tractPerAcre30 = tractPerAcre if year == 1930
bysort countyid (t): egen temp = max(tractPerAcre30)
replace tractPerAcre30 = temp
drop temp
gen tractPerPerson = tractors / totpop * 100
gen tractPerPerson30 = tractPerPerson if year == 1930
bysort countyid (t): egen temp = max(tractPerPerson30)
replace tractPerPerson30 = temp
drop temp


* define tractor variables for 1940
gen tractPerAcre40 = tractPerAcre if year == 1940
bysort countyid (t): egen temp = max(tractPerAcre40)
replace tractPerAcre40 = temp
drop temp
gen tractPerPerson40 = tractPerPerson if year == 1940
bysort countyid (t): egen temp = max(tractPerPerson40)
replace tractPerPerson40 = temp
drop temp


* define tractor variables for 1925
gen tractPerAcre25 = tractPerAcre if year == 1925
bysort countyid (t): egen temp = max(tractPerAcre25)
replace tractPerAcre25 = temp
drop temp
gen tractPerPerson25 = tractPerPerson if year == 1925
bysort countyid (t): egen temp = max(tractPerPerson25)
replace tractPerPerson25 = temp
drop temp


* all motor vehicles 



* save 
save ./clean/output/tractorVars.dta, replace
