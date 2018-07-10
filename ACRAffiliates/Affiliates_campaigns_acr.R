#Draws Affiliate data from ACR’s api

library(httr)
library(XML)
library(plyr)

from_date <- Sys.Date()-120 
to_date   <- Sys.Date() - 1

user <-  "<Insert Username here>"
pass <- "<Insert Password here>"


url <- "http://admin.secure.acraffiliates.com/feeds.php"
feed_id <- "<Insert feed ID>"


x_XMLL <-
  xmlInternalTreeParse(
    GET(url, 
        authenticate(user, pass),
        query=list(`CREATED_DATE_FROM`=from_date,
                   `CREATED_DATE_TO`=to_date,
                   `FEED_ID`=feed_id)))



USER_ID  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"USER_ID"))

USERNAME  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"USERNAME"))

CAMPAIGN_ID  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"CAMPAIGN_ID"))

DESCRIPTION  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"DESCRIPTION"))

DATE_CREATED  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"DATE_CREATED"))

DATE_MODIFIED  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"DATE_MODIFIED"))

SPEND  <-
  unlist(xpathApply(x_XMLL, '//CAMPAIGN', xmlGetAttr,"SPEND"))


feed_id17 <-cbind(USER_ID,USERNAME,CAMPAIGN_ID,DESCRIPTION,DATE_CREATED,DATE_MODIFIED,SPEND)


feed_id17 <-as.data.frame(feed_id17)

feed_id17$DATE_CREATED <- as.character(feed_id17$DATE_CREATED)
feed_id17$DATE_MODIFIED <- as.character(feed_id17$DATE_MODIFIED)

# Results must be in table format. Save your result to coolaResult:

coolaResult <- feed_id17

