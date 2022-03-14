require "../spec_helper"

describe Orderbook::Model do
  it "does not apply trades" do
    order_book = Orderbook::Model.new

    buy = Orderbook::Tick.new(
      timestamp: 1,
      is_trade: true,
      is_bid: true,
      price: BigDecimal.new(0.1),
      quantity: BigDecimal.new(1)
    )
    sell = Orderbook::Tick.new(
      timestamp: 2,
      is_trade: true,
      is_bid: false,
      price: BigDecimal.new(0.1),
      quantity: BigDecimal.new(1)
    )

    order_book.apply(buy)
    order_book.apply(sell)

    order_book.bids.should eq({} of BigDecimal => BigDecimal)
    order_book.asks.should eq({} of BigDecimal => BigDecimal)
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

    order_book.apply(bid)
    order_book.apply(ask)

    order_book.bids.should eq({ BigDecimal.new("0.1") => BigDecimal.new("1") })
    order_book.asks.should eq({ BigDecimal.new("0.11") => BigDecimal.new("2") })

    cancel = Orderbook::Tick.new(
      timestamp: 3,
      price: BigDecimal.new("0.1"),
      quantity: BigDecimal.new("0.00000"),
      is_trade: false,
      is_bid: true
    )

    order_book.apply(cancel)

    order_book.bids.should eq({} of BigDecimal => BigDecimal)
  end
end
