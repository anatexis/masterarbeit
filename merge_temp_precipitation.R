
######
# for precipitation + temp + Evapotranspiration see "merge_plus_epot.R"
#####
library(tidyverse)
library(lubridate)
library(reshape)



# Einlesen der Temperaturschlagsdaten & Koordinaten


setwd("/home/christoph/Dokumente/BOKU/Masterarbeit/Daten/EZG/output_R")
file1 <- "2017-12-08_P-output.txt"
file2 <- "2017-12-08_Temp-output.txt"

pst_P <- read_table(file1, col_names = F, cols( X1 = col_date(format = "%d%m%Y"),
                                                X2 = col_double()
                                                ))

pst_T <- read_table(file2, col_names = F, cols( X1 = col_date(format = "%d%m%Y"),
                                                X2 = col_double()
                                                ))
# cut timeseries to overlapping period from 01.01.1991 to 31.12.2014

pst_P1 <- pst_P[as_date(pst_P$X1) > as_date("1990-12-31"), ]
pst_T1 <- pst_T[as_date(pst_T$X1) < as_date("2015-01-01"), ]

# merge T and P
P_T <- add_column(pst_T1,pst_P1$X2)

# rounding to one digit
P_T$X2 <- round(P_T$X2,1)
P_T$`pst_P1$X2` <- round(P_T$`pst_P1$X2`,1)

#removing all 29.02 from dataframw
P_T2902rm <- P_T[as.numeric(strftime(P_T$X1, "%m%d")) != 229,]

# change date format for input modna
P_T$X1 <- format(P_T$X1, "%d%m%Y") 
P_T2902rm$X1 <- format(P_T2902rm$X1, "%d%m%Y") 



setwd ("/home/christoph/Dokumente/BOKU/Masterarbeit/Daten/output_R/")
# commented to not overwrite stuff
# # complete data
# write.table(P_T,file = paste(format(Sys.time(), "%Y-%m-%d"),
#                              "_tnse", ".txt", sep = "") ,sep=",",
#             row.names=FALSE, col.names = c("Datum", "t", "NSeff"), 
#             eol = "\r\n", quote = F)
# 
# # removed 29.02
# write.table(P_T2902rm,file = paste(format(Sys.time(), "%Y-%m-%d"),
#                                    "_tnse2902rm", ".txt", sep = ""), sep=",",
#             row.names=FALSE, col.names = c("Datum", "t", "NSeff"), 
#             eol = "\r\n", quote = F)

