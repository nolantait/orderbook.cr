require "big"

require "./orderbook/tick"
require "./orderbook/model"

module Orderbook
  VERSION = "0.1.0"

  alias Volume = BigDecimal
  alias Price = BigDecimal
  alias Orders = Hash(Price, Volume)
  alias Timestamp = Int32
end
