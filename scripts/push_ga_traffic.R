library(tidyverse)
library(lubridate)
library(RGoogleAnalytics)
library(stringr)
rm(list = ls())       



source("scripts/helpers/ga_helpers_functions.R")



# GET TRAFFIC -------------------------------------------------------------
# get traffic from beginnin of month until ref_day
traffic <- map_df(c("P","M","MA","KS","C"), ~ ga_get_views(brand = .x, ref_day = Sys.Date()-1, use_carshoe_raw = F))


# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# define remote file name
remote_file <- traffic %>% 
        summarise(d = min(date)) %>% 
        pull(d)
remote_file <- paste0("googleanalytics/visits/visits_",str_sub(remote_file,1,4),"_",str_sub(remote_file,5,6),".csv")

# upload to data lake
source("scripts/helpers/dl_helpers_functions.R")
data_lake_push(traffic, remote_file)





# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)
