# Integration from ACR Affiliates to Cooladata

## Technologies used :  Cooladata , R
                     
### This is a sample code that upload daily changes from ACR Affiliates to Cooladata 

Code written by Cooladata.com  

Using the following code, you can change the time range of the request:

```
from_date <- Sys.Date()-<Insert number of days back - 1>
to_date <- Sys.Date()+ 1
```

Note: ACR Affiliates has many different feeds, each one containing different types of data. For each integration written here the data is pulled from one specific feed.
