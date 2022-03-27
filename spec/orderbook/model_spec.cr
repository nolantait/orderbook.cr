require "../spec_helper"

describe Orderbook::Model do
  it "returns the expected midprice and spread" do
    bids = {
      BigDecimal.new(0.25) => BigDecimal.new(0.1),
      BigDecimal.new(2) => BigDecimal.new(0.1),
    }

    asks = {
      BigDecimal.new(3) => BigDecimal.new(0.1),
      BigDecimal.new(6) => BigDecimal.new(0.1),
    }

    orderbook = Orderbook::Model.new(
      bids: bids,
      asks: asks
    )

    orderbook.midprice.should eq BigDecimal.new(2.5)
    orderbook.spread.should eq BigDecimal.new(1)
    orderbook.imbalance.should eq BigDecimal.new(0.5)
  end


  it "applies trades" do
    order_book = Orderbook::Model.new

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

    limit_order.status.should eq "processing"
    order_book.add_order limit_order

    limit_order.status.should eq "placed"
    order_book.emit buy
    limit_order.status.should eq "filled"
    called.should eq true

    order_book.emit sell

    order_book.bids.should eq([] of {BigDecimal, BigDecimal})
    order_book.asks.should eq([] of {BigDecimal, BigDecimal})
  end

  it "applies limit orders" do
    order_book = Orderbook::Model.new

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

    order_book.bids.should eq([
      { BigDecimal.new("0.1"), BigDecimal.new("1") }
    ])
    order_book.asks.should eq([
      { BigDecimal.new("0.11"), BigDecimal.new("2") }
    ])

    cancel = Orderbook::Tick.new(
      timestamp: 3,
      price: BigDecimal.new("0.1"),
      quantity: BigDecimal.new("0.00000"),
      is_trade: false,
      is_bid: true
    )

    order_book.emit cancel

    order_book.bids.should eq([] of {BigDecimal, BigDecimal})
  end
end
