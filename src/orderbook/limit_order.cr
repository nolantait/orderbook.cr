module Orderbook
  class LimitOrder
    getter id : String | UUID
    getter status : Symbol
    getter is_bid : Bool
    getter quantity : BigDecimal
    getter price : BigDecimal

    def initialize(@id, @is_bid, @quantity, @price)
      @status = :processing
    end

    def initialize(@is_bid, @quantity, @price)
      @id = UUID.random
      @status = :processing
    end

    def cancel
      @status = :cancelled
    end

    def place
      @status = :placed
    end

    def fill
      @status = :filled
    end
  end
end
