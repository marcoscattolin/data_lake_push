
read_posts_social <- function(file){
        if(str_detect(file, paste0(local_folder,"FB"))){
                #colnames
                cols <- list("Date",
                          "Page_Name",
                          "URL",
                          "Page_Id",
                          "Type",
                          "Post_Id",
                          "Title",
                          "Description",
                          "Picture_Url",
                          "Icon_Url",
                          "Caption",
                          "Author_Url",
                          "Author_Id",
                          "Author_Name",
                          "Labels",
                          "Content",
                          "Content_Type",
                          "Content_Link",
                          "View_on_Social",
                          "Created_Timezone",
                          "Interaction_Count",
                          "Number_of_Interactions_per_1000_Fans",
                          "Grade",
                          "Reaction_Count",
                          "Comment_Count",
                          "Share_Count",
                          "Deleted",
                          "Hidden",
                          "Spam",
                          "Published",
                          "Promoted_Post_Detection",
                          "Reactions-Like",
                          "Reactions-Love",
                          "Reactions-Haha",
                          "Reactions-Wow",
                          "Reactions-Sad",
                          "Reactions-Angry",
                          "Reach",
                          "Reach_Paid",
                          "Reach_Organic",
                          "Impressions",
                          "Impressions_Paid",
                          "Impressions_Organic",
                          "Reach_Engagement_Rate",
                          "Engaged_Users",
                          "Negative_Feedback",
                          "Lifetime_Post_Stories",
                          "Total_Likes",
                          "Total_Comments",
                          "Total_Shares",
                          "Post_Consumers",
                          "Post_Clicks",
                          "Photo_Views",
                          "Link_Clicks",
                          "Other_Clicks",
                          "Video_Play",
                          "Insights_Reactions-Like",
                          "Insights_Reactions-Love",
                          "Insights_Reactions-Haha",
                          "Insights_Reactions-Wow",
                          "Insights_Reactions-Sad",
                          "Insights_Reactions-Angry",
                          "Total_Insights_Reactions",
                          "Views",
                          "Views-Auto-played",
                          "Views-Click to Play",
                          "Views-Organic",
                          "Views-Paid",
                          "30-second_Views",
                          "30-second_Views-Auto-played",
                          "30-second_Views-Click-to-Play",
                          "30-second Views-Organic",
                          "30-second Views-Paid",
                          "Avg_Completion")
                #read data
                Posts <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                
                #read colnames
                PreviousHeader_FB <- colnames(Posts)
                save(PreviousHeader_FB, file = paste0(local_folder,"check headers/Previous header FB.rda"))
                
                #process data
                colnames(Posts) <- cols
                Posts <- Posts %>% 
                        mutate(Social_Network = "FB") %>% 
                        select(-starts_with("temp"))
                
        } else if(str_detect(file, paste0(local_folder,"IG"))){
                #colnames
                cols <- c("Date",
                          "Page_Name",
                          "URL",
                          "Page_Id",
                          "Content",
                          "View_on_Social",
                          "Created_Timezone",
                          "Content_Type",
                          "Reactions-Like",
                          "Comment_Count",
                          "Number_of_Interactions_per_1000_Fans",
                          "Labels",
                          "Interaction_Count",
                          "Post_Id",
                          "Picture_Url",
                          "Icon_Url",
                          "temp",
                          "Grade",
                          "Promoted_Post_Detection")
                
                #read data
                Posts <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                
                #read colnames
                PreviousHeader_IG <- colnames(Posts)
                save(PreviousHeader_IG, file = paste0(local_folder,"check headers/Previous header IG.rda"))
                #process data
                colnames(Posts) <- cols
                Posts <- Posts %>% 
                        mutate(Social_Network = "IG") %>% 
                        select(-starts_with("temp"))
                
                
        } else if(str_detect(file, paste0(local_folder,"TW"))){
                #colnames
                cols <- c("Date",
                          "Page_Name",
                          "URL",
                          "Page_Id",
                          "Content",
                          "View_on_Social",
                          "Content_Type",
                          "Created_Timezone",
                          "Reactions-Like",
                          "Comment_Count",
                          "Share_Count",
                          "Number_of_Interactions_per_1000_Fans",
                          "Labels",
                          "Interaction_Count",
                          "Post_Id",
                          "Picture_Url")
                
                #read data
                Posts <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                
                #read colnames
                PreviousHeader_TW <- colnames(Posts)
                save(PreviousHeader_TW, file = paste0(local_folder,"check headers/Previous header TW.rda"))
                
                #process data
                colnames(Posts) <- cols
                Posts <- Posts %>% 
                        mutate(Social_Network = "TW") %>% 
                        select(-starts_with("temp"))
                
        } else {
                #colnames
                cols <- c("Date",
                          "Page_Name",
                          "URL",
                          "Page_Id",
                          "Post_Id",
                          "Title",
                          "Picture_Url",
                          "Labels",
                          "Content",
                          "Content_Type",
                          "View_on_Social",
                          "Created_Timezone",
                          "temp",
                          "Number_of_Interactions_per_1000_Fans",
                          "Reactions-Like",
                          "Reaction-Dislike",
                          "Comment_Count",
                          "Video_Duration",
                          "Views",
                          "Video_View_Time_sec",
                          "temp2")
                
                #read data
                Posts <- read_excel(path = file, sheet = 2,skip = 1,col_names = T)
                
                #read colnames
                PreviousHeader_YT <- colnames(Posts)
                save(PreviousHeader_YT, file = paste0(local_folder,"check headers/Previous header YT.rda"))
                
                #process data
                colnames(Posts) <- cols
                Posts <- Posts %>% 
                        mutate(Social_Network = "YT") %>% 
                        select(-starts_with("temp"))
                
        }
}

