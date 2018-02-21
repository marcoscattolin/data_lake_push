read_data <- function(file){
        data <- read_csv2(file, skip = 4, na = c("#",""), col_types = cols(.default = col_character()))
        
        
        colnames(data) <- data %>% 
                colnames() %>% 
                tolower() %>% 
                gsub("[^a-z 0-9_]","",.) %>%
                gsub(" {1,}","_",.) %>% 
                gsub("_1","_text",.)
        
        data
        
        
}

quantity_at <- function(data, input, output = NULL, drop_oringinal = F){
        
        if(drop_oringinal & is.null(output)){
                stop("Please define output names if you want to drop originals")
        }
        
        if(length(input) != length(output) & !is.null(output)){
                stop("Input and Output must have same length")
        }
        
        temp <- data %>% 
                select_at(input)
                
        if(drop_oringinal){
                data <- data %>% 
                        select(-one_of(input))
        }
        
        
        temp <- temp %>% 
                mutate_all(~if_else(is.na(.),0,as.numeric(.))) 
        

        if(!is.null(output)){
            colnames(temp) <- output
        }
        
        data <- data %>% bind_cols(temp)
        
        
}

value_at <- function(data, input, output = NULL, drop_oringinal = F){
        
        if(drop_oringinal & is.null(output)){
                stop("Please define output names if you want to drop originals")
        }
        
        if(length(input) != length(output) & !is.null(output)){
                stop("Input and Output must have same length")
        }
        
        temp <- data %>% 
                select_at(input)
        
        if(drop_oringinal){
                data <- data %>% 
                        select(-one_of(input))
        }
        
        
        #transform data
        temp <- temp %>% 
                mutate_all( ~ gsub("\\.","",.)) %>%
                mutate_all( ~ gsub(",","\\.",.)) %>%
                mutate_all( ~ as.numeric(.)) %>%
                mutate_all(~if_else(is.na(.),0,.))
        
        
        if(!is.null(output)){
                colnames(temp) <- output
        }
        
        data <- data %>% bind_cols(temp)
        
        
}

dates_at <- function(data, input, output = NULL, drop_oringinal = F, format = NULL){
        
        if(drop_oringinal & is.null(output)){
                stop("Please define output names if you want to drop originals")
        }
        
        if(length(input) != length(output) & !is.null(output)){
                stop("Input and Output must have same length")
        }
        
        temp <- data %>% 
                select_at(input)
        
        if(drop_oringinal){
                data <- data %>% 
                        select(-one_of(input))
        }
        
        
        #transform data
        temp <- temp %>% 
                mutate_all(~ as.Date(., format = format))
        
        
        if(!is.null(output)){
                colnames(temp) <- output
        }
        
        data <- data %>% bind_cols(temp)
        
        
}

unpivot_markdowns <- function(data, qty_reg_col, qty_md_col, val_loc_reg_col, val_loc_md_col){
        
        
        cols <- c(qty_reg_col, qty_md_col, val_loc_reg_col, val_loc_md_col)
        
        data <- data %>% 
                gather_(key = "key", value = "key_val", cols)
        
        data <- data %>%         
                mutate(sale_type = case_when(key %in% c(qty_md_col,val_loc_md_col) ~ "Markdown", TRUE ~ "Regular")) %>% 
                mutate(temp_col = case_when(key %in% c(qty_md_col,qty_reg_col) ~ "quantity",
                                           key %in% c(val_loc_reg_col,val_loc_md_col) ~ "value_local")) 
        
        data <- data %>%
                select(-key) %>% 
                spread(temp_col,key_val, fill = 0)
        
        data %>% 
                filter(!(quantity == 0 & value_local == 0))
        
        
        
}


strip_currency <- function(data,input){
        

        data %>% 
                mutate_at(vars(input), ~ gsub("[^0-9,\\.\\-]*","", .) %>% str_trim() %>% gsub("\\.","",.) %>% gsub(",",".",.) %>% as.numeric(.))
        
}