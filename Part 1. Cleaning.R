# Loading required libraries
library(lubridate)
library(tidyverse)

# Importing data
myfiles = list.files(path = "Data")
SpeedData = data.frame()
for (index in 1:length(myfiles)) {
     variable_name <- sub("\\..*", "", myfiles[index])
     variable_data <- read.csv(paste("Data/", myfiles[index], sep =""))
     variable_data$Location <- strsplit(variable_name, "-")[[1]][1]
     variable_data$Direction <- strsplit(variable_name, "-")[[1]][2]
     variable_data$LD <-  paste(strsplit(variable_name, "-")[[1]][1], strsplit(variable_name, "-")[[1]][2], sep="")
     # assign(letters[index], variable_data)
     SpeedData = rbind(SpeedData, variable_data)
}
rm(index, myfiles, variable_name, variable_data)

# Lubridating
SpeedData$DateTime <- as.POSIXct(SpeedData$DateTime, format = "%m/%d/%Y %H:%M")
SpeedData <- SpeedData %>% 
     mutate(Year = factor(year(DateTime))) %>% 
     mutate(Month = factor(month(ymd_hms(DateTime), label = TRUE))) %>% 
     mutate(Day = factor(day(DateTime))) %>% 
     mutate(Time = format(DateTime, format="%H:%M:%S")) %>% 
     mutate(Hour = factor(hour(DateTime), ordered = T)) %>%       # to make ordinal factor
     mutate(Minute = factor(minute(DateTime), ordered = T)) %>% 
     mutate(LD = factor(LD)) %>% 
     mutate(Location = factor(Location)) %>% 
     mutate(Direction = factor(Direction)) %>%
     mutate(AdviceCode = factor(AdviceCode)) %>% 
     glimpse()

SpeedData <- SpeedData[c(1, 8:13, 7, 5:6, 2:4)]

# Cleaning outliers
plot.new()
boxplot(SpeedData$Speed, horizontal = T)
boxplot(SpeedData$Speed ~ SpeedData$AdviceCode, horizontal = T)
table(SpeedData$AdviceCode)

# Details of speed data when AdviceCode = 128
SpeedData %>% 
     filter(AdviceCode == 128) %>% 
     select(Speed) %>% 
     summary()

# Extract records when AdviceCode is 128 or speed is lower than 15 or higher than 70 mph - cleaning the data
Outliers <- SpeedData %>% 
     filter(AdviceCode == 128 | Speed < 15 | Speed > 70) 

plot(Outliers$Hour, Outliers$Speed)

plot(table(Outliers$Speed), 
     xlab = "Outlier speed",
     ylab = "Number of records")

SpeedData <- SpeedData %>% 
     mutate(Location = dplyr::recode(Location, 
                              EOC = "Location 1",
                              EOR = "Location 2",
                              NOC = "Location 3"
                              )) %>% 
     mutate(LD = dplyr::recode(LD, 
                               EOCEB = "Location 1 - EB",
                               EOCWB = "Location 1 - WB",
                               EOREB = "Location 2 - EB",
                               EORWB = "Location 2 - WB",
                               NOCNB = "Location 3 - NB",
                               NOCSB = "Location 3 - SB"
     )) %>% 
     filter(AdviceCode != 128, 
            Speed >= 15, 
            Speed <= 70)

sprintf("%d outlier records will be removed from the original dataset", nrow(Outliers))
sprintf("Cleaned speed data will include %d records, which is %.2f%s of the total original number of records", 
        nrow(SpeedData), 
        100 * nrow(SpeedData)/(nrow(SpeedData)+nrow(Outliers)),
        '%')

# This wraps up part 1