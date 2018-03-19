library(tidyverse)
library(searchConsoleR)
library(stringr)
library(httr)
library(jsonlite)
library(curl)
library(lubridate)
rm(list = ls())

# GET DATA
source("scripts/helpers/searchconsole_helpers_functions.R")

queries <- search_console_get_data(end_date = Sys.Date()-3)

# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# define remote file name
remote_file <- queries %>% 
        summarise(d = min(date)) %>% 
        pull(d)
remote_file
remote_file <- paste0("searchconsole/queries_",str_sub(remote_file,1,4),"_",str_sub(remote_file,6,7),".csv")

# upload to data lake
source("scripts/helpers/dl_helpers_functions.R")
data_lake_push(queries, remote_file)





# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)