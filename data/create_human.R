# Ville Kuorikoski
# 28.11.2022
# This script modifies and combines two data sets into one, 'human'.
# Data source: https://hdr.undp.org/

# Week 4------------------------------------------------------------------------
# Install packages
library(tidyverse); library(dplyr)



# Read and explore the source data----------------------------------------------
# Read the data into data frame objects
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Print the dimensions of the data frames using 'dim()'
dim(hd) # Output of 'hd' has two dimensions, one with 195 and the other with 8 members
dim(gii) # Output of 'gii' has two dimensions, one with 195 and the other with 10 members

# Print the structures of the data frames using 'str()'
str(hd)
str(gii)
# 'hd' contains 8 columns and 'gii' contains 10 columns with 195 values in both. 
# They both have 'Country' variable in common and the other variables are unique for each data sets 
# like 'HDI Rank' for 'hd' and 'Maternal Mortality Ratio' for 'gii'.

# Print the summaries of the variables in both data sets.
summary(hd)
summary(gii)
# All the variables in both data sets have distinct scales and seem to be not comparable to each other 
# except for the 'HDI Rank' and the 'GDI Rank' variables which both go from 1 to 188.


# Rename and mutate the data----------------------------------------------------
# Rename the variables with shorter names
hd <- hd %>% rename(
  HDI_Rank = "HDI Rank",
  HDI = "Human Development Index (HDI)",
  Life_Exp = "Life Expectancy at Birth",
  Edu_Exp = "Expected Years of Education",
  Edu_Mean = "Mean Years of Education",
  GNI = "Gross National Income (GNI) per Capita",
  GNI_HDI_Rank_Diff = "GNI per Capita Rank Minus HDI Rank")

gii <- gii %>% rename(
  GII_Rank = "GII Rank",
  GII = "Gender Inequality Index (GII)",
  Mat_Mor = "Maternal Mortality Ratio",
  Ado_Birth = "Adolescent Birth Rate",
  Parli_F = "Percent Representation in Parliament",
  Edu_F = "Population with Secondary Education (Female)",
  Edu_M = "Population with Secondary Education (Male)",
  Labo_F = "Labour Force Participation Rate (Female)",
  Labo_M = "Labour Force Participation Rate (Male)")

# Mutate the date
gii <- gii %>% 
  mutate(Edu_FM = Edu_F / Edu_M,
         Labo_FM = Labo_F / Labo_M)

# Combine the two data sets to a new data set called 'human'
human <- inner_join(hd, gii, by = "Country")



# Week 5------------------------------------------------------------------------
# Check that the combined data set is correct
dim(human) # The data set contains 195 observations and 19 variables
str(human) # The data set contains all the variables in both input data sets and no duplicates
# The data set describes certain aspects of human development in different countries. Variables 'Edu_FM' and 'Labo_FM' are the calculated ratios of
# female to male populations with secondary education and labor force participation rates respectively. 'Parli_F' is the percent representation of females
# in parlament. 'Mat_Mor' is the maternal mortality ratio and 'Abo_Birth' means the adolescent birth rate. 'GII' means the Gender Inequality Index and 
# 'GNI' the Gross National Income per capita. 'Edu_Exp' is the expected years of education and 'Exp_Mean' is the mean years of education. 'Life_Exp' is the
# life expectancy at birth and 'HDI' the Human Development Index.

# Step 1. Mutate data
str(human$GNI) # The GNI variable is already numeric so as.numeric() doesn't need to be used

# Step 2. Keep certain columns
human <- human[, c("Country", "Edu_FM", "Labo_FM", "Edu_Exp", "Life_Exp", "GNI", "Mat_Mor", "Ado_Birth", "Parli_F")]

# Step 3. Remove missing values
human_ <- filter(human, complete.cases(human)) %>% 
  as.data.frame()

# Step 4. Remove observations related to regions
tail(human_$Country, 10) # Last 7 variables are regions and are therefore deleted
last <- nrow(human_) - 7
human_ <- human_[1:last, ]

# Step 5. Move country names as a variable to the row names
rownames(human_) <- human_$Country
human_ <- select(human_, -Country)

# Check the data set
dim(human_) # The data set contains 155 observations and 8 variables as it should
head(human_) # The rows are named with the Country names



# Save the results and test the saved file--------------------------------------
# Save the analysis data set to the current working directory, 'data'
write.csv(human_, "human.csv") # write.csv is used instead of write_csv so that the row names will be saved

# Test the saved csv file by reading the file into 'df' and then printing
# the structure and the first parts of the data frame
df <- read_csv("human.csv")
str(df)
head(df)
# The data was saved successfully