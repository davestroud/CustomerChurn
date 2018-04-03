# Load libraries

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

# Determine if log transformation improves correlation
# between TotalCharges and Churn
train_tbl %>%
  select(Churn, TotalCharges) %>%
  mutate(
    Churn = Churn %>% as.factor() %>% as.numeric(),
    LogTotalCharges = log(TotalCharges)
  ) %>%
  correlate() %>%
  focus(Churn) %>%
  fashion()
  
# Create recipe
rec_obj <- recipe(Churn ~ ., data = train_tbl) %>%
  step_discretize(tenure, options = list(cuts = 6)) %>%
  step_log(TotalCharges) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_center(all_predictors(), -all_outcomes()) %>%
  step_scale(all_predictors(), -all_outcomes()) %>%
  prep(data = train_tbl)

# Print the recipe object
rec_obj

# Predictors
x_train_tbl <- bake(rec_obj, newdata = train_tbl) %>% select(-Churn)
x_test_tbl  <- bake(rec_obj, newdata = test_tbl) %>% select(-Churn)

glimpse(x_train_tbl)

# Response variables for training and testing sets
y_train_vec <- ifelse(pull(train_tbl, Churn) == "Yes", 1, 0)
y_test_vec  <- ifelse(pull(test_tbl, Churn) == "Yes", 1, 0)
