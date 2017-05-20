module VgApi
  class Matches
    def self.find_all_by(region, params)
      url = "shards/#{region}/matches"
      VgApi.client.request(url, params)
    end

    attr_reader :data, :includes_data

    def initialize(data, includes_data)
      @data = data
      @includes_data = includes_data
    end

    def rosters
      @rosters ||= get_rosters
    end 

  private
    def rosters_ids
      data['relationships']['rosters']['data'].map { |r| r['id'] }
    end

    def get_rosters
      ids = rosters_ids

      includes_data.map do |i|
        i if i['type'] == 'roster' && ids.include?(i['id'])
      end.compact
    end
  end
end

# client.request('shards/eu/matches', )

