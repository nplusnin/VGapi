module VgApi
  module Matches
    class Match < Record
      def attributes
        @attributes ||= data['attributes']
      end

      def game_mode
        attributes['gameMode']
      end

      def duration
        attributes['duration']
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
          roster.win?
        end.first
      end

      def player_win?(name)
        winners_team.players.map do |player|
          player[:name]
        end.include?(name)
      end

      def participants
        @participants ||= get_participants
      end

      def participant(name)
        participants.select do |p|
          p.player.name == name
        end.first
      end
      
    private

      def get_participants
        rosters.map do |roster|
          roster.participants
        end.inject('+')
      end

      def get_rosters
        parent.find_included('roster', rosters_ids).map do |roster|
          Roster.new(roster, self)
        end
      end
    end
  end
end

