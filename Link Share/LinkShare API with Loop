library(httr)
library(XML)
library(devtools)
library(dplyr)
library(plyr)

             

LS_Token <- "<YOUR TOKEN HERE>"

url_signature_orders_report <- "https://reporting.marketing.com/en/reports/transactions-report/filters?include_summary=Y&tz=GMT&date_type=transaction"



#site: 1=US,3=UK,5=CA,7=FR,9=DE,41=AU
#affiliate_id: 1=LinkShare



# US=USD,UK=GBP,CA=CAD,FR=EUR,DE=EUR,AU=AUD
from <- Sys.Date()-120
to <- Sys.Date()-1

site <- c("1","3","5","7","9","41")


for (i in site){
  assign(paste0('LinkShare_Report',i),
         read.csv(text=rawToChar(
           GET(url_signature_orders_report,
               query=list(token=LS_Token,
                          start_date=from,
                          end_date=to,
                          network=i))
           [["content"]]),skip = 4, header = TRUE, sep =',')
  )
}



LinkShare_Purchase_report <- do.call("rbind",list(LinkShare_Report1,LinkShare_Report3,LinkShare_Report5,LinkShare_Report7,LinkShare_Report9,LinkShare_Report41))

LinkShare_Purchase_report$Transaction.Date <- as.Date(LinkShare_Purchase_report$Transaction.Date,format="%m/%d/%y")
LinkShare_Purchase_report$Transaction_Date <- as.POSIXct(paste(LinkShare_Purchase_report$Transaction.Date, LinkShare_Purchase_report$Transaction.Time), format="%Y-%m-%d %H:%M:%S")

LinkShare_Purchase_report$Process.Date <- as.Date(LinkShare_Purchase_report$Process.Date,format="%m/%d/%y")
LinkShare_Purchase_report$Process_Date <- as.POSIXct(paste(LinkShare_Purchase_report$Process.Date, LinkShare_Purchase_report$Process.Time), format="%Y-%m-%d %H:%M:%S")


LinkShare_Purchase_report <- plyr::rename(LinkShare_Purchase_report,c("Member.ID..U1."="sid",
                                                              "Order.ID"="order_id",
                                                              "MID"="advertiser_id",
                                                              "Advertiser.Name"="advertiser_name",
                                                              "Sales"="sale_amount",
                                                              "Total.Commission"="commission_amount",
                                                              "Currency"="currency",
                                                              "Adjusted.Commission"="adjusted_commission",
                                                              "Transaction.ID"="transaction_id",
                                                              "Consumer.City"="purchase_city",
                                                              "Consumer.Region"="purchase_region",
                                                              "Consumer.Country"="purchase_country",
                                                              "Offer.Name"="offer_name",
                                                              "Offer.Group.ID"="offer_group_id",
                                                              "SKU"="product_id",
                                                              "Product.Name"="product_name"))
                                                              
LinkShare_Purchase_report <- LinkShare_Purchase_report[,c("sid",
                                                          "order_id",
                                                          "advertiser_id",
                                                          "advertiser_name",
                                                          "sale_amount",
                                                          "commission_amount",
                                                          "currency",
                                                          "adjusted_commission",
                                                          "transaction_id",
                                                          "purchase_city",
                                                          "purchase_region",
                                                          "purchase_country",
                                                          "offer_name",
                                                          "offer_group_id",
                                                          "product_id",
                                                          "product_name",
                                                          "Transaction_Date",
                                                          "Process_Date")]                                                              


