library(httr)
library(XML)
library(devtools)


commission_junction_token <-"<YOUR TOKEN HERE>"

commission_junction_url <-"https://commission-detail.api.cj.com/v3/commissions"


#xml   <- xmlInternalTreeParse(GET(add_headers(Authorization=commission_junction_token),url=commission_junction_url))

# 4 months 
from <- Sys.Date()-1
to <- Sys.Date() -0
date_type <- "posting"


Commission_Junction_XML <-
  xmlInternalTreeParse(
    GET(commission_junction_url,add_headers(Authorization=commission_junction_token),
        query=list(`start-date`=from,
                   `end-date`=to,
                   `date-type`=date_type)))


Commission_Junction_Report1 <-xmlToDataFrame(nodes=getNodeSet(Commission_Junction_XML,"//commission"))
names(Commission_Junction_Report1) <- gsub("-", "_", names(Commission_Junction_Report1))

# 3 months

from <- Sys.Date()-90
to <- Sys.Date() -60


Commission_Junction_XML <-
  xmlInternalTreeParse(
    GET(commission_junction_url,add_headers(Authorization=commission_junction_token),
        query=list(`start-date`=from,
                   `end-date`=to,
                   `date-type`=date_type)))


Commission_Junction_Report2 <-xmlToDataFrame(nodes=getNodeSet(Commission_Junction_XML,"//commission"))
names(Commission_Junction_Report2) <- gsub("-", "_", names(Commission_Junction_Report2))


# 2 months

from <- Sys.Date()-60
to <- Sys.Date() -30


Commission_Junction_XML <-
  xmlInternalTreeParse(
    GET(commission_junction_url,add_headers(Authorization=commission_junction_token),
        query=list(`start-date`=from,
                   `end-date`=to,
                   `date-type`=date_type)))


Commission_Junction_Report3 <-xmlToDataFrame(nodes=getNodeSet(Commission_Junction_XML,"//commission"))
names(Commission_Junction_Report3) <- gsub("-", "_", names(Commission_Junction_Report3))

# current months

from <- Sys.Date()-30
to <- Sys.Date() -0


Commission_Junction_XML <-
  xmlInternalTreeParse(
    GET(commission_junction_url,add_headers(Authorization=commission_junction_token),
        query=list(`start-date`=from,
                   `end-date`=to,
                   `date-type`=date_type)))


Commission_Junction_Report4 <-xmlToDataFrame(nodes=getNodeSet(Commission_Junction_XML,"//commission"))
names(Commission_Junction_Report4) <- gsub("-", "_", names(Commission_Junction_Report4))


CJ_Report <- do.call("rbind",list(Commission_Junction_Report1,Commission_Junction_Report2,Commission_Junction_Report3,Commission_Junction_Report4))


###############  Comment   #######################

# Convert timedate to epox
Commission_Junction_Report$`event-date` <-as.integer( as.POSIXct(Commission_Junction_Report$`event-date`))
Commission_Junction_Report$`posting-date` <-as.integer( as.POSIXct(Commission_Junction_Report$`posting-date`))
Commission_Junction_Report$`locking-date` <-as.integer( as.POSIXct(Commission_Junction_Report$`locking-date`))




# fi website

if (Commission_Junction_Report$`website-id`=="7991782")
{Commission_Junction_Report$`website-id` <-"5"
}else if (Commission_Junction_Report$`website-id`=="7991783")
{Commission_Junction_Report$`website-id` <-"6"   
} else if (Commission_Junction_Report$`website-id`=="7991787")
{Commission_Junction_Report$`website-id`<-"7"   
}  

Commission_Junction_Report$`action-status` <-paste(Commission_Junction_Report$`action-status`,Commission_Junction_Report$`action-type`,sep='-')





# Adding Columns
Commission_Junction_Report["affiliate_id"] <-"3" 
Commission_Junction_Report["affiliate"] <-"CommissionJunction"
Commission_Junction_Report["items"] <-"1"

# Reordering fields
Commission_Junction_Report <-Commission_Junction_Report[c(6,19,21,22,12,16,5,23,20,17,11,8,3,10,1,13)]



S3_connect("<USER>","<PASSWORD>")

#Create buchet
#S3_create_bucket("af-affiliate-purchase")


# Create txt file quote null sep =tab
write.table(Commission_Junction_Report, file = "Commission_Junction_Purchase_Report.txt",quote = FALSE,row.names=FALSE,sep="\t")

# Uploasd the file to S3 ,adding date to the filename
S3_put_object("af-affiliate-purchase",paste("Purchase",format(from,"%Y/%m/%d"),"Commission_Junction_Purchase_Report",sep="/"),"Commission_Junction_Purchase_Report.txt","txt")