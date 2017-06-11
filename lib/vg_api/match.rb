module VgApi
  class VgApi::NotFound < StandardError
    def initialize(msg="Player not found")
      super(msg)
    end
  end

  module Matches
    def self.find_by(region, query = {})
      params = query.merge(default_params)
      result = VgApi.client.request("shards/#{region}/matches", params)
      raise VgApi::NotFound.new if result.code == 404
      matches = JSON.parse(result.to_s)
      matches["data"].map do |record|
        Match.new(record, matches["included"])
      end
    end

  private
    def self.default_params
      {
        "page[limit]": 15,
        "sort": "-createdAt",
        "filter[createdAt-start]": "2017-01-01T08:25:30Z"
      }
    end
  end

  class Match
    attr_reader :data, :includes, :red_team, :blue_team

    def initialize(data, includes)
      @data = data
      @includes = includes
    end

    def id
      @data['id']
    end

    def game_mode
      @data['attributes']['gameMode']
    end

    def duration
      @data['attributes']['duration']
    end

    def rosters_ids
      @data['relationships']['rosters']['data'].map do |roster|
        roster["id"]
      end
    end

    def rosters
      @rosters ||= includes.map do |record|
        Roster.new(record, includes) if record["type"] == "roster" && rosters_ids.include?(record["id"]) 
      end.compact
    end
  end

  class Roster
    attr_reader :id, :includes

    def initialize(data, includes)
      @data = data
      @includes = includes
    end

    def id
      @data['id']
    end

    def win
      @data['attributes']['won'] == "true" ? true : false
    end

    def side
      @data['attributes']['stats']['side']
    end

    def participant_ids
      @data["relationships"]["participants"]["data"].map do |p|
        p['id']
      end
    end

    def participants
      @participants ||= includes.map do |record|
        Participant.new(record, includes) if record["type"] == "participant" && participant_ids.include?(record["id"]) 
      end.compact
    end
  end

  class Participant
    attr_reader :data, :includes

    def initialize(data, includes)
      @data = data
      @includes = includes
    end

    def id
      @data['id']
    end

    def hero
      @data['attributes']['actor'].gsub('*', '').downcase
    end

    def items
      @data['attributes']['stats']['items']
    end

    def player_id
      @data["relationships"]["player"]["data"]["id"]
    end

    def player
      @player ||= get_player
    end

  private

    def get_player
      includes.each do |record|
        if record["type"] == "player" && player_id == record["id"]
          @player = Player.new(record, includes)
          break
        end
      end

      @player
    end
  end

  class Player
    attr_reader :data, :includes

    def initialize(data, includes)
      @data = data
      @includes = includes
    end

    def name
      data['attributes']['name']
    end
  end
end