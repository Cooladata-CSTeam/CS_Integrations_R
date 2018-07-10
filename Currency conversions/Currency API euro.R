#returns for each time interval the conversion rate between the Euro and each given currency in the query

library(stringr)
library(reshape)
library(quantmod)

a<-c("AED","AUD","BGN","BOB","BRL","CAD","CHF","CLP","COP","CRC","CZK","DKK","EGP","EUR","GBP",
     "GHS","HKD","HRK","HUF","IDR","ILS","INR","JPY","KES","KRW","KZT","LBP","LKR","MAD","MXN",
     "MYR","NGN","NOK","NZD","PEN","PHP","PKR","PLN","QAR","RON","RUB","SAR","SEK","SGD","THB",
     "TRY","TWD","TZS","UAH","USD","VND","ZAR")

from <- Sys.Date()-3
to <- Sys.Date()

tbl<-0
for (i in 1:length(a))
{
  tmp<-getFX(paste("EUR/",a[i],sep = ""),
             from=from,
             to=to,
             auto.assign=FALSE)
  colnames(tmp)<-gsub("EUR.","",colnames(tmp))
  ifelse(is.null(dim(tbl)),tbl<-tmp,tbl<-merge(tbl,tmp))
}
currency_euro<-data.frame(date=index(tbl), coredata(tbl))
currency_euro_flat <- melt(currency_euro,id = c("date"))

# Results must be in table format. Save your result to coolaResult:
#coolaExtraTables[["flat"]] = currency_euro_flat

coolaResult <- currency_euro