# Loading required libraries
library(data.table)
library(tidyverse)
detach("package:tidyverse", unload = TRUE)

# Importing data
myfiles = list.files(path = "Data")
for (index in 1:length(myfiles)) {
     variable_name <- sub("\\..*", "", myfiles[index])
     variable_data <- read.csv(paste("Data/", myfiles[index], sep =""))
     variable_data$Location <- strsplit(variable_name, "-")[[1]][1]
     variable_data$Direction <- strsplit(variable_name, "-")[[1]][2]
     variable_data$LD <-  paste(strsplit(variable_name, "-")[[1]][1], strsplit(variable_name, "-")[[1]][2], sep="")
     # assign(variable_name, variable_data) # gave me a hard time when doing rbind()
     assign(letters[index], variable_data)
}

Speed <- rbind(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
rm(index, myfiles, variable_name, variable_data, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
###############################



##@@@@@@@@@@@@@@@
rm(list = ls())
