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
        @right_side ||= rosters.find do |r|
          r.side == "right/red"
        end

        @winner_team = @right_side if @right_side.win?
        @right_side
      end

      def left_side
        @left_side ||= rosters.find do |r|
          r.side == "left/blue"
        end

        @winner_team = @left_side if @left_side.win?
        @left_side
      end

      alias_method :red_team, :right_side
      alias_method :blue_team, :left_side

      def winners_team
        @winner_team ||= rosters.each do |roster|
          return roster if roster.win?
        end
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
        participants.each do |p|
          return p if p.player.name == name
        end
      end

      alias_method :player, :participant

      def oponents(player_name)
        @oponents ||= get_oponents(player_name)
      end

      def allies(player_name)
        @allies ||= get_allies(player_name)
      end

      def to_h
        { id: id, duration: duration, game_mode: game_mode,
          right_side: right_side.to_h, left_side: left_side.to_h }
      end
      
    private

      def get_participants
        rosters.map do |roster|
          roster.participants
        end.inject('+')
      end

      def get_rosters
        parent.select_included('roster', rosters_ids).map do |roster|
          Roster.new(roster, self)
        end
      end

      def get_oponents(player_name)
        rosters.each do |roster|
          return roster.players if !roster.player?(player_name)
        end
      end

      def get_allies(player_name)
        rosters.each do |roster|
          return roster.allies(player_name) if roster.player?(player_name)
        end
      end
    end
  end
end

