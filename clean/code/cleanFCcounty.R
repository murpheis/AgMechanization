# PACKAGES
#install.packages("data.table")
library("data.table")


# SET WORKING DIRECTORY
setwd("~/")




##################
###### 1940 ######
##################


basedir="/ipums-repo2019-1/1940/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM", "OWNERSHP", "MORTGAGE", "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$owner <- data$OWNERSHP == 10
data$farmowner <- data$FARM*data$owner
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM
data$AAfarmOwner <- data$AfrAmer & data$farmowner

# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(owner),sum(farmowner),sum(AfrAmer),sum(white),sum(AAfarm),sum(AAfarmOwner),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban"  ,  "owner"   , "farmowner","AfrAmer","white","AAfarm","AAfarmowner","N")

# output table
write.table(counties,file="./TechChange/clean/output/counties1940.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()




##################
###### 1930 ######
##################


basedir="/ipums-repo2019-1/1930/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM", "OWNERSHP", "MORTGAGE", "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$owner <- data$OWNERSHP == 10
data$farmowner <- data$FARM*data$owner
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM
data$AAfarmOwner <- data$AfrAmer & data$farmowner


# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(owner),sum(farmowner),sum(AfrAmer),sum(white),sum(AAfarm),sum(AAfarmOwner),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban"  ,  "owner"   , "farmowner","AfrAmer","white","AAfarm","AAfarmowner","N")

# output table
write.table(counties,file="./TechChange/clean/output/counties1930.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()



##################
###### 1920 ######
##################


basedir="/ipums-repo2019-1/1920/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM", "OWNERSHP", "MORTGAGE", "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$owner <- data$OWNERSHP == 10
data$farmowner <- data$FARM*data$owner
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM
data$AAfarmOwner <- data$AfrAmer & data$farmowner


# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(owner),sum(farmowner),sum(AfrAmer),sum(white),sum(AAfarm),sum(AAfarmOwner),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban"  ,  "owner"   , "farmowner","AfrAmer","white","AAfarm","AAfarmowner","N")

# output table
write.table(counties,file="./TechChange/clean/output/counties1920.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()


##################
###### 1910 ######
##################


basedir="/ipums-repo2019-1/1910/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM", "OWNERSHP", "MORTGAGE", "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$owner <- data$OWNERSHP == 10
data$farmowner <- data$FARM*data$owner
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM
data$AAfarmOwner <- data$AfrAmer & data$farmowner


# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(owner),sum(farmowner),sum(AfrAmer),sum(white),sum(AAfarm),sum(AAfarmOwner),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban"  ,  "owner"   , "farmowner","AfrAmer","white","AAfarm","AAfarmowner","N")

# output table
write.table(counties,file="./TechChange/clean/output/counties1910.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()



##################
###### 1900 ######
##################


basedir="/ipums-repo2019-1/1900/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM", "OWNERSHP", "MORTGAGE", "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data1900 <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data1900$ind_ag <- data1900$IND1950 == 105
data1900$ind_manu <- data1900$IND1950 > 300 & data1900$IND1950 < 500
data1900$FARM <- data1900$FARM - 1
data1900$URBAN <- data1900$URBAN - 1
data1900$owner <- data1900$OWNERSHP == 10
data1900$farmowner <- data1900$FARM*data1900$owner
data1900$AfrAmer <- data1900$RACE == 200
data1900$white <- data1900$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM
data$AAfarmOwner <- data$AfrAmer & data$farmowner


# SUM OVER COUNTIES
counties1900 <- data1900[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(owner),sum(farmowner),sum(AfrAmer),sum(white),sum(AAfarm),sum(AAfarmOwner),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties1900)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban"  ,  "owner"   , "farmowner","AfrAmer","white","AAfarm","AAfarmowner","N")

# output table
write.table(counties1900,file="./TechChange/clean/output/counties1900.csv",sep=",",row.names = FALSE)

rm(counties1900,data1900)
gc()


##################
###### 1880 ######
##################

basedir="/ipums-repo2019-1/1880/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM",   "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM


# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(AfrAmer),sum(white),sum(AAfarm),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban","AfrAmer","white","AAfarm","N" )

# output table
write.table(counties,file="./TechChange/clean/output/counties1880.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()


##################
###### 1870 ######
##################

basedir="/ipums-repo2019-1/1870/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM",   "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM


# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(AfrAmer),sum(white),sum(AAfarm),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban" ,"AfrAmer","white","AAfarm","N")

# output table
write.table(counties,file="./TechChange/clean/output/counties1870.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()



##################
###### 1860 ######
##################

basedir="/ipums-repo2019-1/1860/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM",   "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM

# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(AfrAmer),sum(white),sum(AAfarm),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban","AfrAmer","white","AAfarm","N" )

# output table
write.table(counties,file="./TechChange/clean/output/counties1860.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()


##################
###### 1850 ######
##################

basedir="/ipums-repo2019-1/1850/TSV"

Pnames<-names(fread(paste0(basedir,"/P.tsv"),sep="\t",nrows=1))
Hnames<-names(fread(paste0(basedir,"/H.tsv"),sep="\t",nrows=1))

selectPcols <- c('AGE', 'IND1950' ,'SEX', 'SERIALP', 'LIT' , 'LABFORCE' ,'RACE')
selectHcols <- c("SERIAL" , "YEAR", "REGION", "STATEICP", "STATEFIP", "URBAN", "FARM",   "NUMPREC", "COUNTYICP")

H <- fread(paste0(basedir,"/H.tsv"),sep="\t",select=selectHcols,quote="",showProgress = TRUE)
P <- fread(paste0(basedir,"/P.tsv"),sep="\t",select=selectPcols,quote="",showProgress = TRUE)

setkey(H,SERIAL)
setkey(P,SERIALP)
data <- P[H,nomatch=0]
rm(P)
rm(H)
gc()

# RECODE SOME VARIABLES
data$ind_ag <- data$IND1950 == 105
data$ind_manu <- data$IND1950 > 300 & data$IND1950 < 500
data$FARM <- data$FARM - 1
data$URBAN <- data$URBAN - 1
data$AfrAmer <- data$RACE == 200
data$white <- data$RACE < 200
data$AAfarm <- data$AfrAmer & data$FARM

# SUM OVER COUNTIES
counties <- data[, .(sum(ind_ag),sum(ind_manu),sum(FARM),sum(URBAN),sum(AfrAmer),sum(white),sum(AAfarm),.N), by=.(COUNTYICP,STATEICP,STATEFIP)]
colnames(counties)<-c("COUNTYICP" ,"STATEICP", "STATEFIP",    "ind_ag" , "ind_manu"   , "farm"  , "urban" ,"AfrAmer","white","AAfarm","N")

# output table
write.table(counties,file="./TechChange/clean/output/counties1850.csv",sep=",",row.names = FALSE)

rm(counties,data)
gc()
