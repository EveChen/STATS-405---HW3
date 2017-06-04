#STATS 405 - HW2 - Version2

########1. Setup
#Remove Objects
rm(list=ls())

#Clear Memory
gc(reset=TRUE)

#Set root
setwd("C:/Users/Eve/Dropbox/UCLA Files/Courses/405 Data Management")
dir()

#Package Install
library(dplyr)
library(ggplot2)		#Graphing Utilities
library(stringr)		#String Functions
library(data.table)		#Data management package
library(ndjson)

########2. Data Loading

#A. Yelp Data
strt<-Sys.time()

#Q: Why need to add file()?
#Q: Diff between the stream_in I used and he used
checkin <- stream_in("yelp_academic_dataset_checkin.json")
business<-stream_in("yelp_academic_dataset_business.json")

write.csv(checkin, "check.csv")
write.csv(business, "bus.csv")


#SQL - load into database
library(RSQLite)
SQLite()
con <- dbConnect(SQLite(), db = "database.sqlite")


library(sqldf)
dbWriteTable(conn = con, name = "checkin", value = "check.csv",
             row.names = F, header = T)

dbWriteTable(conn = con, name = "business", value = "bus.csv",
             row.names = F, header = T)

dbListTables(con)
dbListFields(con, "checkin")
dbListFields(con, "business")

#View our data sets
#1. View Diag data set - 569 obs of 3 variables (ID_number is the key)
junk1 <- dbSendQuery(con, paste("SELECT * FROM checkin", sep = ""))
check <- fetch(junk1)
head(check, 3)
str(check)

#2. View Prog data set - 198 obs of 4 variables (ID_number is the key)
junk2 <- dbSendQuery(con, paste("SELECT * FROM business", sep = ""))
bus <- fetch(junk2)
head(bus, 3)
str(bus)


#C. Perform Inner Join - Only 139 obs
innerjoin <- dbGetQuery(con, "SELECT * FROM checkin
                        INNER JOIN business
                        USING (business_id);")
head(innerjoin)
nrow(innerjoin)


#D. Show the processing time of doing inner join
({system.time(innerjoin <- dbGetQuery(con, "SELECT * FROM checkin
                        INNER JOIN business
                                      USING (business_id);"))})
