# HELPERS FUNCTIONS ---------------------------------------------------------
ga_get_data <- function(start_date, end_date, brand, dimensions, metrics, segments = NULL, filters = NULL, split_daywise = T, paginate_query = F,use_miumiu_mirror = F, use_carshoe_raw = F){
        
        # details on dimensions and metrics
        # https://developers.google.com/analytics/devguides/reporting/core/dimsmets
        
        # query explorer -> use to retrieve segment ids'
        # https://ga-dev-tools.appspot.com/query-explorer/
        
        #load token and get views
        load("k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/token/prada_account_oauth_token")
        profiles <- tbl_df(GetProfiles(token = oauth_token))
        
        if(brand == "P"){
                view <- profiles %>% 
                        filter(id == "126281707")
        } else if(brand == "M" & use_miumiu_mirror){
                view <- profiles %>% 
                        filter(id == "158198438")
        } else if(brand == "M" & use_miumiu_mirror == F){
                view <- profiles %>% 
                        filter(id == "126514406")
        } else if(brand == "MA"){
                view <- profiles %>% 
                        filter(id == "165553567")
        } else if (brand == "KS" & use_carshoe_raw == T){
                view <- profiles %>% 
                        filter(id == "65787108")
        } else {
                view <- profiles %>% 
                        filter(id == "169292958")
        }
        
        message(paste0("Getting data for view: ",view$name))
        
        
        if(is.null(segments) & is.null(filters)){
                
                query <- Init(start.date = as.character(start_date),
                              end.date = as.character(end_date),
                              dimensions = dimensions,
                              metrics = metrics,
                              max.results = 10000,
                              table.id = paste0("ga:",view$id))
                
        } else if(!is.null(segments) & is.null(filters)){
                
                query <- Init(start.date = as.character(start_date),
                              end.date = as.character(end_date),
                              dimensions = dimensions,
                              metrics = metrics,
                              segments = segments,
                              max.results = 10000,
                              table.id = paste0("ga:",view$id))
                
        } else if(is.null(segments) & !is.null(filters)){
                
                query <- Init(start.date = as.character(start_date),
                              end.date = as.character(end_date),
                              dimensions = dimensions,
                              metrics = metrics,
                              filters = filters,
                              max.results = 10000,
                              table.id = paste0("ga:",view$id))
                
        } else {
                query <- Init(start.date = as.character(start_date),
                              end.date = as.character(end_date),
                              dimensions = dimensions,
                              metrics = metrics,
                              segments = segments,
                              filters = filters,
                              max.results = 10000,
                              table.id = paste0("ga:",view$id))
        }
        
        
        result <- tbl_df(GetReportData(query.builder = QueryBuilder(query), token =  oauth_token, split_daywise, paginate_query))
        
}

