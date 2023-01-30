# Loading required libraries, additional to those in Part 1. those will be loaded when Part 1 of the project is ran using "source" function.
library(RColorBrewer)              # to use some premade color palettes in making nice looking charts
source("Part 1. Cleaning.R")
attach(SpeedData)

options(digits = 1)

#### EDA: Number of records (volume) for each Location by Direction and Month ####
SpeedData %>% 
     ggplot(aes(x = LD,
                fill = Direction)) + 
     geom_bar(color = "black") +
     facet_wrap(~ Month, nrow = 3) +
     labs(title="Number of vehicles (records) per location by direction")


#### EDA: Overall histogram of Speed ####
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

#### EDA: Overall histogram of Speed by Month ####
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


#### EDA: Histogram of Speed for each location ####
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
     group_by(LD, Location, Direction, Month, Hour) %>% 
     arrange(Month, Hour) %>% 
     summarise(Volume = n(),
               Speed.Mean = mean(Speed),
               Speed.Median = median(Speed),
               Speed.85thP = quantile(Speed, 0.85))

#### EDA: Hourly volume for the Month of April ####
Hourly %>% 
     filter(Month == "Apr") %>% 
     ggplot(aes(x = Hour,
                y = Volume,
                fill = Location)) + 
     geom_bar(stat = "identity", 
              color = "black",
              show.legend = F) + 
     facet_wrap(~ Location + Direction, 
                nrow = 3) +
     labs(title = "Hourly Volume for the Month of April")

#### EDA: Hourly 85th percentile speed for location 1 across 3 data collections ####
Hourly %>% 
     filter(Location == "Location 3") %>% 
     ggplot(aes(x = Hour,
                y = Speed.85thP,
                fill = Month)) + 
     geom_point(shape = "-",
                size = 5,
              color = "blue4",
              show.legend = F) + 
     scale_fill_manual(values = brewer.pal(3, "Set2")) +
     facet_wrap(~ Direction + Month, 
                nrow = 2) +
     geom_hline(yintercept = 25,
                color = "black",
                linetype = "dashed") +
     labs(title = "Hourly 85th Percentile Speed for Location 1",
          subtitle = "Speed Limit = 25 mph",
          y = "85th Percentile Speed")


#### EDA: Daily overall 85th percentile speed for location 2 across 3 data collections ####
SpeedData %>% 
     group_by(LD, Location, Direction, Month) %>% 
     arrange(Month) %>% 
     summarise(Speed.85thP = quantile(Speed, 0.85)) %>% 
     ggplot(aes(x = Month,
                y = Speed.85thP,
                fill = Location),
            fill = Month) +
     geom_bar(stat = "identity",
              color = "black",
              show.legend = F) +
     geom_hline(yintercept = 25, 
                color = "black",
                linetype = "dashed",
                alpha = 0.2) +
     geom_text(aes(label=Speed.85thP), 
               vjust=2) +
     facet_wrap(~ LD,
                nrow = 3) +
     labs(title = "Overall daily 85th Percentile Speed",
          subtitle = "Speed Limit = 25 mph",
          y = "85th Percentile Speed (mph)")

#### EDA: Heat map of 85th percentile speed for the month of April ####
Hourly %>%
     filter(Month == "Apr") %>% 
     ggplot(aes(Hour, 
                LD, 
                fill = Speed.85thP)) +
     geom_tile(color = "black") +
     scale_fill_gradient(low = "white", high = "darkred") + 
     geom_text(aes(label = Volume), 
               size = 3, 
               angle = 90,
               alpha = 0.4) +
     labs(title = "Heat map of 85th percentile speed for the month of April",
          subtitle = "Numbers show traffic volume of the hours",
          y = "",
          fill = "85th% speed")

#### Stat Test: ####



glimpse(Hourly)





##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
rm(list = ls()) ; dev.off() ; plot.new()
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@