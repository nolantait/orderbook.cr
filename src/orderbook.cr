require "big"
require "uuid"
require "event_handler"

require "./orderbook/tick"
require "./orderbook/limit_order"
require "./orderbook/model"

module Orderbook
  VERSION = "0.1.0"

  alias EventHandler = ::EventHandler
  alias Orders = Hash(BigDecimal, BigDecimal)
  alias Timestamp = Int32

  def self.run(&block : ->(OrderBook::Model))
    block.call(Model.new)
  end

  def self.build
    Model.new
  end
end
