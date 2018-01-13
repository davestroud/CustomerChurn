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
  select(Churn, everything()) # Set target in the first column

# View observations and variables
glimpse(churn_data_tbl)

# Split test/training sets ~ uses the rsample package
set.seed(100)
train_test_split <- initial_split(churn_data_tbl, prop = 0.8)
train_test_split
        
# Retrieve train and test sets
train_tbl <- training(train_test_split)
test_tbl <- testing(train_test_split)
