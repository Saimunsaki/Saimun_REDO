# 01_clean_ipums_data.R
# Purpose: Clean and merge IPUMS census data for Rajshahi Division
# Author: Saimun Nahar Saki
# Date: 2025-04-07

# Load required packages
#install.packages("tidyverse")
library(tidyverse)



# Loading the datasets
ipums_paths <- list(
  "../Data/ipumsi_00014.csv",  # 2011
  "../Data/ipumsi_00015.csv",  # 2001
  "../Data/ipumsi_00016.csv"   # 1991
)


# Define the key columns to keep
keep_cols <- c("YEAR", "URBAN", "FAMSIZE", "NCHILD")

# Read the 2011 dataset
ipums_2011 <- read_csv("~/Documents/ipumsi_00014.csv") %>% 
  select(all_of(keep_cols)) %>% 
  mutate(
    YEAR = 2011,
    LOCATION = "Rajshahi"
  )

# Read the 2001 dataset
ipums_2001 <- read_csv("~/Documents/ipumsi_00015.csv") %>% 
  select(all_of(keep_cols)) %>% 
  mutate(
    YEAR = 2001,
    LOCATION = "Rajshahi"
  )

# Read the 1991 dataset
ipums_1991 <- read_csv("~/Documents/ipumsi_00016.csv") %>% 
  select(all_of(keep_cols)) %>% 
  mutate(
    YEAR = 1991,
    LOCATION = "Rajshahi"
  )

# Combining all three datasets
# Combine datasets and clean
ipums_all <- bind_rows(ipums_1991, ipums_2001, ipums_2011) %>%
  mutate(
    LOCATION = "Rajshahi",
    urban_rural = ifelse(URBAN == 1, "Urban", "Rural"),
    child_dependency = NCHILD / FAMSIZE
  )

# Summary check (optional)
print(table(ipums_all$YEAR))


# To check whether it contains the data for all 3 years:
table(read_csv("ipums_cleaned.csv")$YEAR)

# Summarizing the data: calculate average child dependency, family size, and number of children by YEAR and urban_rural status
rajshahi_summary <- ipums_all %>% 
  group_by(YEAR, urban_rural) %>% 
  summarise(
    avg_child_dependency = mean(child_dependency, na.rm = TRUE),
    avg_famsize = mean(FAMSIZE, na.rm = TRUE),
    avg_nchild = mean(NCHILD, na.rm = TRUE),
    .groups = "drop"
  )

# Saving directly into the working directory
write_csv(ipums_all, "ipums_cleaned.csv")
write_csv(rajshahi_summary, "rajshahi_summary.csv")

### While opening the cleaned dataset, Excel was showing only 2011 possibly because:

# - Excel has a **row limit of ~1,048,576 rows** per sheet.
# - The file has **30,228,739 rows**. So Excel is **only loading the first ~1 million** — and those happen to be from 2011.

