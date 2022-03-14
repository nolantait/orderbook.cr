module Orderbook
  struct Tick
    getter timestamp, is_trade, is_bid, price, quantity

    def initialize(
      @timestamp : Timestamp,
      @is_trade : Bool,
      @is_bid : Bool,
      @price : Price,
      @quantity : Volume
    )
    end
  end
end
