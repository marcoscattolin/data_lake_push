

# WCS REPORT -------------------------------------------------------
download_wcs <- function(url,temp = "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.xls", remove_temporary = T){
        
        
        h <- new_handle()
        handle_setopt(h, ssl_verifypeer = F)
        curl_download(url, temp, handle = h)
        
        wcs <- read_excel(temp, sheet = 1)
        
        if(remove_temporary){
                file.remove(temp)
        }
        
        wcs
}






wcs_push_dataset <- function(dataset,remote_file,string_cutoff = 180){
        
        
        # write file to temporary dir
        tempfile <- "k:/dept/DIGITAL E-COMMERCE/E-COMMERCE/Report E-Commerce/data_lake/temp/temp.csv"
        dataset %>%
                write.csv2(file = tempfile, na = "", row.names = F, dec = ",")
        upload_file <- upload_file(tempfile)
        
        
        #upload
        put_url <- paste0("https://pradadigitaldatalake.azuredatalakestore.net/webhdfs/v1/",remote_file,"?op=CREATE&overwrite=true&write=true")
        r <- httr::PUT(put_url,
                       body = upload_file,
                       add_headers(Authorization = paste0("Bearer ",res$access_token),
                                   "Transfer-Encoding" = "chunked"), progress())
        r$status_code
        r <- file.remove(tempfile)
        
        
}
