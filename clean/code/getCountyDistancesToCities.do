

set scheme plotplain , permanently
set more off, perm

cd "/Users/murpheis/Dropbox/UCB/TechChange"

global geofolder "/Volumes/My Passport for Mac/data/nhgis0003_shape"



use ./clean/input/uscounty1920_centers.dta, clear


bysort _ID: egen min_X = min(_X)
bysort _ID: egen max_X = max(_X)
bysort _ID: egen mean_X = (min_X + max_X)/2

bysort _ID: egen min_Y = min(_Y)
bysort _ID: egen max_Y = max(_Y)
bysort _ID: egen mean_Y = (min_Y + max_Y)/2



*
