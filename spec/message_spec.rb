RSpec.describe Message do
  subject(:Message) {
    api_data = { password: 'foo', key: 'bar', secret: 'foz' }
    described_class.new(api_data)
  }

  describe '#new' do
    it 'requires api_data to be send as a parameter' do
      expect{described_class.new}.to raise_error(ArgumentError)
    end
    it 'receives api_data parameters key, password and secret' do
      message = described_class.new(
        {foo: 'bar',key: 'a',secret: 'b',password: 'c',mario: 'bros'}
      )
      expect(message.instance_variable_get(:@api_data)).to eq(
        {key: 'a', secret: 'b',password: 'c'}
      )
    end
  end

  describe '#url' do
    it 'returns a valid url for connection request' do
      expect(subject.url).to match(/^\/([a-zA-Z0-9]+\/?)*$/)
    end
  end

  describe '#headers' do
    it 'returns headers for connection request' do
      allow(subject).to receive(:nonce){'baz'}
      allow(subject).to receive(:signature){'foo'}
      expect(subject.headers).to eq({'Content-Type': 'application/json',
                                     'APIKey': 'bar',
                                     'Signature': 'foo',
                                     'Nonce':'baz'})
    end
  end

  describe '#payload' do
    it 'returns the json dump of the payload method' do
      example_payload = {foo: 'bar'}
      allow(subject).to receive(:raw_payload){ example_payload }
      expect(subject.payload).to eq(JSON.dump(example_payload))
    end
  end
end
