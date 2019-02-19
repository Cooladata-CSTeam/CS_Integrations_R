# The following libraries are always installed: ggplot2, plyr, reshape2, RColorBrewer, scales,grid, wesanderson, RJDBC, devtools, corrplot, testthat
# The results from the query above are saved to "data"
library(gtrendsR)

#define the keywords
keywords=c("firebase")
#set the geographic area: DE = Germany
country=c('US','DE')
#set the time window
time=("2018-01-01 2019-01-31")
#set channels
channel='web'



google.trends<-
gtrends(keywords,
        gprop = channel,
        time = time,
        geo = country)

data<-
data.frame(google.trends$related_queries)

# Results must be in table format. Save your result to coolaResult:
coolaResult <- data