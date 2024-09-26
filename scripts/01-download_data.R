#### Preamble ####
# Purpose: Downloads and saves the data from OpenDataToronto
# Noise Exemption Permits data set and 
# Ward Profiles (25-Ward Model), specfically the 
# 2023-WardProfiles-2011-2021-CensusData and 
# 2023-WardProfiles-GeographicAreas
# Author: Siddharth Gowda
# Date: 21 September 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, opendatatoronto, writexl, and
# and background knowledge on noise exemptions, and toronto wards
# Any other information needed? For more information check these links
# https://open.toronto.ca/dataset/noise-exemption-permits/
# https://open.toronto.ca/dataset/ward-profiles-25-ward-model/


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(writexl)

#### Download data ####
# get all resources for noise_exemption package
noise_exmption_resources <- list_package_resources("noise-exemption-permits")

noise_datastore_resources <- noise_exmption_resources %>% 
  filter(tolower(format) %in% c('csv', 'geojson'))
# loads Noise Exemption Permits.csv
noise_exmeption_dataset <- noise_datastore_resources %>% 
  filter(id == "9716199e-b7a1-4410-b2e6-5463d3590da9") %>% 
  get_resource()
# noise_exmeption_data

# get all resources for Ward Profiles (25-Ward Model)
ward_resources <- list_package_resources("6678e1a6-d25f-4dff-b2b7-aa8f042bc2eb")

# in xlsx
census_dataset <- get_resource("16a31e1d-b4d9-4cf0-b5b3-2e3937cb4121")

#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(noise_exmeption_dataset, 
          "./data/raw_data/raw_noise_exmeption_dataset.csv")
# for some reason r wasn't finding the function
# unless writexl package was explicitly defined
writexl::write_xlsx(census_dataset, "./data/raw_data/raw_census_dataset.xlsx")


         
