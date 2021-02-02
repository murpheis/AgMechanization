
set scheme plotplain , permanently
set more off, perm

cd "/home/ipums/emily-ipums/TechChange"



* 1850

import delimited ./clean/output/counties1850.csv, delim(",") clear
gen year = 1850
save ./clean/temp.tmp, replace



* 1860

import delimited ./clean/output/counties1860.csv, delim(",") clear
gen year = 1860
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace


* 1870

import delimited ./clean/output/counties1870.csv, delim(",") clear
gen year = 1870
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace


* 1880

import delimited ./clean/output/counties1880.csv, delim(",") clear
gen year = 1880
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace



* 1900

import delimited ./clean/output/counties1900.csv, delim(",") clear
gen year = 1900
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace


* 1910

import delimited ./clean/output/counties1910.csv, delim(",") clear
gen year = 1910
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace


* 1920

import delimited ./clean/output/counties1920.csv, delim(",") clear
gen year = 1920
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace


* 1930

import delimited ./clean/output/counties1930.csv, delim(",") clear
gen year = 1930
append using ./clean/temp.tmp
save ./clean/temp.tmp, replace


* 1940

import delimited ./clean/output/counties1940.csv, delim(",") clear
gen year = 1940
append using ./clean/temp.tmp

* rename n
rename n pop

* rename county
rename countyicp county



* save
save ./clean/output/countiesFC.dta, replace


