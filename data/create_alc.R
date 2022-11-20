# Ville Kuorikoski
# 21.11.2022
# This script takes two data sets, combines and exports the combined data
# Data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

# Install packages
library(dplyr); library(tidyverse)



# Read and explore the source data----------------------------------------------
# Read the data into data frame objects
math <- read.csv("student-mat.csv", sep=";", header=TRUE)
por <- read.csv("student-por.csv", sep=";", header=TRUE)

# Print the dimensions of the data frame using 'dim()'
dim(math) # Output of math has two dimensions, one with 395 and the other with 33 members
dim(por) # Output of por has two dimensions, one with 649 and the other with 33 members

# Print the structure of the data frame using 'str()'
str(math)
str(por)
# Outputs show a table with 33 columns such as 'school', 'sex' and 'age' and 649 values for each column



# Create and modify the analysis dataset----------------------------------------
# Define column names with variable data for each student
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# Rest of the columns form identifiers for joining the data
join_cols <- setdiff(colnames(por), free_cols)

# Join the two data sets keeping the students in common in both sets
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

# Print the dimensions and the structure of the combined data set
dim(math_por); str(math_por) 
# Output shows 370 members in table with 39 columns
# and 6 of the columns are duplicates with different suffixes

# Create a data set with only the columns used to join the data sets
alc <- select(math_por, all_of(join_cols))

# Loop through the variable column names
for(col_name in free_cols) {
  # Select the two columns starting with 'col_name'
  two_cols <- select(math_por, starts_with(col_name))
  # Separate the first of these two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # Check if the values are numeric
  if(is.numeric(first_col)) {
    # Add the average value to new combined column
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # If the value was not numeric
    # Add the first value to a new combined column
    alc[col_name] <- first_col
  }
}

# Add two columns representing the average and high alcohol consumptions
alc <- alc %>% 
  mutate(alc_use = (Dalc + Walc) / 2) %>% 
  mutate(high_use = alc_use > 2)

# Using glimpse to check if the modified data set is correct
glimpse(alc) 
# The end of the data set shows the new columns as it should
# Number of rows is 370 and columns is 35



# Save the results and test the saved file--------------------------------------
# Save the analysis data set to the current, 'data' folder
write_csv(alc, "alc.csv")

# Test the saved csv file by reading the file into 'df' and then printing
# the structure and the first parts of the data frame
df <- read_csv("alc.csv")
str(df)
head(df)
# The data was saved successfully