
set scheme s1mono , permanently
set more off, perm

cd "/Users/murpheis/Dropbox/UCB/TechChange"

* =============================================================================*
*           IMPORT DATASETS AND APPEND TO CREATE HISTORICAL PANEL              *
* =============================================================================*

* 1840 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0002/35206-0002-Data.tsv", clear
keep state county name totpop horsemu* wheat* oats* corn* wool* potato* hay* ///
     tobacco* rice* cotton* sugar* irpoto* swpoto* cansug* maplesug* ///
     canesug* mapsug* maplsug* irpot* swpot* cropo totagout level fips region*
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist totpop - totagout {
    destring `var', replace force
}
gen year = 1840
save clean/temp/temp.dta, replace


* 1850 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0003/35206-0003-Data.tsv", clear
keep state county name farmval equipval horse mules wheat* oats* corn* ///
      wool* *pot* hay* tobacco* rice* cotton* *sug*   *agout* level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist farmval - agout3 {
    destring `var', replace force
}
rename agout1 cropo
rename  equipval farmequi
rename agout3 totagout
gen year = 1850
append using clean/temp/temp.dta
save clean/temp/temp.dta, replace

* 1860 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0004/35206-0004-Data.tsv", clear
keep state county name farmval equipval horse mules wheat* oats* corn* ///
      wool* *pot* hay* tobacco* rice* cotton* *sug*  slaves slhtot ///
      farm* *agout* level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist farmval - slaves {
    destring `var', replace force
}
rename  equipval farmequi
rename agout1 cropo
rename agout3 totagout
gen year = 1860
append using clean/temp/temp.dta
save clean/temp/temp.dta, replace

* 1870 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0005/35206-0005-Data.tsv", clear
keep state county name totpop farmval equipval farmout horse mules *wheat* oats* corn* ///
      wool* *pot* hay* tobacco* rice* cotton* *sug*   ///
      farm* level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist farmval - farm1000 {
    destring `var', replace force
}
rename  equipval farmequi
rename farmout totagout
gen year = 1870
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace

* 1880 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0006/35206-0006-Data.tsv", clear
keep state county name totpop farm* farmval equipval farmout horse mules *wheat* oats* corn* ///
      wool* *pot* hay* tobacco* rice* cotton* *sug*  ///
      farm* level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist totpop - wool {
    destring `var', replace force
}
rename  equipval farmequi
rename farmout totagout
rename csugar canesug
rename msugar maplesug
rename ipotato irpotato
rename spotato swpotato
gen year = 1880
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace

* 1890 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0007/35206-0007-Data.tsv", clear
keep state county name totpop *farm* farmval equipval farmout horse mules *wheat* ///
      oats* corn* *pot* hay* tobacco* rice* cotton* *sug* *irr*  ///
      farm* level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist totpop - intfarm {
    destring `var', replace force
}
rename  equipval farmequi
rename farmout totagout
rename csugar canesug
rename msugar maplesug
rename ipotato irpotato
rename spotato swpotato
gen year = 1890
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace

* 1900 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0008/35206-0008-Data.tsv", clear
keep state county name totpop *farm* farmval farmequi farmout horse* colt* ///
      mules* *wheat* oats* corn* wool* *pot* hay* tobac* rice* cotbale* *sug* ///
      tfarmhom fhowfree fhencumb fhrent  totval area* swine livstock ///
      level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist totpop - fhrent {
    destring `var', replace force
}
gen horses = colts0 + colts1_2 + horses20
gen mules = mules0 + mules1_2 + mules20
rename swine pigs
rename farmout totagout
rename csugarwt canesug
rename mapsugar maplesug
rename potatoes irpotato
replace area = 640 * area // convert to acres
gen year = 1900
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace

* 1910 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0009/35206-0009-Data.tsv", clear
rename foragac hayac
keep state county name totpop *farm* farmval farmequi  horse*  ///
      mules *wheat* oats* corn* wool* *pot* hay* tobacco* rice* cotton* *sug* ///
      tfarmhom fhowfree fhencumb fhrent totval area* fawages farebord ///
      farm* cropval level fips
destring fips, replace
gen statefips = fips / 1000
foreach var of varlist totpop - farmland2 {
    destring `var', replace force
}
rename farmown farmopown
rename csugar canesug
rename mapsugar maplesug
rename potatoes irpotato
rename farmland acfarm
rename farmneg farmcol
gen farmwh = farmnw + farmfbw
gen farmlab = fawages + farebord // total expenditures on labor
drop area
rename areaac area
gen year = 1910
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace


