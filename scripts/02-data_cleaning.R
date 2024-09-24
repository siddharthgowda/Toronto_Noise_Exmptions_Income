#### Preamble ####
# Purpose: Cleans the 2021 census table. Extracts median income per ward,
# total population per ward that lives in private housing, and total area of
# ward in km squared. Also only keep relevant variables from 
# noise permit exceptions data set and filters out some incomplete data rows.
# Author: Siddharth Gowda
# Date: 21 September 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, readxl, janitor
# and background knowledge on noise exemptions, and Toronto wards
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(readxl)
library(janitor)

#### Clean data ####


## cleaning noise exemption data
raw_noise_exmp_data <- 
  read_csv("./data/raw_data/raw_noise_exmeption_dataset.csv")

clean_noise_exmp_data <- raw_noise_exmp_data %>% 
  clean_names() %>% 
  select(permit_type, ward, issue_date, expected_end_date) %>% 
  mutate(issue_year = as.numeric(str_split_i(issue_date, "-", 1)),
         expected_end_year = 
           as.numeric(str_split_i(expected_end_date, "-", 1))) %>% 
  mutate(permit_type = tolower(permit_type)) %>% 
  # some exemptions don't have ward info
  drop_na() %>% 
  select(!c(issue_date, expected_end_date))

## cleaning 2021 census data

raw_census_one_variable_data <- 
  read_excel("./data/raw_data/raw_census_dataset.xlsx", 
             sheet = "2021 One Variable") 
## geting ward population stats
clean_ward_pop_data <- raw_census_one_variable_data %>% 
  clean_names() %>%  mutate(row_num = row_number())

pop_table_start_row <- clean_ward_pop_data %>% 
  filter(city_of_toronto_profiles == "Population")

clean_ward_pop_data <- clean_ward_pop_data %>% 
  filter(row_num == pop_table_start_row$row_num + 2 | x2 == "Toronto" 
           ) %>% 
  select(!city_of_toronto_profiles) %>% distinct()

# need to flip columns and rows
clean_ward_pop_data <- as.data.frame(t(as.matrix(clean_ward_pop_data)))
clean_ward_pop_data <- clean_ward_pop_data %>% clean_names()
# renaming by index instead of name to make more reproducible
clean_ward_pop_data <- clean_ward_pop_data %>% 
  rename(ward = 1, ward_population = 2) %>%
  # there are no na's put this code is added for reproduce ability
  drop_na() %>% 
  filter(str_detect(ward, "Ward")) %>% 
  mutate(ward = as.numeric(str_split_i(ward, " ", i = 2))) %>% 
  select(ward, ward_population)

## getting each ward's low income percentage
clean_ward_median_income_data <- raw_census_one_variable_data %>% 
  clean_names()


clean_ward_median_income_data <- clean_ward_median_income_data %>% 
  filter(x2 == "Toronto" | 
           str_detect(city_of_toronto_profiles,
                "Median total income in 2020 among recipients")) %>% 
  select(!city_of_toronto_profiles) %>% 
  distinct()

# flipping rows and columns
clean_ward_median_income_data <- as.data.frame(t(as.matrix(
  clean_ward_median_income_data)))

clean_ward_median_income_data <- clean_ward_median_income_data %>% 
  rename(ward = 1, ward_median_income = 2) %>%
  # there are no na's put this code is added for reproduce ability
  drop_na() %>% 
  filter(str_detect(ward, "Ward")) %>% 
  mutate(ward = as.numeric(str_split_i(ward, " ", i = 2))) %>% 
  mutate(ward_median_income = parse_number(ward_median_income))


## cleaning ward to ward area (kms_squared) data
raw_ward_area_data <- read_excel("./data/raw_data/raw_ward_areas_dataset.xlsx")

clean_ward_area_data <- raw_ward_area_data %>% 
  clean_names() %>% 
  mutate(row_num = row_number())

ward_area_data_start_row <- clean_ward_area_data %>% 
  filter(city_of_toronto_profiles == "Ward") %>% 
  filter(x2 == "Area (sq km)")

clean_ward_area_data <- clean_ward_area_data %>% 
  filter(row_num > ward_area_data_start_row$row_num) %>% 
  rename(
    ward = city_of_toronto_profiles, 
    ward_area_km2 = x2
    ) %>% 
  select(ward, ward_area_km2) %>% clean_names() %>%
  mutate(ward = as.numeric(ward)) %>% 
  # doesn't appear to be any na, but done anyways for reproduce ability
  drop_na()

#### Save data ####

### first need to join all data by ward, so all data is stored in one table
clean_noise_exemp_ward_data <- clean_noise_exmp_data %>% 
  inner_join(clean_ward_area_data, by = "ward") %>% 
  inner_join(clean_ward_pop_data, by = "ward") %>% 
  inner_join(clean_ward_median_income_data, by = "ward") %>% 
  mutate(id = row_number())

write_csv(clean_noise_exemp_ward_data, 
          "./data/analysis_data/clean_noise_exemp_ward_data.csv")
