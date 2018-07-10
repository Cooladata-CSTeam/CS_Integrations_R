#returns for each time interval the conversion rate between the Shekel and each given currency in the query

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
  tmp<-getFX(paste("ILS/",a[i],sep = ""),
             from=from,
             to=to,
             auto.assign=FALSE)
  colnames(tmp)<-gsub("ILS.","",colnames(tmp))
  ifelse(is.null(dim(tbl)),tbl<-tmp,tbl<-merge(tbl,tmp))
}
currency_ron<-data.frame(date=index(tbl), coredata(tbl))
currency_ron <- melt(currency_ron,id = c("date"))

colnames(currency_ron) <- c("date","currency","rate")

# Results must be in table format. Save your result to coolaResult:
#coolaExtraTables[["flat"]] = currency_ron_flat

coolaResult <- currency_ron