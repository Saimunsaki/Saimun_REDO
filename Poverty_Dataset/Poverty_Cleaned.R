# ---------------------------------------------------------
# Script: 01_poverty_cleaning.R
# Purpose: To clean and summarize the zila-level poverty indicators dataset.
# This cleaned data will help me incorporate structural deprivation
# (like sanitation access) into my modeling of demographic patterns in Rajshahi.
# ---------------------------------------------------------

# Step 1: Loading the libraries I need
# I'm using readxl to import Excel data, dplyr for wrangling, stringr for consistent text formatting, and readr to export clean datasets.
library(readxl)
library(dplyr)
library(stringr)
library(readr)

# Step 2: Import the raw poverty data from Excel
# This dataset includes district-level (zila) indicators like toilet access, working-age population, and rurality.
# I placed the file inside my central /Data folder to keep everything organized.
poverty_data <- read_excel("../Data/zila_and_upazila_data/zila_indicators.xlsx")

# Step 3: Clean up the column names and standardize the text
# Some of the column names in the Excel file were long or inconsistent, so I renamed them to something cleaner.
# I also capitalized the division and zila names to make them easier to join with other datasets later.
poverty_clean <- poverty_data %>%
  rename(
    DIVISION = `Division Name`,
    ZILA = `Zila Name`,
    rural_pop_pct = `Rural Population (%)`,
    working_age_total = `Working-age population (N)`,
    working_age_pct = `Population between 15 and 64 years old, National avg (%)`,
    no_toilet_pct = `Households without toilet, open defecation (%)`
  ) %>%
  mutate(
    DIVISION = str_to_title(DIVISION),  # Standardize for joins and maps
    ZILA = str_to_title(ZILA)
  )

# Step 4: Summarize key poverty indicators at the division level
# This part of the script aggregates the cleaned dataset by DIVISION so I can compare regions more easily.
# I'm calculating mean values for rural population %, working-age %, and % without toilet (used as a poverty proxy).
# I'm also summing the total working-age population across districts.
poverty_division <- poverty_clean %>%
  group_by(DIVISION) %>%
  summarise(
    avg_rural_pct = mean(rural_pop_pct, na.rm = TRUE),
    avg_working_age_pct = mean(working_age_pct, na.rm = TRUE),
    avg_no_toilet_pct = mean(no_toilet_pct, na.rm = TRUE),
    total_working_age_pop = sum(working_age_total, na.rm = TRUE),
    .groups = "drop"
  )

# Step 5: Saving both cleaned datasets
# I'm saving two CSVs in the same directory as this script:
# (1) the full cleaned zila-level dataset and 
# (2) the summary table by division, which will help in visualizations and modeling.
write_csv(poverty_clean, "poverty_cleaned.csv")
write_csv(poverty_division, "poverty_division_summary.csv")

# ✅ End of Script
# These cleaned datasets will allow me to join poverty indicators with IPUMS microdata
# and explore how deeper structural conditions like toilet access relate to
# child dependency, urban-rural differences, and economic stress (via rice price).
