#Draws data for Remapped players from ACR’s api

library(httr)
library(XML)
library(plyr)

from_date <- Sys.Date()  -1
to_date   <- Sys.Date() - 1

user <-  "<Insert Username here>"
pass <- "<Insert Password here>"


url <- "http://admin.secure.acraffiliates.com/feeds.php"
feed_id <- "<Insert feed ID>"


x_XML <-
  xmlInternalTreeParse(
    GET(url, 
        authenticate(user, pass),
        query=list(`FROM_DATE`=from_date,
                   `TO_DATE`=to_date,
                   `FEED_ID`=feed_id)))

#coolaResult <-
#ldply(xmlToList(x_XML), function(x) { data.frame(x[!names(x)=="PLAYER"]) } )

SOURCE_GROUP  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"SOURCE_GROUP"))
SOURCE_KEY  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"SOURCE_KEY"))
PLAYER_ID  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"PLAYER_ID"))
DISPLAY_INFO  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"DISPLAY_INFO"))
JOIN_DATE  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"JOIN_DATE"))
AFFILIATE_ID  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"AFFILIATE_ID"))
AFFILIATE_NAME  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"AFFILIATE_NAME"))
PLAN_NAME  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"PLAN_NAME"))
SITE_NAME  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"SITE_NAME"))
LANDING_PAGE  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"LANDING_PAGE"))
TRACKING_ID  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"TRACKING_ID"))
MEDIA_ID  <-
  unlist(xpathApply(x_XML, '//PLAYER', xmlGetAttr,"MEDIA_ID")) 

feed_id22 <-cbind(SOURCE_GROUP,SOURCE_KEY,PLAYER_ID,DISPLAY_INFO,JOIN_DATE,AFFILIATE_ID,AFFILIATE_NAME,PLAN_NAME,SITE_NAME,LANDING_PAGE,TRACKING_ID,MEDIA_ID)


feed_id22 <-as.data.frame(feed_id22)

feed_id22$JOIN_DATE <- as.character(feed_id22$JOIN_DATE) 

# Results must be in table format. Save your result to coolaResult:

coolaResult <- feed_id22



# Results must be in table format. Save your result to coolaResult:
#coolaResult <- data

