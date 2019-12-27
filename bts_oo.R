library(websocket)
library(jsonlite)
library(R6)


BtsWebSocket <- R6Class("BtsWebSocket", inherit = WebSocket,
  
  list (
    ws = NULL,
    initialize = function(wsAddress = "wss://ws.bitstamp.net") {
      self$ws <- WebSocket$new(wsAddress, autoConnect = FALSE)
      self$ws$connect()
      cat(self$ws$readyState())
    },
    finalize = function (){
      self$ws$close()
    },
    onMessage = function (event) {
      self$ws$onMessage (function(event) {
        cat("receiving message")
        bts_data <- fromJSON(event$data)
        write.table(bts_data, 
                    paste(bts_data$channel, ".csv", pate = "")
                    , sep = ","
                    , col.names = !file.exists(paste(bts_data$channel, ".csv", paste = ""))
                    , append = T)
      }
      )
    },
    
    onClose = function (event) {
      self$ws$onClose(function(event) {
        cat("Client disconnected with code ", event$code,
            " and reason ", event$reason, "\n", sep = "")
      })
    },
    onError = function (event) {
      self$ws$onError(function(event) {
        cat("Client failed to connect: ", event$message, "\n")
      })
    },
    
    subscribe = function(channel, instrument, currency) {
      js <- toJSON(list(event = "bts:subscribe"
                        , data = list(channel = paste(channel
                                                      , "_"
                                                      , instrument, currency, sep="")))
                   , pretty=TRUE, auto_unbox = TRUE)
      cat(prettify(js))
      self$ws$send(js)
    },
    
    status = function () {
      cat(self$ws$readyState())
    }
    
  )
)
