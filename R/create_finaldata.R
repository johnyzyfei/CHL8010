library("dplyr")
library("here")

source(here("R", "prep_maternalmortality.R"))
source(here("R", "prep_disaster.R"))
source(here("R", "prep_conflict.R"))
covs <- read.csv(here("original", "covariates.csv"), header = TRUE)

#put all data frames into list
alllist <- list(wbdata, disdata, confdata)

# change Year column name in disdata to year for concatenation
colnames(alllist[[2]])[colnames(alllist[[2]]) == "Year"] <- "year"
head(alllist)

#merge all data frames in list
alllist |> reduce(full_join, by = c('ISO', 'year')) -> finaldata0

finaldata <- covs |>
  left_join(finaldata0, by = c('ISO', 'year'))

# need to fill in NAs with 0's for armconf1, drought, earthquake
finaldata <- finaldata |>
  mutate(armconf1 = replace_na(armconf1, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totdeath = replace_na(totdeath, 0))
