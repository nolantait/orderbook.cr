require "./spec_helper"

describe Orderbook do
  it "runs" do
    book = Orderbook::Partial.new
    result = false

    book.on Orderbook::LimitOrderFilled do |order|
      result = true
    end

    sell_order = Orderbook::LimitOrder.new(
      id: "1",
      is_bid: false,
      quantity: BigDecimal.new(0.5),
      price: BigDecimal.new(0.1)
    )

    tick = Orderbook::Tick.new(
      timestamp: 123456,
      is_trade: true,
      is_bid: true,
      price: BigDecimal.new(0.1),
      quantity: BigDecimal.new(1)
    )

    book.add_order sell_order
    book.emit tick

    result.should eq true
  end
end
