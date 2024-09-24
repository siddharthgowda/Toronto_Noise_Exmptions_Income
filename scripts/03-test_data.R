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
sim_noise_exmp_data <- 
  read_csv("./data/simulation_data/sim_noise_exmp_data.csv")

print("Testing No Na's\n")
count(sim_noise_exmp_data %>% drop_na()) == count(sim_noise_exmp_data)

print("Testing Poverty Rate is a percentage")
count (sim_noise_exmp_data %>% 
         filter(poverty_rate > 1 | poverty_rate < 0)) == 0

print("Issue Year always the same or less than the expected end year")
count (sim_noise_exmp_data %>% 
         filter(issue_year > expected_end_year)) == 0

## cleaned data tests
noise_exmp_ward_data <- read_csv(
  "./data/analysis_data/clean_noise_exmp_ward_data.csv")

print("Testing No Na's\n")
count(noise_exmp_ward_data %>% drop_na()) == count(noise_exmp_ward_data)

print("Testing Poverty percentage is a percentage")
count (noise_exmp_ward_data %>% 
         filter(poverty_rate > 1 | poverty_rate < 0)) == 0

print("Issue Year always the same or less than the expected end year")
count (noise_exmp_ward_data %>% 
         filter(issue_year > expected_end_year)) == 0

