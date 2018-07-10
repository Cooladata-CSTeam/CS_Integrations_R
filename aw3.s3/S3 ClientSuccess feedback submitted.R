#Insert a basic query to be exported to the AWS here.

#Writes the data from the query to the Amazon Web Service at a specific file

library(aws.s3)
library(devtools)
library(parsedate)

colnames(data) <-c("<Insert column names here>")

data$event.time <- format_iso_8601(data$event.time)

data[data == "NA"] <- ""


AWS_ACCESS_KEY_ID = "<Insert AWS access key ID>"
AWS_SECRET_ACCESS_KEY = "<Insert AWS Secret access key>"
bucket = '<Insert bucket name>'


Sys.setenv(AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID,
           AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY,
           AWS_DEFAULT_REGION = "us-east-1")


write.csv(data,file="<Insert file name here>",row.names=FALSE,na="")



put_object(file="<Insert file name here>",
           bucket = bucket, object = paste0("<Insert file name here>",format(Sys.Date(),"%Y%m%d")))


coolaResult <- data



