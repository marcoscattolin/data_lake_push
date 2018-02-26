ga_get_out_of_stock <- function(ref_day, brand, paginate_query = F, use_miumiu_mirror = F, lookback_days = 7){
        
        
        # data on out of stock are reliable from 2017-10-25
        oos_data <- ga_get_data(start_date = max(ref_day - lookback_days + 1, ymd("20171025")), 
                                end_date = ref_day, 
                                brand = brand,
                                dimensions = "ga:date,ga:pagePathLevel3,ga:eventAction,ga:eventLabel", 
                                metrics = "ga:totalEvents",
                                filters = "ga:eventCategory==product_available",
                                split_daywise = F, 
                                paginate_query = paginate_query,
                                use_miumiu_mirror = use_miumiu_mirror) %>% 
                filter(grepl("^is",eventAction))
        
        #subset to e-store pages
        oos_data <- oos_data %>% 
                filter(grepl("miumiu|prada",pagePathLevel3)) %>% 
                mutate(brand = if_else(grepl("prada",pagePathLevel3),"Prada","Miu Miu"))
        
        #extract country and add ref_day and link
        oos_data <- oos_data %>% 
                mutate(country_store = str_extract(pattern = "../$",pagePathLevel3) %>% gsub("/","",.) %>% toupper())
        
        
}

