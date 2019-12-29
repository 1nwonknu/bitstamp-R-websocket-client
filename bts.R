library(websocket)
library(jsonlite)
library(R6)


BtsWebSocket <- R6Class("BtsWebSocket", inherit = WebSocket,
  list (
    subscriptions = vector(mode = "list", length = 100),
    ws = NULL,
    initialize = function(wsAddress = "wss://ws.bitstamp.net") {
      self$ws <- WebSocket$new(wsAddress, autoConnect = FALSE)
      self$ws$connect()
      cat(self$ws$readyState())
    },
    finalize = function (){
      self$ws$close()
      self$removeSubscriptions()
      
    },
    onMessage = function (event) {
      self$ws$onMessage (function(event) {
        #cat("receiving message")
        bts_data <- fromJSON(event$data)
        
        filename <- paste(bts_data$channel, ".csv", sep = "")
        
        write.table(bts_data, 
                    paste(bts_data$channel, ".csv", sep = "")
                    , sep = ","
                    , col.names = !file.exists(filename)
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
    
    subscribe = function(subscription, action = "bts:subscribe") {
      # e.g. live_trades_btcusd
      js <- toJSON(list(event = action
                        , data = list(channel = subscription))
                   , pretty=TRUE, auto_unbox = TRUE)
      cat(prettify(js))
      self$addSubscription(subscription)
      self$ws$send(js)
      self$onMessage()
    },
    
    addSubscription = function (subscription) {
      next_empty_slot <- which (sapply(self$subscriptions, is.null) == TRUE)[1]
      self$subscriptions[next_empty_slot] <- subscription
    },
    
    removeSubscriptions = function() {
      indices_active_subscriptions <- which (sapply(self$subscriptions, is.null) == FALSE)
      
      for ( subscription in indices_active_subscriptions) {
        self$subscribe(subscriptions[subscription], action = "bts:unsubscribe")
      }
    },
    
    status = function () {
      cat(self$ws$readyState())
    }
    
  )
)
