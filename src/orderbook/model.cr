module Orderbook
  EventHandler.event LimitOrderFilled, order : LimitOrder

  class Model
    include EventHandler

    getter orders : Array(LimitOrder)

    def initialize(
      @bids : Orders = {} of BigDecimal => BigDecimal,
      @asks : Orders = {} of BigDecimal => BigDecimal,
      @orders = [] of LimitOrder
    )
      on Tick do |event|
        apply(event)
      end
    end

    def midprice
      (best_ask + best_bid) / 2
    end

    def best_ask
      asks[0][0]
    end

    def best_bid
      bids[1][0]
    end

    def asks
      @asks.each.to_a.sort do |a, b|
        a.first <=> b.first
      end
    end

    def bids
      @bids.each.to_a.sort do |a, b|
        a.first <=> b.first
      end
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
      orders = trade.is_bid ? sell_orders : buy_orders

      filled = orders.select do |sell|
        sell.price <= trade.price
      end

      @orders = @orders - filled

      filled.each do |order|
        emit LimitOrderFilled.new(order: order)
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
