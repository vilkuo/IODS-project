# Ville Kuorikoski
# 28.11.2022
# This script modifies and combines two data sets into one, 'human'.
# Data source: https://hdr.undp.org/

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
  Parli = "Percent Representation in Parliament",
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

# Check that the combined data set is correct
dim(human) # The data set contains 195 observations and 19 variables
str(human) # The data set contains all the variables in both input data sets and no duplicates



# Save the results and test the saved file--------------------------------------
# Save the analysis data set to the current working directory, 'data'
write_csv(human, "human.csv")

# Test the saved csv file by reading the file into 'df' and then printing
# the structure and the first parts of the data frame
df <- read_csv("human.csv")
str(df)
head(df)
# The data was saved successfully