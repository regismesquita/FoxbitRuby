require 'openssl'
require 'faraday'
require 'json'

class FoxbitRuby
  API_URL='https://api.blinktrade.com/'
  def get_orders
    parsed_json_orders=JSON.parse(connection.get('/api/v1/BRL/orderbook').body)
    Order.orders_from_api(parsed_json_orders)
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
