require "big"
require "uuid"
require "event_handler"

require "./orderbook/tick"
require "./orderbook/limit_order"
require "./orderbook/simple"
require "./orderbook/partial"

module Orderbook
  VERSION = "0.1.0"

  alias EventHandler = ::EventHandler
  alias Orders = Hash(BigDecimal, BigDecimal)
  alias Timestamp = Int32

  EventHandler.event LimitOrderFilled, order : LimitOrder
  EventHandler.event LimitOrderCancelled, order : LimitOrder
  EventHandler.event LimitOrderPlaced, order : LimitOrder
end
