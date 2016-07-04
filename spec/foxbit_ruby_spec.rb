RSpec.describe FoxbitRuby do
  describe '#orders' do
    before do
      stub = stub_request(:get, 'https://api.blinktrade.com/api/v1/BRL/orderbook')
        .to_return(body: '{"pair":"BTCBRL","bids":[[2000.0,0.01,90804599]],"asks":[[2000.00,0.25,90855278]]}')
    end

    subject(:FoxbitRuby) { described_class.new }

    it "return an order list with asks and bids" do
      expect(subject.orders[:asks].first.class).to eq(Order)
    end

    it "parse asks correctly" do
      ask = subject.orders[:asks].first
      expect([ask.price,ask.bitcoin_amount,ask.id]).to eq([2000.00,0.25,90855278])
    end

    it "parse bids correctly" do
      bid = subject.orders[:bids].first
      expect([bid.price,bid.bitcoin_amount,bid.id]).to eq([2000.0,0.01,90804599])
    end
  end
end
