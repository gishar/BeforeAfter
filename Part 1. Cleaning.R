# Loading required libraries
# library(data.table)
# library(tidyverse)
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
###############################






##@@@@@@@@@@@@@@@
rm(list = ls())
