require 'active_support/core_ext/hash'
require 'json'

class Message
  attr_accessor :raw_payload
  MESSAGE_RECEIVING_URL='/tapi/v1/message'

  def initialize(params)
    @api_data = params.symbolize_keys.extract!(:key,:secret,:password)
  end

  def url
    MESSAGE_RECEIVING_URL
  end

  def headers
    {'Content-Type': 'application/json',
     'APIKey': api_data[:key],
     'Nonce': nonce,
     'Signature': signature
    }
  end

  def payload
    JSON.dump(raw_payload)
  end

  private
    def nonce
      Time.new.to_i.to_s
    end

    def digest
      OpenSSL::Digest.new('sha256')
    end

    def signature
      OpenSSL::HMAC.hexdigest(digest,api_data[:secret],nonce)
    end

    def api_data
      @api_data
    end
end
