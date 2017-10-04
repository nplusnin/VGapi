module VgApi
  class Player
    def self.find_by_name(server, names)
      query = names.kind_of?(Array) ? names.join(",") : names
      result = VgApi.client.request("shards/#{server}/players", "filter[playerNames]": query)
      
      if result["data"].count > 1
        result["data"].map do |player|
          Player.new(player)
        end
      else
        Player.new(result["data"][0])
      end
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def attributes
      data["attributes"]
    end

    def stats
      attributes["stats"]
    end

    def name
      attributes["name"]
    end

    def rank
      stats["skillTier"]
    end

    def wins
      stats["wins"]
    end

    def level
      stats["level"]
    end
  end
end