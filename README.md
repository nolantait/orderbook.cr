# Orderbook

[![GitHub release](https://img.shields.io/github/release/nolantait/orderbook.cr.svg)](https://github.com/nolantait/orderbook.cr/releases)

An extensible limit order book model written in Crystal.

Designed to be used in live trading and backtesting market making strategies.

It uses the
[Dense Tick Format](https://rickyhan.com/jekyll/update/2017/10/28/how-to-handle-order-book-data.html)
for all ticks and orders in an effort to keep the API somewhat uniform.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     orderbook:
       github: nolantait/orderbook.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "orderbook"
require "big"

book = Orderbook::Partial.new

book.on Orderbook::LimitOrderFilled do |order|
  puts "ORDER FILLED"
end

sell_order = Orderbook::LimitOrder.new(
  id: "1",
  is_bid: false,
  quantity: BigDecimal.new(0.5),
  price: BigDecimal.new(0.1)
)

tick = Tick.new(
  timestamp: 123456,
  is_trade: true,
  is_bid: true,
  price: BigDecimal.new(0.1),
  quantity: BigDecimal.new(1)
)

book.add_order sell_order
book.emit tick
```

OR you could initialize a simple book with just the best bid/ask:

```crystal
book = Orderbook::Simple.new

tick = Tick.new(
  timestamp: 123456,
  is_trade: false,
  is_bid: true,
  price: BigDecimal.new(0.1),
  quantity: BigDecimal.new(1)
)

book.emit tick
```

The above would set the `book.best_bid` to equal the new tick

## Development

`shards install` and then `crystal specs`

## Contributing

1. Fork it (<https://github.com/nolantait/orderbook/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Nolan J Tait](https://github.com/nolantait) - creator and maintainer
