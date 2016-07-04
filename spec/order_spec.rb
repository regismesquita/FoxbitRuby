RSpec.describe Order do
  describe '.order_from_api' do
    subject(:orders){ described_class.orders_from_api(bids: [[2000,0.01,1],[1000,0.02,2]], asks: [[1200,0.01,3],[1300,0.02,4]]) }

    it 'receive bids and asks from api and return an array of orders' do
      first_bid_order = subject[:bids].first
      parameter_list = [first_bid_order.price, first_bid_order.bitcoin_amount, first_bid_order.id]
      expect(parameter_list).to eq([2000,0.01,1])
    end

    it 'load mutiple bids' do
      expect(subject[:bids].size).to eq(2)
    end

    it 'load mutiple asks' do
      expect(subject[:asks].size).to eq(2)
    end

  end

  describe '#fiat_value' do
    subject(:order){ described_class.new(price: 200, bitcoin_amount: 1.5) }

    it 'return the fiat value of the order' do
      expect(subject.fiat_value).to eq(300)
    end

    it 'updates the fiat value when bitcoin amount changes' do
      subject.bitcoin_amount = 2
      expect(subject.fiat_value).to eq(400)
    end

    it 'updates the fiat value when price changes' do
      subject.price = 300
      expect(subject.fiat_value).to eq(450)
    end
  end

  describe '#satoshis' do
    subject(:order){ described_class.new(bitcoin_amount: 1.5) }

    it 'return the bitcoin amount in satoshis' do
      expect(subject.satoshis).to eq(150_000_000)
    end
  end
end
