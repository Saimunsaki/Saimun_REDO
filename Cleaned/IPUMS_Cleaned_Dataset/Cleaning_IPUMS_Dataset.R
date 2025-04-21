# ---------------------------------------------------------------------
# Script Name: Cleaning_IPUMS_Dataset.R
# Author: Saimun Nahar Saki
# Date: 2025-04-07
#
# Purpose:
# This script loads, cleans, and merges individual-level census data 
# from IPUMS International for Bangladesh (1991, 2001, and 2011), 
# focusing on Rajshahi Division. It prepares the cleaned full dataset 
# and creates summary metrics for use in my demographic analysis.
# ---------------------------------------------------------------------

# Loading required libraries
# I'm using the tidyverse for data import and manipulation
library(tidyverse)

# Step 1: To define relative paths to raw IPUMS CSV files
# These files were downloaded from the IPUMS portal and stored in the 'Data' folder
ipums_paths <- list(
  "../Data/ipumsi_00014.csv",  # 2011
  "../Data/ipumsi_00015.csv",  # 2001
  "../Data/ipumsi_00016.csv"   # 1991
)

# Step 2: To define the variables I need
# These include household structure and urban/rural status — used to compute dependency
keep_cols <- c("YEAR", "URBAN", "FAMSIZE", "NCHILD")

# Step 3: Reading and labelling each dataset year
# I am loading the data, keeping only the columns I need, and tagging the year manually.
# I also hardcode LOCATION as "Rajshahi" because my focus is on that division only.

ipums_2011 <- read_csv(ipums_paths[[1]]) %>% 
  select(all_of(keep_cols)) %>% 
  mutate(
    YEAR = 2011,
    LOCATION = "Rajshahi"
  )

ipums_2001 <- read_csv(ipums_paths[[2]]) %>% 
  select(all_of(keep_cols)) %>% 
  mutate(
    YEAR = 2001,
    LOCATION = "Rajshahi"
  )

ipums_1991 <- read_csv(ipums_paths[[3]]) %>% 
  select(all_of(keep_cols)) %>% 
  mutate(
    YEAR = 1991,
    LOCATION = "Rajshahi"
  )

# 🔗 Step 4: Combining all datasets into one long panel
# Here I merge the three census waves and create new variables:
# - 'urban_rural' labels urban/rural status
# - 'child_dependency' is calculated as children per household size
ipums_all <- bind_rows(ipums_1991, ipums_2001, ipums_2011) %>%
  mutate(
    LOCATION = "Rajshahi",  # just reinforcing this label
    urban_rural = ifelse(URBAN == 1, "Urban", "Rural"),
    child_dependency = NCHILD / FAMSIZE
  )

# Step 5: Quick check — are all years loaded properly?
# This is a helpful sanity check before saving the data
print(table(ipums_all$YEAR))

# Step 6: Creating a summary table by year and area type
# I compute average child dependency, family size, and number of children
# for each year × urban/rural group. This is useful for time trend plots
rajshahi_summary <- ipums_all %>% 
  group_by(YEAR, urban_rural) %>% 
  summarise(
    avg_child_dependency = mean(child_dependency, na.rm = TRUE),
    avg_famsize = mean(FAMSIZE, na.rm = TRUE),
    avg_nchild = mean(NCHILD, na.rm = TRUE),
    .groups = "drop"
  )

# Step 7: Saving both cleaned individual-level data and summary
# These are used throughout the project — especially for regression and visualization
write_csv(ipums_all, "ipums_cleaned.csv")
write_csv(rajshahi_summary, "rajshahi_summary.csv")




# This script processes IPUMS microdata from Bangladesh's 1991, 2001, and 2011 censuses, filtering and labeling records specific to Rajshahi Division.
# It standardizes urban/rural labels, creates a child dependency variable, and summarizes key family indicators by year and area type. 
# Outputs from this script support both time series analysis and regression modeling in later stages of the project.