* 1920 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0010/35206-0010-Data.tsv", clear
rename var1 farms
rename var4 farmnw // Number of farms of native white farmers, 1920
rename var5 farmfbw // Number of farms of foreign white farmers, 1920
rename var6 farmcol // Number of farms of Negroes/non-white farmers, 1920
rename var7 farm02 // Number of farms of below 3 acres, 1920
rename var8 farm39 // Number of farms of 3-9 acres, 1920
rename var9 farm1019 //Number of farms of 10-19 acres, 1920
rename var10 farm2049 //Number of farms of 20-49 acres, 1920
rename var11 farm5099 //Number of farms of 50-99 acres, 1920
rename var12 farm100 //Number of farms of 100-174 acres, 1920
rename var13 farm175 //Number of farms of 175-259 acres, 1920
rename var14 farm260 //Number of farms of 260-499 acres, 1920
rename var15 farm500 //Number of farms of 500-999 acres, 1920
rename var16 farm1000 //Number of farms of 1000+ acres, 1920
rename var17 area // area of county in acres
rename var18 acfarm // area of farms in county (acres)
rename var22 totval // total farm value
rename var23 farmval // value of farm land and improvements exluding buildings
rename var25 farmequi //Value of farm implements/machinery, 1920 (dollars)
rename var26 livstock // value of livestock
rename var56 horses // Total number of horses, 1920
rename var63 mules // Total number of mules, 1920
rename var71 cattle //Value of cattle on farms & ranges ($), 1920
rename var99 pigs // Value of pigs on farms & ranges ($), 1920
rename var104 poultry // Value of poultry on farms & ranges ($), 1920
rename var117 eggs // dozens of eggs produced
rename var102 chickens //Total number of chickens, 1920
rename var107 milkprod // Gallons of milk produced (as reported), 1919
rename var148 corn //Corn (bu.), 1919
rename var147 cornac // Corn acreage, 1919
rename var150 oats //Oats (bu.), 1919
rename var149 oatsac //Oats acreage, 1919
rename var152 wheat //Wheat (bu.), 1919
rename var151 wheatac //Wheat acreage, 1919
rename var153 barleyac
rename var154 barley
rename var155 ryeac
rename var156 rye
rename var157 buckwheatac
rename var158 buckwheat
rename var177 hayac
rename var178 hay
rename var206 irpotato //Potatoes (bu.), 1919
rename var205 ipotatoac // potato acreage
rename var208 swpotato //Sweetpotatoes (bu.), 1919
rename var207 spotatoac // sweet potato acreage
rename var217 cotton //Cotton (bales), 1919
rename var216 cottonac // cotton acreage
rename var214 tobaccoac //Tobacco (lbs.), 1919
rename var215 tobacco //Tobacco (lbs.), 1919
rename var219 maplesug //Maple sugar (lbs.), 1919
rename var222 canesug //Sugar cane, tons sold, 1919
rename var221 csugarac // sugar cane acreage
rename var299 fhowfree //Number of owned farms free from mortgage debt, 1920
rename var300 fhencumb //Number of owned farms with mortgage debt, 1920
rename var307 farmlab // expenditures on farm Labor
rename var308 labexp // labor expenditures
rename var309 fawages // wages for Labor
rename var310 farebord // exp. on fare and board of laborers
rename var166 rice // Rice (lbs.), 1919
rename var138 cropval // total crop value
keep state county name totpop *farm*  farmequi  horse  ///
      mules *wheat* oats* corn*  *pot* tobacco* rice* cotton* *sug* ///
      fhowfree fhencumb farm* level fips statefip *area* labexp totval ///
      pigs cattle poultry chickens milk* eggs livstock fawages farebord ///
      hay* buck* barley* rye* cropval
