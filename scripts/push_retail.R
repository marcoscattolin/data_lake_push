library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(lubridate)              #version 1.6.0
library(stringr)                #version 1.2.0


rm(list = ls())        
source("scripts/helpers/sap_helpers_functions.R")


# SET PARAMS --------------------------------------------------------------
local_folder <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/retail/"
local_files <- list.files(local_folder, full.names = T, pattern = "csv$")
remote_file <- paste0("sales/retail/",list.files(local_folder))




# LOAD AND TRANSFORM DATASET DATA -----------------------------------------------------
sales_dataset <- map_df(local_files, read_data)
sales_dataset <- dates_at(sales_dataset, input = c("calendar_day"), output = c("day"), drop_oringinal = T, format = "%d.%m.%Y")
sales_dataset <- quantity_at(sales_dataset, input = c("qty_regolari","qty_saldi"), output = c("qty_reg","qty_saldi"), drop_oringinal = T)
sales_dataset <- strip_currency(sales_dataset, c("vendreg_loccurr","vendsaldi_loc_curr"))
sales_dataset <- value_at(sales_dataset, c("vendreg_loccurr","vendsaldi_loc_curr"), output = c("val_loc_reg","val_loc_saldi"), drop_oringinal = T)
sales_dataset <- unpivot_markdowns(data = sales_dataset, 
                               qty_reg_col = "qty_reg", 
                               qty_md_col = "qty_saldi", 
                               val_loc_reg_col = "val_loc_reg", 
                               val_loc_md_col = "val_loc_saldi")



# UPLOAD TO DATA LAKE -----------------------------------------------------
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")
source("scripts/helpers/dl_helpers_functions.R")
data_lake_push(sales_dataset, remote_file)








# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)
