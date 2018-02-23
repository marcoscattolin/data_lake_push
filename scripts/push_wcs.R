library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(stringr)                #version 1.2.0
library(curl)


message("\n\n\n\n\n\n\n-------- STARTING SCRIPT --------")


#source 
source("scripts/helpers/wcs_helpers_functions.R")

#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


#download file path
data_lake_file <- "wcs/path/wcsfilepaths.csv"
r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",data_lake_file,"?op=OPEN&read=true"),
                       add_headers(Authorization = paste0("Bearer ",res$access_token)))
writeBin(content(r), paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv")) 
paths <- read_csv2(paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"), col_types = cols(.default = col_character()))
r <- file.remove(paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"))




# upload files
map2(.x = paths$wcs_path,.y = paths$data_lake_path, function(.x,.y){
        dataset <- download_wcs(.x)
        wcs_push_dataset(dataset, remote_file = .y)
        message(paste0("Uploaded ",.y))
})






# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)
