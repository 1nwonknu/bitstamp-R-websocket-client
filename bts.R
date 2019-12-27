library(websocket)
library(jsonlite)

ws <- WebSocket$new("wss://ws.bitstamp.net", autoConnect = FALSE)

ws$onOpen(function(event) {
  cat("Connection opened\n")
})

ws$onMessage(function(event) {
  cat("Got client message", prettify(event$data))
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


js <- toJSON(list(event = "bts:subscribe", data = list(channel = "live_trades_btcusd")), pretty=TRUE, auto_unbox = TRUE)
