# install.packages("tidyverse")
library("tidyverse")
library("dplyr")
library("here")
library("tidyr")
library("readr")

rawdat <- read.csv(here("original", "disaster.csv"), header=TRUE)

# Subset data to have only the variables Country.Name, X2000 – X2019
# Change format to long and remove prefix
subdat <- filter(rawdat, rawdat$Year %in% c(2000:2019), rawdat$Disaster.Type== "Earthquake" | rawdat$Disaster.Type=="Drought") %>% 
  select(c("Year","ISO","Disaster.Type"))

subdat$earthquake <- ifelse(subdat$Disaster.Type == "Drought", 1, 0)
subdat$drought <- ifelse(subdat$Disaster.Type == "Earthquake", 1, 0)

subdat <- subdat %>% select(-c("Disaster.Type")) %>%
  group_by(Year, ISO) %>%
  summarize(earthquake=max(earthquake), drought=max(drought))



head(subdat)