ga_get_grouped_traffic <- function(brand, start_date, end_date, segment_id, split_daywise, use_carshoe_raw = F){
        
        
        #  get traffic from social but logins
        if(brand == "KS" & use_carshoe_raw == F){
                visits <- ga_get_data(start_date = start_date, 
                                      end_date = end_date, 
                                      brand = brand,
                                      dimensions = "ga:date,ga:countryIsoCode,ga:source,ga:medium,ga:campaign", 
                                      metrics = "ga:sessions,ga:transactions,ga:bounces,ga:newUsers,ga:pageviews,ga:goalCompletionsAll", 
                                      segments = segment_id,
                                      filters = "ga:landingPagePath!@SocialSignIn",
                                      split_daywise = split_daywise,
                                      use_carshoe_raw = use_carshoe_raw) %>% 
                        mutate(brand = brand, 
                               landingPagePath = "not social",
                               transactions = goalCompletionsAll) %>% 
                        select(-goalCompletionsAll)
        } else {
                visits <- ga_get_data(start_date = start_date, 
                                      end_date = end_date, 
                                      brand = brand,
                                      dimensions = "ga:date,ga:countryIsoCode,ga:source,ga:medium,ga:campaign", 
                                      metrics = "ga:sessions,ga:transactions,ga:bounces,ga:newUsers,ga:pageviews", 
                                      segments = segment_id,
                                      filters = "ga:landingPagePath!@SocialSignIn",
                                      split_daywise = split_daywise,
                                      use_carshoe_raw = use_carshoe_raw) %>% 
                        mutate(brand = brand, landingPagePath = "not social")
        }
        
        
        
        #  get traffic from social logins (after 5-5-2017 for Prada, after 29-12-2017 for miu miu)
        if(brand == "P"){
                temp_start_date <- max(start_date,ymd("20170505"))
        } else if(brand == "M"){
                temp_start_date <- max(start_date,ymd("20171229"))
        } else {
                temp_start_date <- end_date + 1
        }
        
        if(temp_start_date < end_date & brand != "P"){
                visits <- ga_get_data(start_date = temp_start_date, 
                                      end_date = end_date, 
                                      brand = brand,
                                      dimensions = "ga:date,ga:countryIsoCode,ga:source,ga:medium,ga:campaign",
                                      metrics = "ga:sessions,ga:transactions,ga:bounces,ga:newUsers,ga:pageviews", 
                                      segments = segment_id,
                                      filters = "ga:landingPagePath=@SocialSignIn",
                                      split_daywise = F,
                                      use_carshoe_raw = use_carshoe_raw) %>% 
                        mutate(brand = brand,
                               landingPagePath = "social") %>% 
                        bind_rows(visits)
        }
        
        if(temp_start_date < end_date & brand == "P"){
                visits <- ga_get_data(start_date = temp_start_date, 
                                      end_date = end_date, 
                                      brand = brand,
                                      dimensions = "ga:date,ga:countryIsoCode,ga:source,ga:medium,ga:campaign",
                                      metrics = "ga:sessions,ga:transactions,ga:bounces,ga:newUsers,ga:pageviews", 
                                      segments = segment_id,
                                      filters = "ga:landingPagePath=@SocialSignIn",
                                      split_daywise = T,
                                      use_carshoe_raw = use_carshoe_raw) %>% 
                        mutate(brand = brand,
                               landingPagePath = "social") %>% 
                        bind_rows(visits)
        }
        # new channel grouping
        visits <- visits %>% 
                mutate(custom_grouping = case_when(source == "(direct)" & medium == "(none)" ~ "Direct",
                                                   medium == "organic" ~ "Natural Search",
                                                   medium == "referral" & landingPagePath != "social" & campaign == "(not set)" & grepl(pattern = "(.*facebook.*)|(.*instagram.*)|(.*t\\.co$)|(.*pinterest.*)|(.*vk\\.com.*)|(.*twitter.*)|(.*youtube.*)|(^line$)", source) ~ "Referrals from socials",
                                                   medium == "referral" & landingPagePath != "social" & campaign == "(not set)" ~ "Referrals non-social",
                                                   grepl("social[-_]post",medium) & landingPagePath != "social" & campaign != "(not set)" ~ "Social Posts",
                                                   medium == "sa" | medium == "social_ad" ~ "Social Paid Campaigns",
                                                   grepl("email|mail",medium)  ~ "Email",
                                                   grepl("cpc|mse",medium) ~ "Paid Search",
                                                   grepl("display|affiliate|video|video_ad|branded_content|native",medium)  ~ "Display",
                                                   grepl(" ^(cpv|cpa|cpp|content-text)$",medium) | campaign != "(not set)" ~ "Other Campaigns",
                                                   landingPagePath == "social" & campaign == "(not set)" ~ "Social Login",
                                                   TRUE ~ "(Other)")) %>% 
                group_by(date,countryIsoCode,brand,custom_grouping) %>% 
                summarise_at(vars(sessions,transactions,bounces,newUsers,pageviews),sum)
        
        # renam to standard channel
        visits <- visits %>% 
                ungroup() %>% 
                rename(channelGrouping = custom_grouping)
        
        
}

