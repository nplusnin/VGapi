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

    def players
      @players ||= get_players
    end

    def player(player_name)
      players.select do |p|
        p[:name] == player_name
      end.first
    end
    
  private

    def get_players
      rosters.map do |p1|
        p1.participants.map do |p2|
          {
            name: p2.player_name,
            stats: p2.stats,
            hero: p2.hero,
            items: p2.items,
            hero_skin: p2.skin
          }
        end
      end.inject('+')
    end

    def get_rosters
      parent.find_included('roster', rosters_ids).map do |roster|
        VgApi::Roster.new(roster, self)
      end
    end
  end
end

