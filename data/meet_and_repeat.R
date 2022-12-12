# Ville Kuorikoski
# 12.12.2022
# This script modifies two data sets to long form and outputs them as csv files.
# Data source: https://github.com/KimmoVehkalahti/MABS

# Install packages
library(tidyverse); library(dplyr)



# Read and explore the source data----------------------------------------------
# Read the data into data frame objects
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = '\t', header = T)

# Print the dimensions of the data frames using 'dim()'
dim(BPRS) # Output of 'BPRS' has two dimensions, one with 40 and the other with 11 members
dim(RATS) # Output of 'gii' has two dimensions, one with 16 and the other with 13 members

# Print the structures of the data frames using 'str()'
str(BPRS) # treatment and subject variables seem to categorical while the week variables are the observed values. Every value is an integer.
str(RATS) # Every value is an integer. ID and Group seem to be categorical and the rest are the actual observations.

# Print the summaries of the variables in both data sets.
summary(BPRS)
# treatment is either 1 or 2. subject is the observed subject number from 1 to 20. The values seem to lower during the treatment when looking at the
# change in the different statistics like min, max and mean.
summary(RATS)
# Subject IDs seem to be integers from 1 to 16. Group number seems to be integers from 1 to 3. The rest of the variables seem to be observations that
# are in a similar scale based on the minimum and maximum values.



# Modify the data---------------------------------------------------------------
# Factorize the categorical variables
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Convert to long form
BPRSL <-  pivot_longer(BPRS, cols=-c(treatment, subject), names_to = "weeks", values_to = "bprs") %>% 
  mutate(week = as.integer(substr(weeks,5,5))) %>% 
  arrange(week)

RATSL <-  pivot_longer(RATS, cols=-c(ID, Group), names_to = "WD", values_to = "Weight") %>%
  mutate(Time = as.integer(substr(WD,3,4))) %>%
  arrange(Time)

# Check the data and compare with the original wide form data sets
glimpse(BPRSL)
glimpse(BPRS)
str(BPRSL)
str(BPRS)
summary(BPRSL)
summary(BPRS)

glimpse(RATSL)
glimpse(RATS)
str(RATSL)
str(RATS)
summary(RATSL)
summary(RATS)
# Long format has fewer variables and the concatenated variables are now more easily usable in different models.



# Save the results and test the saved file--------------------------------------
# Save the analysis data sets to the current working directory, 'data'
write_csv(BPRSL, "BPRSL.csv")
write_csv(RATSL, "RATSL.csv")

# Test the saved csv file by reading the file into 'df' and then printing
# the structure and the first parts of the data frame
df <- read_csv("BPRSL.csv")
str(df)
glimpse(df)

df <- read_csv("RATSL.csv")
str(df)
glimpse(df)
# The data was saved successfully