set more off, perm
set scheme plotplain
cd "/home/ipums/emily-ipums/TechChange/"

global geofolder "/home/ipums/emily-ipums/TechChange/analyze/input/shapeFiles"




* GET RELEVANT PRICE DATA
use ./clean/output/farmPrices.dta, clear


* chart of price time series
label var tobacco "tobacco"
label var potatoes "potatoes"
label var sugar "sugar"
label var corn "corn"
label var cotton "cotton"
label var wheat "wheat"
label var oats "oats"
label var hay "hay"
line  tobacco potatoes sugar corn cotton wheat oats hay year if year <= 1930, ///
	xline(1917) color(gray gray gray gray gray red red red) ///
	legend(ring(0) pos(11)) xlabel(1913(1)1930) xtitle("")
	graph export ./analyze/output/priceTS.png, as(png) replace
	

* regression of prices around 
keep tobacco potatoes sugar corn cotton wheat oats hay year
rename * p*
rename pyear year
reshape long p, i(year) j(crop) string
gen post = (year >1917)
gen smallgrain = (crop == "wheat") |  (crop == "oats") | (crop == "hay")
gen postSG = post * smallgrain

label var post "Post-1917"
label var smallgrain "Small Grain"
label var postSG "Post x Small Grain"
eststo clear
eststo: qui reg p postSG post smallgrain  
eststo: qui reg p postSG post smallgrain  if year <= 1921
eststo: qui reg p postSG post smallgrain  if year <= 1925
eststo: qui reg p postSG post smallgrain  if year <= 1930
esttab * , l se compress 
esttab * using ./analyze/output/priceDD.tex, l se compress replace ///
	title("Decline in prices of small grains around tractor difussion") ///
	mtitles("1913-1950" "1913-1921" "1913-1925" "1913-1930")
