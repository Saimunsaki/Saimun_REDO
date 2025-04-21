# Clean_rice_data.R
# Purpose: Clean and process rice price data
# Author: Saimun Nahar Saki
# Date: 2025-04-07

# Loading required packages
#install.packages("tidyverse")
library(tidyverse)

# To define file path (relative, not absolute)
raw_data_path <- "../data_raw/Rice_Updated_merged_cleaned_data.csv"

# Reading the raw rice dataset
rice_data <- read.csv(raw_data_path)

# Cleaning and transforming the dataset for my analysis
rice_cleaned <- rice_data %>%
  filter(str_detect(commodity, regex("Rice", ignore_case = TRUE))) %>%
  mutate(
    unit = as.character(unit),
    PRICE_KG = case_when(
      unit == "100 KG" ~ as.numeric(price) / 100,
      unit == "KG" ~ as.numeric(price),
      unit == "L" ~ as.numeric(price),  # assuming L ≈ KG
      TRUE ~ NA_real_
    ),
    YEAR = as.numeric(year),
    LOCATION = as.character(admin1)
  ) %>%
  filter(!is.na(PRICE_KG)) %>%
  select(YEAR, LOCATION, PRICE_KG)

# Summarizing average price by division and year
avg_price_div_year <- rice_cleaned %>%
  group_by(LOCATION, YEAR) %>%
  summarise(avg_price = mean(PRICE_KG, na.rm = TRUE), .groups = "drop")


# Saving directly in my current folder
write_csv(rice_cleaned, "rice_cleaned.csv")
write_csv(avg_price_div_year, "avg_price_div_year.csv")

