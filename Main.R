# Load libraries
library(readr)
library(keras)
library(lime)
library(tidyquant)
library(rsample)
library(recipes)
library(yardstick)
library(corrr)

# Import IBM Churn Data
churn_data_raw <- read_csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")

# View observations and variables
glimpse(churn_data_raw)

# Remove unnecessary data
churn_data_tbl <- churn_data_raw %>%
  select(-customerID) %>% # Remove Customer ID
  drop_na() %>% # drop NA observations
  select(Churn, everything()) # Remove all of Churn variable

# View observations and variables
glimpse(churn_data_tbl)


        