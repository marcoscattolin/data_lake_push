library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(lubridate)              #version 1.6.0
library(stringr)                #version 1.2.0


rm(list = ls())        
source("helpers/marchesi_helpers_functions.R")


marchesi <- read_marchesi_custom("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/marchesi/marchesi.TXT")
remote_file <- "sales/ecommerce/marchesi_2018.csv"

# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
marchesi %>%
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
