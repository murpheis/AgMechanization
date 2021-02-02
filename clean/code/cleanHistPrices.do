
set scheme plotplain , permanently
set more off, perm
cd "/Users/murpheis/Dropbox/UCB/TechChange"

* Import Wheat
import excel using ./clean/input/farmprices.xlsx, sheet("wheat") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
rename m wheat
destring wheat, force replace
save ./clean/temp/temp.tmp, replace

* Import Corn
import excel using ./clean/input/farmprices.xlsx, sheet("corn") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
rename m corn
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace


* Import Cotton
import excel using ./clean/input/farmprices.xlsx, sheet("cotton") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m cotton
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace


* Import Sugar
import excel using ./clean/input/farmprices.xlsx, sheet("sugar") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m sugar
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace


* Import Potatoes
import excel using ./clean/input/farmprices.xlsx, sheet("potatoes") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m potatoes
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace


* Import Oats
import excel using ./clean/input/farmprices.xlsx, sheet("oats") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m oats
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace


* Import Cattle
import excel using ./clean/input/farmprices.xlsx, sheet("cattle") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m cattle
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace



* Import Hogs
import excel using ./clean/input/farmprices.xlsx, sheet("hogs") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m hogs
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace

* Import Milk
import excel using ./clean/input/farmprices.xlsx, sheet("milk") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m milk
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace

* Import Poultry
import excel using ./clean/input/farmprices.xlsx, sheet("poultry") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m poultry
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace


* Import Eggs
import excel using ./clean/input/farmprices.xlsx, sheet("eggs") firstrow clear
gen datem = 12*(year - 1960) + month - 1
format datem %tm
drop year month
destring m, force replace
rename m eggs
merge 1:1 datem using ./clean/temp/temp.tmp
drop _m
save ./clean/temp/temp.tmp, replace



* Import Tobacco
import excel using ./clean/input/farmprices.xlsx, sheet("tobacco") firstrow clear
rename Year year
save ./clean/temp/temptobacco.tmp, replace


* Import Hay
import excel using ./clean/input/farmprices.xlsx, sheet("hay") firstrow clear
save ./clean/temp/temphay.tmp, replace

* take annual averages
use ./clean/temp/temp.tmp, clear
gen year = yofd(dofm(datem))
collapse (mean) eggs poultry milk hogs cattle oats potatoes sugar corn cotton wheat, by(year)

* merge in Tobacco
merge 1:1 year using ./clean/temp/temptobacco.tmp
drop _m

* merge in hay
merge 1:1 year using ./clean/temp/temphay.tmp
drop _m

* Normalize each to Jan 1900
keep if year >= 1913
sort year
foreach var of varlist eggs poultry milk hogs cattle oats potatoes sugar corn cotton wheat tobacco hay {
local norm = `var'[1]
replace `var' = `var'/`norm'
}

* get changes
tsset year, y
foreach var of varlist eggs poultry milk hogs cattle oats potatoes sugar corn cotton wheat tobacco hay {
gen L`var' = L.`var'
gen D`var' = `var' - L.`var'
}


* check data
twoway line eggs poultry milk hogs cattle oats potatoes ///
            sugar corn cotton wheat tobacco hay year if year <= 1940 , ///
            title("Wholesale Prices of Ag. Products in the US") ///
            xtitle("Year") ytitle("Price, 1913 = 1") ///
            legend(ring(0) pos(1) col(2) lab(1 "eggs") lab(2 "poultry")  ///
            lab(3 "milk") lab(4 "pigs") lab(5 "cattle") lab(6 "oats") lab(7 "potatoes") ///
            lab(8 "sugar") lab(9 "corn") lab( 10 "cotton") lab(11 "wheat") lab(12 "tobacco") lab(13 "hay"))
            graph export ./analyze/output/AgPrices.png, as(png) replace
twoway line D* year if year <=1940, ///
            title("Change from Previous Year, Wholesale Prices of Ag. Products in the US") ///
            xtitle("Year") ytitle("Price, 1913 = 1") ///
            legend(ring(0) pos(4) col(2) lab(1 "eggs") lab(2 "poultry")  ///
            lab(3 "milk") lab(4 "pigs") lab(5 "cattle") lab(6 "oats") lab(7 "potatoes") ///
            lab(8 "sugar") lab(9 "corn") lab( 10 "cotton") lab(11 "wheat") lab(12 "tobacco") lab(13 "hay"))
            graph export ./analyze/output/ChangeAgPrices.png, as(png) replace

* SAVE
save ./clean/output/farmPrices.dta, replace
