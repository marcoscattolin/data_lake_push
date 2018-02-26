library(tidyverse)
library(lubridate)
library(RGoogleAnalytics)
library(stringr)
 


# SOURCE HELPERS FILES ----------------------------------------------------
source("scripts/helpers/ga_oos_helpers_functions.R")
source("scripts/helpers/ga_helpers_functions.R")
source("scripts/helpers/dl_helpers_functions.R")




# GET OUT OF STOCK DATA -------------------------------------------------------------
# get last 14 days of out of stock details
oos <- map_df(c("P","M"),~ ga_get_out_of_stock(ref_day = Sys.Date()-1, brand = .x, paginate_query = T, lookback_days = 14))



# ENRICH WITH CATEGORIES --------------------------------------------------
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")

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
oos <- out_of_stock_enrich(oos,ecommerce)



# UPLOAD TO DATA LAKE -----------------------------------------------------
# assign remote file name
remote_file <- paste0("googleanalytics/outofstock/outofstock.csv")
data_lake_push(oos,remote_file)



# END OF SCRIPT -----------------------------------------------------------
cat("Script completed, hit Return to finish...")
a <- readLines(file("stdin"),1)
