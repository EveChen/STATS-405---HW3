#STATS405_HW3_Win
###A. Setup
#Remove Objects
rm(list=ls())

#Clear Memory
gc(reset=TRUE)

#Set Working Directory
setwd("C:/Users/Eve/Dropbox/UCLA Files/Courses/405 Data Management/HW3")

#Load packages
library(readr)
library(RSQLite)


#B. Run RSQLite
SQLite()

#dbconnect
con <- dbConnect(SQLite(), db = "database.sqlite")

#Load data sets into our database - database.sqlite
dbWriteTable(conn = con, name = "Diag", value = "diag.csv",
             row.names = F, header = T)

dbWriteTable(conn = con, name = "Prog", value = "prog.csv",
             row.names = F, header = T)

#Check our database to ensure we have already loaded our two data sets
dbListTables(con)
dbListFields(con, "Diag")
dbListFields(con, "Prog")

#View our data sets
#1. View Diag data set - 569 obs of 3 variables (ID_number is the key)
junk1 <- dbSendQuery(con, paste("SELECT ID_number, Diag, mean_radius
                        FROM Diag", sep = ""))
diagnosis <- fetch(junk1)
head(diagnosis, 3)
str(diagnosis)

#2. View Prog data set - 198 obs of 4 variables (ID_number is the key)
junk2 <- dbSendQuery(con, paste("SELECT ID_number, outcome, time, mean_radius
                                FROM Prog", sep = ""))
prognosis <- fetch(junk2)
head(prognosis, 3)
str(prognosis)


#C. Perform Inner Join - Only 139 obs
innerjoin <- dbGetQuery(con, "SELECT * FROM Diag
                        INNER JOIN Prog
                        USING (ID_number);")
head(innerjoin)
nrow(innerjoin)


#D. Show the processing time of doing inner join
({system.time(innerjoin <- dbGetQuery(con, "SELECT * FROM Diag
                        INNER JOIN Prog
                                      USING (ID_number);"))})
