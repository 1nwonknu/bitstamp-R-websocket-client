library(data.table)


loadDataTable <- function (path2file) {
  ' change to fread'
  df = as.data.table(read.csv(path2file))#, col_names  = c('timestamp', 'symbol', 'bidSize', 'bidPrice', 'askPrice', 'askSize')))
  df$t <- as.POSIXct(df$timestamp,format =  "%Y-%m-%dD%H:%M:%OS")
  df_vol <- df[, .(bidVolume = sum(bidSize), askVolume = sum(askSize), askPrice = mean(askPrice), bidPrice = mean(bidPrice)), by = .(symbol, timestamp = cut(t, breaks= "1 min")) ]
  return(df_vol)
}

setwd ("E:/Dokumente/bitcoin_data/quotes/")

#df = as.data.table(read.csv('20191002'))#, col_names  = c('timestamp', 'symbol', 'bidSize', 'bidPrice', 'askPrice', 'askSize')))

#df$t <- as.POSIXct(df$timestamp,format =  "%Y-%m-%dD%H:%M:%OS")

#df_vol <- df[, .(volume = sum(bidSize)), by = .(symbol, timestamp = cut(t, breaks= "1 min")) ]

#df_ADAZ199 <- filter(df_vol, symbol == 'ADAZ19')

count <- 0

for (file in c('20191002', '20191003')) {
  if(count==0) {
    df_list <- list(loadDataTable(file))
  } else {
    df_list <- c(list(loadDataTable(file)), df_list) 
  }
  count <- count + 1
}

df_all <- rbindlist(df_list)
