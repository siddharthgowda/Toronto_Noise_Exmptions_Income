#### Preamble ####
# Purpose: Simulates Noise Exemption Permit Data (including all ward data)
# Author: Siddharth Gowda
# Date: 21 September 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, general knowledge of how wards and noise permits
# work in Toronto
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
set.seed(888)

#### Simulate data ####

# reasons why you can get a noise pollution exemptions
permit_types <- c("Amplified or Instrument Sound", "Construction", 
                 "Continuous Concrete Pour", "Large Crane Work", 
                 "Other Sounds")

# year when exemption was given (only looking at 21st for this report)
issue_years <- c(2000:2024)
wards <- c(1:25)

n = 100 # 1000 rows in simulated sample


sim_noise_exmp_data <- tibble(
  type = sample(permit_types, size = n, replace = TRUE),
  ward = sample(wards, size = n, replace = TRUE),
  issue_year = sample(issue_years, size = n, replace = TRUE),
  poverty_rate = rnorm(n, 0.10, 0.03),
  population = floor(rnorm(n, 100000, 25000)),
  ward_area_kms_sq = rnorm(n, 30, 10)
)

# adding expected end date of permit
# Amplified or Instrument Sound are usually for concerts or events
# so the expected end year should be the same as issue_year
sim_noise_exmp_data <- sim_noise_exmp_data %>% 
  mutate(expected_end_year = if_else(type == "Amplified or Instrument Sound",
                                     issue_year, 
                                     issue_year + floor(rnorm(1, 4, 2)))) %>%
  mutate(id = row_number())

write_csv(sim_noise_exmp_data, 
         "./data/simulation_data/sim_noise_exmp_data.csv")






