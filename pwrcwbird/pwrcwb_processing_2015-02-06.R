# Set working directory

setwd("C:/Users/derek/R/pwrcwbird")


# Import datasets

pwrcwb <- read.csv("C:/Users/derek/R/projects/dataload/pwrcwbird/CWBMaster.csv")

pwrcwbspecies <- read.csv("C:/Users/derek/R/projects/dataload/pwrcwbird/masterSpeciesList.csv")


# Review data

View(pwrcwb)

View(pwrcwbspecies)


# Add sqldf library

install.packages("sqldf")

library("sqldf", lib.loc="~/R/win-library/3.1")

# join species names to pwrcwb dataframe from master species list

# AOU code in pwrcwb is our key for retrieving scientific/common name

speciesjoinstr <- "select pwrcwb.*, pwrcwbspecies.EnglishFull, pwrcwbspecies.Genus, pwrcwbspecies.Species from pwrcwb left join pwrcwbspecies on pwrcwb.AOU_code = pwrcwbspecies.Aou"

pwrcwb_join_temp <- sqldf(speciesjoinstr)

View(pwrcwb_join_temp)

# if temp join works create pwrcw_join

pwrcwb_join <- pwrcwb_join_temp


# change date format to ISO ex. "12/14/98" >> "1998-12-14"

pwrcwb_join$isodate<-as.Date(strptime(pwrcwb_join$SurveyDate,"%m/%d/%Y"))

# Add geographic information from state lookup

# retrieve state lookup 

states <- read.csv("C:/Users/derek/R/projects/dataload/pwrcwbird/states.csv", header=FALSE)

# Join pwrcwb and state

colnames(pwrcwb_join)[12]<-"common_name"

stjoinstr <- "select pwrcwb_join.*, states.state_name from pwrcwb_join left join states on pwrcwb_join.State = states.abbr"

pwrcwb_join_temp <- sqldf(stjoinstr)

pwrcwb_join <- pwrcwb_join_temp

# Clean up headers and drop columns

# change column header name

colnames(pwrcwb_join)

colnames(pwrcwb_join)[1]<-"newname"

# drop column

pwrcwb_join$header<-NULL

# write results

write.csv(pwrcwb_join,"pwrcwb_bison_final_2015-02-06.csv",row.names=FALSE)



