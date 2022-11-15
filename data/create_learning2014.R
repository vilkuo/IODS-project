# Ville Kuorikoski
# 14.11.2022
# This script modifies and exports a dataset into csv format. Data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

# Install package 'tidyverse'
library(tidyverse)



# Read and explore the source data----------------------------------------------
# Read the data into a data frame object called 'learning2014'
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Print the dimensions of the data frame using 'dim()'
dim(learning2014) # Output is two dimensions, one with 183 and the other with 60 members

# Print the structure of the data frame using 'str()'
str(learning2014) # Output is the columns listed below and the first 10 members of each of them



# Create and modify the analysis dataset----------------------------------------
# Create the analysis dataset 'lrn14' and exclude observations with exam points of 0 and below
lrn14 <- 
  learning2014 %>% 
  filter(Points > 0)

# Create new column 'attitude' by scaling back the observations of 'Attitude' by dividing it with the number of questions
lrn14$attitude <- lrn14$Attitude / 10

# Select columns related to each type of learning using select function with a regular expression in matches argument
deep_columns <- select(lrn14, matches("D\\d\\d"))
surface_columns <- select(lrn14, matches("SU\\d\\d"))
strategic_columns <- select(lrn14, matches("ST\\d\\d"))

# Create the corresponding columns by averaging the observations in different types of learning
lrn14$deep <- rowMeans(deep_columns)
lrn14$surf <- rowMeans(surface_columns)
lrn14$stra <- rowMeans(strategic_columns)

# Remove unnecessary columns and rearrange the dataset
lrn14 <-
  lrn14 %>% 
  select(gender, 'age'=Age, attitude, deep, stra, surf, 'points'=Points)



# Save the results and test the saved file--------------------------------------
# Save the analysis dataset to 'data' folder
write_csv(lrn14, "data/learning2014.csv")

# Test the saved csv file by reading the file into 'df' and then printing the structure and the first parts of the dataframe
df <- read_csv("data/learning2014.csv")
str(df)
head(df)
