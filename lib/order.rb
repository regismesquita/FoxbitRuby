require 'active_support/core_ext/hash'

class Order
  attr_accessor :type, :price , :bitcoin_amount, :id

  def initialize(params)
    params.each do |m,v|
      self.instance_variable_set('@' << m.to_s,v)
    end
  end

  def fiat_value
    price * bitcoin_amount
  end

  def satoshis
    bitcoin_amount * 100_000_000
  end

  def self.orders_from_api(api_received_json)
    # API BID FORMAT {'bids': [[price,bitcoin_amount,id]], 'asks': [[price,bitcoin_amount,id]]}
    bids = Array.new
    asks = Array.new
    api_received_json.symbolize_keys!
    unless api_received_json[:bids].nil?
      api_received_json[:bids].each do |price,bitcoin_amount,id|
        bids.push self.new(type: 'bid', price: price, bitcoin_amount: bitcoin_amount, id: id)
      end
    end

    unless api_received_json[:asks].nil?
      api_received_json[:asks].each do |price,bitcoin_amount,id|
        asks.push self.new(type: 'ask', price: price, bitcoin_amount: bitcoin_amount, id: id)
      end
    end

    return {bids: bids,asks: asks}
  end
end
