data_lake_push <- function(dataset, remote_file, tempfile = "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv", remove_temp = T){
        
        # write temporary file to temporary dir
        dataset %>%
                write_csv(path = tempfile, na = "")
        upload_file <- upload_file(tempfile)
        
        
        
        #upload
        put_url <- paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",remote_file,"?op=CREATE&overwrite=true&write=true")
        r <- httr::PUT(put_url,
                       body = upload_file,
                       add_headers(Authorization = paste0("Bearer ",res$access_token),
                                   "Transfer-Encoding" = "chunked"), progress())
        r$status_code
        
        # delete temp file
        if(remove_temp){
                rr <- file.remove(tempfile)
        }
        message(paste0("Uploaded file: ",remote_file))
        
}

data_lake_fetch <- function(data_lake_file, remove_temp = T, temp_file = "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"){
        
        #download file
        r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",data_lake_file,"?op=OPEN&read=true"),
                       add_headers(Authorization = paste0("Bearer ",res$access_token)))
        
        #write to temp dir
        writeBin(content(r), temp_file) 
        
        #read
        dataset<- read_csv2(temp_file, col_types = cols(.default = col_character()))
        
        if(remove_temp){
                r <- file.remove(temp_file)
        }
        
        
        dataset
        
        
}


data_lake_list <- function(remote_dir){
        
        r <- httr::GET(paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",remote_dir,"?op=LISTSTATUS"),add_headers(Authorization = paste0("Bearer ",res$access_token)))
        files <- toJSON(jsonlite::fromJSON(content(r,"text")), pretty = TRUE) %>% fromJSON(simplifyDataFrame = T)
        
        files <- files$FileStatuses$FileStatus %>% 
                tbl_df() %>% 
                arrange(desc(pathSuffix))
        
        
        
        
}