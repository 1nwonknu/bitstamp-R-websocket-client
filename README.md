# bitstamp-R-websocket-client

Uses websocket R package to retrieve real time data from Bitstamp websocket.

# Usage

Create an object:

ws <- BtsWebSocket$new()

Subscribe to data feeds. They will be written to csv.

ws$subscribe("order_book_btcusd")
