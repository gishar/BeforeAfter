# Loading required libraries
library(tidyverse)
source("Part 1. Cleaning.R")
attach(SpeedData)

SpeedData %>% 
     ggplot(aes(x = Time, 
                y = Speed)) + 
     geom_point()





##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
rm(list = ls()) ; dev.off() ; plot.new()
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@