ga_get_views <- function(brand, ref_day, split_daywise = F,use_carshoe_raw = F){
        
        #subset to e-store countries
        
        if(brand == "P"){
                # modified for go live china
                segment_id <- "gaid::J09RpBPURA2XrNwnp9ih4A"
        } else if(brand == "M"){
                segment_id <- "gaid::J09RpBPURA2XrNwnp9ih4A"
        } else if(brand == "MA"){
                segment_id <- "gaid::OJMUdSU9RiK0BdphC3T0Zg"
        } else if(brand == "KS" & use_carshoe_raw == T){
                segment_id <- "gaid::wpN-5UBESBuzUedlpmhLSg"
        } else {
                segment_id <- "gaid::r9VnChzwQduyWOb50bwN1w"
        }
        
        
        start_date <- ymd(paste0(year(ref_day),"-",month(ref_day),"-", "01"))
        
        
        visits <- ga_get_grouped_traffic(start_date = start_date, 
                                         end_date = ref_day, 
                                         brand = brand,
                                         segment_id = segment_id, 
                                         split_daywise = split_daywise,
                                         use_carshoe_raw = use_carshoe_raw)
        
        
}

ga_get_most_viewed <- function(ref_day, brand, paginate_query = F, use_miumiu_mirror = F, lookback_days = 6){
        
        
        most_viewed <- ga_get_data(start_date = ref_day-lookback_days,
                    end_date = ref_day,
                    brand = brand,
                    dimensions = "ga:pagePathLevel3,ga:eventLabel",
                    metrics = "ga:totalEvents",
                    filters = "ga:eventCategory==ecommerce,ga:eventAction==detail",
                    split_daywise = F,
                    paginate_query = paginate_query,
                    use_miumiu_mirror = use_miumiu_mirror) %>% 
                filter(pagePathLevel3 != "/miumiuca/") %>% 
                mutate(brand = brand)
        
        most_viewed %>% 
                mutate(country_code = str_sub(pagePathLevel3,-3) %>% str_sub(.,1,2) %>% toupper()) %>% 
                filter(grepl("^[A-Z0-9]{4,}",eventLabel)) %>% 
                mutate(sku = gsub("-","_",eventLabel)) %>% 
                group_by(sku,country_code,brand) %>% 
                summarise(views = sum(totalEvents)) %>% 
                ungroup()
        
        
        
        
        
}

ga_get_most_viewed_china <- function(ref_day, brand, paginate_query = F, use_miumiu_mirror = F, lookback_days = 6){
        
        
        
        most_viewed_china <- ga_get_data(start_date = ref_day-lookback_days,
                                         end_date = ref_day,
                                         brand = brand,
                                         dimensions = "ga:pagePathLevel4",
                                         metrics = "ga:pageviews",
                                         filters = "ga:pagePath=~^www\\.prada\\.com/cn/*;ga:pagePathLevel4=~product",
                                         split_daywise = F,
                                         paginate_query = paginate_query,
                                         use_miumiu_mirror = use_miumiu_mirror)
        
        most_viewed_china <- most_viewed_china %>% 
                mutate(sku = str_extract(pagePathLevel4,"[A-Z0-9_]*\\.html$") %>% gsub("\\.html$","",.)) %>% 
                group_by(sku) %>% 
                summarise(views = sum(pageviews)) %>% 
                mutate(country_code = "CN", brand = brand) %>% 
                filter(sku != "") %>% 
                ungroup()
        
        
        
}

sku_enrich <- function(ga_data,ecom_data, sku_col){
        
        temp <- ecom_data %>% 
                mutate(key = str_sub(article_style_code,1,3)) %>% 
                mutate(category_id = paste0(brand,commercial_class,collection)) %>% 
                select(category_id,key) %>% 
                group_by(key) %>% 
                summarise(category_id = first(category_id))
        
        
        ga_data <- ga_data %>% 
                mutate_("key" = sku_col) %>% 
                mutate(key = str_sub(key,1,3)) %>% 
                left_join(temp, by = "key") %>% 
                select(-key)
        
}
