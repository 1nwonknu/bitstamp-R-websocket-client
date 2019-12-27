library(Quandl)
library(data.table)
library(janitor)
library(lubridate)


my_quandl_api_key <- "2VvZoWG28n4JL3kJx_FC"

Quandl.api_key(my_quandl_api_key)

get_quandl_data <- function(data_source = "BITFINEX"
                            , pair = 'btcusd'
                            , ...){
  
  # make sure the user supplied the correct data_source
  if(toupper(data_source) != "BITFINEX") stop("data source supplied is wrong...")
  # quandl is case sensitive, all codes have to be upper case
  pair <- toupper(pair)
  tmp <- NA
  try(tmp <- Quandl(code = toupper(paste(data_source, pair, sep = "/")), ...), silent = TRUE)
  return(tmp)
}
# get btc data from different exchanges
exchange_data <- list()

exchanges <- c('KRAKENUSD','COINBASEUSD','BITSTAMPUSD','ITBITUSD')

for (i in exchanges){
  exchange_data[[i]] <- Quandl(paste0('BCHARTS/', i))
}


# put them all in one dataframe to plot in ggplot2
btc_usd <- do.call("rbind", exchange_data)
btc_usd$exchange <- row.names(btc_usd)
btc_usd <- as.data.table(btc_usd)
                         