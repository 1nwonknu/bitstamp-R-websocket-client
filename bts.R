library(websocket)
library(jsonlite)

ws <- WebSocket$new("wss://ws.bitstamp.net", autoConnect = FALSE)

ws$onOpen(function(event) {
  cat("Connection opened\n")
})

ws$onMessage(function(event) {
  bts_data <- fromJSON(event$data)
  write.table(bts_data, 
              paste(bts_data$channel, ".csv", pate = "")
              , sep = ","
              , col.names = !file.exists(paste(bts_data$channel, ".csv", paste = ""))
              , append = T)
})
ws$onClose(function(event) {
  cat("Client disconnected with code ", event$code,
      " and reason ", event$reason, "\n", sep = "")
})
ws$onError(function(event) {
  cat("Client failed to connect: ", event$message, "\n")
})
ws$connect()


subscribe <- function(channel, instrument, currency) {
  js <- toJSON(list(event = "bts:subscribe"
              , data = list(channel = paste(channel
              , "_"
              , instrument, currency, sep="")))
              , pretty=TRUE, auto_unbox = TRUE)
  ws$send(js)
}



#js <- toJSON(list(event = "bts:subscribe", data = list(channel = "live_trades_btcusd")), pretty=TRUE, auto_unbox = TRUE)
