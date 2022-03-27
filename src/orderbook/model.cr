module Orderbook
  class Model
    getter bids, asks

    def initialize(
      @bids : Orders = {} of BigDecimal => BigDecimal,
      @asks : Orders = {} of BigDecimal => BigDecimal,
      @orders : Array(LimitOrder) = [] of LimitOrder
    )
    end

    def apply(tick : Tick)
      if tick.is_trade
        check_orders(tick)
      else
        tick.is_bid ? handle_bid(tick) : handle_ask(tick)
      end
    end

    def add_order(order : LimitOrder)
      @orders.push order
      order.place
    end

    private def check_orders(trade : Tick)
      if trade.is_bid
        filled = sell_orders.select do |sell|
          sell.price <= trade.price
        end
      else
        filled = buy_orders.select do |buy|
          buy.price >= trade.price
        end
      end

      @orders = @orders - filled

      filled.each do |order|
        order.fill
      end
    end

    private def buy_orders
      @orders.select do |order|
        order.is_bid
      end
    end

    private def sell_orders
      @orders.select do |order|
        !order.is_bid
      end
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
