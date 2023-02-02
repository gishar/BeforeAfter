# Loading required libraries, additional to those in Part 1. those will be loaded when Part 1 of the project is ran using "source" function.
lapply(c("DT", "tidyverse", "RColorBrewer", "gridExtra"), require, character.only = T)
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
                    show.legend = F,
                    alpha = 0.6) +
     geom_vline(xintercept = 25, 
                color = "red",
                linetype = "dashed") +
     facet_wrap(~ LD, 
                nrow = length(levels(LD))) +
     labs(title = "Histogram of Speeds",
          subtitle = "Speed limit = 25 mph (dashed red line)",
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


# Showing the data in an html data table
Hourly %>% 
     ungroup() %>% 
     select(Location, Direction, Month, Hour, Volume, 'Mean Speed' = Speed.Mean, 'Median Speed' = Speed.Median, '85th Percentile Speed' = Speed.85thP) %>% 
     datatable(options = list(pageLength = 5, 
                              autoWidth = TRUE))

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


#### EDA: Overall daily 85th percentile speed for location 2 across 3 data collections ####
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

# Simply looking at speed statistics for a location/direction and how it changes over the three periods
SpeedData %>% 
     filter(LD == "Location 1 - EB") %>% 
     select(Month, Speed) %>% 
     group_by(Month) %>% 
     summarise(
          Min = min(Speed),
          Q1 = quantile(Speed, 0.25),
          Median = median(Speed),
          Mean = mean(Speed),
          Q3 = quantile(Speed, 0.75),
          Percentile85 = quantile(Speed, 0.85),
          max = max(Speed)
     )

# ANOVA (Example for location 1 EB direction)
# (two ways to do - using the main large individual speed data and using the aggregated hourly data): 
# H0 = Average speed is the same for all three data collection periods for location 1
# H1 = Not H0
SpeedData %>% 
     filter(LD == "Location 1 - EB") %>% 
     select(Month, Speed) %>% 
     aov(Speed ~ Month, data = .) %>% 
     summary()
     
Hourly %>% 
     filter(LD == "Location 1 - EB") %>% 
     select(Month, Speed.Mean) %>%
     aov(Speed.Mean ~ Month, data = .) %>% 
     summary()

# However, for the hourly data we should not use the simple mean but rather the weighted mean with the volume as weight. 
# It's aggregated and different from original individual data in the SpeedData. Here is the proof of the two giving me different values:
Hourly %>% 
     group_by(LD, Month) %>%
     filter(LD == "Location 1 - WB" & Month == "Apr") %>%
     {mean(.$Speed.85thP)}

SpeedData %>% 
     filter(SpeedData$LD == "Location 1 - WB" & SpeedData$Month == "Apr") %>% 
     {quantile(.$Speed, 0.85)}


# Now let's try to do the 85th percentile speed comparison for all 6 cases in one run and show p-values in a matrix for each location/direction
ANOVA.Results = data.frame(matrix(NA, 
                                  nrow = length(unique(SpeedData$LD)), 
                                  ncol = 4))
colnames(ANOVA.Results) = c(
                           'Sep - Apr',   # difference between Sep and Apr
                           'Dec - Sep',
                           'Dec - Apr',
                           'ANOVA P.value'
                           )
rownames(ANOVA.Results) = unique(SpeedData$LD)

options(digits = 4)
for (i in 1:length(unique(SpeedData$LD))) {
     temp <- Hourly %>% 
          filter(LD == unique(SpeedData$LD)[i])
     ANOVA.Results[i, 1] = weighted.mean(temp$Speed.85thP[temp$Month == "Sep"], temp$Volume[temp$Month == "Sep"]) - weighted.mean(temp$Speed.85thP[temp$Month == "Apr"], temp$Volume[temp$Month == "Apr"])
     ANOVA.Results[i, 2] = weighted.mean(temp$Speed.85thP[temp$Month == "Dec"], temp$Volume[temp$Month == "Dec"]) - weighted.mean(temp$Speed.85thP[temp$Month == "Sep"], temp$Volume[temp$Month == "Sep"])
     ANOVA.Results[i, 3] = weighted.mean(temp$Speed.85thP[temp$Month == "Dec"], temp$Volume[temp$Month == "Dec"]) - weighted.mean(temp$Speed.85thP[temp$Month == "Apr"], temp$Volume[temp$Month == "Apr"])     
     ANOVA <- Hourly %>% 
          filter(LD == unique(SpeedData$LD)[i]) %>% 
          select(Month, Speed.85thP) %>%
          aov(Speed.85thP ~ Month, data = .)
     ANOVA.Results[i, 4] = summary(ANOVA)[[1]][["Pr(>F)"]][1]
}
ANOVA.Results
rm(i, temp, ANOVA)

# Let's do the anova for one location and show the results using Tukey HSD (honestly significant difference) with confidence intervals.
# first let's have some graphics to compare visually what we want to see in ANOVA results

Hourly %>%     # adding mean of 85th percentile speed for every location-direction-month
     group_by(LD, Month) %>%
     mutate(LD.Month.Mean85 = mean(Speed.85thP)) -> Hourly

plot.box <- Hourly %>% 
     group_by(LD, Month) %>%
     filter(LD == "Location 1 - WB") %>%
     ggplot(aes(y = Speed.85thP,
                fill = Month)) +
     scale_fill_manual(values = brewer.pal(3, "Set2")) +
     scale_y_continuous(breaks = seq(min(Hourly$Speed.85thP), 
                                     max(Hourly$Speed.85thP), 
                                     by = 2)) +
     geom_boxplot(alpha = 0.6) +
     facet_wrap(~ Month,
                nrow = 3) +
     geom_hline(aes(yintercept = LD.Month.Mean85),
                color = "darkblue",
                linetype = "dashed") +
     theme(legend.position="none") +
     coord_flip() +
     labs(title = "Boxplot of hourly 85th percentile speeds collected on three periods",
          subtitle = "Location 1 - WB (mean value in dashed blue)",
          y = "85th Percentile speed",
          x = "")

plot.density <- Hourly %>% 
     group_by(LD, Month) %>%
     filter(LD == "Location 1 - WB") %>%
     ggplot(aes(x = Speed.85thP,
                fill = Month)) +
     scale_x_continuous(breaks = seq(min(Hourly$Speed.85thP), 
                                     max(Hourly$Speed.85thP), 
                                     by = 2)) +
     scale_fill_manual(values = brewer.pal(3, "Set2")) +
     geom_density(alpha = 0.6,
                  show.legend = F) +
     facet_wrap(~ Month,
                nrow = 3) +
     geom_vline(aes(xintercept = LD.Month.Mean85),
                color = "darkblue",
                linetype = "dashed") +
     # theme_bw() +
     labs(title = "Density plot of hourly 85th percentile speeds collected on three periods",
          subtitle = "Location 1 - WB (mean value in dashed blue)",
          x = "85th Percentile speed",
          y = "Density")

grid.arrange(plot.box, plot.density, ncol = 2)

Hourly %>% 
     filter(LD == "Location 1 - WB") %>% 
     select(Month, Volume, Speed.85thP) %>% 
     aov(Speed.85thP ~ Month, data = .) %>% 
     TukeyHSD()
