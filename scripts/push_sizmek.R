library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(lubridate)              #version 1.6.0
library(stringr)                #version 1.2.0


rm(list = ls())        


# SET PARAMS --------------------------------------------------------------
local_folder <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/Sizmek/"
local_files <- list.files(local_folder, full.names = T, pattern = "^Prada.+xlsx$")
sizmek <- read_xlsx(local_files,skip = 19)
local_files
sizmek <- sizmek %>% 
        mutate(campaign_start_date = ymd(paste0(year(`Campaign Start Date`),"-",month(`Campaign Start Date`),"-",day(`Campaign Start Date`))),
               campaing_end_date = ymd(paste0(year(`Campaign End Date`),"-",month(`Campaign End Date`),"-",day(`Campaign End Date`)))) %>% 
        rename(date = Date,
               campaign_name = `Campaign Name`,
               impressions = `* Served Impressions`,
               clicks = `* Clicks`,
               site_name = `Site Name`) %>% 
        select(date, campaign_start_date,campaing_end_date,campaign_name,site_name,impressions,clicks)
remote_file <- "sizmek/sizmek_2018.csv"

# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
sizmek %>%
        write.csv2(file = tempfile, na = "", row.names = F)
upload_file <- upload_file(tempfile)



#upload
put_url <- paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",remote_file,"?op=CREATE&overwrite=true&write=true")
r <- httr::PUT(put_url,
               body = upload_file,
               add_headers(Authorization = paste0("Bearer ",res$access_token),
                           "Transfer-Encoding" = "chunked"), progress())
r$status_code
file.remove(tempfile)







# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)