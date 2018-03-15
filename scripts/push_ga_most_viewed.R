library(tidyverse)
library(lubridate)
library(RGoogleAnalytics)
library(stringr)
rm(list = ls())       



source("scripts/helpers/ga_helpers_functions.R")



# GET TRAFFIC -------------------------------------------------------------
ref_day <- Sys.Date()-1

# get traffic for last 7 days
most_viewed <- map_df(c("P","M","MA"), ~ ga_get_most_viewed(brand = .x, ref_day = ref_day, lookback_days = 7))
most_viewed <- map_df(c("P"), ~ ga_get_most_viewed_china(brand = .x, ref_day = ref_day, lookback_days = 7)) %>% bind_rows(most_viewed,.)
most_viewed <- most_viewed %>% 
        mutate(last7daysuntil = ref_day)



# ENRICH WITH CATEGORIES --------------------------------------------------
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")
source("scripts/helpers/dl_helpers_functions.R")

#list ecommerce files
path <- "sales/ecommerce"
files <- data_lake_list(path)

#restrict to last 2 ecommerce files
files <- files %>% 
        filter(grepl("ecom",pathSuffix)) %>% 
        arrange(desc(pathSuffix)) %>% 
        head(2) %>% 
        pull(pathSuffix) %>% 
        paste0(path,"/",.)


# get ecommerce data from data lake 
ecommerce <- map_df(files,data_lake_fetch)


#enrich oos data
most_viewed <- sku_enrich(most_viewed,ecommerce,sku_col = "sku")




# UPLOAD TO DATA LAKE -----------------------------------------------------
#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")


# define remote file name
remote_file <- paste0("googleanalytics/mostviewed/mostviewed_last7days_",gsub("-","",as.character(ref_day)),".csv")

# upload to data lake
source("scripts/helpers/dl_helpers_functions.R")
data_lake_push(most_viewed, remote_file)





# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)
