library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(lubridate)              #version 1.6.0
library(stringr)                #version 1.2.0


rm(list = ls())        
source("scripts/helpers/sap_helpers_functions.R")


# SET PARAMS --------------------------------------------------------------
local_folder <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/retail_agg/"
local_files <- list.files(local_folder, full.names = T)
remote_file <- paste0("sales/retail_agg/",list.files(local_folder))




# LOAD DATASET DATA -----------------------------------------------------
sales_dataset <- map_df(local_files, read_data)
sales_dataset <- dates_at(sales_dataset, input = c("calendar_day"), output = c("day"), drop_oringinal = T, format = "%d.%m.%Y")
sales_dataset <- quantity_at(sales_dataset, input = c("qty_regolari","qty_saldi"), output = c("qty_reg","qty_saldi"), drop_oringinal = T)
sales_dataset <- value_at(sales_dataset, c("vend_reg_loccurr","vend_saldi_loccurr"), output = c("val_loc_reg","val_loc_saldi"), drop_oringinal = T)

sales_dataset <- unpivot_markdowns(data = sales_dataset, 
                               qty_reg_col = "qty_reg", 
                               qty_md_col = "qty_saldi", 
                               val_loc_reg_col = "val_loc_reg", 
                               val_loc_md_col = "val_loc_saldi")



# SAVE INTO LOCAL REPO -----------------------------------------------------
# sales_dataset %>%
#         write.csv2(paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/analytics/datasets/",remote_file), na = "", row.names = F, dec = ",")


# # UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
sales_dataset %>%
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
