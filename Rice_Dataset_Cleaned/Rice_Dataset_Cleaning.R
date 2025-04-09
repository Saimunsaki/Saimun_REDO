# --------------------------------------------------------------------
# Script Name: 01_clean_rice_data.R
# Author: Saimun Nahar Saki
# Date: 2025-04-07
# Purpose: This script cleans and prepares raw rice price data
#          for use in my ECNS 560 term project. The goal is to convert
#          mixed units to a standardized price per KG, extract the relevant
#          fields, and generate a yearly summary by region for analysis.
# --------------------------------------------------------------------

# Loading required packages
# I used tidyverse for reading files, data wrangling, and plotting.
library(tidyverse)

# To define relative path to raw rice price file
# I intentionally use a *relative* path here (not absolute) so that this script
# can run smoothly on any computer — no need to change file paths!
raw_data_path <- "../data_raw/Rice_Updated_merged_cleaned_data.csv"

# Step 1: Reading in the raw rice price dataset
# This CSV includes price data by year, region, unit (KG, 100 KG, L), etc.
# My task here is to clean it so it’s ready for aggregation and modeling.
rice_data <- read.csv(raw_data_path)

# Step 2: Filtering, cleaning, and transforming for consistency
# - I keep only rows related to rice (ignoring other commodities).
# - Then I standardize all prices to a “per KG” unit, converting where needed.
# - I also keep only the necessary columns to keep things tidy and focused.
rice_cleaned <- rice_data %>%
  filter(str_detect(commodity, regex("Rice", ignore_case = TRUE))) %>%
  mutate(
    unit = as.character(unit),
    
    # 🔄 Convert different units to price per KG
    PRICE_KG = case_when(
      unit == "100 KG" ~ as.numeric(price) / 100,
      unit == "KG" ~ as.numeric(price),
      unit == "L" ~ as.numeric(price),  # Assuming L ≈ KG for simplicity
      TRUE ~ NA_real_
    ),
    
    # Ensuring consistent formatting
    YEAR = as.numeric(year),
    LOCATION = as.character(admin1)
  ) %>%
  # 🔍 Filtering out any rows where conversion failed (NA)
  filter(!is.na(PRICE_KG)) %>%
  
  # 📌 Keeping only the variables I care about for this stage
  select(YEAR, LOCATION, PRICE_KG)

# Step 3: Aggregating — To get average rice price by division and year
# This summary table is useful for visualizing long-term price trends,
# modeling regional price volatility, and linking with demographic data.
avg_price_div_year <- rice_cleaned %>%
  group_by(LOCATION, YEAR) %>%
  summarise(
    avg_price = mean(PRICE_KG, na.rm = TRUE),
    .groups = "drop"
  )

# Step 4: Saving outputs for reuse
# I'm saving:
# - rice_cleaned.csv → full cleaned observations
# - avg_price_div_year.csv → yearly division-level average price
# These will be used for plotting seasonal patterns and in regression models.
write_csv(rice_cleaned, "rice_cleaned.csv")
write_csv(avg_price_div_year, "avg_price_div_year.csv")


# These cleaned datasets are foundational for the rest of my analysis.
# I use them to study rice price volatility, seasonality, and how it connects
# to household outcomes (like dependency and poverty) in later scripts.


# This script prepares rice price data for analysis by standardizing mixed units (KG, 100 KG, L) into a single PRICE_KG variable. 
# I then generate a summary of average prices across divisions and years. 
# These outputs help me understand how rice markets behaved during key periods like the 2007–08 food crisis, and allow me to connect regional price trends with household-level vulnerability indicators in later stages of my project.

