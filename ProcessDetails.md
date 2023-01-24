<h1 style="text-align: center;">

A Before/After Analysis of Speed Data

</h1>

## Objective:

The objective of this project is to see if ***narrowing the lanes*** has any effects on driver speed.

------------------------------------------------------------------------

## 1. Data

The data includes 24 hours of individual speed data at three different locations in both directions of travel for: - before condition - after condition (1 month after) - after condition (4 months after). Here are some details on the locations:

-   Residential street
-   Speed limit 25 mph
-   *Before* condition road width 24 ft, between edges of pavement (not curb to curb), no edge lines
-   *After* condition road width 20 ft, edge lines 2 ft from edge of pavement, no center line
-   AADT (Average Annual Daily Traffic) of 2000 vehicles per day

### 1.1. Importing data

The data I have are in csv forms. There are 3 locations and each have 2 directions of travel, and each of those are collected on 3 different times (before condition, after condition right after lane road narrowing, and another one 4 months after the treatment). That is 18 files and I don't like to clutter my code importing files one by one and then work on each one individually. So, I tried to find a way to automate this importing into 18 different dataframes in one run. Each of the dataframes can take the name of the file and the values inside will be imported from the csv file.

-   I used `list.files()` to collect the name of the data files into a temporary dataframe
-   used `sub()` to remove the .csv from the file names and create individual dataframe names
-   used `strsplit()` to extract location and direction from the names
-   used `read.csv()` to read from the csv files
-   used `assign()` to stored the data into individual dataframes - p.s. modified to not need this.
-   add new columns for each dataframe containing the location and direction
-   to automate this process, all were done in a *For loop*
-   used `rbind()` to bind all dataframes into a single dataframe as csv files were being read
-   removed all the interim variables and dataframes

Come to think of it, the easiest way for importing the data would have been to have 18 lines of read.csv() to read the files and then 5 lines for each to form the dataframes at each location. in total it would have been more than 100 lines of code to do what I did in 7 lines within a for loop. I am happy now!

### 1.2. Feature Engineering

The date and time is imported into the dataframe as character data and for this I will use the `lubridate` library to do some *feature engineering*. For this step, I extracted Year, month, day of month, Time, hour, and minute in separate columns. Although, for this type of work, most likely just the month and hours will be used in the analysis and comparisons. We'll see.

In addition, class of the variables Location, Direction, and Advice Code were assigned as factor

### 1.3. Cleaning up the date from outliers

The data is collected from a roadway with a speed limit of 25 mph inside a neighborhood. A quick boxplot of the speed data shows that the data includes many outliers that need to be shaved off the data. It can be observed that some of the speed data is shown as above 150 mph which is absurd. Another quick glance at boxplots of speed data for each levels of the mysterious factor variable AdviceCode shows that many of these outliers are tied to the level 128 of this variable.

-   Used the `table()` to see how many records are under this level - turns our 304 out of total of 9243
-   used `summary()` to see the distribution of speed data under this level - turns out Q1 is already higher than speed limit, and median is 127 mph

This tells me something strange is happening with this level of AdviceCode and I need to remove it from the data completely. Next, with my knowledge on the speed data, if not rare, it would be suicidal for anyone driving with a speed of higher than 70 mph. I will remove any speed higher than 70 mph. At the same time I will also remove any speed lower than 15 mph, as that would not be a likely case to be witnessed on such a road. First I extracted all the above records and there is no apparent pattern with time of day for these records. I noticed there is no pattern between these outlier speeds and time of day either. There are a total of 548 out of 9243 records that will be thrown away.

This will wrap up Part 1 of this project.

## 2. Analysis Process

The analysis of this data will include the following steps: Data Aggregation, EDA, and Statistical Analysis. First, I called the script for Part 1 to start with the cleaned and engineered dataframe created in the first steps. I also attached the Speed dataframe to make it easier to work with the variables for EDA, possibly.

### 2.1. Aggregation

### 2.2. EDA - Visual before/after comparisons

### 2.3. Statistical before/after comparisons

## 3. Conclusions