col_check <- function(file){
        if(str_detect(file, paste0(local_folder,"FB"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header FB.rda"))
                
                #read new headers
                NewHeader_FB <- colnames(read_excel(path = file, sheet = 2,skip = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_FB) == length(PreviousHeader_FB)){
                        message("FB - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_FB)-length(PreviousHeader_FB))
                        message("FB - There are ",delta," new columns" )
                }
                
                #check removed column
                Removed <- PreviousHeader_FB[!PreviousHeader_FB %in% NewHeader_FB]
                if(length(Removed)==0){
                        message("FB - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("FB - There are ",n," removed columns: ", Removed)
                        RemovedFBcolumn <<- Removed
                }
                
                #check added column
                Added <- NewHeader_FB[!NewHeader_FB %in% PreviousHeader_FB]
                if(length(Added)==0){
                        message("FB - No added column")
                } else {
                        n = as.character(length(Added))
                        message("FB - There are ",n," new columns: ", Added)
                        NewFBcolumn <<- Added
                }
                rm(delta,n,Removed,Added,NewHeader_FB,PreviousHeader_FB)
        } else if(str_detect(file, paste0(local_folder,"IG"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header IG.rda"))
                
                #read new headers
                NewHeader_IG <- colnames(read_excel(path = file, sheet = 2,skip = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_IG) == length(PreviousHeader_IG)){
                        message("IG - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_IG)-length(PreviousHeader_IG))
                        message("IG - There are ",delta," new columns" )
                }
                
                #check removed column
                Removed <- PreviousHeader_IG[!PreviousHeader_IG %in% NewHeader_IG]
                if(length(Removed)==0){
                        message("IG - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("IG - There are ",n," removed columns: ", Removed)
                        RemovedIGcolumn <<- Removed
                }
                
                #check added column
                Added <- NewHeader_IG[!NewHeader_IG %in% PreviousHeader_IG]
                if(length(Added)==0){
                        message("IG - No added column")
                } else {
                        n = as.character(length(Added))
                        message("IG - There are ",n," new columns: ", Added)
                        NewIGcolumn <<- Added
                }
                rm(delta,n,Removed,Added,PreviousHeader_IG,NewHeader_IG)
        }else if(str_detect(file, paste0(local_folder,"TW"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header TW.rda"))
                
                #read new headers
                NewHeader_TW <- colnames(read_excel(path = file, sheet = 2,skip = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_TW) == length(PreviousHeader_TW)){
                        message("TW - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_TW)-length(PreviousHeader_TW))
                        message("TW - There are ",delta," new columns" )
                }
                
                #check removed column
                Removed <- PreviousHeader_TW[!PreviousHeader_TW %in% NewHeader_TW]
                if(length(Removed)==0){
                        message("TW - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("TW - There are ",n," removed columns: ", Removed)
                        RemovedTWcolumn <<- Removed
                }
                
                #check added column
                Added <- NewHeader_TW[!NewHeader_TW %in% PreviousHeader_TW]
                if(length(Added)==0){
                        message("TW - No added column")
                } else {
                        n = as.character(length(Added))
                        message("TW - There are ",n," new columns: ", Added)
                        NewTWcolumn <<- Added
                }
                rm(delta,n,Removed,Added,NewHeader_TW,PreviousHeader_TW)
        }else if(str_detect(file, paste0(local_folder,"YT"))){
                
                #read previuos headers
                load(file = paste0(local_folder,"check headers/Previous header YT.rda"))
                
                #read new headers
                NewHeader_YT <- colnames(read_excel(path = file, sheet = 2,skip = 1,col_names = T))
                
                #check column number
                if(length(NewHeader_YT) == length(PreviousHeader_YT)){
                        message("YT - Number of columns: OK")
                }else{
                        delta = as.character(length(NewHeader_YT)-length(PreviousHeader_YT))
                        message("YT - There are ",delta," new columns" )
                }
                
                #check removed column
                Removed <- PreviousHeader_YT[!PreviousHeader_YT %in% NewHeader_YT]
                if(length(Removed)==0){
                        message("YT - No removed column")
                } else {
                        n = as.character(length(Removed))
                        message("YT - There are ",n," removed columns: ", Removed)
                        RemovedYTcolumn <<- Removed
                }
                
                #check added column
                Added <- NewHeader_YT[!NewHeader_YT %in% PreviousHeader_YT]
                if(length(Added)==0){
                        message("YT - No added column")
                } else {
                        n = as.character(length(Added))
                        message("YT - There are ",n," new columns: ", Added)
                        NewYTcolumn <<- Added
                }
                rm(delta,n,Removed,Added,NewHeader_YT,PreviousHeader_YT)
        }
}

