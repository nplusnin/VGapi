module VgApi
  class Client
    attr_reader :access_token

    def initialize
      @access_token = VgApi.access_token
    end

    def request(path, params = {})
      url = [host, path].join('/')

      HTTParty.get(url, headers: headers, query: params)
    end

  private

    def headers
      {
        'Authorization': access_token,
        'X-TITLE-ID': 'semc-vainglory',
        'Accept': 'application/vnd.api+json'
      }
    end 

    def host
      'https://api.dc01.gamelockerapp.com'
    end
  end
end

# VgApi::Client.new.request("shards/eu/players", "filter[playerNames]": "NikitaPWNZ")
