# The following libraries are always installed: ggplot2, plyr, reshape2, RColorBrewer, scales,grid, wesanderson, RJDBC, devtools, corrplot, testthat
library(googleCloudStorageR)
library(googleAuthR)
library(rjson)

#install.packages("googleAuthR")

service_account_paz<-
  data.frame("type"= "service_account",
             "project_id"= "YOUR PROJECT ID HERE",
             "private_key_id"= "YOUR PRIVATE KEY HERE",
             "private_key"= " YOUR KEY HERE",
             "client_email"= "YOUR CLIENT EMAIL HERE",
             "client_id"= "YOUR CLIENT ID HERE",
             "auth_uri"= "https://accounts.google.com/o/oauth2/auth",
             "token_uri"= "https://oauth2.googleapis.com/token",
             "auth_provider_x509_cert_url"= "https://www.googleapis.com/oauth2/v1/certs",
             "client_x509_cert_url"= "YOUR URL HERE"
  )

exportJSON<-toJSON(service_account_paz)
write(exportJSON, "/tmp/service_account.json")
print(data)

googleAuthR::gar_auth_service("/tmp/service_account.json",
                                  scope = "https://www.googleapis.com/auth/cloud-platform")



##### upload file to bucket

project_name <-'YOUR PROJECT NAME'
bucket_name <- 'YOUR BUCKET NAME'
bucket_path <- "YOUR BUCKET PATH"
bucket_segment <- "new_registration_app"

date <-format(Sys.Date(), "%Y%m%d%H")
file_name <- paste0(bucket_path,'/',bucket_segment,'/',bucket_segment,date,'.csv')


## upload file to bucket

# remove row.names
f <- function(input, output) write.csv(input, row.names = FALSE, file = output)

gcs_upload(file= data,
           bucket = bucket_name,
		   object_function = f,
           name = file_name,
		   type = "text/csv")

coolaResult <- data