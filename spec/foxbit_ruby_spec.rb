RSpec.describe FoxbitRuby do
  subject(:FoxbitRuby) { described_class.new }

  describe '#orders' do
    before do
      stub = stub_request(:get, 'https://api.blinktrade.com/api/v1/BRL/orderbook')
        .to_return(body: '{"pair":"BTCBRL","bids":[[2000.0,0.01,90804599]],"asks":[[2000.00,0.25,90855278]]}')
    end

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
  describe '#instant_sell_price' do
    before do
      stub = stub_request(:get, 'https://api.blinktrade.com/api/v1/BRL/orderbook')
        .to_return(body: '{"pair":"BTCBRL","bids":[[2000.0,0.01,90804599],[1800.0,0.04,90904599],[1600.0,0.03,90904599]],"asks":[[2000.00,0.25,90855278]]}')
    end

    it 'returns biggest bid price in order book (so we can sell)' do
      expect(subject.instant_sell_price).to eq(2000)
    end

    it 'returns biggest bid price for the amount we want to sell.' do
      expect(subject.instant_sell_price(0.05)).to eq(1800)
    end

    context 'given an amount not available'
    it "throw an 'amount not available' exception" do
      expect{subject.instant_sell_price(1.00)}.to raise_exception('Amount not available')
    end
  end
  describe '#instant_buy_price' do
    before do
      stub = stub_request(:get, 'https://api.blinktrade.com/api/v1/BRL/orderbook')
        .to_return(body: '{"pair":"BTCBRL","bids":[[1990.0,0.01,90804599]],"asks":[[2400.00,0.20,90855278],[2200.00,0.15,90855277],[2000.00,0.10,90855276]]}')
    end

    it 'returns lowest ask price in order book (so we can buy)' do
      expect(subject.instant_buy_price).to eq(2000)
    end

    it 'returns lowest ask price for the amount we want to buy.' do
      expect(subject.instant_buy_price(0.25)).to eq(2200)
    end

    context 'given an amount not available'
    it "throw an 'amount not available' exception" do
      expect{subject.instant_buy_price(1.00)}.to raise_exception('Amount not available')
    end
  end

end
