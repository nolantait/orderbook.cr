module Orderbook
  class LimitOrder
    getter status, is_bid, amount, price

    def initialize(
      @is_bid : Bool,
      @amount : BigDecimal,
      @price : BigDecimal
    )
      @status = "processing"
    end

    def place
      @status = "placed"
    end

    def fill
      @status = "filled"
    end
  end
end
