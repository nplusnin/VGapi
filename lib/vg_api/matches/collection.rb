module VgApi
  class VgApi::NotFound < StandardError
    def initialize(msg="Player not found")
      super(msg)
    end
  end

  module Matches
    class Collection
      def self.find_by(server, query = {})
        params = default_params.merge(query)
        result = VgApi.client.request("shards/#{server}/matches", params)
        raise VgApi::NotFound.new if result.code == 404
        Collection.new(JSON.parse(result))
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
        i, h = [], []

        included.each do |record|
          if record["type"] == 'participant'
            record["attributes"]["stats"]["items"].map { |item| i.push(item) }
            h.push(record["attributes"]["actor"])
          end
        end

        @items, @heroes = i.uniq, h.uniq
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
end