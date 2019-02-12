singular_KEY <- "<YOUR KEY HERE>"
sing_from <- Sys.Date()-10
sing_to <- Sys.Date() -1
time_break<-"day"
params<-c('custom_clicks,custom_installs,adn_cost')
          params2<-c('adn_impressions','adn_original_cost','adn_estimated_total_conversions','ctr','cvr','ecpi','ocvr','ecpm','ecpc')
          params3<-c('ocvr','ecpm','ecpc')
          singular_format<-"csv"
          singular_metrics<-c('app','site_public_id','source','os','platform','country_field',
                              'custom_dimension_id','adn_campaign_name','adn_campaign_id','singular_campaign_id',
                              'adn_sub_campaign_name','adn_sub_campaign_id','adn_sub_adnetwork_name','adn_original_currency',
                              'adn_timezone','adn_utc_offset','adn_account_id','adn_campaign_url','adn_status','adn_click_type'
                              ,'keyword','publisher_id','publisher_site_id','publisher_site_name','tracker_name','retention')
          
#url = paste("https://api.singular.net/api/v2.0/reporting?api_key=",API_KEY,"&start_date=",start_date,"&end_date=",end_date,"&metrics=",metrics,"&time_breakdown=",time_breakdown,sep="")
url ="https://api.singular.net/api/v2.0/reporting"
a<-read.csv(text=rawToChar(GET(url,query=list(api_key=singular_KEY,start_date=sing_from,end_date=sing_to,metrics=params,time_breakdown=time_break,format=singular_format,dimension=singular_metrics))[["content"]]), header = TRUE, sep =',')

a<-read.csv(text=rawToChar(GET(url,query=list(start_date=sing_from,end_date=sing_to,metrics=params,
                                              time_breakdown=time_break,format=singular_format))[["content"]]), header = TRUE, sep =',')


x <-data.frame(a)



report<-
  read.csv(paste0(url,"?api_key=",singular_KEY,
                  "&start_date=",sing_from,
                  "&end_date=",sing_to,
                  "&metrics=",params,
                  "&time_breakdown=",time_break,
                  "&format=",singular_format))

x<-data.frame(data.matrix(report))
x<-data.frame(report$start_date)

report <- data.frame(lapply(report, as.character), stringsAsFactors=FALSE)
