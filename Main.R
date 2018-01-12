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


glimpse(churn_data_raw)
