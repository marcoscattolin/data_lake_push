
read_marchesi_custom <- function(file){
        
        cols <- c("first_discard",
                  "doc_ved_discard",
                  "Posizione_discard",
                  "order_id",
                  "day",
                  "consegna_discard",
                  "il_discard",
                  "ora_discard",
                  "gift_discard",
                  "stato_ge_discard",
                  "_discard",
                  "article_style_code",
                  "article_style_code_text",
                  "quantity",
                  "unita_discard",
                  "value_local",
                  "invoice_currency",
                  "imposta_discard",
                  "currency_discard",
                  "lordo_discard",
                  "currency2_discard",
                  "commit_discard",
                  "nome_discard",
                  "localita_discard",
                  "cap_discard",
                  "via_discard",
                  "tel1_discard",
                  "provincia_discard",
                  "paese_discard",
                  "email_discard")
        
        marchesi <- read_delim(file, delim = "|", skip = 6, col_names = cols)
        
        #process data
        marchesi <- marchesi %>% 
                select_at(vars(-ends_with("discard"))) %>% 
                mutate(country = str_sub(string = order_id,start = 1,end = 2)) %>% 
                mutate(brand = str_sub(string = order_id,start = 3,end = 4)) %>% 
                mutate(commercial_class = str_sub(string = article_style_code, start = 1,end = 3)) %>% 
                mutate(collection = "") %>% 
                mutate(day = dmy(day)) %>% 
                mutate(value_local = gsub("\\.","",value_local) %>% gsub(",",".",.) %>% as.numeric(.)) %>% 
                select(-order_id) %>% 
                filter(!is.na(value_local))
        
}

