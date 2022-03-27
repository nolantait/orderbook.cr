# Orderbook

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
       github: your-github-user/orderbook
   ```

2. Run `shards install`

## Usage

```crystal
require "orderbook"
require "big"

Orderbook.run do |book|
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
end
```

OR you could initialize the book yourself without a block:

```crystal
book = Orderbook.build
# Do stuff from above here
```

Running either would print "ORDER FILLED"

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
