# Loading required libraries, additional to those in Part 1. those will be loaded when Part 1 of the project is ran using "source" function.
library(RColorBrewer)              # to use some premade color palettes in making nice looking charts
source("Part 1. Cleaning.R")
attach(SpeedData)


# Overall histogram of Speed
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
          y = "Frequency")

# Histogram of Speed for each location
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

glimpse(SpeedData)





##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
rm(list = ls()) ; dev.off() ; plot.new()
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@