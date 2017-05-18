module VgApi
  class Client
    def initialize(access_token = nil)
      @access_token = access_token || ENV["VG_ACCESS_TOKEN"]
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

#client.perform_request("shards/na/players", "filter[playerNames]": "NikitaPWNZ")
