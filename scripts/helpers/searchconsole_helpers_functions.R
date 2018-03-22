library(tidyverse)
library(searchConsoleR)
library(stringr)
library(httr)
library(jsonlite)
library(curl)
library(lubridate)


search_console_get_data <- function(end_date){
        # SET START DATE
        start_date <- end_date - 90
        
        
        # options("googleAuthR.client_id" = "797888071372-v3q8h1f3r7q2356drtg0nhl44m5juu7k.apps.googleusercontent.com")
        # options("googleAuthR.client_secret" = "TS5PmKapBep2eRB9OXW7f7x3")
        # options("googleAuthR.scopes.selected" = "https://www.googleapis.com/auth/webmasters")
        scr_auth(token = ".httr-oauth")
        
        
        
        # LIST WEBSITES -----------------------------------------------------------
        website <- list_websites() %>% 
                tbl_df()
        
        
        # BUILD QUERY GRID -----------------------------------------------------------
        countries <- pull_countries()
        
        file.remove("K:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv")
        
        stores <- website %>% 
                mutate(country_iso_code = str_extract(siteUrl,pattern = "/(prada|miumiu)../$")) %>% 
                mutate(country_iso_code = str_sub(country_iso_code,start = -3,end = -2)) %>% 
                inner_join(countries) %>% 
                select(siteUrl, country_iso_code3)
        
        website <- website %>% 
                filter(grepl(x = siteUrl, pattern = "www.(prada|miumiu|pasticceriamarchesi|carshoe)"))
        
        generic <- stores %>% 
                distinct(country_iso_code3) %>% 
                expand(siteUrl = website$siteUrl, country_iso_code3 = pull(.))
        
        
        grid <- bind_rows(generic,stores)
        
        
        
        
        # GET DATA ----------------------------------------------------------------
        queries <- map2_df(.x = grid$siteUrl,.y = grid$country_iso_code3,
                           ~ search_analytics(.x,
                                              dimensionFilterExp = paste0("country==",.y),
                                              start = start_date, 
                                              end = end_date,
                                              dimensions = c("date","query","country"),
                                              searchType = "web",
                                              rowLimit = 5000) %>% 
                                   tbl_df() %>% 
                                   mutate(website = .x)
        )
        
        
        
        
        # CREATE BRAND AND DOMAIN COLUMN -------------------------------
        queries <- queries %>% 
                mutate(domain = str_extract(website, "[a-z]*\\.com"),
                       brand = case_when(str_detect(domain,"prada")~ "P",
                                         str_detect(domain,"miumiu")~ "M",
                                         str_detect(domain,"carshoe")~ "KS",T ~"MA")) %>% 
                filter(!is.na(date))

}




pull_countries <- function(){
        
        # GET TOKEN ---------------------------------------------------------------
        source("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/azure_token.r")
        
        # FILE --------------------------------------------------------------
        path <- "sales/maps/countries"
        r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",path,"?op=LISTSTATUS"),add_headers(Authorization = paste0("Bearer ",res$access_token)))
        toJSON(jsonlite::fromJSON(content(r,"text")), pretty = TRUE) %>% fromJSON(simplifyDataFrame = T)
        
        
        # READ DATA ---------------------------------------------------------------
        data_lake_file <- paste0(path,"/country_map.csv")
        r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",data_lake_file,"?op=OPEN&read=true"),
                               add_headers(Authorization = paste0("Bearer ",res$access_token)))
        
        writeBin(content(r), "K:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv")
        countries <- read.csv("K:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv", sep = ";") %>% 
                mutate_all(tolower)
        
}
