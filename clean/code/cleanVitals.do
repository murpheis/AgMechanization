set more off, perm

cd "/Users/murpheis/Dropbox/UCB/TechChange"

clear




* import data
import excel using ./clean/input/fishback_copy_of_mtco2129.xls, sheet("data") firstrow clear

* rename VARIABLES
rename STATE state
rename COUNTY county
rename _FREQ_ numSources


* label variables
label var state	"State Code from ICPSR"
label var county	"County Code from ICPSR"
label var year	"Year"
label var rbir	"Rural Births"
label var rdth	"Rural Noninfant Deaths"
label var rindth	"Rural Infant Deaths"
label var cname	"County Name"
label var rstb	"rural stillbirths"
label var numSources	"Number of cities and rural areas combined to get total for county"
label var cbir	"City Births"
label var cindth	"City Infant Deaths"
label var cstb	"City Still Births"
label var cdth	"City Noninfant Deaths."
label var bir	"Total Births in City and Rural Areas"
label var dth	"Total Noninfant Deaths in City and Rural Areas"
label var indth	"Total Infant Deaths in City and Rural Areas"
label var stb	"Total Stillbirths in City and Rural Areas"

* save
save ./clean/output/vitalityData_1921_1929_county.dta, replace

* collapse to whole decade
collapse (sum) rbir rdth rindth rstb cbir cindth cstb cdth bir dth indth stb , by(state county)


* label variables
label var state	"State Code from ICPSR"
label var county	"County Code from ICPSR"
label var rbir	"Rural Births"
label var rdth	"Rural Noninfant Deaths"
label var rindth	"Rural Infant Deaths"
label var rstb	"rural stillbirths"
label var cbir	"City Births"
label var cindth	"City Infant Deaths"
label var cstb	"City Still Births"
label var cdth	"City Noninfant Deaths."
label var bir	"Total Births in City and Rural Areas"
label var dth	"Total Noninfant Deaths in City and Rural Areas"
label var indth	"Total Infant Deaths in City and Rural Areas"
label var stb	"Total Stillbirths in City and Rural Areas"

* save
save ./clean/output/vitalityData_decadeTotal_county.dta, replace
