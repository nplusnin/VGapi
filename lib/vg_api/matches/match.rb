module VgApi
  class Match < Record
    attr_reader :winners_team

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

    def right_side
      @right_side ||= rosters.select do |r|
        r.side == "right/red"
      end.first
    end

    def left_side
      @left_side ||= rosters.select do |r|
        r.side == "left/blue"
      end.first
    end

    def red_team
      right_side
    end

    def blue_team
      left_side
    end

    def winners_team
      rosters.select do |roster|
        roster.win
      end.first
    end

    def player_win?(player_name)
      winners_team.players.map do |player|
        player[:name]
      end.include?(player_name)
    end
    
  private

    def get_rosters
      parent.find_included('roster', rosters_ids).map do |roster|
        VgApi::Roster.new(roster, self)
      end
    end
  end
end

