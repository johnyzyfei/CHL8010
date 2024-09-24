library("tidyverse")
library("dplyr")
library("here")
library("tidyr")
library("readr")
library("countrycode")

## ======================= Week 2 ======================= ##
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

## ======================= Week 3 (John's Code) ======================= ##
# readdat <- function(x){
#   rawdata <- read.csv(here(“original”, x), header = TRUE)
#   data_subset <- rawdata |>
#     select(Country.Name, X2000:X2019)
#   data_long <- data_subset |>
#     pivot_longer(cols = X2000:X2019,
#                  names_to = “Year”,
#                  values_to = “MatMor”) |>
#     mutate(Year = as.numeric(sub(“X”, “”, Year)))
#   return(data_long)
# }
# infdat <- readdat(“infantmortality.csv”)
# matdat <- readdat(“maternalmortality.csv”)
# neodat <- readdat(“neonatalmortality.csv”)
# underdat <- readdat(“under5mortality.csv”)

## ======================= Week 3 (Adjusted to Aya's Code) ======================= ##
matmor0 <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)
infmor0 <- read.csv(here("original", "infantmortality.csv"), header = TRUE)
neomor0 <- read.csv(here("original", "neonatalmortality.csv"), header = TRUE)
un5mor0 <- read.csv(here("original", "under5mortality.csv"), header = TRUE)


### write a function that does the above manipulation to each data
wbfun <- function(dataname, varname){
  dataname |>
    dplyr::select(Country.Name, X2000:X2019) |>
    pivot_longer(cols = starts_with("X"),
                 names_to = "year",                                     
                 names_prefix = "X",                                    ### NOT SURE ###
                 values_to = varname) |>
    mutate(year = as.numeric(year)) |>
    arrange(Country.Name, year)
}

matmor <- wbfun(dataname = matmor0, varname = "matmor")
infmor <- wbfun(dataname = infmor0, varname = "infmor")
neomor <- wbfun(dataname = neomor0, varname = "neomor")
un5mor <- wbfun(dataname = un5mor0, varname = "un5mor")

#put all data frames into list
wblist <- list(matmor, infmor, neomor, un5mor)

#merge all data frames in list
wblist |> reduce(full_join, by = c('Country.Name', 'year')) -> wbdata

# add ISO-3 to data
wbdata$ISO <- countrycode(wbdata$Country.Name, 
                          origin = "country.name", 
                          destination = "iso3c")
wbdata <- wbdata |>
  dplyr::select(-Country.Name)

head(wbdata)

