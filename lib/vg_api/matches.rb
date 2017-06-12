matches_dir = [Dir.pwd, 'lib/vg_api/matches/*.rb'].join('/')
require_relative "matches/record"
Dir[matches_dir].each {|file| require_relative file }

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

    attr_reader :matches, :included

    def initialize(data)
      @matches = data["data"].map do |record|
        Match.new(record, self)
      end

      @included = data["included"]
    end

    def find_included(type, ids)
      included.select do |record|
        record["type"] == type && ids.include?(record["id"])
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
end