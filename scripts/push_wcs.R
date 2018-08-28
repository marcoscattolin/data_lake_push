library(tidyverse)              #version 1.1.1
library(readxl)                 #version 1.0.0
library(stringr)                #version 1.2.0
library(curl)


message("\n\n\n\n\n\n\n-------- STARTING SCRIPT --------")


#source 
source("scripts/helpers/wcs_helpers_functions.R")

#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")
source("scripts/helpers/dl_helpers_functions.R")

#download file paths
data_lake_file <- "wcs/path/wcsfilepaths.csv"
paths <- data_lake_fetch(data_lake_file) %>% 
        mutate(wcs_path = paste0(wcs_path,"x"))


pathReturn <- paths %>%
        mutate(data_lake_path = "wcs/returns.csv",
               wcs_path = "https://backofficewcs.pradagroup.net:8000/pradareports/csrRmaReport.xlsx")

pathReturn <- pathReturn[1,]

paths <- paths %>% 
        bind_rows(pathReturn)

# upload files
map2(.x = paths$wcs_path,.y = paths$data_lake_path, function(.x,.y){
        dataset <- download_wcs(.x)
        data_lake_push(dataset, remote_file = .y, preserve_chinese = T,remove_temp = F)
})






# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)
