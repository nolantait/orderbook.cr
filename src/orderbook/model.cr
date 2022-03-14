module Orderbook
  class Model
    getter bids, asks

    def initialize(
      @bids : Orders = {} of BigDecimal => BigDecimal,
      @asks : Orders = {} of BigDecimal => BigDecimal
    )
    end

    def apply(tick : Tick)
      return if tick.is_trade

      tick.is_bid ? handle_bid(tick) : handle_ask(tick)
    end

    private def handle_bid(tick : Tick)
      if tick.quantity == 0
        @bids.delete(tick.price)
      else
        @bids[tick.price] = tick.quantity
      end
    end

    private def handle_ask(tick : Tick)
      if tick.quantity == 0
        @asks.delete(tick.price)
      else
        @asks[tick.price] = tick.quantity
      end
    end
  end
end
