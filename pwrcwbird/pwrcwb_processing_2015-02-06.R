# Set working directory

setwd("C:/Users/derek/R/pwrcbbl")


# Import datasets

bblspecies <- read.csv("C:/Users/derek/R/pwrcbbl/bands.csv")

specieslu <- read.csv("C:/Users/derek/R/pwrcbbl/species_lookup.csv")

stctylu <- read.csv("C:/Users/derek/R/pwrcbbl/cntry_state_cnty_lookup.csv")

# Review data

# Add sqldf library

install.packages("sqldf")

library("sqldf", lib.loc="~/R/win-library/3.1")

# Add species names to bblspecies dataframe

# SPECIES_ID in bblspecies is our key for retrieving scientific/common name

speciesjoinstr <- "select bblspecies.*, specieslu.SCI_NAME, specieslu.SPECIES_NAME, specieslu.ALPHA_CODE from bblspecies left join specieslu on bblspecies.SPECIES_ID = specieslu.SPECIES_ID"

bblspecies_join_temp<-bblspecies_join

bblspecies_join <- sqldf(speciesjoinstr)

# drop "X..." column

bblspecies$X...<-NULL

# change date format ex. "12/14/98" >> "1998-12-14"


bblspecies_join$isodate<-as.Date(strptime(bblspecies_join$Banding.Date,'%Y-%m-%d'))

# Add geographic information from state county lookup

# Clean up code fields

# County code should be 3 character string

stctylu$COUNTY_CODE<-sprintf("%03d",stctylu$COUNTY_CODE)

bblspecies_join$COUNTY_CODE<-sprintf("%03d",bblspecies_join$COUNTY_CODE)

# State code should be 2 character string

stctylu$STATE_CODE<-sprintf("%02d",stctylu$STATE_CODE)

bblspecies_join$STATE_CODE<-sprintf("%02d",bblspecies_join$STATE_CODE)

# Concatenate state and county code to get 5 character FIPS

bblspecies_join$FIPS <- paste(bblspecies_join$STATE_CODE, bblspecies_join$COUNTY_CODE, sep='')

stctylu$FIPS <- paste(stctylu$STATE_CODE, stctylu$COUNTY_CODE, sep='')

# Join bblspecies_join and state lookup to retrieve state county

stcntyjoinstr <- "select bblspecies_join.*, stctylu.STATE_NAME, stctylu.COUNTY_NAME, stctylu.COUNTY_DESCRIPTION, stctylu.COUNTRY_CODE from bblspecies_join left join stctylu on bblspecies_join.FIPS = stctylu.FIPS"

bblspecies_join_temp <- sqldf(stcntyjoinstr)

bblspecies_join <- sqldf(stcntyjoinstr)


# if join returns same number of rows as original then commit final

bblspecies_join <- sqldf(stcntyjoinstr)


# Clean up headers and drop columns

# change column header name

colnames(bblspecies_join)

colnames(bblspecies_join)[1]<-"newname"

# drop column

bblspecies_join$header<-NULL



