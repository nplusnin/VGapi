module VgApi
  class Players
    def self.find_by_name(name, region = 'eu')
      result = VgApi.client.request("shards/#{ region }/players", "filter[playerNames]": name)
      return Players.new(result)
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def name
      @data["data"][0]["attributes"]["name"]
    end

    def rank
      @data["data"][0]["attributes"]["stats"]["skillTier"]
    end

    def wins
      @data["data"][0]["attributes"]["stats"]["wins"]
    end

    def level
      @data["data"][0]["attributes"]["stats"]["level"]
    end
  end
end