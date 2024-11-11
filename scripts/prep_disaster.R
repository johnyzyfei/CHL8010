# install.packages("tidyverse")
library("tidyverse")
library("dplyr")
library("here")
library("tidyr")
library("readr")
library("countrycode")

## ======================= Week 2 ======================= ##
rawdat <- read.csv(here("data", "original", "disaster.csv"), header=TRUE)

# Subset data to have only the variables Country.Name, X2000 – X2019
# Change format to long and remove prefix
subdat <- filter(rawdat, rawdat$Year %in% c(2000:2019), rawdat$Disaster.Type== "Earthquake" | rawdat$Disaster.Type=="Drought") %>% 
  select(c("Year","ISO","Disaster.Type"))

subdat$earthquake <- ifelse(subdat$Disaster.Type == "Drought", 1, 0)
subdat$drought <- ifelse(subdat$Disaster.Type == "Earthquake", 1, 0)

disdata <- subdat %>% select(-c("Disaster.Type")) %>%
  group_by(Year, ISO) %>%
  summarize(earthquake=max(earthquake), drought=max(drought))

colnames(disdata)[colnames(disdata) == "Year"] <- "year"

head(disdata)


