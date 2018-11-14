
read_posts_social <- function(file){
        if(str_detect(file, paste0(local_folder,"FB"))){
                #read data
                Posts <- read_excel(path = file, sheet = 1,col_names = T)
                
                #read colnames
                PreviousHeader_FB <- colnames(Posts)
                save(PreviousHeader_FB, file = paste0(local_folder,"check headers/Previous header FB.rda"))
                
                #process data
                cols <- PreviousHeader_FB
                cols <- str_replace_all(cols," \\[\\%\\]", "")
                cols <- str_replace_all(cols," ","_")
                cols <- str_trim(cols,side = "both")
                cols <- str_replace_all(cols,"Facebook|facebook", "Social")
                cols <- str_replace_all(cols,"-","")
                cols <- str_replace_all(cols,"\\.","")
                colnames(Posts) <- cols
                Posts <- Posts %>% 
                        mutate(Social_Network = "FB") %>% 
                        select(-starts_with("temp")) 
                
                #rename modified column
                if("Total_View_Time_(sec)" %in% colnames(Posts)){
                Posts <- Posts %>% 
                        rename(Video_View_Time_sec = `Total_View_Time_(sec)`,
                               Crossposted = Crosspost)
                }
                
                Posts <- Posts %>%
                        mutate_if(is.character, ~ gsub(pattern = "\n|\r\n|\r",replacement = " ",x = .))      

        } else if(str_detect(file, paste0(local_folder,"IG"))){
                
                #read data
                Posts <- read_excel(path = file, sheet = 1,col_names = T)
                
                #read colnames
                PreviousHeader_IG <- colnames(Posts)
                save(PreviousHeader_IG, file = paste0(local_folder,"check headers/Previous header IG.rda"))
                
                #process data
                Posts <- Posts %>%
                        mutate(`Total Interactions` = case_when(is.na(`Total Interactions`)~`Organic Interactions`,
                                                                T ~ `Total Interactions`),
                               `Number of Total Interactions per 1000 Followers` = case_when(is.na(`Number of Total Interactions per 1000 Followers`)~`Number of Interactions per 1000 Followers`,
                                                                                             T ~ `Number of Total Interactions per 1000 Followers`)) %>% 
                        rename(Date = Date,
                               Page_Name = `Profile Name`,
                               URL = URL,
                               Page_Id = `Profile Id`,
                               Content = Content,
                               Created_Timezone = `Created Timezone`,
                               Content_Type = `Content Type`,
                               View_on_Social = `View on Instagram`,
                               Reactions__Like  = `Total Likes`,
                               Comment_Count = `Total Comments`,
                               Number_of_Interactions_per_1000_Fans = `Number of Total Interactions per 1000 Followers`,
                               Labels = Labels,
                               Interaction_Count = `Total Interactions`,
                               Picture_Url = `Media Url`,
                               Post_Id = Id,
                               Views = `Video Views`,
                               temp2 = Saves,
                               Engaged_Users = Engagement)
                
                Posts <- Posts %>% 
                        mutate(Social_Network = "IG") %>% 
                        select(-starts_with("temp"))
                Posts <- Posts %>%
                        mutate_if(is.character, ~ gsub(pattern = "\n|\r\n|\r",replacement = " ",x = .))

                
        } else if(str_detect(file, paste0(local_folder,"TW"))){
                
                #read data
                Posts <- read_excel(path = file, sheet = 1,col_names = T)
                
                #read colnames
                PreviousHeader_TW <- colnames(Posts)
                save(PreviousHeader_TW, file = paste0(local_folder,"check headers/Previous header TW.rda"))
                
                #process data
                Posts <- Posts %>%
                        rename(Date = Date,
                               Page_Name = `Profile Name`,
                               URL = URL,
                               Page_Id = `Profile Id`,
                               Content = Content,
                               View_on_Social = `View on Twitter`,
                               Content_Type = `Content Type`,
                               Created_Timezone = `Created Timezone`,
                               Reactions__Like = Likes,
                               Comment_Count = Replies,
                               Share_Count = Retweets,
                               Number_of_Interactions_per_1000_Fans = `Number of Interactions per 1000 Followers`,
                               Labels = Labels,
                               Interaction_Count = `Interaction Count`,
                               Post_Id = Id,
                               Picture_Url = `Picture Url`)
                
                Posts <- Posts %>% 
                        mutate(Social_Network = "TW") %>% 
                        select(-starts_with("temp"))
                
                Posts <- Posts %>%
                        mutate_if(is.character, ~ gsub(pattern = "\n|\r\n|\r",replacement = " ",x = .))
        
                
        } else {
                
                #read data
                Posts <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                
                #read colnames
                PreviousHeader_YT <- colnames(Posts)
                save(PreviousHeader_YT, file = paste0(local_folder,"check headers/Previous header YT.rda"))
                PreviousHeader_YT
                #process data
                Posts <- Posts %>%
                        rename(Date = Date,
                               Page_Name = `Channel Name`,
                               URL = URL,
                               Page_Id = `Channel Id`,
                               Post_Id = `Video Id`,
                               Title = Title,
                               Picture_Url = `Picture Url`,
                               Labels = Labels,
                               Content = Content,
                               Content_Type = `Content Type`,
                               View_on_Social = `View on YouTube`,
                               Created_Timezone = `Created Timezone`,
                               temp = Recorded,
                               Number_of_Interactions_per_1000_Fans = `Number of Interactions per 1000 Subscribers`,
                               Reactions__Like = `Like Count`,
                               Reactions__Dislike = `Dislike Count`,
                               Comment_Count = `Comment Count`,
                               Video_Duration = Duration,
                               Views = `View Count`,
                               Video_View_Time_sec = `Video View Time (sec)`,
                               temp2 = `Video View Time`)
                
                Posts <- Posts %>% 
                        mutate(Social_Network = "YT") %>% 
                        select(-starts_with("temp"))
                
                Posts <- Posts %>%
                        mutate_if(is.character, ~ gsub(pattern = "\n|\r\n|\r",replacement = " ",x = .))
                
                
        }
}



