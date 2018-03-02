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
local_folder <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/socialbakers/Posts"
local_files <- list.files(local_folder, full.names = T, pattern = "xlsx$")

# CHECK COLUMNS --------------------------------------------------------------
lapply(local_files,col_check)

stop_function()

# READ POSTS -------------------------------------------------------------------
Posts <- lapply(local_files,read_posts_social) %>% 
        bind_rows()
remote_file <- "social/Posts/Posts_2018_01.csv"


# UPLOAD POSTS TO DATA LAKE -----------------------------------------------------

#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")

# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
Posts %>%
        write.csv2(file = tempfile, na = "", row.names = F, dec = ",")
upload_file <- upload_file(tempfile)



#upload
put_url <- paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",remote_file,"?op=CREATE&overwrite=true&write=true")
r <- httr::PUT(put_url,
               body = upload_file,
               add_headers(Authorization = paste0("Bearer ",res$access_token),
                           "Transfer-Encoding" = "chunked"), progress())
r$status_code
file.remove(tempfile)





#############
### FANS ###
############


rm(list = ls())
source("scripts/helpers/socialbakers_helpers_functions.R")


# READ FANS -------------------------------------------------------------------
Posts <- lapply(local_files,read_fans_social) %>% 
        bind_rows()
remote_file <- "social/Fans/Fans_2017_12.csv"


# UPLOAD POSTS TO DATA LAKE -----------------------------------------------------

#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")

# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
Posts %>%
        write.csv2(file = tempfile, na = "", row.names = F, dec = ",")
upload_file <- upload_file(tempfile)



#upload
put_url <- paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",remote_file,"?op=CREATE&overwrite=true&write=true")
r <- httr::PUT(put_url,
               body = upload_file,
               add_headers(Authorization = paste0("Bearer ",res$access_token),
                           "Transfer-Encoding" = "chunked"), progress())
r$status_code
file.remove(tempfile)


