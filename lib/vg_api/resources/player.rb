module VgApi
  class Player
    attr_reader :response, :data

    def self.find(player_id, region = 'eu')
      url = [api_url(region), player_id].join('/')

      result = VgApi::Client.new.request(url)
      VgApi::Player.new(result)
    end

    def self.find_by_name(name, region = 'eu')
      url = api_url(region)

      result = VgApi::Client.new.request(url, "filter[playerNames]": name)
      VgApi::Player.new(result)
    end

    def initialize(data)
      @response = JSON.parse(data.to_s)
      @data = response['data'].first
    end

    def id
      data['id']
    end

    def player_attributes
      data['attributes']
    end

    def stats
      player_attributes['stats']
    end

    def name
      player_attributes['name']
    end

    def region
      player_attributes['shardId']
    end

    def level
      stats['level']
    end

    def win_streak
      stats['winStreak']
    end

    def loss_streak
      stats['lossStreak']
    end

    def skill_tier
      stats['skillTier']
    end

  private

    def self.api_url(region)
      "shards/#{region}/players"
    end
  end
end