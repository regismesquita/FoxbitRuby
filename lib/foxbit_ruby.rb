require 'openssl'
require 'faraday'
require 'json'

class FoxbitRuby
  API_URL='https://api.blinktrade.com/'

  def orders
    parsed_json_orders=JSON.parse(connection.get('/api/v1/BRL/orderbook').body)
    Order.orders_from_api(parsed_json_orders)
  end

  def instant_sell_price(amount_to_sell=0)
    price_ordered_list = orders[:bids].sort{|c,d| c.price <=> d.price}.reverse
    current_amount = 0
    while
      current_order = price_ordered_list.shift
      current_amount += current_order.bitcoin_amount
      break if current_amount >= amount_to_sell
    end
    raise 'Amount not available' if current_order.nil?
    current_order.price
  end

  def instant_buy_price(amount_to_buy=0)
    price_ordered_list = orders[:asks].sort{|c,d| c.price <=> d.price}
    current_amount = 0
    while
      current_order = price_ordered_list.shift
      current_amount += current_order.bitcoin_amount
      break if current_amount >= amount_to_buy
    end
    raise 'Amount not available' if current_order.nil?
    current_order.price
  end

  def check_balance
    message = Message.new(api_data)
    message.raw_payload = {:MsgType=>"U2", :BalanceReqID=>1}
    connection.post{|req|
      req.url message.url
      req.headers = message.headers
      req.body = message.payload
    }
    # Now should have a response handling class to receive that response.
  end
  private

  def api_data
    JSON.parse(File.open('config.json').read)
    ### JSON FORMAT:
      #  {
      #    password: '',
      #    key: '',
      #    secret: ''
      #  }
  end

  def connection
    Faraday.new(:url => API_URL)
  end

end