col_check <- function(file){
        if(str_detect(file, paste0(local_folder,"FB"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header FB.rda"))
                
                #read new headers
                NewHeader_FB <- colnames(read_excel(path = file, sheet = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_FB) == length(PreviousHeader_FB)){
                        message("FB - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_FB)-length(PreviousHeader_FB))
                        message("FB - There are ",delta," new columns" )
                        rm(delta)
                }
                
                #check removed column
                Removed <- PreviousHeader_FB[!PreviousHeader_FB %in% NewHeader_FB]
                if(length(Removed)==0){
                        message("FB - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("FB - There are ",n," removed columns: ", Removed)
                        RemovedFBcolumn <<- Removed
                        rm(n)
                }
                
                #check added column
                Added <- NewHeader_FB[!NewHeader_FB %in% PreviousHeader_FB]
                if(length(Added)==0){
                        message("FB - No added column")
                } else {
                        n = as.character(length(Added))
                        message("FB - There are ",n," new columns: ", Added)
                        NewFBcolumn <<- Added
                        rm(n)
                }
                rm(Removed,Added,NewHeader_FB,PreviousHeader_FB)
        } else if(str_detect(file, paste0(local_folder,"IG"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header IG.rda"))
                
                #read new headers
                NewHeader_IG <- colnames(read_excel(path = file, sheet = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_IG) == length(PreviousHeader_IG)){
                        message("IG - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_IG)-length(PreviousHeader_IG))
                        message("IG - There are ",delta," new columns" )
                        rm(delta)
                }
                
                #check removed column
                Removed <- PreviousHeader_IG[!PreviousHeader_IG %in% NewHeader_IG]
                if(length(Removed)==0){
                        message("IG - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("IG - There are ",n," removed columns: ", Removed)
                        RemovedIGcolumn <<- Removed
                        rm(n)
                }
                
                #check added column
                Added <- NewHeader_IG[!NewHeader_IG %in% PreviousHeader_IG]
                if(length(Added)==0){
                        message("IG - No added column")
                } else {
                        n = as.character(length(Added))
                        message("IG - There are ",n," new columns: ", Added)
                        NewIGcolumn <<- Added
                        rm(n)
                }
                rm(Removed,Added,PreviousHeader_IG,NewHeader_IG)
        }else if(str_detect(file, paste0(local_folder,"TW"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header TW.rda"))
                
                #read new headers
                NewHeader_TW <- colnames(read_excel(path = file, sheet = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_TW) == length(PreviousHeader_TW)){
                        message("TW - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_TW)-length(PreviousHeader_TW))
                        message("TW - There are ",delta," new columns" )
                        rm(delta)
                }
                
                #check removed column
                Removed <- PreviousHeader_TW[!PreviousHeader_TW %in% NewHeader_TW]
                if(length(Removed)==0){
                        message("TW - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("TW - There are ",n," removed columns: ", Removed)
                        RemovedTWcolumn <<- Removed
                        rm(n)
                }
                
                #check added column
                Added <- NewHeader_TW[!NewHeader_TW %in% PreviousHeader_TW]
                if(length(Added)==0){
                        message("TW - No added column")
                } else {
                        n = as.character(length(Added))
                        message("TW - There are ",n," new columns: ", Added)
                        NewTWcolumn <<- Added
                        rm(n)
                }
                rm(Removed,Added,NewHeader_TW,PreviousHeader_TW)
        } else {
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header YT.rda"))
                
                #read new headers
                NewHeader_YT <- colnames(read_excel(path = file, sheet = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_YT) == length(PreviousHeader_YT)){
                        message("YT - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_YT)-length(PreviousHeader_YT))
                        message("YT - There are ",delta," new columns" )
                        rm(delta)
                }
                
                #check removed column
                Removed <- PreviousHeader_YT[!PreviousHeader_YT %in% NewHeader_YT]
                if(length(Removed)==0){
                        message("YT - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("YT - There are ",n," removed columns: ", Removed)
                        RemovedYTcolumn <<- Removed
                        rm(n)
                }
                
                #check added column
                Added <- NewHeader_YT[!NewHeader_YT %in% PreviousHeader_YT]
                if(length(Added)==0){
                        message("YT - No added column")
                } else {
                        n = as.character(length(Added))
                        message("YT - There are ",n," new columns: ", Added)
                        NewYTcolumn <<- Added
                        rm(n)
                }
                rm(Removed,Added,NewHeader_YT,PreviousHeader_YT)
        }
}

stop_function <- function(){
        if(exists("NewFBcolumn") | 
           exists("NewIGcolumn") | 
           exists("NewTWcolumn") |
           exists("NewYTcolumn") |
           exists("RemovedFBcolumn") |
           exists("RemovedIGcolumn") |
           exists("RemovedTWcolumn") |
           exists("RemovedYTcolumn")){
                input <- menu(c("Yes", "No"), title = "Have you updated column names?")
                if(input != 1){
                        stop("Columns must be updated!")
                }
        }
}


read_fans_social <- function(file){
        if(str_detect(file, paste0(local_folder,"FB"))){
                #read data
                if("Fans" %in% colnames(read_excel(path = file, sheet = 4, skip = 1, col_names = T))){
                        Fans <- read_excel(path = file, sheet = 4,skip = 1,col_names = T)
                        Fans <- Fans %>% 
                                mutate(Page = str_trim(str_replace(Page,"Global Statistics",""),side = "both"),
                                       Social_Network = "FB")
                } else{
                     Fans <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                     Fans <- Fans %>% 
                             mutate(Social_Network = "FB")
                }
                
        } else if(str_detect(file, paste0(local_folder,"IG"))){
                #read data
                Fans <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                Fans <- Fans %>%
                        rename(Fans = Followers,
                               Page = Profile) %>% 
                        mutate(Social_Network = "IG")
        } else if(str_detect(file, paste0(local_folder,"TW"))){
                #read data
                Fans <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                Fans <- Fans %>%
                        rename(Fans = Followers,
                               Page = Profile) %>% 
                        mutate(Social_Network = "TW")
        } else {
                #read data
                Fans <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                
                Fans <- Fans %>%
                        rename(Fans = Subscribers,
                               Page = Channel) %>% 
                        mutate(Social_Network = "YT")
        }
}