destring fips, replace
gen statefips = fips / 1000
order state county name fips statefip level *
foreach var of varlist totpop - farebord {
    destring `var', replace force
}
gen farmwh = farmnw + farmfbw
gen year = 1920
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace


* 1925 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0012/35206-0012-Data.tsv", clear
rename var2 farms // Total number of farms, 1925
rename  var3 farm02 //Number of farms below 3 acres, 1925
rename  var4 farm39 //Number of farms of 3-9 acres, 1925
rename  var5 farm1019 //Number of farms of 10-19 acres, 1925
rename  var6 farm2049 //Number of farms of 20-49 acres, 1925
rename  var7 farm5099 //Number of farms of 50-99 acres, 1925
rename  var8 farm100 //Number of farms of 100-174 acres, 1925
rename  var9 farm175 //Number of farms of 175-259 acres, 1925
rename  var10 farm260 //Number of farms of 260-499 acres, 1925
rename  var11 farm500 //Number of farms of 500-999 acres, 1925
rename var12 farm1000 //Number of farms of 1000-4999 acres, 1925
rename var13 farm5000 //Number of farms of 5000 or more acres, 1925
rename var72 acfarm //All land in farms, acres, 1925
rename var71 area // total area in acres
rename var126 totval //Value of farm: all farm property ($), 1925
rename var127 farmval // value of farm land and improvements (no buildings)
rename var129 farmequi //Value of farm: implements & machinery ($), 1925
rename var130 livstock // value of livestock
rename var166 fhencumb //Farms operated by full owners reporting mortgage debt, 1925
rename var182 fawages // labor expenditures (just money wages)
rename var188 tractors //Tractors on farms, 1925
rename var199 horses //Total number of horses, 1925
rename var203 mules //Total number of mules, 1925
rename var261 corn //Corn harvested for grain (bu.), 1924
rename var267 wheat //Wheat (bu.), 1924
rename var269 oats //Oats threshed for grain (bu.), 1924
rename var280 rice //Rice (rough) (bu.), 1924
rename var298 hay //Total quantity of hay of all kinds, both tame & wild (tons), 1924
rename var300 cotton //Cotton (bales), 1924
rename var304 canesug //Sugar cane for sugar or sirup (tons), 1924
rename var307 tobacco //Tobacco (lbs.), 1924
rename var309 irpotato //Potatoes, white (bu.), 1924
rename var311 swpotato //Sweetpotatoes & yams (bu.), 1924
rename var257 cropval // crop value in 1924
rename var15 farmwh // total number of white farms
rename var16 farmcol // total number of non-white farms
keep state county name  *farm*  farmequi  horse  area ///
      mules tractors *wheat* oats* corn*  *pot* tobacco* rice* cotton* *sug* ///
      fhencumb farm* level fips statefip region* totval livstock fawages cropval
destring fips, replace
gen statefips = fips / 1000
order state county name fips statefip level *
foreach var of varlist farms - swpotato {
    destring `var', replace force
}
gen year = 1925
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace

