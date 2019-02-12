#Draws statistics from Taboola's API

library(httr)
library(devtools)
library(plyr)
library(jsonlite)
library(readr)
Sys.setlocale("LC_ALL", "hebrew")

# Params

taboola_token_url <-"https://backstage.taboola.com/backstage/oauth/token"
client_id <- "<Insert Client ID here>"
client_secret <-"<Insert Client Secret here>"
grant_type <- "client_credentials"

## Access Token

response <- POST(url = paste0(taboola_token_url,"?client_id=",client_id,"&client_secret=",client_secret,"&grant_type=",grant_type), 
                 content_type("application/x-www-form-urlencoded"))
token_dailies<-
  fromJSON(content(response, "text"))

access_token <- token_dailies$access_token
token_type <- token_dailies$token_type

access_token

token_type

#Campaign Report

taboola_reports_url <- "https://backstage.taboola.com/backstage/api/1.0/"
account_name <- "YOUR ACCOUNT HERE"
campaidn_name <-"campaidn_name"
dimension_id <-"dimension_id"


from_date <- Sys.Date()-1
to_date <- Sys.Date()-0


#Advertiser

#Tabolla advertiser Reports (campaign-summary,top-campaign-content)


#Tabolla Publisher Reports (revenue-summary,visit-value)
full_taboola_reports_url <-
  paste0(taboola_reports_url,
         account_name,
         "/reports/",
         campaidn_name,
         "/dimensions/",
         dimension_id)



taboola_visit_value_report <-
  content(
    GET(full_taboola_reports_url,add_headers(Authorization=paste0(token_type ,access_token)),
        query=list(`start_date`=from_date,
                   `end_date`=from_date)))


taboola_visit_value_report <-taboola_visit_value_report[["results"]]

taboola_visit_value_report<-data.frame(do.call(rbind,taboola_visit_value_report))

taboola_visit_value_report <- data.frame(lapply(taboola_visit_value_report, as.character), stringsAsFactors=FALSE)



date = c(Sys.Date()-0)
date = format(date, "%Y-%m-%d")
taboola_visit_value_report$date=date												   

taboola_visit_value_report <- as.data.frame(sapply(taboola_visit_value_report, function(x) gsub("\"", "", x)))											   
# Results must be in table format. Save your result to coolaResult:
coolaResult <- taboola_visit_value_report
