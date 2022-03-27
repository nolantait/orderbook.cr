require "../spec_helper"

describe Orderbook::Model do
  it "applies trades" do
    order_book = Orderbook::Model.new

    limit_order = Orderbook::LimitOrder.new(
      is_bid: false,
      amount: BigDecimal.new(1),
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

    limit_order.status.should eq "processing"
    order_book.add_order(limit_order)
    limit_order.status.should eq "placed"
    order_book.apply(buy)
    limit_order.status.should eq "filled"
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
