require 'order'

RSpec.describe Order do
  describe '.order_from_api' do
    before(:each) do
      @orders = described_class.orders_from_api(bids: [[2000,0.01,1],[1000,0.02,2]], asks: [[1200,0.01,3],[1300,0.02,4]])
    end
    it 'receive bids and asks from api and return an array of orders' do
      first_bid_order = @orders[:bids].first
      parameter_list = [first_bid_order.price, first_bid_order.bitcoin_amount, first_bid_order.id]
      expect(parameter_list).to eq([2000,0.01,1])
    end

    it 'load mutiple bids' do
      expect(@orders[:bids].size).to eq(2)
    end

    it 'load mutiple asks' do
      expect(@orders[:asks].size).to eq(2)
    end

  end

  describe '#fiat_value' do
    it 'return the fiat value of the order' do
      order = Order.new(price: 200, bitcoin_amount: 1.5)
      expect(order.fiat_value).to eq(300)
    end
  end

  describe '#satoshis' do
    it 'return the bitcoin amount in satoshis' do
      order = Order.new(bitcoin_amount: 1.5)
      expect(order.satoshis).to eq(150_000_000)
    end
  end
end
