library(tidyverse)
library(lubridate)
library(stringi)
detach("package:hydroGOF", unload=TRUE)
setwd("C:/Users/Russ/Desktop/master/daten/output")
file <- "tt2summary.txt"

### to get r to read in files with in the form of
### dmmyyy AND ddmmyyy we have to do smt like this:
discharge <- read_table(file, col_names = T,
                        cols(TTMMYYYY = "c",
                             .default=col_double()))
stri_sub(discharge$TTMMYYYY,-6,0) <- "-"
stri_sub(discharge$TTMMYYYY,-4,0) <- "-"
discharge$TTMMYYYY <- as.Date(discharge$TTMMYYYY, "%d-%m-%Y")
# now the dates are correctly read in

#calculate qsim and select output which is interesting for us
discharge <- discharge %>% mutate(qsim=linout + cascout,qsim_etp=qsim+ETP) %>% 
  select(., TTMMYYYY,NS,Qobs,ETP,ETA,liqwater,linout,cascout,qsim,qsim_etp)
discharge

sums <- discharge[2:length(discharge)] %>% summarise_all(funs(sum)) %>%
  select(.,NS,qsim_etp,qsim,Qobs)

sumplot <- sums %>% 
  gather(.,data,mm_d,NS:Qobs, factor_key = TRUE)

ggplot(data=sumplot, aes(x=data, y=mm_d))+
  geom_bar(stat="identity")

perct <- sums %>% mutate(Qperct=qsim/Qobs*100, NSperct=qsim_etp/NS*100) %>% 
  select(.,Qperct,NSperct)

sums
perct

#perctplot <- perct %>% gather(.,item,percent,Qperct,NSperct, factor_key = TRUE)
#ggplot(data=perctplot, mapping = (aes(x=item,y=percent)))+
#  geom_bar(stat="identity")

  