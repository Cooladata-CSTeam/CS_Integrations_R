# Integration from Awin to Cooladata

## Technologies used :  Cooladata , R
                     
### This is a sample code that upload daily changes from Awin to Cooladata 

Code written by Cooladata.com  

Using the following code, you can change the time range of the request:

```
from <- paste0(Sys.Date()-<Amount of days from today to go back to for start of range>,"T00:00:00")
to <- paste0(Sys.Date()-<Amount of days from today to go back to for end of range>,"T23:59:59")
timezone <- "UTC"
```
For example, the following code will bring the data from the past four months:
```
from <- paste0(Sys.Date()-120,"T00:00:00")
to <- paste0(Sys.Date()-91,"T23:59:59")
timezone <- "UTC"
```

