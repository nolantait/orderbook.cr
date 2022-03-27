module Orderbook
  class Tick < EventHandler::Event
    getter timestamp : Timestamp
    getter is_trade : Bool
    getter is_bid : Bool
    getter price : BigDecimal
    getter quantity : BigDecimal

    def initialize(@timestamp, @is_trade, @is_bid, @price, @quantity); end
  end
end
