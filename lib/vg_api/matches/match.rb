module VgApi
  class Match < Record
    def game_mode
      data['attributes']['gameMode']
    end

    def duration
      data['attributes']['duration']
    end

    def rosters_ids
      data['relationships']['rosters']['data'].map do |roster|
        roster["id"]
      end
    end

    def rosters
      @rosters ||= get_rosters
    end
    
  private

    def get_rosters
      parent.find_included('roster', rosters_ids).map do |roster|
        VgApi::Roster.new(roster, self)
      end
    end
  end
end

