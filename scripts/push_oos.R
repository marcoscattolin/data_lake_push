library(tidyverse)
library(lubridate)
library(RGoogleAnalytics)
library(stringr)
rm(list = ls())       



source("scripts/helpers/ga_oos_helpers_functions.R")
source("scripts/helpers/ga_helpers_functions.R")






# GET OUT OF STOCK DATA -------------------------------------------------------------
# get last 14 days of out of stock details
oos <- map_df(c("P","M"),~ ga_get_out_of_stock(ref_day = Sys.Date()-1, brand = .x, paginate_query = T, lookback_days = 14))



# ENRICH WITH CATEGORIES --------------------------------------------------
# get from data lake ecommerce data

#source token
source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")

#list files
path <- "sales/ecommerce"
r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",path,"?op=LISTSTATUS"),add_headers(Authorization = paste0("Bearer ",res$access_token)))
files <- toJSON(jsonlite::fromJSON(content(r,"text")), pretty = TRUE) %>% fromJSON(simplifyDataFrame = T)

files <- files$FileStatuses$FileStatus %>% 
        tbl_df() %>% 
        arrange(desc(pathSuffix)) %>% 
        head(2) %>% 
        pull(pathSuffix)

# download and build data frame
ecommerce <- map_df(files, function(x){
        r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",path,"/",x,"?op=OPEN&read=true"),
                       add_headers(Authorization = paste0("Bearer ",res$access_token)))
        writeBin(content(r), paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/",x)) 
        ecommerce <- read_csv2(paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/",x), col_types = cols(.default = col_character()))
        file.remove(paste0("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/",x))
        ecommerce
})



oos <- out_of_stock_enrich(oos,ecommerce)



# UPLOAD TO DATA LAKE -----------------------------------------------------
# write file to temporary dir
tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
oos %>%
        write.csv2(file = tempfile, na = "", row.names = F, dec = ",")
upload_file <- upload_file(tempfile)

# assign remote file name
remote_file <- paste0("googleanalytics/outofstock/outofstock.csv")


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