* 1930 DATA (all the labels should say 1930...they're correct just milabeled below)
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0013/35206-0013-Data.tsv", clear
rename var1 totpop //Total population, 1920
rename var2 farms // Total number of farms, 1925
rename var6 area // total acres in county
rename var8 acfarm // acres of farm land
rename  var85 farm02 //Number of farms below 3 acres, 1925
rename  var86 farm39 //Number of farms of 3-9 acres, 1925
rename  var87 farm1019 //Number of farms of 10-19 acres, 1925
rename  var88 farm2049 //Number of farms of 20-49 acres, 1925
rename  var89 farm5099 //Number of farms of 50-99 acres, 1925
rename  var90 farm100 //Number of farms of 100-174 acres, 1925
rename  var91 farm175 //Number of farms of 175-259 acres, 1925
rename  var92 farm260 //Number of farms of 260-499 acres, 1925
rename  var93 farm500 //Number of farms of 500-999 acres, 1925
rename var94 farm1000 //Number of farms of 1000-4999 acres, 1925
rename var95 farm5000 //Number of farms of 5000 or more acres, 1925
rename var120 totval // value of farm land and buildings (doesn't list livestock and equipment)
rename var121 farmval // value of land (no buildings)
rename var125 farmequi //Value of farm: implements & machinery ($), 1925
rename var172 horses //Total number of horses on farms, 1930
rename var182 mules //Total number of mules on farms, 1930
rename var238 corn_grain //Corn harvested for grain, bushels, 1929
rename var241 corn_silage //Corn cut for silage, bushels, 1929
rename var246 wheat //Wheat threshed, total, bushels, 1929
rename var257 oats //Oats-threshed, bushels, 1929
rename var274 rice //Rice (rough), bushels, 1929
rename var277 hay //Hay crops, total, tons, 1929
rename var306 cotton //Cotton, lint, bales, 1929
rename var313 canesug //Sugarcane harvested for sugar, or sale to mills, tons of cane, 1929
rename var319 tobacco //Tobacco, pounds, 1929
rename var322 irpotato //Potatoes (Irish or white), bushels, 1929
rename var325 swpotato //Sweetpotatoes & yams, bushels, 1929
rename var953 fhowfree //Farm mortgage debt: all farms operated by owners, free from mortgage debt, number, 1930
rename var954 fhencumb //Farm mortgage debt: all farms operated by owners, mortgaged, number, 1930
rename var1007 fawages //Farm expenditures for: farm labor, exclusive of housework (cash),
rename var1010 invest_machines //Farm expenditures for: farm implements & machinery (including automobiles, trucks, tractors, etc.), $, 1929
rename var1012 invest_elec //Farm expenditures for: electric light & power (paid to a power company),$, 1929
rename var1014 cars //Farm machinery: automobiles, number, 1930
rename var1016 trucks //Farm machinery: motor trucks, number, 1930
rename var1018 tractors //Farm machinery: tractors, number, 1930
rename var4 farmwh
rename var5 farmcol
rename var1096 cropval
keep state county name totpop *farm*  farmequi totval horses area  ///
      mules *wheat* oats* corn*  *pot* tobacco* rice* hay cotton *sug* ///
      fhencumb fhowfree invest* cars trucks tractors level fips statefip region* ///
      fawages cropval
destring fips, replace
gen statefips = fips / 1000
order state county name fips statefip level *
foreach var of varlist totpop - cropval {
    destring `var', replace force
}
gen year = 1930
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace


* 1940 DATA
import delimited using "/Volumes/My Passport for Mac/data/ICPSR_35206/DS0016/35206-0016-Data.tsv", clear
rename var1 totpop //Total population, 1920
rename var4 farms // Total number of farms, 1925
rename var5 area // total land area in acres, 1940
rename var7 acfarm //All land in farms, acres, 1940
rename  var112 farm02 //Number of farms below 3 acres, 1925
rename  var114 farm39 //Number of farms of 3-9 acres, 1925
rename  var116 farm1019 //Number of farms of 10-19 acres, 1925
*gen farm2049 = var117+var115-var116 //Number of farms of 20-49 acres, 1925
*gen farm5099 =  var118 + var119 //Number of farms of 50-99 acres, 1925
*gen farm100 = var120 + var121 - var122 //Number of farms of 100-174 acres, 1925
*gen farm175  = var122 + var123 + var124 //Number of farms of 175-259 acres, 1925
*gen farm260 = var125 + var126 //Number of farms of 260-499 acres, 1925
*gen farm500 = var127 + var128 //Number of farms of 500-999 acres, 1925
rename var129 farm1000plus //Number of farms of 1000-4999 acres, 1925
rename var188 horsemule // Horses &/or mules, number (calculated), 1940
rename var29 totval //Value of farm: all farm property ($), 1925
rename var33 farmequi //Value of farm: implements & machinery ($), 1925
rename var560 fawages // money wages for labor
rename var594 tractors // Tractors on farms, number, April 1, 1940
rename var400 fhowfree // Owners, number free from mortgage, April 1, 1940
rename var401 fhencumb // Owners, number mortgaged, April 1, 1940
rename var34 farmwh
rename var35 farmcol
rename var582 cars
rename var588 trucks
keep state county name totpop *farm*  farmequi    ///
      horsemule *area totval fawages cars trucks ///
      fhencumb fhowfree tractors level fips statefip region*
destring fips, replace
gen statefips = fips / 1000
order state county name fips statefip level *
foreach var of varlist totpop - tractors {
    destring `var', replace force
}
gen year = 1940
drop if mi(fips) // for some reasons there are duplicates of each county with no data
append using clean/temp/temp.dta, force
save clean/temp/temp.dta, replace


* combine corn variable
replace corn = corn_grain + corn_silage if mi(corn)

* combine mortgage variable
replace fhencumb = farmencu if mi(fhencumb)

* CLEAN UP PANEL
keep if year >= 1900
keep if level == 1
drop if statefip == "2" // drop alaska
drop if statefip == "15" // drop hawaii
gen ICPSRFIP = fips
drop if mi(fips)
bysort year fips: gen N = _N
drop if N >1 // not many obs (2 total)
drop N



* SAVE TO OUTPUT FOLDER
save clean/output/AgPanel.dta, replace
