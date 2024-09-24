#### Preamble ####
# Purpose: Tests if simulated data is resonable and if cleaned data is clean
# Author: siddharth.gowda@mail.utoronto.ca
# Date: 23 September 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse and background knowledge on wards, census data,
# and noise exemptions in Toronto
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)

#### Test data ####

## simulated data tests
sim_noise_exemp_data <- 
  read_csv("./data/simulation_data/sim_noise_exemp_data.csv")

print("Testing No Na's\n")
count(sim_noise_exemp_data %>% drop_na()) == count(sim_noise_exemp_data)

print("Testing only 25 wards from 1-25")
count (sim_noise_exemp_data %>% 
         filter(!(ward %in% c(1:25)))) == 0

print("Issue Year always the same or less than the expected end year")
count (sim_noise_exemp_data %>% 
         filter(issue_year > expected_end_year)) == 0

## cleaned data tests
noise_exmp_ward_data <- read_csv(
  "./data/analysis_data/clean_noise_exemp_ward_data.csv")

print("Testing No Na's\n")
count(noise_exmp_ward_data %>% drop_na()) == count(noise_exmp_ward_data)

print("Testing only 25 wards from 1-25")
count (noise_exmp_ward_data %>% 
         filter(!(ward %in% c(1:25)))) == 0

print("Issue Year always the same or less than the expected end year")
count (noise_exmp_ward_data %>% 
         filter(issue_year > expected_end_year)) == 0

