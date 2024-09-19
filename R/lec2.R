# install.packages("tidyverse")
library("tidyverse")
library("dplyr")
library("here")
library("tidyr")
library("readr")

rawdat <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)

data_subset <- rawdat %>%
  select(Country.Name, X2000:X2019)

data_long <- data_subset %>%
  pivot_longer(cols = X2000:X2019,  # Select the columns to reshape
               names_to = "Year",   # New column for the year
               values_to = "MatMor") %>%  # New column for the maternal mortality values
  mutate(Year = as.numeric(sub("X", "", Year)))  # Remove the prefix 'X' and convert Year to numeric

# View the resulting data
head(data_long, 20)
tail(data_long, 20)
