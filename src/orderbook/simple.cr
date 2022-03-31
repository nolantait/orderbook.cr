module Orderbook
  struct Offer
    getter price : BigDecimal
    getter quantity : BigDecimal

    def initialize(@price : BigDecimal, @quantity : BigDecimal); end

    def initialize(price : Int64, quantity : Int64)
      @price = BigDecimal.new(price)
      @quantity = BigDecimal.new(quantity)
    end
  end

  class Simple
    include EventHandler

    getter best_bid : Offer
    getter best_ask : Offer
    getter orders : Array(LimitOrder)

    def initialize(
      @best_bid = Offer.new(0, 0),
      @best_ask = Offer.new(0, 0),
      @orders = [] of LimitOrder
    )
      on Tick do |event|
        apply(event)
      end
    end

    def spread
      @best_bid.price - @best_ask.price
    end

    def midprice
      (@best_ask.price + @best_bid.price) / 2
    end

    def imbalance
      @best_bid.quantity / (@best_bid.quantity + @best_ask.quantity)
    end

    def microprice
      weighted_ask = imbalance * @best_ask.price
      weighted_bid = (1-imbalance) * @best_bid.price

      weighted_ask + weighted_bid
    end

    def apply(tick : Tick)
      if tick.is_trade
        check_orders(tick)
      else
        tick.is_bid ? handle_bid(tick) : handle_ask(tick)
      end
    end

    def cancel_order(order : LimitOrder)
      @orders = @orders - [order]
      order.cancel
      emit LimitOrderCancelled.new(order: order)
    end

    def add_order(order : LimitOrder)
      @orders.push order
      order.place
      emit LimitOrderPlaced.new(order: order)
    end

    private def fill_order(order : LimitOrder)
      order.fill
      emit LimitOrderFilled.new(order: order)
    end

    private def check_orders(trade : Tick)
      orders = trade.is_bid ? sell_orders : buy_orders

      filled = orders.select do |sell|
        sell.price <= trade.price
      end

      @orders = @orders - filled

      filled.each do |order|
        fill_order order
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
      @best_bid = Offer.new(price: tick.price, quantity: tick.quantity)
    end

    private def handle_ask(tick : Tick)
      @best_ask = Offer.new(price: tick.price, quantity: tick.quantity)
    end
  end
end
