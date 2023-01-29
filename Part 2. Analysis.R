# Loading required libraries, additional to those in Part 1. those will be loaded when Part 1 of the project is ran using "source" function.
library(RColorBrewer)              # to use some premade color palettes in making nice looking charts
source("Part 1. Cleaning.R")
attach(SpeedData)

options(digits = 1)

#### Number of records (volume) for each Location by Direction ####
SpeedData %>% 
     ggplot(aes(x = Location,
                fill = Direction)) + 
     geom_bar(color = "black") +
     labs(title="Number of vehicles (records) per location by direction")


#### Overall histogram of Speed ####
SpeedData %>% 
     ggplot(aes(x = Speed)) +
     geom_histogram(binwidth = 1,
                    col = 'black',
                    show.legend = T,
                    alpha = 0.6) +
     geom_vline(xintercept = c(25, mean(Speed), median(Speed), quantile(Speed, 0.85)),
                color = c("black", "blue", "green", "red"),
                linetype = c("dashed", "solid", "solid", "solid")) +
     labs(title = "Histogram of All Speeds",
          subtitle = "Speed limit = 25 mph (dashed black), mean(blue), median(green) ,85th Percentile(red)",
          x = "Speed",
          y = "Frequency") +
     annotate(geom="text", 
              x=55, 
              y=500, 
              label=paste("Mean speed = ", round(mean(Speed), 1), "mph", 
                          "\nMedian speed = ", round(median(Speed), 1), "mph",
                          "\n85th Percentile speed = ", round(quantile(Speed, 0.85), 1), "mph"),
              color="blue4")

#### Overall histogram of Speed by Month ####
SpeedData %>% 
     ggplot(aes(x = Speed)) +
     geom_histogram(binwidth = 1,
                    col = 'black',
                    show.legend = T,
                    alpha = 0.6) +
     geom_vline(xintercept = 25,
                color = "black",
                linetype = "dashed") +
     labs(title = "Histogram of All Speeds",
          subtitle = "Speed limit = 25 mph",
          x = "Speed",
          y = "Frequency") +
     facet_wrap(~ Month, 
                nrow = length(Month))


#### Histogram of Speed for each location ####
SpeedData %>% 
     ggplot(aes(x = Speed)) +
     geom_histogram(aes(fill = Direction), 
                    binwidth = 1,
                    col = 'black',
                    show.legend = T,
                    alpha = 0.6) +
     geom_vline(xintercept = 25, 
                color = "red",
                linetype = "dashed") +
     facet_wrap(~ LD, 
                nrow = length(levels(LD))) +
     labs(title = "Histogram of Speeds",
          subtitle = "Speed limit = 25 mph",
          x = "Speed",
          y = "Frequency")

#### Aggregation of volume and speed by 1-hour bins ####
Hourly <- SpeedData %>% 
     group_by(Location, Direction, Month, Hour) %>% 
     arrange(Month, Hour) %>% 
     summarise(Volume = n(),
               Speed.Mean = mean(Speed),
               Speed.Median = median(Speed),
               Speed.85thP = quantile(Speed, 0.85))

Hourly %>% 
     ggplot(aes(x = Hour,
                y = Volume,
                fill = Month)) + 
     geom_bar(stat = "identity", 
              color = "black") + 
     facet_wrap(~ Location + Direction, 
                nrow = 3)


glimpse(Hourly)





##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
rm(list = ls()) ; dev.off() ; plot.new()
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@