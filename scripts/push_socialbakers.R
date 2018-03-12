library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(lubridate)              #version 1.6.0
library(stringr)                #version 1.2.0



#############
### POST ###
############


rm(list = ls())
source("scripts/helpers/socialbakers_helpers_functions.R")


# SET PARAMS --------------------------------------------------------------
local_folder <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/socialbakers/Posts/"
local_files <- list.files(local_folder, full.names = T, pattern = "xlsx$")

# CHECK COLUMNS --------------------------------------------------------------
lapply(local_files,col_check)

stop_function()

# READ POSTS -------------------------------------------------------------------
Posts <- lapply(local_files,read_posts_social) %>% 
        bind_rows()
remote_file <- "social/Posts/Posts_2018_02.csv"


# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")
source("scripts/helpers/dl_helpers_functions.R")
data_lake_push(Posts, remote_file)


#############
### FANS ###
############


rm(list = ls())
source("scripts/helpers/socialbakers_helpers_functions.R")

# SET PARAMS --------------------------------------------------------------
local_folder <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/socialbakers/Fans/"
local_files <- list.files(local_folder, full.names = T, pattern = "xlsx$")

# READ FANS -------------------------------------------------------------------
Fans <- lapply(local_files,read_fans_social) %>% 
        bind_rows()
remote_file <- "social/Fans/Fans_2018_02.csv"


# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")
source("scripts/helpers/dl_helpers_functions.R")
data_lake_push(Fans, remote_file)

# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)

