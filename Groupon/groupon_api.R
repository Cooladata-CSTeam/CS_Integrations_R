#draws data from Groupon's API

library(httr)
library(XML)
library(devtools)
library(jsonlite)
library(plyr)
library(parsedate)


accessToken <-"<Insert access token>"
groupon_url <- "https://partner-int-api.groupon.com/reporting/v2/order.csv"

#from-to-date timerange
from_date <- Sys.Date()-20
to_date <- Sys.Date()-1

date_string <-paste0('[',from_date,"&date=",to_date,"]")
report_type <-"deal|date|order|Platform"
currency<-"GBP"

groupon_report<-
  read.csv(paste0(groupon_url,"?clientId=",accessToken,
                  "&date=",date_string,
                  "&group=",report_type,
                  "&campaign.currency=",currency))



groupon_report <- plyr::rename(groupon_report,c("Date.Datetime"="event_time_ts",
                                                "Order.BillingId"="billing_id",
                                                "Order.Sid"="sid",
                                                "Order.Wid"="wid",
                                                "Order.Country"="country",
                                                "Order.Currency"="currency",
                                                "Order.Status"="status",
                                                "Order.CustomerStatus"="customer_status",
                                                "Order.DealListName"="deal_list_name",
                                                "Platform.Platform"="platform",
                                                "SaleGrossAmount"="sale_amount",
                                                "SaleCount"="orders",
                                                "NumberOfUnits"="number_of_units",
                                                "LedgerAmount"="commission_amount",
                                                "LedgerCredit"="orig_commission_amount",
                                                "LedgerDebit"="refund_amount",
                                                "LedgerCount"="ledger_count"
))


groupon_report<-
  groupon_report[c("event_time_ts",
                   "billing_id",
                   "sid",
                   "wid",
                   "country",
                   "currency",
                   "status",
                   "customer_status",
                   "deal_list_name",
                   "platform",
                   "sale_amount",
                   "orders",
                   "number_of_units",
                   "commission_amount",
                   "orig_commission_amount",
                   "refund_amount"
  )]

groupon_report$event_time_ts<- format_iso_8601(parse_iso_8601(groupon_report$event_time_ts))
# Results must be in table format. Save your result to coolaResult:
coolaResult <- groupon_report