require_relative "matches/record"
require_relative "matches/match"
require_relative "matches/participant"
require_relative "matches/player"
require_relative "matches/roster"

module VgApi
  class VgApi::NotFound < StandardError
    def initialize(msg="Player not found")
      super(msg)
    end
  end

  class Matches
    def self.find_by(region, query = {})
      params = query.merge(default_params)
      result = VgApi.client.request("shards/#{region}/matches", params)
      raise VgApi::NotFound.new if result.code == 404
      Matches.new(JSON.parse(result))
    end

    attr_reader :matches, :included, :items, :heroes

    def initialize(data)
      @matches = data["data"].map do |record|
        Match.new(record, self)
      end

      @included = data["included"]
      get_shared_data
    end

    def find_included(type, ids)
      included.select do |record|
        record["type"] == type && ids.include?(record["id"])
      end
    end

    def get_shared_data
      i = []
      h = []
      included.each do |record|
        if record["type"] == 'participant'
          record["attributes"]["stats"]["items"].map { |item| i.push(item) }
          h.push(record["attributes"]["actor"])
        end
      end

      @items = i.uniq
      @heroes = h.uniq
    end

  private
    def self.default_params
      {
        "page[limit]": 10,
        "sort": "-createdAt",
        "filter[createdAt-start]": time_28_days_ago
      }
    end

    def self.time_28_days_ago
      (Time.now - 28.days).strftime("%Y-%m-%dT%H:%M:%SZ")
    end
  end
end