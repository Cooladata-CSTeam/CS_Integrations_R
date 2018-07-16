# Draws Approval data from Awing's API

library(httr)
library(XML)
library(devtools)
library(jsonlite)
library(plyr)

accessToken <-"<Insert Access Token here>"
awin_url <- "https://api.awin.com/publishers/311113/transactions/"

# 4 months ago
from <- paste0(Sys.Date()-120,"T00:00:00")
to <- paste0(Sys.Date()-91,"T23:59:59")
timezone <- "UTC"


Awin_Report1<-
  fromJSON(paste0(awin_url,"?accessToken=",accessToken,"&startDate=",from,"&endDate=",to,"&timezone=",timezone))

Awin_Report1 <- flatten(Awin_Report1)

Awin_Report1 <-
  subset(Awin_Report1, select=-c(url,
                                 commissionSharingPublisherId,
                                 saleAmount.currency,
                                 transactionParts,
                                 customParameters,
                                 oldCommissionAmount.currency,
                                 oldSaleAmount.currency))


Awin_Report1 <-
  rename(Awin_Report1, c("commissionAmount.amount"="commission",
                         "saleAmount.amount"="sale",
                         "commissionAmount.currency"="currency",
                         "clickRefs.clickRef"="clickRef",
                         "oldCommissionAmount.amount"="oldCommission",
                         "oldSaleAmount.amount"="oldSale"))

Awin_Report1$validationDate <-
  ifelse(Awin_Report1$commissionStatus=="pending", paste0("2040-01-01","T00:00:00"), Awin_Report1$validationDate)


#From-to Daterange (For now 3 months, can be changed)
from <- paste0(Sys.Date()-90,"T00:00:00")
to <- paste0(Sys.Date()-61,"T23:59:59")
timezone <- "UTC"


Awin_Report2<-
  fromJSON(paste0(awin_url,"?accessToken=",accessToken,"&startDate=",from,"&endDate=",to,"&timezone=",timezone))

Awin_Report2 <- flatten(Awin_Report2)

Awin_Report2 <-
  subset(Awin_Report2, select=-c(url,
                                 commissionSharingPublisherId,
                                 saleAmount.currency,
                                 transactionParts,
                                 customParameters,
                                 oldCommissionAmount.currency,
                                 oldSaleAmount.currency))


Awin_Report2 <-
  rename(Awin_Report2, c("commissionAmount.amount"="commission",
                         "saleAmount.amount"="sale",
                         "commissionAmount.currency"="currency",
                         "clickRefs.clickRef"="clickRef",
                         "oldCommissionAmount.amount"="oldCommission",
                         "oldSaleAmount.amount"="oldSale"))

Awin_Report2$validationDate <-
  ifelse(Awin_Report2$commissionStatus=="pending", paste0("2040-01-01","T00:00:00"), Awin_Report2$validationDate)


#From-to Daterange (For now 2 month, can be changed)
from <- paste0(Sys.Date()-60,"T00:00:00")
to <- paste0(Sys.Date()-31,"T23:59:59")
timezone <- "UTC"


Awin_Report3<-
  fromJSON(paste0(awin_url,"?accessToken=",accessToken,"&startDate=",from,"&endDate=",to,"&timezone=",timezone))

Awin_Report3 <- flatten(Awin_Report3)

Awin_Report3 <-
  subset(Awin_Report3, select=-c(url,
                                 commissionSharingPublisherId,
                                 saleAmount.currency,
                                 transactionParts,
                                 customParameters,
                                 oldCommissionAmount.currency,
                                 oldSaleAmount.currency))


Awin_Report3 <-
  rename(Awin_Report3, c("commissionAmount.amount"="commission",
                         "saleAmount.amount"="sale",
                         "commissionAmount.currency"="currency",
                         "clickRefs.clickRef"="clickRef",
                         "oldCommissionAmount.amount"="oldCommission",
                         "oldSaleAmount.amount"="oldSale"))

Awin_Report3$validationDate <-
  ifelse(Awin_Report3$commissionStatus=="pending", paste0("2040-01-01","T00:00:00"), Awin_Report3$validationDate)





Awin_Report <- do.call("rbind",list(Awin_Report3,Awin_Report2,Awin_Report1))

coolaResult <- Awin_Report
