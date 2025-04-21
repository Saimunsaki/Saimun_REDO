# ---------------------------------------------------------------------
# Script Name: merge_all_data.R
# Author: Saimun Nahar Saki
# Date: 2025-04-16
#
# Purpose:
# This script merges cleaned IPUMS microdata (household-level), rice price 
# summaries, and poverty indicators into a single contextual dataset 
# for Rajshahi Division. This is used for modeling and visualization.
# ---------------------------------------------------------------------

# Load required libraries
library(tidyverse)
library(readr)
library(dplyr)

# ------------------- Load Cleaned IPUMS Data -----------------------
ipums_data <- read_csv("Cleaned/ipums_cleaned.csv")  # household-level data
summary_data <- read_csv("Cleaned/rajshahi_summary.csv")  # summary stats

# ------------------- Load Cleaned Poverty Data ---------------------
poverty_data <- read_csv("Cleaned/poverty_division.csv")  # or however you saved it
poverty_rajshahi <- poverty_data %>%
  filter(DIVISION == "Rajshahi")

# ------------------- Load Cleaned Rice Price Summary --------------
rice_data <- read_csv("Cleaned/avg_price_div_year.csv")  # by year and division
rice_rajshahi <- rice_data %>%
  filter(LOCATION == "Rajshahi")

# ------------------- Merge All Datasets ----------------------------

# Combine summary data with rice price and poverty by YEAR
merged_data <- summary_data %>%
  left_join(rice_rajshahi, by = "YEAR") %>%
  left_join(poverty_rajshahi, by = c("LOCATION" = "DIVISION"))

# Check result
glimpse(merged_data)

# ------------------- Save Final Dataset ----------------------------
write_csv(merged_data, "Cleaned/rajshahi_merged_all.csv")

message("✅ Merging complete! File saved to: Cleaned/rajshahi_merged_all.csv")
