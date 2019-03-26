# Draws data from Awing's API

library(httr)
library(XML)
library(devtools)
library(jsonlite)
library(plyr)

accessToken <-"<Insert Access Token here>"
awin_url <- "https://api.awin.com/publishers/9999999/transactions/"


#From-to Daterange (For now 1 month, can be changed)
from <- paste0(Sys.Date()-30,"T00:00:00")
to <- paste0(Sys.Date(),"T23:59:59")
timezone <- "UTC"


Awin_Report4<-
  fromJSON(paste0(awin_url,"?accessToken=",accessToken,"&startDate=",from,"&endDate=",to,"&timezone=",timezone))

Awin_Report4 <- flatten(Awin_Report4)

Awin_Report4$oldCommissionAmount.currency <-
  ifelse(length(Awin_Report4$oldCommissionAmount.currency)!=0, Awin_Report4$oldCommissionAmount.currency, NA)

Awin_Report4$oldSaleAmount.currency <-
  ifelse(length(Awin_Report4$oldSaleAmount.currency)!=0, Awin_Report4$oldSaleAmount.currency, NA)





Awin_Report4 <-
  subset(Awin_Report4, select=-c(url,
                                 commissionSharingPublisherId,
                                 saleAmount.currency,
                                 transactionParts,
                                 customParameters,
                                 oldCommissionAmount.currency,
                                 oldSaleAmount.currency))


Awin_Report4 <-
  rename(Awin_Report4, c("commissionAmount.amount"="commission",
                         "saleAmount.amount"="sale",
                         "commissionAmount.currency"="currency",
                         "clickRefs.clickRef"="clickRef",
                         "oldCommissionAmount.amount"="oldCommission",
                         "oldCommissionAmount"="oldCommission",
                         "oldSaleAmount.amount"="oldSale",
                         "oldSaleAmount"="oldSale"))




Awin_Report4$validationDate <-
  ifelse(Awin_Report4$commissionStatus=="pending", paste0("2040-01-01","T00:00:00"), Awin_Report4$validationDate)



Awin_Report <- do.call("rbind",list(Awin_Report4))

coolaResult <- Awin_Report
