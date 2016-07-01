require 'foxbit_ruby'

RSpec.describe "FoxbitRuby#orders" do
  before do
    stub = stub_request(:get, 'https://api.blinktrade.com/api/v1/BRL/orderbook')
              .to_return(body: '{"pair":"BTCBRL","bids":[[2000.0,0.01,90804599]],"asks":[[2000.00,0.25,90855278]]}')
  end

  it "should return an order list with asks and bids" do
    fbr = FoxbitRuby.new
    expect(fbr.orders[:asks].first.class).to eq(Order)
  end

  it "should parse asks correctly" do
    fbr = FoxbitRuby.new
    ask = fbr.orders[:asks].first
    expect([ask.price,ask.bitcoin_amount,ask.id]).to eq([2000.00,0.25,90855278])
  end

  it "should parse asks correctly" do
    fbr = FoxbitRuby.new
    bid = fbr.orders[:bids].first
    expect([bid.price,bid.bitcoin_amount,bid.id]).to eq([2000.0,0.01,90804599])
  end


end
