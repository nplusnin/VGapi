require 'spec_helper'

describe VgApi::Client do
  let(:client) { VgApi.client }
  let(:headers) { client.send(:headers) }

  describe '.request' do
    it 'should do request if url full specified' do
      allow(HTTParty).to receive(:get).with("https://api.dc01.gamelockerapp.com", headers: headers, query: {})
      client.request("https://api.dc01.gamelockerapp.com")
    end

    it 'should do request if not specified' do
      allow(HTTParty).to receive(:get).with("https://api.dc01.gamelockerapp.com/shards/eu/players", headers: headers, query: {})
      client.request("shards/eu/players")
    end
  end
end