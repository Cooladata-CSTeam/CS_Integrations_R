#Draws data from Appflyer's API		

library(httr)
library(devtools)
library(plyr)

accessToken <-"<Insert access token here>"

#From-to Daterange (for now 2 days back, can be changed)
from_date <- Sys.Date()-2
to_date <- Sys.Date()+1

## installs reports Android

appsflyer_url <- "https://hq.appsflyer.com/export/x.y.z.app/installs_report/v5"

appsflyer_report_android<-
  read.csv(paste0(appsflyer_url,"?api_token=",accessToken,
                  "&from=",from_date,
                  "&to=",to_date))


## install reports iOS

appsflyer_url <- "https://hq.appsflyer.com/export/id99999999/installs_report/v5"


appsflyer_report_ios<-
  read.csv(paste0(appsflyer_url,"?api_token=",accessToken,
                  "&from=",from_date,
                  "&to=",to_date))




appsflyer_report <-rbind(appsflyer_report_ios,appsflyer_report_android)


names(appsflyer_report) <- gsub(x = names(appsflyer_report),
                                pattern = "\\.",
                                replacement = "_")

appsflyer_report$OS_Version <- as.character(appsflyer_report$OS_Version) 
# Results must be in table format. Save your result to coolaResult:
coolaResult <- appsflyer_report
