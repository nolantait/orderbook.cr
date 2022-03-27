require "big"
require "uuid"
require "event_handler"

require "./orderbook/tick"
require "./orderbook/limit_order"
require "./orderbook/model"

module Orderbook
  VERSION = "0.1.0"

  alias Orders = Hash(BigDecimal, BigDecimal)
  alias Timestamp = Int32
end
