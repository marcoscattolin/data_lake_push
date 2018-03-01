
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
                
                #process data
                colnames(Posts) <- cols
                Posts <- Posts %>% 
                        mutate(Social_Network = "YT") %>% 
                        select(-starts_with("temp"))
                
        }
}

