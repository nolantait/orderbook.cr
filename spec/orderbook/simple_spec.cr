require "../spec_helper"

describe Orderbook::Simple do
  it "returns the expected midprice and spread" do
    bid = Orderbook::Offer.new(
      price: BigDecimal.new("2"),
      quantity: BigDecimal.new("0.1")
    )
    ask = Orderbook::Offer.new(
      price: BigDecimal.new("3"),
      quantity: BigDecimal.new("0.3")
    )

    orderbook = Orderbook::Simple.new(best_bid: bid, best_ask: ask)

    orderbook.midprice.should eq BigDecimal.new(2.5)
    orderbook.spread.should eq BigDecimal.new(-1)
    orderbook.imbalance.should eq BigDecimal.new(0.25)
    orderbook.microprice.should eq BigDecimal.new(2.25)
  end

  it "cancels limit orders" do
    orderbook = Orderbook::Simple.new

    order = Orderbook::LimitOrder.new(
      is_bid: true,
      quantity: BigDecimal.new(1),
      price: BigDecimal.new(0.1)
    )

    orderbook.add_order order
    orderbook.cancel_order order

    orderbook.orders.should eq [] of Orderbook::LimitOrder
    order.status.should eq :cancelled
  end


  it "applies trades" do
    order_book = Orderbook::Simple.new

    called = false

    limit_order = Orderbook::LimitOrder.new(
      is_bid: false,
      quantity: BigDecimal.new(1),
      price: BigDecimal.new(0.1)
    )

    buy = Orderbook::Tick.new(
      timestamp: 1,
      is_trade: true,
      is_bid: true,
      price: BigDecimal.new(0.1),
      quantity: BigDecimal.new(0.5)
    )

    sell = Orderbook::Tick.new(
      timestamp: 2,
      is_trade: true,
      is_bid: false,
      price: BigDecimal.new(0.1),
      quantity: BigDecimal.new(1)
    )

    order_book.on Orderbook::LimitOrderFilled do |event|
      called = true
    end

    limit_order.status.should eq :processing
    order_book.add_order limit_order

    limit_order.status.should eq :placed
    order_book.emit buy
    limit_order.status.should eq :filled
    called.should eq true
  end

  it "applies updates" do
    order_book = Orderbook::Simple.new

    bid = Orderbook::Tick.new(
      timestamp: 1,
      is_trade: false,
      is_bid: true,
      price: BigDecimal.new("0.1"),
      quantity: BigDecimal.new("1")
    )
    ask = Orderbook::Tick.new(
      timestamp: 2,
      is_trade: false,
      is_bid: false,
      price: BigDecimal.new("0.11"),
      quantity: BigDecimal.new("2")
    )

    order_book.emit bid
    order_book.emit ask

    order_book.best_bid.should eq(
      Orderbook::Offer.new(
        price: BigDecimal.new("0.1"),
        quantity: BigDecimal.new("1")
      )
    )

    order_book.best_ask.should eq(
      Orderbook::Offer.new(
        price: BigDecimal.new("0.11"),
        quantity: BigDecimal.new("2")
      )
    )
  end
end
