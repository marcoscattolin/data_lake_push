library(tidyverse)
library(lubridate)
library(RGoogleAnalytics)
library(stringr)
rm(list = ls())       



source("scripts/helpers/ga_helpers_functions.R")






# GET TRAFFIC -------------------------------------------------------------
# get traffic from beginnin of month until ref_day
traffic <- map_df(c("P","M","KS","MA"), ~ ga_get_views(brand = .x, ref_day = Sys.Date()-1, use_carshoe_raw = T))


# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
traffic %>%
        write.csv2(file = tempfile, na = "", row.names = F, dec = ",")
upload_file <- upload_file(tempfile)

# assign remote file name
remote_file <- traffic %>% 
        summarise(d = min(date)) %>% 
        pull(d)
remote_file <- paste0("googleanalytics/visits/visits_",str_sub(remote_file,1,4),"_",str_sub(remote_file,5,6),".csv")


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
