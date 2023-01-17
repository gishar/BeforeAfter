# Loading required libraries
library(lubridate)
library(tidyverse)
# library(data.table)
# detach("package:tidyverse", unload = TRUE)

# Importing data
myfiles = list.files(path = "Data")
Speed = data.frame()
for (index in 1:length(myfiles)) {
     variable_name <- sub("\\..*", "", myfiles[index])
     variable_data <- read.csv(paste("Data/", myfiles[index], sep =""))
     variable_data$Location <- strsplit(variable_name, "-")[[1]][1]
     variable_data$Direction <- strsplit(variable_name, "-")[[1]][2]
     variable_data$LD <-  paste(strsplit(variable_name, "-")[[1]][1], strsplit(variable_name, "-")[[1]][2], sep="")
     # assign(letters[index], variable_data)
     Speed = rbind(Speed, variable_data)
}
rm(index, myfiles, variable_name, variable_data)

# Lubridating
Speed$DateTime <- as.POSIXct(Speed$DateTime, format = "%m/%d/%Y %H:%M")
Speed <- Speed %>% 
     mutate(Year = factor(year(DateTime))) %>% 
     mutate(Month = factor(month(ymd_hms(DateTime), label = TRUE))) %>% 
     mutate(Day = factor(day(DateTime))) %>% 
     mutate(Hour = factor(hour(DateTime), ordered = T)) %>%       # to make ordinal factor
     mutate(Minute = factor(minute(DateTime), ordered = T)) %>% 
     mutate(LD = factor(LD)) %>% 
     mutate(Location = factor(Location)) %>% 
     mutate(Direction = factor(Direction)) %>%
     mutate(AdviceCode = factor(AdviceCode)) %>% 
     glimpse()

Speed <- Speed[c(1, 8:12, 7, 5:6, 2:4)]


###############################
plot.new()
str(Speed)
table(Speed$AdviceCode)
boxplot(Speed$Speed ~ Speed$AdviceCode)
hist(Speed$Speed)
Speed %>% 
     filter(AdviceCode == 128, Speed > 50) %>% 
     summarise(Count = n())
     



##@@@@@@@@@@@@@@@
rm(list = ls())
