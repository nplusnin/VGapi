module VgApi
  class VgApi::NotFound < StandardError
    def initialize(msg="Not found")
      super(msg)
    end
  end

  module Matches
    class Collection
      def self.find_by(server, query = {})
        params = default_params.merge(query)
        result = VgApi.client.request("shards/#{server}/matches", params)
        raise VgApi::NotFound.new if result.code == 404
        Collection.new(JSON.parse(result.body))
      end

      attr_reader :matches, :data, :included

      def initialize(data)
        @data = data

        @matches = data["data"].map do |record|
          Match.new(record, self)
        end

        @included = data["included"]
      end

      def find_included(type, ids)
        included.find do |record|
          record["type"] == type && ids.include?(record["id"])
        end
      end

      def select_included(type, ids)
        included.select do |record|
          record["type"] == type && ids.include?(record["id"])
        end
      end

      def next
        raise VgApi::NotFound.new unless next_link
        result = VgApi.client.request(next_link)
        Collection.new(JSON.parse(result))
      end

      def last?
        !next_link
      end

      def to_json
        matches.map do |m|
          m.to_h
        end.to_json
      end

    private
      def self.default_params
        {
          "page[limit]": 10,
          "sort": "-createdAt"
        }
      end

      def next_link
        data["links"]["next"]
      end
    end
  end
end

# Time format
# .strftime("%Y-%m-%dT%H:%M:%SZ")