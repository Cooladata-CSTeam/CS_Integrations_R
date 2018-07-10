#gets mails and their content from Mailchimp's API

library(httr)
library(devtools)
library(jsonlite)
library(plyr)
library(RCurl)

accessToken <-"<Insert Access token here>"
campaigns_url <- "https://us14.api.mailchimp.com/3.0/campaigns"

pagination <-1000
SearchTerm <-"?id="
StringLength <-6

mailchimp_campaigns<-
  fromJSON(paste0(campaigns_url,"?apikey=",accessToken,"&count=",pagination),flatten = TRUE)

mailchimp_campaigns <-mailchimp_campaigns$campaigns


mailchimp_campaigns <- flatten(mailchimp_campaigns,recursive = TRUE)
mailchimp_campaigns <-data.frame(mailchimp_campaigns)
mailchimp_campaigns <-subset(mailchimp_campaigns, select = -c(X_links) )


names(mailchimp_campaigns) = gsub(pattern = ".\\.", replacement = "_", x = names(mailchimp_campaigns))

mailchimp_campaigns$date <-paste0(Sys.Date()-1,"T00:00:00")
mailchimp_campaigns<-
  mailchimp_campaigns[c('id','web_id','type','create_time','archive_url','long_archive_url','status',
                        'emails_sent','send_time','content_type','needs_block_refresh','recipient_list_id',
                        'recipient_list_name','recipient_recipient_count','setting_subject_line',
                        'setting_preview_text','setting_title','setting_from_name','setting_reply_to',
                        'setting_use_conversation','setting_to_name','setting_authenticate',
                        'setting_template_id','trackin_opens','trackin_html_clicks','trackin_text_clicks',
                        'report_summar_opens','report_summar_unique_opens','report_summar_open_rate',
                        'report_summar_clicks','report_summar_subscriber_clicks','report_summar_click_rate',
                        'report_summar_ecommerc_total_orders','report_summar_ecommerc_total_spent',
                        'report_summar_ecommerc_total_revenue','delivery_statu_enabled','social_car_image_url',
                        'social_car_description','social_car_title','date')]
   

automations_url <- "https://us14.api.mailchimp.com/3.0/automations"

pagination <-1000

mailchimp_automations<-
  fromJSON(paste0(automations_url,"?apikey=",accessToken,"&count=",pagination),flatten = TRUE)

campagin_id<-mailchimp_automations[["automations"]][["id"]]

mailchimp_automations <-mailchimp_automations$automations

mailchimp_automations <- flatten(mailchimp_automations,recursive = TRUE)
mailchimp_automations <-data.frame(mailchimp_automations)
mailchimp_automations <-subset(mailchimp_automations, select = -c(X_links) )

names(mailchimp_automations) = gsub(pattern = ".\\.", replacement = "_", x = names(mailchimp_automations))

mailchimp_automations$date <-paste0(Sys.Date()-1,"T00:00:00")
mailchimp_automations$web_id<- '1'
mailchimp_automations[c("archive_url",
                        "long_archive_url",
                        "content_type",
                        "needs_block_refresh",
                        "recipient_recipient_count",
                        "setting_subject_line",
                        "setting_preview_text",
                        "setting_template_id",
                        "report_summar_ecommerc_total_orders",
                        "report_summar_ecommerc_total_spent",
                        "report_summar_ecommerc_total_revenue",
                        "delivery_statu_enabled",
                        "social_car_image_url",
                        "social_car_description",
                        "social_car_title")] <- NA





result_list = list(length = length(campagin_id))
for (i in campagin_id) {
  h <- basicHeaderGatherer()
  doc <- getURI(
    paste0(
      automations_url,"/",i,"?apikey=",
      accessToken,
      "&count=",
      pagination
    ),
    headerfunction = h$update
  )
  
  result_list[[i]] =  c(i,as.integer(
    substring(
      h$value()[as.integer(grep(SearchTerm, h$value()))[1]],
      as.integer(regexpr(SearchTerm, h$value()[as.integer(grep(SearchTerm, h$value()))[1]])) +
        nchar(SearchTerm) - 1,
      as.integer(regexpr(SearchTerm, h$value()[as.integer(grep(SearchTerm, h$value()))[1]])) +
        nchar(SearchTerm) + StringLength - 2
    )
  )
  )
}

results = do.call(rbind, result_list)
colnames(results) <- c("id","web_id")
#mailchimp
mailchimp_automations<-
  merge(mailchimp_automations,results,by="id", all.mailchimp_automations=TRUE)

mailchimp_automations <- plyr::rename(mailchimp_automations,c("trigger_setting_runtim_hour_type"="type",
                                                              "start_time"="send_time",
                                                              "web_id.y"="web_id"))

mailchimp_automations<-
  mailchimp_automations[c('id','web_id','type','create_time','archive_url','long_archive_url','status',
                          'emails_sent','send_time','content_type','needs_block_refresh','recipient_list_id',
                          'recipient_list_name','recipient_recipient_count','setting_subject_line',
                          'setting_preview_text','setting_title','setting_from_name','setting_reply_to',
                          'setting_use_conversation','setting_to_name','setting_authenticate',
                          'setting_template_id','trackin_opens','trackin_html_clicks','trackin_text_clicks',
                          'report_summar_opens','report_summar_unique_opens','report_summar_open_rate',
                          'report_summar_clicks','report_summar_subscriber_clicks','report_summar_click_rate',
                          'report_summar_ecommerc_total_orders','report_summar_ecommerc_total_spent',
                          'report_summar_ecommerc_total_revenue','delivery_statu_enabled','social_car_image_url',
                          'social_car_description','social_car_title','date')]

mailchimp_automations<- subset(mailchimp_automations, status != "save")

mailchimp_automations$web_id<-as.numeric(paste(mailchimp_automations$web_id))

mailchimp <- do.call("rbind",list(mailchimp_automations,mailchimp_campaigns))


mailchimp$create_time <-substr(mailchimp$create_time,1,nchar(mailchimp$create_time)-6)

mailchimp$send_time <-substr(mailchimp$send_time,1,nchar(mailchimp$send_time)-6)
mailchimp$web_id <-as.character(mailchimp$web_id)

mailchimp <- as.data.frame(sapply(mailchimp, function(x) gsub("\"", "", x)))

# Results must be in table format. Save your result to coolaResult:
coolaResult <- mailchimp